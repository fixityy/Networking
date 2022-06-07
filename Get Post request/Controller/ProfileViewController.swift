//
//  ProfileViewController.swift
//  Get Post request
//
//  Created by Roman Belov on 07.06.2022.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    lazy var logOutButton: UIButton = {
        var button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width - 64, height: 50)
        button.center = view.center
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        return button
    }()
    
    lazy var logLabel: UILabel = {
        var label = UILabel()
        label.frame = CGRect(x: 0, y: 100, width: view.frame.width - 64, height: 100)
        label.center.x = view.center.x
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        view.addSubview(logOutButton)
        view.addSubview(logLabel)
        logLabel.text = getlabelText()
    }
    
    @objc func logOut() {
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//            openLoginVC()
//            print("sign out")
//        } catch let signOutError as NSError {
//            print("Error signing out: %@", signOutError)
//        }
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facbook.com":
                    //implement...
                    print("User did log out of Facebook")
                case "google.com":
                    GIDSignIn.sharedInstance.signOut()
                    print("User did log out of Google")
                    openLoginVC()
                default:
                    print("User is signed in with: \(userInfo.providerID)")
                }
            }
        }
    }

}

extension ProfileViewController {
    
    private func openLoginVC(){
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                self.present(loginVC, animated: true, completion: nil)
                return
            }
        } catch let error {
            print("Failed to sign out with error: \(error)")
        }
    }
    
    private func getlabelText() -> String{
        var text = ""
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facbook.com":
                    text = "Facebook"
                case "google.com":
                    text = "Google"
                default:
                    break
                }
            }
        }
        return "You are logged in with \(text)"
    }
}
