//
//  CustomSentencesViewController.swift
//  CustomVibes
//
//  Created by Sümeyra Demirtaş on 1/6/25.
//

import UIKit
import CoreData

class CustomSentencesViewController: UIViewController {
    // MARK: - Properties
    let tableView = UITableView()
    var sentences: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Custom Sentences"
        
        setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSentenceTapped))
        
        fetchSentences() // Verileri yükle
    }

    // MARK: - Setup TableView
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SentenceCell")
    }

    // MARK: - Core Data
    func fetchSentences() {
        let fetchRequest: NSFetchRequest<Sentence> = Sentence.fetchRequest()
        do {
            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
            sentences = results.map { $0.message ?? "" }
            tableView.reloadData()
        } catch {
            print("Error fetching sentences: \(error)")
        }
    }
    
    // MARK: - Add Sentence
    @objc private func addSentenceTapped() {
        let alert = UIAlertController(title: "Add Sentence", message: "Enter a new sentence below.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Your sentence here"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self, let newSentence = alert.textFields?.first?.text, !newSentence.isEmpty else { return }
            
            let sentence = Sentence(context: CoreDataManager.shared.context)
            sentence.message = newSentence
            CoreDataManager.shared.saveContext()
            
            self.fetchSentences()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func editSentence(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Sentence", message: "Update your sentence below.", preferredStyle: .alert)
        
        // TextField'e mevcut cümleyi ekleyelim
        alert.addTextField { textField in
            textField.text = self.sentences[indexPath.row] // Seçilen cümle
        }
        
        // Save butonu
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self, let updatedText = alert.textFields?.first?.text, !updatedText.isEmpty else { return }
            
            // Core Data'daki veriyi güncelle
            let fetchRequest: NSFetchRequest<Sentence> = Sentence.fetchRequest()
            do {
                let results = try CoreDataManager.shared.context.fetch(fetchRequest)
                let sentenceToUpdate = results[indexPath.row]
                sentenceToUpdate.message = updatedText // Yeni metni ata
                
                CoreDataManager.shared.saveContext() // Güncellemeyi kaydet
                
                // TableView'daki diziyi güncelle ve yenile
                self.sentences[indexPath.row] = updatedText
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } catch {
                print("Error updating sentence: \(error)")
            }
        }
        
        // Cancel butonu
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        // Alert'i göster
        present(alert, animated: true, completion: nil)
    }
}
    

extension CustomSentencesViewController: UITableViewDataSource, UITableViewDelegate {
    // Satır sayısını belirliyoruz
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentences.count
    }

    // Her hücrenin içeriğini belirliyoruz
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentenceCell", for: indexPath)
        cell.textLabel?.text = sentences[indexPath.row]
        return cell
    }

    // Silme özelliğini ekliyoruz
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fetchRequest: NSFetchRequest<Sentence> = Sentence.fetchRequest()
            
            do {
                let results = try CoreDataManager.shared.context.fetch(fetchRequest)
                let sentenceToDelete = results[indexPath.row]
                CoreDataManager.shared.context.delete(sentenceToDelete)
                CoreDataManager.shared.saveContext()
                
                sentences.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Error deleting sentence: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Hücrenin seçili durumunu kaldır
        
        // Düzenleme işlemini başlat
        editSentence(at: indexPath)
    }

    // Hücrelerin düzenlenebilir olduğunu belirtmek için
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
