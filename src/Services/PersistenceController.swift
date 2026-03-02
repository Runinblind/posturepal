//
//  PersistenceController.swift
//  PosturePal
//
//  Week 1 - CoreData Stack Setup
//

import CoreData

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PosturePal")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                // In production, handle this more gracefully
                fatalError("❌ Core Data failed to load: \(error.localizedDescription)")
            }
            print("✅ Core Data loaded: \(description)")
        }
        
        // Automatic merging of changes from parent
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - Save Context
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                print("💾 Core Data saved successfully")
            } catch {
                print("❌ Failed to save Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Preview Helper (for SwiftUI previews)
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        // Create sample data for previews
        for i in 0..<10 {
            let checkIn = CheckIn(context: context)
            checkIn.id = UUID()
            checkIn.timestamp = Date().addingTimeInterval(TimeInterval(-i * 3600))
            checkIn.wasOnTime = i % 2 == 0
        }
        
        do {
            try context.save()
        } catch {
            print("❌ Preview data creation failed: \(error)")
        }
        
        return controller
    }()
}

// MARK: - CoreData Model Definition (Documentation)

/*
 PosturePal.xcdatamodeld should contain:
 
 Entity: CheckIn
 - id: UUID (indexed, required)
 - timestamp: Date (indexed, required)
 - wasOnTime: Boolean (default: false)
 
 Note: This file documents the expected schema.
 The actual .xcdatamodeld file must be created in Xcode.
 */
