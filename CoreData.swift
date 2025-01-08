//
//  CoreData.swift
//  CustomVibes
//
//  Created by Sümeyra Demirtaş on 1/6/25.

import CoreData

class CoreDataManager {
    // Singleton tasarım deseni: Bu sınıfın yalnızca bir örneği olmasını sağlıyoruz.
    static let shared = CoreDataManager() // Tek bir ortak örnek oluşturduk.

    // Init'i private yaparak dışarıdan yeni bir örnek oluşturulmasını engelliyoruz.
    private init() {}

//    // Core Data'nın tüm işlemlerini yöneten "persistent container"
//    lazy var persistentContainer: NSPersistentContainer = {
//        // Veri modelimizin adını burada belirtiyoruz.
//        // "SentencesModel" dosyanızın adını yazmalısınız.
//        let container = NSPersistentContainer(name: "SentencesModel")
//
//        // Persistent Store'u (veri deposunu) yüklemeye çalışıyoruz.
//        container.loadPersistentStores { _, error in
//            if let error = error {
//                // Eğer hata oluşursa uygulamayı burada durduruyoruz
//                // (genellikle hata burada çözülür, fatal error olarak bırakılmaz)
//                fatalError("Unresolved error \(error.localizedDescription)")
//            }
//        }
//        return container
//    }()
//    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SentencesModel")

        if let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.dmrts.CustomVibes") {
            print("App Group URL: \(appGroupURL)")
            let storeURL = appGroupURL.appendingPathComponent("SentencesModel.sqlite")
            let description = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [description]
        } else {
            print("App Group URL not found!")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    // Context: Core Data ile çalışırken kullandığımız işlem birimi.
    // Veri ekleme, güncelleme ve silme işlemleri bu context üzerinden yapılır.
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Verileri kaydetmek için bir yardımcı fonksiyon.
    func saveContext() {
        // Eğer context'te değişiklikler varsa
        if context.hasChanges {
            do {
                // Değişiklikleri kaydet
                try context.save()
            } catch {
                // Eğer kaydetme sırasında bir hata oluşursa,
                // hatanın detaylarını yazdır ve uygulamayı durdur
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
