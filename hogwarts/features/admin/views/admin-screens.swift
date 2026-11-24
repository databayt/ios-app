import SwiftUI

/// The full staff list as its own screen — the admin hub links here with
/// `AdminRoute.staff`, and a pushed screen owns its own view model so it
/// loads even when the hub is not in memory.
struct AdminStaffScreen: View {
    @State private var viewModel = AdminViewModel()

    var body: some View {
        AdminStaffList(viewModel: viewModel)
            .task { if viewModel.staff.isEmpty { await viewModel.loadAll() } }
    }
}

/// The full classes list, grouped by grade.
struct AdminClassesScreen: View {
    @State private var viewModel = AdminViewModel()

    var body: some View {
        AdminClassesList(viewModel: viewModel)
            .task { if viewModel.classes.isEmpty { await viewModel.loadAll() } }
    }
}
