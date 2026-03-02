// AnalyticsData.swift
// PosturePal Pro - Week 4-5
// Advanced analytics calculations for charts and insights

import Foundation

/// Analytics time period
enum AnalyticsPeriod {
    case week
    case month
    case year
    
    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .year: return 365
        }
    }
    
    var title: String {
        switch self {
        case .week: return "Week"
        case .month: return "Month"
        case .year: return "Year"
        }
    }
}

/// Daily check-in count for charts
struct DailyCheckInData: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

/// Hourly check-in distribution (heatmap data)
struct HourlyCheckInData: Identifiable {
    let id = UUID()
    let hour: Int
    let count: Int
    
    var hourLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date())!
        return formatter.string(from: date)
    }
}

/// Day of week check-in distribution
struct WeekdayCheckInData: Identifiable {
    let id = UUID()
    let weekday: Int // 1 = Sunday, 7 = Saturday
    let count: Int
    
    var weekdayName: String {
        let formatter = DateFormatter()
        return formatter.weekdaySymbols[weekday - 1]
    }
    
    var shortWeekday: String {
        let formatter = DateFormatter()
        return formatter.shortWeekdaySymbols[weekday - 1]
    }
}

/// Complete analytics data structure
struct AnalyticsData {
    let period: AnalyticsPeriod
    let dailyData: [DailyCheckInData]
    let hourlyData: [HourlyCheckInData]
    let weekdayData: [WeekdayCheckInData]
    
    let totalCheckIns: Int
    let averagePerDay: Double
    let complianceRate: Double // 0.0 - 1.0
    let bestDay: Date?
    let worstDay: Date?
    let peakHour: Int?
    
    /// Calculate analytics from check-ins
    static func calculate(from checkIns: [CheckIn], period: AnalyticsPeriod) -> AnalyticsData {
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .day, value: -period.days, to: now)!
        
        // Filter check-ins for period
        let periodCheckIns = checkIns.filter { $0.timestamp >= startDate }
        
        // Daily data
        var dailyDict: [Date: Int] = [:]
        for day in 0..<period.days {
            let date = calendar.date(byAdding: .day, value: -day, to: now)!
            let dayStart = calendar.startOfDay(for: date)
            dailyDict[dayStart] = 0
        }
        
        for checkIn in periodCheckIns {
            let dayStart = calendar.startOfDay(for: checkIn.timestamp)
            dailyDict[dayStart, default: 0] += 1
        }
        
        let dailyData = dailyDict.map { DailyCheckInData(date: $0.key, count: $0.value) }
            .sorted { $0.date < $1.date }
        
        // Hourly data (0-23)
        var hourlyDict: [Int: Int] = [:]
        for hour in 0..<24 {
            hourlyDict[hour] = 0
        }
        
        for checkIn in periodCheckIns {
            let hour = calendar.component(.hour, from: checkIn.timestamp)
            hourlyDict[hour, default: 0] += 1
        }
        
        let hourlyData = hourlyDict.map { HourlyCheckInData(hour: $0.key, count: $0.value) }
            .sorted { $0.hour < $1.hour }
        
        // Weekday data (1=Sunday, 7=Saturday)
        var weekdayDict: [Int: Int] = [:]
        for weekday in 1...7 {
            weekdayDict[weekday] = 0
        }
        
        for checkIn in periodCheckIns {
            let weekday = calendar.component(.weekday, from: checkIn.timestamp)
            weekdayDict[weekday, default: 0] += 1
        }
        
        let weekdayData = weekdayDict.map { WeekdayCheckInData(weekday: $0.key, count: $0.value) }
            .sorted { $0.weekday < $1.weekday }
        
        // Calculate stats
        let totalCheckIns = periodCheckIns.count
        let averagePerDay = Double(totalCheckIns) / Double(period.days)
        
        // Compliance rate: days with at least 1 check-in / total days
        let daysWithCheckIns = dailyDict.values.filter { $0 > 0 }.count
        let complianceRate = Double(daysWithCheckIns) / Double(period.days)
        
        // Best and worst days
        let bestDay = dailyData.max(by: { $0.count < $1.count })?.date
        let worstDay = dailyData.min(by: { $0.count < $1.count })?.date
        
        // Peak hour
        let peakHour = hourlyData.max(by: { $0.count < $1.count })?.hour
        
        return AnalyticsData(
            period: period,
            dailyData: dailyData,
            hourlyData: hourlyData,
            weekdayData: weekdayData,
            totalCheckIns: totalCheckIns,
            averagePerDay: averagePerDay,
            complianceRate: complianceRate,
            bestDay: bestDay,
            worstDay: worstDay,
            peakHour: peakHour
        )
    }
}
