import SwiftUI

// MARK: - FeeDetailView
//
// Drills into a single fee record. Pulls the row from the parent VM cache
// so the screen renders instantly with no extra fetch — when the list is
// stale the parent's pull-to-refresh updates it.
//
// Receipt is shareable as plain text via `ShareLink`. A real PDF receipt
// would land here once the backend exposes one.

struct FeeDetailView: View {
    let id: String
    var record: FeeRecord?

    @Environment(\.locale) private var locale

    var body: some View {
        Group {
            if let record {
                content(for: record)
            } else {
                missingState
            }
        }
        .navigationTitle(Text(record?.feeType ?? String(localized: "fees.detail.title")))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let record {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: shareText(for: record)) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityLabel(Text("fees.share"))
                }
            }
        }
    }

    // MARK: - Content

    private func content(for record: FeeRecord) -> some View {
        List {
            Section { hero(for: record).listRowSeparator(.hidden) }

            Section(String(localized: "fees.detail.section.amounts")) {
                LabeledContent(String(localized: "fees.detail.field.amount"),
                               value: record.amount.formattedAsCurrency(locale: locale))
                LabeledContent(String(localized: "fees.detail.field.paid"),
                               value: record.paidAmount.formattedAsCurrency(locale: locale))
                if let lateFee = record.lateFee, lateFee > 0 {
                    LabeledContent(String(localized: "fees.detail.field.lateFee"),
                                   value: lateFee.formattedAsCurrency(locale: locale))
                }
                if let discount = record.discount, discount > 0 {
                    LabeledContent(String(localized: "fees.detail.field.discount"),
                                   value: discount.formattedAsCurrency(locale: locale))
                }
                LabeledContent(String(localized: "fees.detail.field.outstanding"),
                               value: record.outstanding.formattedAsCurrency(locale: locale))
                .foregroundStyle(record.outstanding > 0 ? .orange : .primary)
            }

            Section(String(localized: "fees.detail.section.dates")) {
                if let due = record.dueDate {
                    LabeledContent(String(localized: "fees.detail.field.due"),
                                   value: due.formatted(date: .abbreviated, time: .omitted))
                }
                if let paid = record.paymentDate {
                    LabeledContent(String(localized: "fees.detail.field.paid"),
                                   value: paid.formatted(date: .abbreviated, time: .omitted))
                }
            }

            if record.paymentMethod != nil || record.receiptNumber != nil {
                Section(String(localized: "fees.detail.section.payment")) {
                    if let method = record.paymentMethod, !method.isEmpty {
                        LabeledContent(String(localized: "fees.detail.field.method"),
                                       value: method.capitalized)
                    }
                    if let receipt = record.receiptNumber, !receipt.isEmpty {
                        LabeledContent(String(localized: "fees.detail.field.receipt"),
                                       value: receipt)
                    }
                }
            }

            if let remarks = record.remarks, !remarks.isEmpty {
                Section(String(localized: "fees.detail.section.notes")) {
                    Text(remarks)
                }
            }

            if record.outstanding > 0 {
                Section {
                    Text("fees.detail.payAtSchool")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func hero(for record: FeeRecord) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(record.statusKind.label, systemImage: record.statusKind.systemImage)
                .labelStyle(.titleAndIcon)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(record.statusKind.color.opacity(0.15)))
                .foregroundStyle(record.statusKind.color)

            Text(record.amount.formattedAsCurrency(locale: locale))
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .accessibilityAddTraits(.isHeader)

            if record.outstanding > 0 {
                Text("fees.detail.outstandingPill \(record.outstanding.formattedAsCurrency(locale: locale))")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(.orange.opacity(0.15)))
                    .foregroundStyle(.orange)
            }
        }
        .padding(.vertical, 6)
    }

    // MARK: - Missing

    private var missingState: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.questionmark")
                .font(.system(size: 44))
                .foregroundStyle(.tertiary)
            Text("fees.detail.notLoaded").font(.headline)
            Text("fees.detail.openFromList")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Share

    private func shareText(for record: FeeRecord) -> String {
        var lines: [String] = []
        lines.append(record.feeType ?? String(localized: "fees.detail.title"))
        lines.append(String(localized: "fees.share.line.amount \(record.amount.formattedAsCurrency(locale: locale))"))
        lines.append(String(localized: "fees.share.line.status \(String(localized: record.statusKind.label))"))
        if let due = record.dueDate {
            lines.append(String(localized: "fees.share.line.due \(due.formatted(date: .abbreviated, time: .omitted))"))
        }
        if let receipt = record.receiptNumber, !receipt.isEmpty {
            lines.append(String(localized: "fees.share.line.receipt \(receipt)"))
        }
        return lines.joined(separator: "\n")
    }
}

#Preview("LTR") { NavigationStack { FeeDetailView(id: "preview") } }
#Preview("RTL") {
    NavigationStack { FeeDetailView(id: "preview") }
        .environment(\.layoutDirection, .rightToLeft)
}
