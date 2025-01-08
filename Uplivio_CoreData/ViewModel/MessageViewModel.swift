////
////  MessageViewModel.swift
////  Uplivio_CoreData
////
////  Created by Sümeyra Demirtaş on 10/23/24.
////
//
//import Foundation
//
//class MessageViewModel {
//    // JSON dosyasından çekilen verileri tutan property
//    private var messageData: Message?
//
//    // Mesaj türünü belirleme
//    func getMessageTypeForDay() -> String {
//        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
//        switch (dayOfYear - 1) % 4 {
//        case 0:
//            return "motivationalMessages"
//        case 1:
//            return "inspiringQuotes"
//        case 2:
//            return "positiveThoughts"
//        case 3:
//            return "mindfulnessMessages"
//        default:
//            return "motivationalMessages"
//        }
//    }
//
//    // getMessageForToday
//    func getMessageForToday() -> String {
//        guard let messageData = messageData else { return "No message available" }
//        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
//
//        let messageType = getMessageTypeForDay()
//
//
//        // Mesaj türüne göre mesajı seçme
//        switch messageType {
//        case "motivationalMessages":
//            return messageData.motivationalMessages[dayOfYear % messageData.motivationalMessages.count]
//        case "inspiringQuotes":
//            return messageData.inspiringQuotes[dayOfYear % messageData.inspiringQuotes.count]
//        case "positiveThoughts":
//            return messageData.positiveThoughts[dayOfYear % messageData.positiveThoughts.count]
//        case "mindfulnessMessages":
//            return messageData.mindfulnessMessages[dayOfYear % messageData.mindfulnessMessages.count]
//        default:
//            return "No message available"
//        }
//    }
//
//    // upload JSON File
//    func loadMessages(for language: String) {
//        let fileName = (language == "tr") ? "messages_tr" : "messages_en"
//        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path))
//                let messageResponse = try JSONDecoder().decode(MessageResponse.self, from: data)
//                messageData = messageResponse.messages
//            } catch {
//                print("Error loading JSON: \(error)")
//            }
//        }
//    }
//}



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
