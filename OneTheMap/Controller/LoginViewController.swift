//
//  ViewController.swift
//  OneTheMap
//
//  Created by Lixiang Zhang on 1/23/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private let signupPageURL = "https://www.udacity.com/account/auth#!/signup"

    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
    }

    @IBAction func signinTapped(_ sender: Any) {
        indicator.startAnimating()
        NetworkClient.login(email: email.text ?? "", password: password.text ?? "") { isSuccess, error in
            self.indicator.stopAnimating()
            if isSuccess {
                self.performSegue(withIdentifier: "loginComplete", sender: nil)
            } else {
                self.showAlert(title: "Login Failed", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        guard let url = URL(string: signupPageURL) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
