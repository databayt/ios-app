import SwiftUI

struct ResourceBrowserView: View {
    @State private var viewModel = ResourceBrowserViewModel()
    let tenantContext: TenantContext

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filtered) { res in
                    HStack {
                        Image(systemName: res.type.icon)
                            .foregroundStyle(.tint)
                            .frame(width: 28)
                        VStack(alignment: .leading) {
                            Text(res.name)
                            if let size = res.fileSize {
                                Text(ByteCountFormatter.string(fromByteCount: size, countStyle: .file))
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        if let u = URL(string: res.url) {
                            Link(destination: u) { Image(systemName: "arrow.up.right.square") }
                        }
                    }
                }
            }
            .navigationTitle("lessons.resources")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("filter") {
                        Button("lessons.filter.all") { viewModel.filterType = nil }
                        ForEach(ResourceType.allCases, id: \.self) { t in
                            Button(t.rawValue.uppercased()) { viewModel.filterType = t }
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
}
