//
//  ViewController.swift
//  LogoViewer
//
//  Created by Ambroise COLLON on 24/04/2018.
//  Copyright © 2018 OpenClassrooms. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func didTapSearchButton() {
        searchLogo(domain: textField.text)
    }

    override func viewDidLoad() {
        searchLogo(domain: "openclassrooms.com")
    }

    private func searchLogo(domain: String?) {
        guard domain != "" else {
            return presentAlert(with: "Domain is required")
        }

        toggleActivityIndicator(shown: true)

        LogoService.shared.getLogo(domain: domain!) { (success, logo) in
            self.toggleActivityIndicator(shown: false)
            if success, let logo = logo {
                self.updateLogo(logo: logo)
            } else {
                self.presentAlert(with: "The logo download failed.")
            }
        }
    }

    private func toggleActivityIndicator(shown: Bool) {
        searchButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }

    private func updateLogo(logo: Logo) {
        imageView.image = UIImage(data: logo.imageData)
    }

    private func presentAlert(with message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchLogo(domain: textField.text!)
        return true
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}
