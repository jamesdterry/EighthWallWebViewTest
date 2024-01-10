//
//  MenuViewController.swift
//  EighthWallWebViewTest
//
//  Created by James Terry on 1/9/24.
//

import UIKit
import AVFoundation

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        // Create the stack view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Create the buttons
        let button1 = UIButton(type: .system)
        button1.setTitle("Hacker News", for: .normal)
        button1.addTarget(self, action: #selector(buttonTappedHackerNews), for: .touchUpInside)
        button1.titleLabel?.adjustsFontForContentSizeCategory = true

        let button2 = UIButton(type: .system)
        button2.setTitle("8th Wall Demo", for: .normal)
        button2.addTarget(self, action: #selector(buttonTapped8thWall), for: .touchUpInside)
        button2.titleLabel?.adjustsFontForContentSizeCategory = true

        let button3 = UIButton(type: .system)
        button3.setTitle("8th Wall Debug", for: .normal)
        button3.addTarget(self, action: #selector(buttonTapped8thWallDebug), for: .touchUpInside)
        button3.titleLabel?.adjustsFontForContentSizeCategory = true

        let button4 = UIButton(type: .system)
        button4.setTitle("Motion Test", for: .normal)
        button4.addTarget(self, action: #selector(buttonTappedMotion), for: .touchUpInside)
        button4.titleLabel?.adjustsFontForContentSizeCategory = true

        // Add buttons to the stack view
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(button3)
        stackView.addArrangedSubview(button4)

        // Add the stack view to the view
        view.addSubview(stackView)

        // Set up constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func buttonTappedHackerNews(sender: UIButton) {
        let userInfo = ["url": "https://news.ycombinator.com"]
        NotificationCenter.default.post(name: NSNotification.Name("ShowWebView"), object: nil, userInfo: userInfo)
    }

    @objc func buttonTapped8thWall(sender: UIButton) {
        requestCameraPermission {
            let userInfo = ["url": "https://jamesdterry.8thwall.app/inapickle/"]
            NotificationCenter.default.post(name: NSNotification.Name("ShowWebView"), object: nil, userInfo: userInfo)
        }
    }

    @objc func buttonTapped8thWallDebug(sender: UIButton) {
        requestCameraPermission {
            let userInfo = ["url": "https://8w.8thwall.app/iframe-debug/"]
            NotificationCenter.default.post(name: NSNotification.Name("ShowWebView"), object: nil, userInfo: userInfo)
        }
    }

    @objc func buttonTappedMotion(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("ShowMotion"), object: nil)
    }

    private func requestCameraPermission(completion: @escaping () -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    completion()
                }
                // Handle the case if permission is denied
            }
        default:
            // Handle the case if permission is already denied
            break
        }
    }
}
