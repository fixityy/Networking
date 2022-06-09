//
//  LoginViewController.swift
//  Get Post request
//
//  Created by Roman Belov on 07.06.2022.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    lazy var googleLoginButton: GIDSignInButton = {
        var button = GIDSignInButton()
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width - 64, height: 50)
        button.center = view.center
        button.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
        return button
    }()
    
    lazy var customGoogleLoginButton: UIButton = {
        var button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width - 64, height: 50)
        button.center.x = view.center.x
        button.center.y = view.center.y + 80
        button.setTitle("Login with Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
        return button
    }()
    
    lazy var signWithEmailButton: UIButton = {
        var button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width - 64, height: 50)
        button.center.x = view.center.x
        button.center.y = view.center.y + 80 + 80
        button.setTitle("Sign with Email", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(goToSignIn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(googleLoginButton)
        view.addSubview(customGoogleLoginButton)
        view.addSubview(signWithEmailButton)
    }
    
    
    @objc func googleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            
            if let error = error {
                print("Failed to log into Google: \(error)")
                return
            }
            
            print("Successfully logged into Google")

            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Failed to log in with Google: \(error)")
                    return
                }
                // User is signed in
                print("Successfully logged into firebase with Google")
                self.openMainVC()
            }
        }
    }
    
    @objc private func goToSignIn(){
        performSegue(withIdentifier: "ToSignInVC", sender: nil)
    }
    
    private func openMainVC(){
        dismiss(animated: true)
    }
    
}
