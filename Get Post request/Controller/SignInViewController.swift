//
//  SignInViewController.swift
//  Get Post request
//
//  Created by Roman Belov on 09.06.2022.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var signLabel: UILabel!
    
    lazy var emailLabel: UILabel = {
        var label = UILabel()
        label.frame = CGRect(x: 32, y: 0, width: view.frame.width - 64, height: 32)
        label.center.y = signLabel.center.y + 64
        label.text = "EMAIL"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        var textField = UITextField()
        textField.frame = CGRect(x: 32, y: 0, width: view.frame.width - 64, height: 32)
        textField.center.y = emailLabel.center.y + 28
        textField.addBottomLine(withColor: .black)
        return textField
    }()
    
    lazy var passwordLabel: UILabel = {
        var label = UILabel()
        label.frame = CGRect(x: 32, y: 0, width: view.frame.width - 64, height: 32)
        label.center.y = emailTextField.center.y + 64
        label.text = "PASSWORD"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.frame = CGRect(x: 32, y: 0, width: view.frame.width - 64, height: 32)
        textField.center.y = passwordLabel.center.y + 28
        textField.addBottomLine(withColor: .black)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var signUpButton: UIButton = {
        var button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width - 64, height: 50)
        button.center.x = view.center.x
        button.center.y = passwordTextField.center.y + 80
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(goToSignUP), for: .touchUpInside)
        return button
    }()
    
    lazy var continueButton: UIButton = {
        var button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width - 192, height: 50)
        button.center.x = view.center.x
        button.center.y = view.frame.height - 80
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        var activity = UIActivityIndicatorView(style: .medium)
        activity.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activity.center = continueButton.center
        return activity
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setContinueButton(enabled: false)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    private func setupView() {
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(continueButton)
        view.addSubview(activityIndicator)
    }

    private func setContinueButton(enabled: Bool) {
        if enabled {
            continueButton.alpha = 1
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc func textFieldChanged() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        
        let formFilled = !(email.isEmpty) && !(password.isEmpty)
        
        setContinueButton(enabled: formFilled)
    }
    
    @IBAction func goBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goToSignUP() {
        performSegue(withIdentifier: "ToSignUpVC", sender: nil)
    }
    
    @objc func handleSignIn() {
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                
                print(error.localizedDescription)
                self.setContinueButton(enabled: true)
                self.continueButton.setTitle("Continue", for: .normal)
                self.activityIndicator.stopAnimating()
                self.continueButton.shake()
                
                return
            }
            
            print("Successfully logged into Firebase with User Email")
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
        activityIndicator.center = continueButton.center
    }
    
    @objc func keyboardWillHide() {
        continueButton.center.y = view.frame.height - 80 
        activityIndicator.center = continueButton.center
    }

}


extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default: break
        }
        return true
    }
}
