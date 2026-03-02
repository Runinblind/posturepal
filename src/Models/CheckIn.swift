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
