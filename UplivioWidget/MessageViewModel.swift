//
//  MessageViewModel.swift
//  Uplivio_CoreData
//
//  Created by Sümeyra Demirtaş on 10/23/24.
//

import CoreData

class MessageViewModel {
    // MARK: - Properties
    private var messages: [String] = [] // Çekilen mesajlar
    private var context: NSManagedObjectContext

    // MARK: - Initializer
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
        loadMessagesFromCoreData()
    }

    // MARK: - Public Methods

    /// Günün mesajını döner
    func getMessageForToday() -> String {
        let dayIndex = getCurrentDayIndex() // Yılın gününü al
        guard !messages.isEmpty else { return "No messages available." }
        return messages[dayIndex % messages.count] // Mod işlemine göre mesaj döndür
    }

    // MARK: - Private Methods

    /// Core Data'dan mesajları yükler
    private func loadMessagesFromCoreData() {
        let fetchRequest: NSFetchRequest<Sentence> = Sentence.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            messages = results.map { $0.message ?? "" } // Core Data'daki tüm mesajları al
        } catch {
            print("Error fetching messages from Core Data: \(error)")
        }
    }

    /// Mevcut günü hesaplar
    private func getCurrentDayIndex() -> Int {
        let calendar = Calendar.current
        guard let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) else {
            return 0
        }
        return dayOfYear
    }
}
