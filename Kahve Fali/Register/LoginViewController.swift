//
//  FirstViewController.swift
//  Kahve Fali
//
//  Created by ycankasal on 27.11.2018.
//  Copyright © 2018 ycankasal. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import SCLAlertView
import MBProgressHUD

class LoginViewController: UIViewController {

    
    //MARK: - Variables
    
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    
    
    //MARK: - IBActions
    @IBAction func emailButtonAction(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let vc : RegisterViewController = storyboard.instantiateViewController(withIdentifier: "RegisterStoryboardID") as! RegisterViewController;
        
        vc.isRegistering = false;
        
        self.present(vc, animated: true, completion: nil);
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let vc : RegisterViewController = storyboard.instantiateViewController(withIdentifier: "RegisterStoryboardID") as! RegisterViewController;
        
        vc.isRegistering = true;

        
        self.present(vc, animated: true, completion: nil);
    }
    
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        let permissions = ["public_profile"];
        
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
            if error == nil{
                
                if let user = user{
                    
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                    UIApplication.shared.beginIgnoringInteractionEvents();
                    
                    if user.isNew{ // kullanıcı yeni, bunu db'ye ekle
                        
                        var incoming_facebook : NSDictionary?
                        
                        if (FBSDKAccessToken.current() != nil){
                            
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, first_name, last_name, email"])?.start(completionHandler: { (connection, result, error) in
                                
                                if error == nil{ // bilgiler doğru geldi ise
                                    incoming_facebook = result as! NSDictionary?;
                                    
                                    if let incoming_facebook = incoming_facebook{
                                        //email
                                        if (incoming_facebook.object(forKey: "email") != nil){
                                            user["email"] = incoming_facebook.object(forKey: "email");
                                        }
                                        
                                        if (incoming_facebook.object(forKey: "first_name") != nil){
                                            user["name"] = incoming_facebook.object(forKey: "first_name");
                                        }
                                        
                                        if (incoming_facebook.object(forKey: "last_name") != nil){
                                            user["surname"] = incoming_facebook.object(forKey: "last_name");
                                        }
                                
                                    }
                                    
                                    //ilk kayıtta kullanıcıya 10 kredi ver
                                    user["credits"] = 10;
                                    
                                    let acl = PFACL();
                                    acl.hasPublicReadAccess = true;
                                    acl.hasPublicWriteAccess = true;
                                    
                                    user.acl = acl;
                                    
                                    user.saveInBackground(block: { (success, error) in
                                        if error == nil{
                                            self.redirect();
                                        }else{
                                            SCLAlertView().showError("Hata", subTitle: "Facebook ile kullanıcı kaydı oluşturalamadı.")
                                        }
                                    })
                                    
                                    
                                    
                                }
                            })
                            
                        }
                        
                        
                    }else{ // kullanıcı eski, redirect ile gönder
                        self.redirect();
                    }
                    
                }
                
            }else{
                SCLAlertView().showError("Hata", subTitle: "Facebook ile giriş başarısız. \(String(describing: error?.localizedDescription))")
            }
        }
        
    }
    
    
    
    //MARK: - Statements
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        changeRadius(button: facebookButton);
        changeRadius(button: emailButton);
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true);
        
        checkUser();
    }
    
    
    //MARK: - Functions
    func changeRadius(button: UIButton){
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = true;
    }

    
    func checkUser(){
        if PFUser.current() != nil{
            redirect();
        }
    }
    
    
    func redirect(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarStoryboardID") as! UITabBarController;
        
        
        self.present(vc, animated: true, completion: nil);
    }
    
    
}

