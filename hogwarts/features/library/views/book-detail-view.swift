import SwiftUI

struct BookDetailView: View {
    @State private var viewModel = BookDetailViewModel()
    let bookId: String
    let tenantContext: TenantContext

    var body: some View {
        ScrollView {
            if let book = viewModel.book {
                VStack(alignment: .leading, spacing: 16) {
                    if let url = book.coverImageUrl, let u = URL(string: url) {
                        AsyncImage(url: u) { phase in
                            switch phase {
                            case .success(let img): img.resizable().aspectRatio(contentMode: .fit)
                            default: Color.gray.opacity(0.2).aspectRatio(2/3, contentMode: .fit)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    Text(book.title).font(.title2.weight(.bold))
                    Text(book.author).font(.body).foregroundStyle(.secondary)

                    HStack {
                        Label(book.category.displayName, systemImage: "tag")
                        Spacer()
                        if book.isAvailable {
                            Label("\(book.availableCopies)/\(book.totalCopies)", systemImage: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else {
                            Label("library.unavailable", systemImage: "xmark.circle")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .font(.caption)

                    Divider()
                    Text(book.description).font(.body)

                    Group {
                        Text("library.shelf \(book.shelfLocation)")
                        Text("library.section \(book.sectionName)")
                        Text("library.isbn \(book.isbn)")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
            } else if viewModel.isLoading {
                ProgressView().padding()
            }
        }
        .safeAreaInset(edge: .bottom) {
            if let book = viewModel.book, book.isAvailable {
                Button {
                    Task { _ = await viewModel.borrow() }
                } label: {
                    if viewModel.isBorrowing {
                        ProgressView()
                    } else {
                        Text("library.borrow")
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.bar)
            }
        }
        .task {
            viewModel.tenantContext = tenantContext
            await viewModel.load(id: bookId)
        }
        .navigationTitle("library.book")
        .navigationBarTitleDisplayMode(.inline)
    }
}
