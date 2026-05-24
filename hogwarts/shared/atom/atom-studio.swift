import SwiftUI

// MARK: - Atom Studio
// Scrollable catalog of every HW atom for visual QA.
// Navigate here from Profile > Developer > Atom Studio (or via deep link).

struct AtomStudio: View {
    @State private var searchText = ""
    @State private var textFieldValue = ""
    @State private var toggleValue = false
    @State private var selectedChip: String? = "All"
    @State private var showAlert = false
    @State private var showActionSheet = false
    @State private var showOverlay = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppleSpacing.extraLarge) {

                    // ── Button ──────────────────────────
                    section("HWButton") {
                        HWButton(title: "Default", variant: .default) {}
                        HWButton(title: "Secondary", variant: .secondary) {}
                        HWButton(title: "Outline", variant: .outline) {}
                        HWButton(title: "Ghost", variant: .ghost) {}
                        HWButton(title: "Destructive", variant: .destructive) {}
                        HWButton(title: "Link", variant: .link) {}
                        HWButton(title: "Loading...", isLoading: true) {}
                        HWButton(title: "Small", size: .sm, isFullWidth: false) {}
                    }

                    // ── TextField ────────────────────────
                    section("HWTextField") {
                        HWTextField(label: "Email", text: $textFieldValue)
                        HWTextField(label: "Password", text: $textFieldValue, isSecure: true)
                        HWTextField(label: "With Error", text: $textFieldValue, error: "This field is required")
                    }

                    // ── Card ─────────────────────────────
                    section("HWCard") {
                        HWCard(style: .glass) {
                            Text("Glass Card").padding()
                        }
                        HWCard(style: .solid) {
                            Text("Solid Card").padding()
                        }
                        HWCard(style: .clear) {
                            Text("Clear Card").padding()
                        }
                    }

                    // ── SearchBar ────────────────────────
                    section("HWSearchBar") {
                        HWSearchBar(text: $searchText)
                    }

                    // ── Badge ────────────────────────────
                    section("HWBadge") {
                        HStack(spacing: AppleSpacing.small) {
                            HWBadge(text: "Default")
                            HWBadge(text: "Success", variant: .success)
                            HWBadge(text: "Warning", variant: .warning)
                            HWBadge(text: "Error", variant: .error)
                            HWBadge(text: "Info", variant: .info)
                        }
                    }

                    // ── DividerWithText ──────────────────
                    section("HWDividerWithText") {
                        HWDividerWithText(text: "or continue with")
                    }

                    // ── SectionHeader ────────────────────
                    section("HWSectionHeader") {
                        HWSectionHeader(title: "Students", action: "View All") {}
                        HWSectionHeader(title: "No Action")
                    }

                    // ── FilterChips ──────────────────────
                    section("HWFilterChips") {
                        HWFilterChips(
                            items: ["All", "Present", "Absent", "Late"],
                            selected: $selectedChip
                        ) { $0 }
                    }

                    // ── Avatar ───────────────────────────
                    section("HWAvatar") {
                        HStack(spacing: AppleSpacing.standard) {
                            HWAvatar(name: "Osman Abdout", size: .small)
                            HWAvatar(name: "Osman Abdout", size: .medium)
                            HWAvatar(name: "Osman Abdout", size: .large)
                        }
                    }

                    // ── SocialButton ────────────────────
                    section("HWSocialButton") {
                        HWSocialAuthButtons(onGoogleTap: {}, onAppleTap: {})
                    }

                    // ── FormMessage ──────────────────────
                    section("HWFormMessage") {
                        HWFormMessage(message: "Invalid email or password", variant: .error)
                        HWFormMessage(message: "Login successful!", variant: .success)
                    }

                    // ── ListRow ──────────────────────────
                    section("HWListRow") {
                        VStack(spacing: 0) {
                            HWListRow(title: "Wi-Fi") {
                                Image(systemName: "wifi")
                                    .foregroundStyle(.accentBlue)
                            } trailing: {
                                Text("Home").foregroundStyle(.secondary)
                                Image(systemName: "chevron.forward")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            HWListRow(title: "Bluetooth", subtitle: "On") {
                                Image(systemName: "antenna.radiowaves.left.and.right")
                                    .foregroundStyle(.accentBlue)
                            } trailing: {
                                Toggle("", isOn: $toggleValue)
                                    .labelsHidden()
                            }
                            HWListRow(title: "Airplane Mode", showDivider: false) {
                                Image(systemName: "airplane")
                                    .foregroundStyle(.orange)
                            } trailing: {
                                Toggle("", isOn: $toggleValue)
                                    .labelsHidden()
                            }
                        }
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // ── SheetHeader ──────────────────────
                    section("HWSheetHeader") {
                        HWSheetHeader(title: "Sheet Title", onClose: {})
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // ── Alert ────────────────────────────
                    section("HWAlert") {
                        Button("Show Alert") { showAlert = true }
                            .buttonStyle(.borderedProminent)
                        if showAlert {
                            HWAlert(
                                title: "Delete Item?",
                                message: "This action cannot be undone.",
                                primaryAction: (label: "Delete", action: { showAlert = false }),
                                secondaryAction: (label: "Cancel", action: { showAlert = false })
                            )
                        }
                    }

                    // ── ActionSheet ──────────────────────
                    section("HWActionSheet") {
                        Button("Show Action Sheet") { showActionSheet = true }
                            .buttonStyle(.borderedProminent)
                        if showActionSheet {
                            HWActionSheet(
                                title: "Choose Action",
                                message: "Select an option below.",
                                actions: [
                                    HWActionSheetAction(label: "Delete", isDestructive: true) { showActionSheet = false },
                                    HWActionSheetAction(label: "Edit") { showActionSheet = false },
                                    HWActionSheetAction(label: "Share") { showActionSheet = false },
                                    HWActionSheetAction(label: "Cancel") { showActionSheet = false },
                                ]
                            )
                        }
                    }

                    // ── NotificationBanner ───────────────
                    section("HWNotificationBanner") {
                        HWNotificationBanner(
                            title: "Hogwarts",
                            description: "Your attendance has been recorded.",
                            time: "9:41 AM",
                            icon: Image(systemName: "graduationcap.fill")
                        )
                    }

                    // ── Overlay ──────────────────────────
                    section("HWOverlay") {
                        Button("Show Overlay") { showOverlay = true }
                            .buttonStyle(.borderedProminent)
                    }

                    // ── OfflineBanner ────────────────────
                    section("HWOfflineBanner") {
                        HWOfflineBanner(isOffline: true)
                    }

                    Spacer().frame(height: AppleSpacing.extraLarge)
                }
                .padding(.horizontal, AppleSpacing.standard)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Atom Studio")
            .overlay {
                if showOverlay {
                    HWOverlay(onTap: { showOverlay = false })
                }
            }
        }
    }

    @ViewBuilder
    private func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: AppleSpacing.small) {
            Text(title)
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            content()
        }
    }
}

#Preview {
    AtomStudio()
}

#Preview("RTL -- Arabic") {
    AtomStudio()
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "ar"))
}
