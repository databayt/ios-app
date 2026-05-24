import SwiftUI

struct MyBorrowingsView: View {
    @State private var viewModel = MyBorrowingsViewModel()
    let tenantContext: TenantContext

    var body: some View {
        List {
            if !viewModel.active.isEmpty {
                Section("library.borrowings.active") {
                    ForEach(viewModel.active) { b in BorrowingRow(borrowing: b, onReturn: { Task { await viewModel.returnBook(b) } }) }
                }
            }
            if !viewModel.overdue.isEmpty {
                Section("library.borrowings.overdue") {
                    ForEach(viewModel.overdue) { b in BorrowingRow(borrowing: b, onReturn: { Task { await viewModel.returnBook(b) } }) }
                }
            }
            if !viewModel.history.isEmpty {
                Section("library.borrowings.history") {
                    ForEach(viewModel.history) { b in BorrowingRow(borrowing: b, onReturn: nil) }
                }
            }
            if viewModel.borrowings.isEmpty && !viewModel.isLoading {
                ContentUnavailableView("library.borrowings.empty", systemImage: "books.vertical")
            }
        }
        .refreshable { await viewModel.load() }
        .navigationTitle("library.borrowings")
        .task {
            viewModel.tenantContext = tenantContext
            await viewModel.load()
        }
    }
}

private struct BorrowingRow: View {
    let borrowing: Borrowing
    let onReturn: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(borrowing.bookTitle).font(.headline)
            HStack {
                Text(borrowing.status.displayName).font(.caption).foregroundStyle(borrowing.isOverdue ? .red : .secondary)
                Spacer()
                Text(borrowing.dueDate, style: .date).font(.caption).foregroundStyle(.secondary)
            }
            if let fine = borrowing.fine, fine > 0 {
                Text("library.fine \(fine.formatted(.currency(code: "SAR")))")
                    .font(.caption).foregroundStyle(.red)
            }
            if let onReturn {
                Button("library.return", action: onReturn)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
            }
        }
        .padding(.vertical, 4)
    }
}
