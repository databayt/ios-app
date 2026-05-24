import SwiftUI
import EventKit

// MARK: - EventDetailView
//
// Detail screen for a school event with an "Add to Calendar" button that
// uses EventKit's write-only access (iOS 17+). This closes the calendar-
// export gap noted in the parity audit.
//
// Permission needed in Info.plist:
//   NSCalendarsWriteOnlyAccessUsageDescription
//
// Tap flow:
//   1. Request write-only access (modal sheet shown by iOS once)
//   2. Build EKEvent from `SchoolEventDetail.resolvedRange()`
//   3. Save via EKEventStore — show success toast
//   4. On failure, surface the error in an alert

struct EventDetailView: View {
    let id: String

    @State private var detail: SchoolEventDetail?
    @State private var isLoading = false
    @State private var lastError: String?
    @State private var calendarMessage: CalendarMessage?

    @Environment(\.locale) private var locale

    private let actions = EventsActions()

    var body: some View {
        Group {
            if let detail {
                content(for: detail)
            } else if let lastError {
                errorState(lastError)
            } else {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(Text("events.detail.title"))
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
        .refreshable { await load() }
        .alert(item: $calendarMessage) { msg in
            Alert(
                title: Text(msg.titleKey),
                message: Text(msg.body),
                dismissButton: .default(Text("common.ok"))
            )
        }
    }

    // MARK: - Content

    private func content(for d: SchoolEventDetail) -> some View {
        List {
            Section {
                header(for: d).listRowSeparator(.hidden)
            }

            if let description = d.description, !description.isEmpty {
                Section(String(localized: "events.detail.section.about")) {
                    Text(description)
                        .font(.body)
                }
            }

            Section(String(localized: "events.detail.section.when")) {
                if let date = d.startDate {
                    LabeledContent(
                        String(localized: "events.detail.field.date"),
                        value: date.formatted(.dateTime.weekday(.wide).day().month(.wide).year().locale(locale))
                    )
                }
                if let s = d.startTime, !s.isEmpty {
                    LabeledContent(
                        String(localized: "events.detail.field.time"),
                        value: d.endTime.map { e in "\(s) – \(e)" } ?? s
                    )
                }
            }

            if let location = d.location, !location.isEmpty {
                Section(String(localized: "events.detail.section.where")) {
                    LabeledContent(
                        String(localized: "events.detail.field.location"),
                        value: location
                    )
                }
            }

            if d.organizerName != nil || d.targetAudience != nil || (d.maxAttendees ?? 0) > 0 {
                Section(String(localized: "events.detail.section.meta")) {
                    if let organizer = d.organizerName, !organizer.isEmpty {
                        LabeledContent(String(localized: "events.detail.field.organizer"), value: organizer)
                    }
                    if let audience = d.targetAudience, !audience.isEmpty {
                        LabeledContent(String(localized: "events.detail.field.audience"), value: audience)
                    }
                    if let max = d.maxAttendees, max > 0 {
                        LabeledContent(
                            String(localized: "events.detail.field.attendance"),
                            value: "\(d.currentAttendees ?? 0) / \(max)"
                        )
                    }
                }
            }

            Section {
                Button {
                    Task { await addToCalendar(d) }
                } label: {
                    Label(String(localized: "events.action.addToCalendar"),
                          systemImage: "calendar.badge.plus")
                }
                if let notes = d.notes, !notes.isEmpty {
                    Label(notes, systemImage: "note.text")
                        .foregroundStyle(.secondary)
                        .font(.callout)
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func header(for d: SchoolEventDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(d.kind.label, systemImage: d.kind.systemImage)
                .labelStyle(.titleAndIcon)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(d.kind.color.opacity(0.15)))
                .foregroundStyle(d.kind.color)

            Text(d.title)
                .font(.title2.weight(.bold))
                .accessibilityAddTraits(.isHeader)

            if d.isRegistered == true {
                Label(String(localized: "events.detail.registered"),
                      systemImage: "checkmark.seal.fill")
                    .font(.subheadline)
                    .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Calendar

    private func addToCalendar(_ d: SchoolEventDetail) async {
        guard let range = d.resolvedRange() else {
            calendarMessage = .init(titleKey: "events.calendar.errorTitle",
                                    body: String(localized: "events.calendar.missingDate"))
            return
        }

        let store = EKEventStore()
        do {
            // iOS 17+ write-only API — narrowest scope iOS allows.
            let granted = try await store.requestWriteOnlyAccessToEvents()
            guard granted else {
                calendarMessage = .init(titleKey: "events.calendar.errorTitle",
                                        body: String(localized: "events.calendar.permissionDenied"))
                return
            }

            let event = EKEvent(eventStore: store)
            event.title = d.title
            event.startDate = range.start
            event.endDate = range.end
            event.location = d.location
            event.notes = [d.description, d.notes]
                .compactMap { $0 }
                .filter { !$0.isEmpty }
                .joined(separator: "\n\n")
            event.calendar = store.defaultCalendarForNewEvents

            try store.save(event, span: .thisEvent, commit: true)
            calendarMessage = .init(titleKey: "events.calendar.successTitle",
                                    body: String(localized: "events.calendar.savedBody \(d.title)"))
        } catch {
            calendarMessage = .init(titleKey: "events.calendar.errorTitle",
                                    body: error.localizedDescription)
        }
    }

    // MARK: - Loading / errors

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(.orange)
            Text("events.detail.loadFailed").font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(String(localized: "events.retry")) {
                Task { await load() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            detail = try await actions.detail(id: id)
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}

// MARK: - Calendar feedback

private struct CalendarMessage: Identifiable {
    let id = UUID()
    let titleKey: LocalizedStringResource
    let body: String
}

#Preview("LTR") { NavigationStack { EventDetailView(id: "preview") } }
#Preview("RTL") {
    NavigationStack { EventDetailView(id: "preview") }
        .environment(\.layoutDirection, .rightToLeft)
}
