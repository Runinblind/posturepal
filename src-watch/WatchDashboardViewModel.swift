//
//  WatchDashboardViewModel.swift
//  PosturePal Watch App
//
//  ViewModel for the Watch app dashboard
//

import Foundation
import Combine

class WatchDashboardViewModel: ObservableObject {
    @Published var isCheckingIn: Bool = false
    @Published var showSuccessAnimation: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Perform a check-in
    func checkIn() {
        guard !isCheckingIn else { return }
        
        isCheckingIn = true
        
        // Send to iPhone via WatchConnectivity
        WatchConnectivityManager.shared.sendCheckIn()
        
        // Show success animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.showSuccessAnimation = true
            self?.isCheckingIn = false
            
            // Auto-dismiss after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self?.showSuccessAnimation = false
            }
        }
    }
    
    /// Format next reminder time as relative string
    func nextReminderText(from date: Date?) -> String {
        guard let date = date else { return "Not scheduled" }
        
        let now = Date()
        let interval = date.timeIntervalSince(now)
        
        if interval < 0 {
            return "Now"
        }
        
        let minutes = Int(interval / 60)
        let hours = minutes / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes % 60)m"
        } else {
            return "\(minutes)m"
        }
    }
}
