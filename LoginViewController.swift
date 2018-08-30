//
//  LoginViewController.swift
//  stayInTouch
//
//  Created by cosma kufa on 12/19/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Contacts
import UserNotifications

class LoginViewController: UIViewController {
    var personStore: PersonStore!
    override func viewDidLoad() {
        super.viewDidLoad()
        if  AccessToken.current != nil {
            self.loadApp()
        }else{
     /**
        let loginButton =  LoginButton(readPermissions: [ .publicProfile ])
        loginButton.target(forAction: #selector(self.loginButtonClicked), withSender: self)
        loginButton.center = view.center
        view.addSubview(loginButton)
 */
        // Add a custom login button to your app
        let myLoginButton = UIButton.init(type: .custom)
        myLoginButton.backgroundColor = UIColor.darkGray
        myLoginButton.frame = CGRect.init(x: 0, y: 0, width: 180, height: 40);
        myLoginButton.center = view.center;
        myLoginButton.setTitle("Login/Register", for: .normal)
        
        // Handle clicks on the button
        myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(myLoginButton)
        // Do any additional setup after loading the view.
        }
    }
    
    // Once the button is clicked, show the login dialog
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ ReadPermission.publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
               print("we in here")
               self.loadApp()
            }
        }
    }
    
    func loadApp(){
        let center = Notifications.center
        let contactStoreMod = ContactStoreMod()
        let imageStore = ImageStore()
        Notifications.setDelegate()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if granted {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        }
        Notifications.setNextReminder(personStore: personStore)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let navController =  storyboard.instantiateViewController(withIdentifier: "genesis") as! UINavigationController
        let tabController = navController.topViewController as! UITabBarController as! HomeTabBarController
        tabController.encounterStore = personStore.encounters
        tabController.imageStore = imageStore
        tabController.personStore = personStore
        
        let encountersController = tabController.viewControllers![1] as! EncountersViewController
        encountersController.imageStore = imageStore
        encountersController.allEncounters = true
        encountersController.personStore = personStore
        
        let contactController = tabController.viewControllers![0] as! ContactsViewController
        contactController.contactStoreMod = contactStoreMod
        contactController.personStore = personStore
        contactController.imageStore = imageStore
        present(navController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
