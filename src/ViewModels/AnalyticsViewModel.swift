// AnalyticsViewModel.swift
// PosturePal Pro - Week 4-5
// ViewModel for analytics dashboard

import Foundation
import SwiftUI
import UniformTypeIdentifiers

class AnalyticsViewModel: ObservableObject {
    @Published var selectedPeriod: AnalyticsPeriod = .month {
        didSet {
            refreshAnalytics()
        }
    }
    
    @Published var analytics: AnalyticsData
    @Published var checkIns: [CheckIn] = []
    
    private let persistenceController = PersistenceController.shared
    
    init() {
        // Initialize with empty analytics
        self.analytics = AnalyticsData.calculate(from: [], period: .month)
        loadCheckIns()
    }
    
    /// Load check-ins from CoreData
    func loadCheckIns() {
        let context = persistenceController.container.viewContext
        checkIns = CheckIn.fetchAll(context: context)
        refreshAnalytics()
    }
    
    /// Refresh analytics calculations
    private func refreshAnalytics() {
        analytics = AnalyticsData.calculate(from: checkIns, period: selectedPeriod)
    }
    
    /// X-axis stride for chart
    var xAxisStride: Int {
        switch selectedPeriod {
        case .week:
            return 1
        case .month:
            return 3
        case .year:
            return 30
        }
    }
    
    /// Peak hour as formatted string
    var peakHourString: String {
        guard let hour = analytics.peakHour else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date())!
        return formatter.string(from: date)
    }
    
    // MARK: - Export & Share
    
    /// Export data as CSV
    func exportData() {
        let csv = generateCSV()
        
        // Create temporary file
        let fileName = "PosturePal_Export_\(Date().timeIntervalSince1970).csv"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try csv.write(to: tempURL, atomically: true, encoding: .utf8)
            shareFile(url: tempURL)
        } catch {
            print("Error exporting CSV: \(error)")
        }
    }
    
    /// Generate CSV string
    private func generateCSV() -> String {
        var csv = "Date,Time,Timestamp\n"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        for checkIn in checkIns.sorted(by: { $0.timestamp < $1.timestamp }) {
            let date = formatter.string(from: checkIn.timestamp)
            let time = timeFormatter.string(from: checkIn.timestamp)
            let timestamp = Int(checkIn.timestamp.timeIntervalSince1970)
            csv += "\(date),\(time),\(timestamp)\n"
        }
        
        return csv
    }
    
    /// Share stats as image (placeholder - would need rendering)
    func shareStats() {
        // In a real implementation, we would:
        // 1. Render the analytics view to an image
        // 2. Share via UIActivityViewController
        // For now, just share text summary
        
        let summary = """
        PosturePal Stats (\(selectedPeriod.title))
        
        Total Check-Ins: \(analytics.totalCheckIns)
        Compliance Rate: \(Int(analytics.complianceRate * 100))%
        Avg Per Day: \(String(format: "%.1f", analytics.averagePerDay))
        Peak Hour: \(peakHourString)
        
        Keep up the great posture! 💪
        """
        
        shareText(summary)
    }
    
    /// Share file via activity controller
    private func shareFile(url: URL) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                return
            }
            
            let activityVC = UIActivityViewController(
                activityItems: [url],
                applicationActivities: nil
            )
            
            // For iPad
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = rootViewController.view
                popover.sourceRect = CGRect(x: rootViewController.view.bounds.midX,
                                          y: rootViewController.view.bounds.midY,
                                          width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            rootViewController.present(activityVC, animated: true)
        }
    }
    
    /// Share text via activity controller
    private func shareText(_ text: String) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                return
            }
            
            let activityVC = UIActivityViewController(
                activityItems: [text],
                applicationActivities: nil
            )
            
            // For iPad
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = rootViewController.view
                popover.sourceRect = CGRect(x: rootViewController.view.bounds.midX,
                                          y: rootViewController.view.bounds.midY,
                                          width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            rootViewController.present(activityVC, animated: true)
        }
    }
}
