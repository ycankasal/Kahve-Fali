//
//  SecondViewController.swift
//  Kahve Fali
//
//  Created by ycankasal on 27.11.2018.
//  Copyright © 2018 ycankasal. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    //MARK: - Variables
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var table: UITableView!
    
    
    
    //MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.tableFooterView = UIView();
    }
    
    
    //MARK: - Table Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell;
        
        switch indexPath.row {
        case 0:
            cell.menuImage.image = UIImage(named: "gizlilikpolitikasi");
            cell.menuText.text = "Gizlilik Politikası";
            return cell;

        case 1:
            cell.menuImage.image = UIImage(named: "kullanimsartlari");
            cell.menuText.text = "Kullanım Şartları";
            return cell;

            
        case 2:
            cell.menuImage.image = UIImage(named: "logout");
            cell.menuText.text = "Çıkış Yap";
            return cell;

            
        default:
            return cell;
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            openURL("gizlilikpolitisi.com");
        case 1:
            openURL("kullanimsartlari.com");
            
        case 2: // Parse Çıkış Yap
            
            if (PFUser.current() != nil){
                PFUser.logOutInBackground { (error) in
                    if error != nil{
                        SCLAlertView().showError("Hata", subTitle: "Çıkış yapamadınız.")
                    }else{
                        
                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController;
                        
                        
                        self.present(vc, animated: true, completion: nil);
                        
                    }
                }
            }
            
            
        default:
            return;
        }
    }
    
    
    //MARK: - Functions
    func openURL(_ url : String){
        print(url);
    }
    
}

