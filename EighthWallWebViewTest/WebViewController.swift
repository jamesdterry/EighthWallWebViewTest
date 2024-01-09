//
//  WebViewController.swift
//  EighthWallWebViewTest
//
//  Created by James Terry on 1/9/24.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView: WKWebView!
    var url: String?

    // Custom initializer
    init(url: String?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view = UIView()
        view.addSubview(webView)

        webView.uiDelegate = self

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let button = UIButton(type: .system)
        button.setTitle("Menu", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.layer.cornerRadius = 5
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        button.configuration = configuration
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonTappedMenu), for: .touchUpInside)

        // Constraints for the button
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlString = self.url {
            if let myURL = URL(string: urlString) {
                let myRequest = URLRequest(url: myURL)
                webView.load(myRequest)
            }
        }
    }

    @objc func buttonTappedMenu(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("ShowMenu"), object: nil)
    }
}

extension WebViewController: WKUIDelegate {
    open func webView(_ webView: WKWebView,
                      requestMediaCapturePermissionFor origin: WKSecurityOrigin,
                      initiatedByFrame frame: WKFrameInfo,
                      type: WKMediaCaptureType,
                      decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        decisionHandler(.grant)
    }

    open func webView(_ webView: WKWebView,
                      requestDeviceOrientationAndMotionPermissionFor origin: WKSecurityOrigin,
                      initiatedByFrame frame: WKFrameInfo,
                      decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        decisionHandler(.grant)
    }

}
