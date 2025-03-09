import WidgetKit
import SwiftUI

private let widgetGroupId = "group.spotube_home_player_widget"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀", trackTitle: "Track Title", artistName: "Artist Name", albumArt: UIImage())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀", trackTitle: "Track Title", artistName: "Artist Name", albumArt: UIImage())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀", trackTitle: "Track Title", artistName: "Artist Name", albumArt: UIImage())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let trackTitle: String
    let artistName: String
    let albumArt: UIImage
}

struct HomePlayerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.emoji)

            Text("Track Title:")
            Text(entry.trackTitle)

            Text("Artist Name:")
            Text(entry.artistName)

            Image(uiImage: entry.albumArt)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct HomePlayerWidget: Widget {
    let kind: String = "HomePlayerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HomePlayerWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HomePlayerWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    HomePlayerWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀", trackTitle: "Track Title", artistName: "Artist Name", albumArt: UIImage())
    SimpleEntry(date: .now, emoji: "🤩", trackTitle: "Track Title", artistName: "Artist Name", albumArt: UIImage())
}
