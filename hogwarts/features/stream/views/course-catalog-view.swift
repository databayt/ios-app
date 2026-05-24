import SwiftUI

struct CourseCatalogView: View {
    @State private var viewModel = CourseCatalogViewModel()
    let tenantContext: TenantContext

    private let categories = ["Math", "Science", "Language", "Art", "Sport"]

    var body: some View {
        List(viewModel.courses) { course in
            NavigationLink {
                CourseDetailView(courseId: course.id, tenantContext: tenantContext)
            } label: {
                HStack(spacing: 12) {
                    if let url = course.thumbnailUrl, let u = URL(string: url) {
                        AsyncImage(url: u) { img in img.resizable() } placeholder: { Color.gray.opacity(0.2) }
                            .aspectRatio(16/9, contentMode: .fill).frame(width: 80, height: 45).clipped().cornerRadius(4)
                    }
                    VStack(alignment: .leading) {
                        Text(course.title).font(.subheadline.weight(.semibold))
                        Text(course.category).font(.caption).foregroundStyle(.secondary)
                        Text("\(course.lessonCount) lessons · \(course.totalDuration)")
                            .font(.caption2).foregroundStyle(.tertiary)
                    }
                }
            }
        }
        .navigationTitle("stream.catalog")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu("filter") {
                    Button("filter.all") { viewModel.category = nil; Task { await viewModel.load() } }
                    ForEach(categories, id: \.self) { c in
                        Button(c) { viewModel.category = c; Task { await viewModel.load() } }
                    }
                }
            }
        }
        .task {
            viewModel.tenantContext = tenantContext
            await viewModel.load()
        }
    }
}
