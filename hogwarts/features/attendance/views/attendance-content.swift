import SwiftUI

/// Main attendance view — renders the date picker and the role-aware
/// content. The role-specific subviews live in
/// `attendance-role-views.swift`; the stats / chips primitives live in
/// `attendance-stats-components.swift`; the history row is in
/// `attendance-history-row.swift`.
/// Mirrors: src/components/platform/attendance/content.tsx
struct AttendanceContent: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(TenantContext.self) private var tenantContext
    @Environment(NotificationNavigationState.self) private var navigationState
    @State private var viewModel = AttendanceViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                DatePicker(
                    String(localized: "attendance.date"),
                    selection: $viewModel.selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .accessibilityLabel(String(localized: "a11y.attendance.datePicker"))
                .padding()
                .onChange(of: viewModel.selectedDate) { _, newDate in
                    Task { await viewModel.loadAttendanceForDate(newDate) }
                }

                Divider()

                roleContent
            }
            .navigationTitle(String(localized: "attendance.title"))
            .toolbar { toolbarContent }
            .sheet(isPresented: $viewModel.isShowingForm) {
                if let mode = viewModel.formMode {
                    AttendanceForm(mode: mode, viewModel: viewModel)
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .sheet(isPresented: $viewModel.isShowingQRScanner) {
                QRScannerView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.isShowingExcuseForm) {
                if case .submitExcuse(let studentId, let date) = viewModel.formMode {
                    ExcuseFormView(studentId: studentId, date: date, viewModel: viewModel)
                }
            }
            .alert(
                String(localized: "error.title"),
                isPresented: $viewModel.showError,
                presenting: viewModel.error
            ) { _ in
                Button(String(localized: "common.ok")) {}
            } message: { error in
                Text(error.localizedDescription)
            }
            .alert(
                String(localized: "success.title"),
                isPresented: $viewModel.showSuccess
            ) {
                Button(String(localized: "common.ok")) {}
            } message: {
                if let message = viewModel.successMessage {
                    Text(message)
                }
            }
            .task {
                viewModel.setup(tenantContext: tenantContext, authManager: authManager)
                await viewModel.loadAttendanceForDate(viewModel.selectedDate)
                await viewModel.loadStats()
                await viewModel.loadTeacherClasses()

                // Handle deep link from push notification
                if case .attendance(_) = navigationState.pendingDestination {
                    navigationState.clearPending()
                }
            }
        }
    }

    /// Routes to the role-specific subview. Pulled out of `body` so the
    /// chain of modifiers above stays readable.
    @ViewBuilder
    private var roleContent: some View {
        if viewModel.capabilities.canMarkAttendance {
            TeacherAttendanceContent(viewModel: viewModel)
        } else if viewModel.capabilities.canQRCheckIn {
            StudentAttendanceContent(viewModel: viewModel)
        } else if viewModel.capabilities.canSubmitExcuse {
            GuardianAttendanceContent(viewModel: viewModel)
        } else {
            ViewOnlyAttendanceContent(viewModel: viewModel)
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                NavigationLink {
                    AttendanceGamificationView()
                } label: {
                    Label(String(localized: "gamification.title"), systemImage: "rosette")
                }
                NavigationLink {
                    HallPassView()
                } label: {
                    Label(String(localized: "hallPass.title"), systemImage: "door.left.hand.open")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .accessibilityLabel(Text("attendance.moreMenu"))
        }
        ToolbarItem(placement: .topBarTrailing) {
            if viewModel.capabilities.canMarkAttendance {
                Menu {
                    if viewModel.teacherClasses.isEmpty {
                        Button {
                            viewModel.showMarkClassForm(classId: viewModel.selectedClassId ?? "")
                        } label: {
                            Label(
                                String(localized: "attendance.action.markClass"),
                                systemImage: "person.3"
                            )
                        }
                    } else {
                        ForEach(viewModel.teacherClasses) { cls in
                            Button {
                                viewModel.showMarkClassForm(classId: cls.id)
                            } label: {
                                Label(cls.displayName, systemImage: "person.3")
                            }
                        }
                    }

                    Divider()

                    Button {
                        viewModel.showMarkForm(studentId: "")
                    } label: {
                        Label(
                            String(localized: "attendance.action.markStudent"),
                            systemImage: "person"
                        )
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(String(localized: "a11y.button.markAttendance"))
            } else if viewModel.capabilities.canQRCheckIn {
                Button {
                    viewModel.showQRScanner()
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                }
                .accessibilityLabel(String(localized: "a11y.button.scanQR"))
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AttendanceContent()
        .environment(AuthManager())
        .environment(TenantContext())
        .environment(NotificationNavigationState.shared)
}
