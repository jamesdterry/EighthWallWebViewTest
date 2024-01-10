//
//  MotionViewController.swift
//  EighthWallWebViewTest
//
//  Created by James Terry on 1/9/24.
//

import UIKit
import CoreMotion

class MotionViewController: UIViewController {

    let interval = 0.01
    let imageWidth = CGFloat(800)
    let imageHeight = CGFloat(1200)

    let manager = CMMotionManager()
    var imageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard manager.isDeviceMotionAvailable else { return }

        setImageView()

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
        
        manager.deviceMotionUpdateInterval = interval
        let queue = OperationQueue()

        manager.startDeviceMotionUpdates(to: queue, withHandler: {(data, error) in
            guard let data = data else { return }
            let gravity = data.gravity
            let rotation = atan2(gravity.x, gravity.y) - .pi

            OperationQueue.main.addOperation {
                self.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
            }
        })
    }

    func setImageViewOld() {
        if let img = UIImage(named: "Shuttle") {
            let iv = UIImageView(image: img)

            // center the image
            let x = (self.view.frame.width/2)-(imageWidth/2)
            let y = (self.view.frame.height/2)-(imageHeight/2)
            iv.frame = CGRect(x: x, y: y, width: imageWidth, height: imageHeight)

            self.view.addSubview(iv)
            self.imageView = iv
        }
    }

    func setImageView() {
        if let img = UIImage(named: "Shuttle") {
            let iv = UIImageView(image: img)
            iv.translatesAutoresizingMaskIntoConstraints = false  // Enable Auto Layout
            self.view.addSubview(iv)
            self.imageView = iv

            // Set up Auto Layout constraints
            NSLayoutConstraint.activate([
                iv.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                iv.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                iv.widthAnchor.constraint(equalToConstant: imageWidth),
                iv.heightAnchor.constraint(equalToConstant: imageHeight)
            ])
        }
    }


    @objc func buttonTappedMenu(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("ShowMenu"), object: nil)
    }
}
