import SwiftUI

// MARK: - Artwork
//
// Course art is illustrated scenery, so the card keeps the 16:9 frame the web
// and Android use — squaring it cuts the scene in half. A course with no art
// paints its own color, then a deterministic one, so a shelf never looks empty.

struct LumosArtwork: View {
    let url: String?
    let color: String?
    let seed: String
    var cornerRadius: CGFloat = 12

    var body: some View {
        ZStack {
            Rectangle().fill(fallback)
            if let url, let link = URL(string: url) {
                AsyncImage(url: link) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFill()
                    }
                }
            } else {
                Image(systemName: "sparkles")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    private var fallback: LinearGradient {
        let base = Color(hex: color) ?? Color.deterministic(from: seed)
        return LinearGradient(
            colors: [base.opacity(0.95), base.opacity(0.55)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Course card

/// One course in a shelf: art on top, then the grade, the title and what the
/// course holds.
struct LumosCourseCard: View {
    let course: CatalogCourse
    /// A shelf card is a fixed width; a grid card fills its column.
    var width: CGFloat? = 220
    var progress: Double? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            LumosArtwork(url: course.imageUrl, color: course.color, seed: course.id)
                .aspectRatio(16 / 9, contentMode: .fit)
                .frame(width: width)
                .overlay(alignment: .bottomLeading) {
                    if let grade = course.grades.first {
                        Text(String(localized: "lumos.grade \(grade)"))
                            .font(.caption2.weight(.semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.ultraThinMaterial, in: Capsule())
                            .padding(8)
                    }
                }

            Text(course.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: width, alignment: .leading)

            HStack(spacing: 4) {
                if course.totalLessons > 0 {
                    Text(String(localized: "lumos.lessonCount \(course.totalLessons)"))
                }
                if course.chapters > 0 {
                    Text("·")
                    Text(String(localized: "lumos.chapterCount \(course.chapters)"))
                }
                if course.averageRating > 0 {
                    Text("·")
                    Label(
                        String(format: "%.1f", course.averageRating),
                        systemImage: "star.fill"
                    )
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .frame(width: width, alignment: .leading)

            if let progress, progress > 0 {
                LumosProgressBar(value: progress)
                    .frame(width: width)
            }
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Continue watching

/// A lesson in flight: its art, its course, and how far the reader got.
struct LumosContinueCard: View {
    let resume: ResumeLesson

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            LumosArtwork(url: resume.thumbnailUrl, color: resume.color, seed: resume.lessonId)
                .aspectRatio(16 / 9, contentMode: .fit)
                .frame(width: 240)
                .overlay {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 34))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .black.opacity(0.45))
                }
                .overlay(alignment: .bottom) {
                    LumosProgressBar(value: resume.progress, tracks: 4)
                        .padding(8)
                }

            Text(resume.lessonTitle)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)

            Text([resume.courseTitle, resume.chapterTitle].filter { !$0.isEmpty }.joined(separator: " · "))
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: 240, alignment: .leading)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Progress bar

/// A flat bar, or `tracks` segments the way a streaming row divides them.
struct LumosProgressBar: View {
    let value: Double
    var tracks: Int? = nil

    var body: some View {
        GeometryReader { proxy in
            let filled = max(0, min(1, value))
            if let tracks, tracks > 1 {
                HStack(spacing: 3) {
                    ForEach(0..<tracks, id: \.self) { index in
                        let share = Double(index) / Double(tracks)
                        Capsule()
                            .fill(share < filled ? Color.white : Color.white.opacity(0.28))
                            .frame(height: 3)
                    }
                }
            } else {
                ZStack(alignment: .leading) {
                    Capsule().fill(.quaternary)
                    Capsule()
                        .fill(Color.hogwartsPrimary)
                        .frame(width: proxy.size.width * filled)
                }
                .frame(height: 4)
            }
        }
        .frame(height: 4)
        .accessibilityLabel(String(localized: "lumos.progress \(Int(value * 100))"))
    }
}

// MARK: - Shelf

/// A heading over a sideways row of cards.
struct LumosShelf<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3.bold())
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    content
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Lesson row

/// One lesson inside a chapter on the course page.
struct LumosLessonRow: View {
    let lesson: CoursePageLesson
    let position: Int
    let isCurrent: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isCurrent ? Color.hogwartsPrimary : Color.secondary.opacity(0.15))
                    .frame(width: 30, height: 30)
                Text("\(position)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(isCurrent ? .white : .primary)
            }
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(lesson.title)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                HStack(spacing: 6) {
                    if let duration = lesson.duration, duration > 0 {
                        Text(String(localized: "lumos.minutes \(duration)"))
                    }
                    if lesson.isFree {
                        Text(String(localized: "lumos.free"))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 1)
                            .background(Color.hogwartsTertiary.opacity(0.15), in: Capsule())
                            .foregroundStyle(Color.hogwartsTertiary)
                    }
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.forward")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}
