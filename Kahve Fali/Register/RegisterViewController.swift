//
//  RegisterViewController.swift
//  Kahve Fali
//
//  Created by ycankasal on 27.11.2018.
//  Copyright © 2018 ycankasal. All rights reserved.
//

import UIKit
import MBProgressHUD
import SCLAlertView
import Parse


class RegisterViewController: UIViewController {


    //MARK: - Variables
    var isRegistering = true;
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    
    
    
    //MARK: - IBActions
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    
    @IBAction func loginRegisterAction(_ sender: Any) {
        if isRegistering{
            register()
        }else{
            login();
        }
    }
    
    
    //MARK: - Statements
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        
        checkUser();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeButtonRounded(button: closeButton);
        changeTexts();
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard));
        view.addGestureRecognizer(tap);
    }
    
    
    //MARK: - Functions
    func makeButtonRounded(button: UIButton){
        button.layer.cornerRadius = button.layer.frame.width / 2;
        button.layer.masksToBounds = true;
    }
    
    
    func changeTexts(){
        if (isRegistering){
            topLabel.text = "Email ile Kayıt Ol";
            loginRegisterButton.setTitle("Kayıt Ol", for: .normal);
        }
    }
    
    
    
    //Kullanıcı Burda Kayıt Olacak
    func register(){
        dismissKeyboard();
        
        if (emailTextField.text == "" || passwordTextField.text == ""){
            SCLAlertView().showError("Hata", subTitle: "Şifreniz veya email adresiniz boş olamaz")
        }else{
            
            MBProgressHUD.showAdded(to: self.view, animated: true);
            UIApplication.shared.endIgnoringInteractionEvents();

            if let email = emailTextField.text, let password = passwordTextField.text{
           
                let user = PFUser();
            
                user.username = email.lowercased();
                user.email = email.lowercased();
                user.password = password;
                user["credits"] = 10;

                
                let acl = PFACL();
                acl.hasPublicWriteAccess = true;
                acl.hasPublicReadAccess = true;
                
                user.acl = acl;
                
                user.signUpInBackground { (success, error) in
                    if error != nil{
                        SCLAlertView().showError("Hata", subTitle: "Kullanıcı kaydı gerçekleşmedi, lütfen tekrar deneyin.")
                    }else{
                        self.redirect()
                    }
                }
                
            }
        }
        
    }
    
    
    
    
    //Kullanıcı Burda Giriş Yapıyor
    func login(){
        dismissKeyboard();

        if (emailTextField.text == "" || passwordTextField.text == ""){
            SCLAlertView().showError("Hata", subTitle: "Şifreniz veya email adresiniz boş olamaz")
        }else{
            
            MBProgressHUD.showAdded(to: self.view, animated: true);
            UIApplication.shared.beginIgnoringInteractionEvents();
            
            //login işlemlerine başlayalım
            if let email = emailTextField.text, let password = passwordTextField.text{
                
                PFUser.logInWithUsername(inBackground: email.lowercased(), password: password) { (user, error) in
                    
                    //Loading durdurmak gerekli
                    MBProgressHUD.hide(for: self.view, animated: true);
                    UIApplication.shared.endIgnoringInteractionEvents();
                    
                    if error == nil{
                        self.redirect(); //kullanıcı girişi başarılı, gelecek ekrana gönder
                    }else{
                        SCLAlertView().showError("Hata", subTitle: "Kullanıcı girişi olurken hata oluştu. Lütfen tekrar deneyiniz.")
                    }
                    
                }
            
            }
        }
    }
    
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true);
    }
    
    
    
    func redirect(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarStoryboardID") as! UITabBarController;
        
        
        self.present(vc, animated: true, completion: nil);
    }
    
    
    func checkUser(){
        if PFUser.current() != nil{
            redirect();
        }
    }


    
}
