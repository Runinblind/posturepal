#!/bin/bash

# Create all remaining PosturePal Week 1 files

# CheckIn.swift
cat > Models/CheckIn.swift << 'EOF'
//
//  CheckIn.swift
//  PosturePal
//
//  Week 1 - CoreData Entity Model
//

import Foundation
import CoreData

// Note: This is the Swift class representation
// The actual CoreData model will be defined in PosturePal.xcdatamodeld

@objc(CheckIn)
public class CheckIn: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var timestamp: Date
    @NSManaged public var wasOnTime: Bool  // Within 15min of scheduled notification
}

// MARK: - Convenience Initializer

extension CheckIn {
    static func create(in context: NSManagedObjectContext, wasOnTime: Bool = false) -> CheckIn {
        let checkIn = CheckIn(context: context)
        checkIn.id = UUID()
        checkIn.timestamp = Date()
        checkIn.wasOnTime = wasOnTime
        return checkIn
    }
}

// MARK: - Fetch Requests

extension CheckIn {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckIn> {
        return NSFetchRequest<CheckIn>(entityName: "CheckIn")
    }
    
    // Fetch all check-ins, sorted by most recent
    static func fetchAll(in context: NSManagedObjectContext) -> [CheckIn] {
        let request = fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CheckIn.timestamp, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Error fetching check-ins: \(error)")
            return []
        }
    }
    
    // Fetch check-ins for a specific date
    static func fetchForDate(_ date: Date, in context: NSManagedObjectContext) -> [CheckIn] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CheckIn.timestamp, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Error fetching check-ins for date: \(error)")
            return []
        }
    }
    
    // Fetch check-ins for date range
    static func fetchForDateRange(from startDate: Date, to endDate: Date, in context: NSManagedObjectContext) -> [CheckIn] {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp <= %@", startDate as NSDate, endDate as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CheckIn.timestamp, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Error fetching check-ins for range: \(error)")
            return []
        }
    }
}
EOF

echo "✅ Created CheckIn.swift"

# Continue with next file...
bash << 'INNERBASH'
cd Models
cat > StreakData.swift << 'EOF2'
//
//  StreakData.swift
//  PosturePal
//
//  Week 1 - Computed Streak Analytics Model
//

import Foundation

// MARK: - Streak Data (Computed from CheckIns)

struct StreakData: Equatable {
    var currentStreak: Int
    var longestStreak: Int
    var totalCheckIns: Int
    var lastCheckInDate: Date?
    var monthlyConsistency: Double  // 0.0-1.0 (percentage)
    
    static var empty: StreakData {
        StreakData(currentStreak: 0, longestStreak: 0, totalCheckIns: 0, lastCheckInDate: nil, monthlyConsistency: 0.0)
    }
}

// MARK: - Streak Calculator

class StreakCalculator {
    static let shared = StreakCalculator()
    
    private init() {}
    
    // Calculate current streak from check-ins
    func calculateCurrentStreak(from checkIns: [CheckIn]) -> Int {
        guard !checkIns.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Group check-ins by day
        let dayGroups = Dictionary(grouping: checkIns) { checkIn in
            calendar.startOfDay(for: checkIn.timestamp)
        }
        
        var streak = 0
        var currentDay = today
        
        // Count consecutive days backward from today
        while dayGroups[currentDay] != nil {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay) else {
                break
            }
            currentDay = previousDay
        }
        
        // Grace period: if no check-in today but had one yesterday, still count it
        if dayGroups[today] == nil {
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
               dayGroups[yesterday] != nil {
                // Streak already includes yesterday from the loop above
                return streak
            } else {
                // No check-in today or yesterday -> streak broken
                return 0
            }
        }
        
        return streak
    }
    
    // Calculate longest streak ever
    func calculateLongestStreak(from checkIns: [CheckIn]) -> Int {
        guard !checkIns.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        
        // Get all unique days with check-ins, sorted
        let uniqueDays = Set(checkIns.map { calendar.startOfDay(for: $0.timestamp) })
            .sorted()
        
        guard !uniqueDays.isEmpty else { return 0 }
        
        var longestStreak = 1
        var currentStreak = 1
        
        for i in 1..<uniqueDays.count {
            let previousDay = uniqueDays[i - 1]
            let currentDay = uniqueDays[i]
            
            // Check if days are consecutive
            if let nextDay = calendar.date(byAdding: .day, value: 1, to: previousDay),
               calendar.isDate(nextDay, inSameDayAs: currentDay) {
                currentStreak += 1
                longestStreak = max(longestStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return longestStreak
    }
    
    // Calculate monthly consistency (last 30 days)
    func calculateMonthlyConsistency(from checkIns: [CheckIn]) -> Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        guard let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: today) else {
            return 0.0
        }
        
        // Filter check-ins from last 30 days
        let recentCheckIns = checkIns.filter { $0.timestamp >= thirtyDaysAgo }
        
        guard !recentCheckIns.isEmpty else { return 0.0 }
        
        // Count unique days with check-ins
        let uniqueDays = Set(recentCheckIns.map { calendar.startOfDay(for: $0.timestamp) })
        
        // Consistency = (days with check-ins / 30) * 100
        let consistency = Double(uniqueDays.count) / 30.0
        return min(consistency, 1.0)  // Cap at 100%
    }
    
    // Calculate complete streak data
    func calculateStreakData(from checkIns: [CheckIn]) -> StreakData {
        let currentStreak = calculateCurrentStreak(from: checkIns)
        let longestStreak = calculateLongestStreak(from: checkIns)
        let monthlyConsistency = calculateMonthlyConsistency(from: checkIns)
        let lastCheckIn = checkIns.max(by: { $0.timestamp < $1.timestamp })
        
        return StreakData(
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            totalCheckIns: checkIns.count,
            lastCheckInDate: lastCheckIn?.timestamp,
            monthlyConsistency: monthlyConsistency
        )
    }
    
    // Check if milestone was just reached
    func checkMilestone(previousStreak: Int, newStreak: Int) -> Int? {
        let milestones = [7, 14, 30, 50, 100, 365]
        
        for milestone in milestones {
            if previousStreak < milestone && newStreak >= milestone {
                return milestone
            }
        }
        
        return nil
    }
}
EOF2
echo "✅ Created StreakData.swift"
INNERBASH

echo "✅ All Week 1 files created!"

