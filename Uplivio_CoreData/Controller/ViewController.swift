//
//  ViewController.swift
//  Uplivio_CoreData
//
//  Created by Sümeyra Demirtaş on 10/23/24.
//

import SwiftUI
import UIKit

class ViewController: UIViewController {
    // MARK: - Properties

    // ViewModel'den veri çeken property
    let viewModel = MessageViewModel()
    let messageView = MessageView()


    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view = messageView
        messageView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        // ViewModel'i kullanarak mesajları Core Data'dan yükle
        let todayMessage = viewModel.getMessageForToday()
        
        // Güne göre mesajı ekranda göster
        messageView.messageLabel.text = todayMessage
        messageView.messageLabel.alpha = 0.0
        
        // Animasyonlu bir şekilde mesajı göster
        updateMessageLabel()
    }
    
    // Butona tıklanınca çalışacak fonksiyon
    @objc private func addButtonTapped() {
        let customSentencesVC = CustomSentencesViewController() // Yeni ekranın instance'ı
        navigationController?.pushViewController(customSentencesVC, animated: true)
    }

    // Animasyonu viewDidAppear'da başlatıyoruz
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageView.fadeInText()
    }

    // MARK: - Functions

    private func updateMessageLabel() {
        messageView.messageLabel.text = viewModel.getMessageForToday()
    }
 

    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

#if DEBUG
import SwiftUI

// SwiftUI Preview için gerekli olan yapı
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview().edgesIgnoringSafeArea(.all)
    }

    struct ViewControllerPreview: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> ViewController {
            return ViewController()
        }

        func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
    }
}
#endif
