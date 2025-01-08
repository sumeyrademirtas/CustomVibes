//
//  LaunchScreen.swift
//  Uplivio
//
//  Created by Sümeyra Demirtaş on 10/17/24.
//

import Lottie
import UIKit

class LaunchScreenViewController: UIViewController {
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Launch")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start each day with inspiration"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "gradientAnimation")
        animation.contentMode = .scaleAspectFit
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackgroundAnimation()
        setMessageBasedOnLanguage()
        setupUI()

        startLottieAnimationandGoToMainScreen()
    }

    func setupBackgroundAnimation() {
        view.addSubview(animationView)
        view.frame = view.bounds
    }

    func setupUI() {
        view.addSubview(appIconImageView)
        view.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            appIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appIconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            appIconImageView.widthAnchor.constraint(equalToConstant: 200),
            appIconImageView.heightAnchor.constraint(equalToConstant: 200)
        ])

        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setMessageBasedOnLanguage() {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        
        if preferredLanguage.contains("tr") {
            messageLabel.text = "Her güne ilhamla başla"
        } else {
            messageLabel.text = "Start each day with inspiration"
        }
    }

    func startLottieAnimationandGoToMainScreen() {
        animationView.play()
        let mainVC = ViewController()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }

            mainVC.modalPresentationStyle = .fullScreen
            UIView.transition(with: self.view.window!, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.present(mainVC, animated: false, completion: nil)
            })
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
