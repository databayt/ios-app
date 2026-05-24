import SwiftUI

struct BookCatalogView: View {
    @State private var viewModel = BookCatalogViewModel()
    @State private var selectedBook: Book?
    let tenantContext: TenantContext

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.books.isEmpty {
                    ProgressView()
                } else if viewModel.books.isEmpty {
                    ContentUnavailableView("library.empty.title", systemImage: "books.vertical", description: Text("library.empty.subtitle"))
                } else {
                    List(viewModel.books) { book in
                        Button { selectedBook = book } label: { BookRow(book: book) }
                            .buttonStyle(.plain)
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) { Task { await viewModel.load() } }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("library.category") {
                        Button("library.category.all") { viewModel.category = nil; Task { await viewModel.load() } }
                        ForEach(BookCategory.allCases) { cat in
                            Button(cat.displayName) { viewModel.category = cat; Task { await viewModel.load() } }
                        }
                    }
                }
            }
            .navigationTitle("library.title")
            .navigationDestination(item: $selectedBook) { book in
                BookDetailView(bookId: book.id, tenantContext: tenantContext)
            }
            .task {
                viewModel.tenantContext = tenantContext
                await viewModel.load()
            }
        }
    }
}

private struct BookRow: View {
    let book: Book

    var body: some View {
        HStack(spacing: 12) {
            if let url = book.coverImageUrl, let u = URL(string: url) {
                AsyncImage(url: u) { phase in
                    switch phase {
                    case .success(let img): img.resizable().aspectRatio(contentMode: .fit)
                    default: Color.gray.opacity(0.2)
                    }
                }
                .frame(width: 44, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            } else {
                RoundedRectangle(cornerRadius: 4).fill(.gray.opacity(0.2)).frame(width: 44, height: 60)
                    .overlay(Image(systemName: "book").foregroundStyle(.secondary))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(book.title).font(.headline)
                Text(book.author).font(.caption).foregroundStyle(.secondary)
                Text(book.category.displayName).font(.caption2).foregroundStyle(.tertiary)
            }
            Spacer()
            if book.isAvailable {
                Text("library.available").font(.caption2).foregroundStyle(.green)
            } else {
                Text("library.unavailable").font(.caption2).foregroundStyle(.secondary)
            }
        }
    }
}
