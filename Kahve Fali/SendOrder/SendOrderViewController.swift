//
//  SendOrderViewController.swift
//  Kahve Fali
//
//  Created by ycankasal on 27.11.2018.
//  Copyright © 2018 ycankasal. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD


class SendOrderViewController: UIViewController {

    
    //MARK: - Variables
    
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var creditsText: UIButton!
    
    
    
    //MARK: - IBActions
    @IBAction func goSubmitOrderAction(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "SubmitOrderStoryboardID") as! SubmitOrderTableViewController;
        
        
        self.present(vc, animated: true, completion: nil);
    }
    
    
    @IBAction func increaseCreditsAction(_ sender: Any) {
        if let user = PFUser.current(){
            
            MBProgressHUD.showAdded(to: self.view, animated: true);
            
            user.incrementKey("credits", byAmount: 10);
            
            user.saveInBackground { (success, error) in
                MBProgressHUD.hide(for: self.view, animated: true);
                
                if error == nil{
                    self.getUserData();
                }
            }
            
            
        }
        
    }
    
    
    
    
    //MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        
        getUserData();
    }
    

    //MARK: - Functions
    func getUserData(){
        
        if let user = PFUser.current(){
            
            user.fetchInBackground { (fetchedUser, error) in
                if error == nil{
                    
                    if let fetchedUser = fetchedUser{
                        if let credits = fetchedUser["credits"] as? Int{
                            self.creditsText.setTitle("\(String(credits)) Kredi", for: .normal);
                        }
                    }
                }
            }
            
        }
        
    }
    
    

}
