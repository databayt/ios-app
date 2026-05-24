import SwiftUI

struct CertificateView: View {
    @State private var viewModel = CertificateViewModel()
    let courseId: String
    let tenantContext: TenantContext

    var body: some View {
        Group {
            if let c = viewModel.certificate {
                VStack(spacing: 20) {
                    Image(systemName: "rosette").font(.system(size: 80)).foregroundStyle(.yellow)
                    Text("stream.certificate.title").font(.title.weight(.bold))
                    VStack(spacing: 6) {
                        Text(c.studentName).font(.title2)
                        Text("stream.certificate.completed").font(.caption).foregroundStyle(.secondary)
                        Text(c.courseName).font(.title3.weight(.semibold))
                        Text(c.completedAt).font(.caption).foregroundStyle(.secondary)
                    }
                    Divider().padding(.horizontal)
                    Text("stream.certificate.verification \(c.verificationCode)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    if let url = c.certificateUrl, let u = URL(string: url) {
                        Link(destination: u) {
                            Label("stream.certificate.download", systemImage: "square.and.arrow.down")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                }
                .padding()
            } else if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationTitle("stream.certificate")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.tenantContext = tenantContext
            await viewModel.load(courseId: courseId)
        }
    }
}
