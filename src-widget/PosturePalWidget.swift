//
//  PosturePalWidget.swift
//  PosturePal Widget Extension
//
//  Home Screen and Lock Screen widgets
//  Shows current streak and next reminder time
//

import WidgetKit
import SwiftUI

// MARK: - Widget Entry

struct StreakEntry: TimelineEntry {
    let date: Date
    let currentStreak: Int
    let nextReminderTime: Date?
    let todayCheckIns: Int
    let maxCheckIns: Int
}

// MARK: - Timeline Provider

struct StreakProvider: TimelineProvider {
    func placeholder(in context: Context) -> StreakEntry {
        StreakEntry(
            date: Date(),
            currentStreak: 42,
            nextReminderTime: Date().addingTimeInterval(3600),
            todayCheckIns: 3,
            maxCheckIns: 5
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (StreakEntry) -> Void) {
        let entry = StreakEntry(
            date: Date(),
            currentStreak: loadCurrentStreak(),
            nextReminderTime: loadNextReminderTime(),
            todayCheckIns: loadTodayCheckIns(),
            maxCheckIns: 5
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<StreakEntry>) -> Void) {
        let currentDate = Date()
        
        let entry = StreakEntry(
            date: currentDate,
            currentStreak: loadCurrentStreak(),
            nextReminderTime: loadNextReminderTime(),
            todayCheckIns: loadTodayCheckIns(),
            maxCheckIns: 5
        )
        
        // Update timeline every 15 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
    
    // MARK: - Data Loading (Shared App Group)
    
    private func loadCurrentStreak() -> Int {
        let sharedDefaults = UserDefaults(suiteName: "group.com.posturepal.app")
        return sharedDefaults?.integer(forKey: "widgetCurrentStreak") ?? 0
    }
    
    private func loadNextReminderTime() -> Date? {
        let sharedDefaults = UserDefaults(suiteName: "group.com.posturepal.app")
        return sharedDefaults?.object(forKey: "widgetNextReminder") as? Date
    }
    
    private func loadTodayCheckIns() -> Int {
        let sharedDefaults = UserDefaults(suiteName: "group.com.posturepal.app")
        return sharedDefaults?.integer(forKey: "widgetTodayCheckIns") ?? 0
    }
}

// MARK: - Widget Views

struct SmallWidgetView: View {
    let entry: StreakEntry
    
    var body: some View {
        VStack(spacing: 4) {
            Text("🔥")
                .font(.system(size: 28))
            
            Text("\(entry.currentStreak)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.orange)
            
            Text(entry.currentStreak == 1 ? "day" : "days")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Spacer()
            
            if let nextReminder = entry.nextReminderTime {
                Text("Next: \(timeUntil(nextReminder))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
    }
    
    private func timeUntil(_ date: Date) -> String {
        let interval = date.timeIntervalSince(Date())
        if interval < 0 { return "Now" }
        
        let minutes = Int(interval / 60)
        let hours = minutes / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes % 60)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct MediumWidgetView: View {
    let entry: StreakEntry
    
    var body: some View {
        HStack(spacing: 16) {
            // Streak Section
            VStack(spacing: 4) {
                Text("🔥")
                    .font(.system(size: 32))
                
                Text("\(entry.currentStreak)")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
                
                Text("day streak")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 100)
            
            Divider()
            
            // Today's Progress
            VStack(alignment: .leading, spacing: 8) {
                Text("Today")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(index < entry.todayCheckIns ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                
                Spacer()
                
                if let nextReminder = entry.nextReminderTime {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text(nextReminderText(nextReminder))
                            .font(.caption2)
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
    }
    
    private func nextReminderText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "Next: \(formatter.string(from: date))"
    }
}

struct LockScreenWidgetView: View {
    let entry: StreakEntry
    
    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Text("🔥")
                    .font(.system(size: 18))
                Text("\(entry.currentStreak)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
            }
            
            Text("day streak")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(8)
    }
}

// MARK: - Widget Configuration

@main
struct PosturePalWidgetBundle: WidgetBundle {
    var body: some Widget {
        PosturePalHomeWidget()
        PosturePalLockScreenWidget()
    }
}

struct PosturePalHomeWidget: Widget {
    let kind: String = "PosturePalHomeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StreakProvider()) { entry in
            if #available(iOS 17.0, *) {
                HomeScreenWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HomeScreenWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Streak Counter")
        .description("Track your posture check-in streak")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct PosturePalLockScreenWidget: Widget {
    let kind: String = "PosturePalLockScreenWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StreakProvider()) { entry in
            LockScreenWidgetView(entry: entry)
        }
        .configurationDisplayName("Streak Badge")
        .description("Your streak on your lock screen")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
    }
}

struct HomeScreenWidgetView: View {
    let entry: StreakEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Preview

struct PosturePalWidget_Previews: PreviewProvider {
    static var previews: some View {
        let entry = StreakEntry(
            date: Date(),
            currentStreak: 42,
            nextReminderTime: Date().addingTimeInterval(3600),
            todayCheckIns: 3,
            maxCheckIns: 5
        )
        
        Group {
            SmallWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            MediumWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            LockScreenWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
        }
    }
}
