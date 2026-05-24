import SwiftUI

struct StreamHomeContent: View {
    @State private var viewModel = StreamHomeViewModel()
    let tenantContext: TenantContext

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if !viewModel.continueWatching.isEmpty {
                        SectionHeader(title: "stream.continue_watching")
                        CourseRow(courses: viewModel.continueWatching, tenantContext: tenantContext)
                    }
                    if !viewModel.featured.isEmpty {
                        SectionHeader(title: "stream.featured")
                        CourseRow(courses: viewModel.featured, tenantContext: tenantContext)
                    }
                    NavigationLink {
                        CourseCatalogView(tenantContext: tenantContext)
                    } label: {
                        Label("stream.browse_all", systemImage: "rectangle.stack")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("stream.title")
            .task {
                viewModel.tenantContext = tenantContext
                await viewModel.load()
            }
        }
    }
}

struct SectionHeader: View {
    let title: LocalizedStringKey
    var body: some View {
        Text(title)
            .font(.title3.weight(.semibold))
            .padding(.horizontal)
    }
}

struct CourseRow: View {
    let courses: [Course]
    let tenantContext: TenantContext

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(courses) { course in
                    NavigationLink {
                        CourseDetailView(courseId: course.id, tenantContext: tenantContext)
                    } label: {
                        CourseCard(course: course)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CourseCard: View {
    let course: Course

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let url = course.thumbnailUrl, let u = URL(string: url) {
                AsyncImage(url: u) { phase in
                    switch phase {
                    case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                    default: Color.gray.opacity(0.2)
                    }
                }
                .aspectRatio(16/9, contentMode: .fill)
                .frame(width: 220)
                .clipped()
            } else {
                Rectangle().fill(.gray.opacity(0.2)).aspectRatio(16/9, contentMode: .fit).frame(width: 220)
                    .overlay(Image(systemName: "play.rectangle").font(.title).foregroundStyle(.secondary))
            }
            Text(course.title).font(.subheadline.weight(.semibold)).lineLimit(2)
            Text(course.instructorName).font(.caption).foregroundStyle(.secondary)
            if course.progress > 0 {
                ProgressView(value: course.progress).controlSize(.mini)
            }
        }
        .frame(width: 220)
    }
}
