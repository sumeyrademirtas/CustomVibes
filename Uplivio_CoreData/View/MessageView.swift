//
//  MessageView.swift
//  Uplivio_CoreData
//
//  Created by Sümeyra Demirtaş on 10/30/24.
//

import UIKit

class MessageView: UIView {
    // MARK: - UI Components

    // Motivational message label
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading motivational message..."
        label.textAlignment = .center
        label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.alpha = 0.0 // Animasyon öncesi görünmez
        return label
    }()

    // Sağ alt köşeye eklenecek buton
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("🦔", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30) 
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()

    private let gradientLayer = CAGradientLayer()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    // UI'yi ayarlayan fonksiyon
    func setupUI() {
        // Arka plan rengini gradient ile ayarla
        setGradientBackground()

        // Mesaj Label'ı ekle
        addSubview(messageLabel)
        addSubview(addButton)

        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            // Sağ alt köşeye butonu yerleştiriyoruz
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)

        ])
    }

    // MARK: - Functions

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func fadeInText() {
        // UIView animasyonu ile opacity'yi değiştiriyoruz
        UIView.animate(withDuration: 3.0, // animasyon süresi (2 saniye)
                       delay: 0.0, // animasyon başlamadan önceki bekleme süresi
                       options: .curveEaseIn, // animasyon eğrisi
                       animations: {
                           self.messageLabel.alpha = 1.0 // Opaklığı 1.0'a (tamamen görünür) getiriyoruz
                       }, completion: nil)
    }

    // Set gradient background
    private func setGradientBackground() {
        let colors = BackgroundColors.randomTwoColors()
        gradientLayer.colors = [colors.color1.cgColor, UIColor.white.cgColor, colors.color2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        layer.insertSublayer(gradientLayer, at: 0)
    }
}
