import SwiftUI

// MARK: - ContactsView
//
// Inset-grouped list of contacts the user can message, grouped by
// category. Search field at the top filters server-side. Tap a row to
// start a direct conversation (delegated via `onSelect`).

struct ContactsView: View {
    /// Called when the user taps a contact — typically used to open the
    /// compose flow with the recipient pre-filled. Defaults to no-op so
    /// the view can be previewed in isolation.
    var onSelect: (Contact) -> Void = { _ in }

    @State private var viewModel = ContactsViewModel()
    @Environment(\.locale) private var locale

    var body: some View {
        List {
            categoryChips
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                .listRowSeparator(.hidden)

            if viewModel.visibleGroups.isEmpty && !viewModel.isLoading {
                emptyState
            } else {
                ForEach(viewModel.visibleGroups) { group in
                    Section {
                        ForEach(group.contacts) { contact in
                            Button {
                                onSelect(contact)
                            } label: {
                                ContactRow(contact: contact, group: group)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        sectionHeader(for: group)
                    }
                }
            }

            if let error = viewModel.lastError {
                errorBanner(error)
            }
        }
        .listStyle(.insetGrouped)
        .overlay { if viewModel.isLoading && viewModel.groups.isEmpty { ProgressView() } }
        .navigationTitle(Text("contacts.title"))
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.search, prompt: Text("contacts.search.prompt"))
        .task { if viewModel.groups.isEmpty { await viewModel.load(locale: locale) } }
        .refreshable { await viewModel.load(locale: locale) }
    }

    // MARK: - Sub-views

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(title: Text("contacts.filter.all"),
                     isSelected: viewModel.selectedCategory == nil) {
                    viewModel.selectedCategory = nil
                }
                ForEach(presentCategories, id: \.self) { cat in
                    chip(title: Text(cat.label),
                         isSelected: viewModel.selectedCategory == cat) {
                        viewModel.selectedCategory = (viewModel.selectedCategory == cat) ? nil : cat
                    }
                }
            }
        }
    }

    /// Categories actually present in the backend response — keeps the
    /// chip strip from showing empty filters.
    private var presentCategories: [ContactCategory] {
        Array(Set(viewModel.groups.map(\.categoryKind))).sorted { $0.rawValue < $1.rawValue }
    }

    private func chip(title: Text, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            title
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Capsule().fill(isSelected ? Color.accentColor : Color(uiColor: .tertiarySystemFill)))
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func sectionHeader(for group: ContactGroup) -> some View {
        HStack(spacing: 6) {
            Image(systemName: group.categoryKind.systemImage)
                .foregroundStyle(group.categoryKind.color)
            Text(group.categoryKind.label)
            Spacer()
            Text("\(group.contacts.count)")
                .font(.caption2.monospacedDigit())
                .foregroundStyle(.secondary)
        }
    }

    private var emptyState: some View {
        Section {
            VStack(spacing: 12) {
                Image(systemName: "person.2.slash")
                    .font(.system(size: 44))
                    .foregroundStyle(.tertiary)
                Text("contacts.empty.title").font(.headline)
                Text("contacts.empty.subtitle")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .listRowBackground(Color.clear)
        }
    }

    private func errorBanner(_ message: String) -> some View {
        Section {
            Label(String(localized: "contacts.error.title"), systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
            Text(message).font(.caption).foregroundStyle(.secondary)
        }
    }
}

// MARK: - Row

private struct ContactRow: View {
    let contact: Contact
    let group: ContactGroup

    var body: some View {
        HStack(spacing: 12) {
            avatar
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(contact.fullName)
                    .font(.body.weight(.medium))
                if let context = contact.contextLabel, !context.isEmpty {
                    Text(context)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else if let email = contact.email, !email.isEmpty {
                    Text(email)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            Spacer(minLength: 8)
            Image(systemName: "bubble.left")
                .font(.subheadline)
                .foregroundStyle(.tint)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var avatar: some View {
        if let url = contact.image, let parsed = URL(string: url) {
            AsyncImage(url: parsed) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFill()
                default: placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        ZStack {
            group.categoryKind.color.opacity(0.18)
            Image(systemName: group.categoryKind.systemImage)
                .font(.subheadline)
                .foregroundStyle(group.categoryKind.color)
        }
    }
}

#Preview("LTR") { NavigationStack { ContactsView() } }
#Preview("RTL") {
    NavigationStack { ContactsView() }
        .environment(\.layoutDirection, .rightToLeft)
}
