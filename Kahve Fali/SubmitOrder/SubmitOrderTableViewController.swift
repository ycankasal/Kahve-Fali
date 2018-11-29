//
//  SubmitOrderTableViewController.swift
//  Kahve Fali
//
//  Created by ycankasal on 28.11.2018.
//  Copyright © 2018 ycankasal. All rights reserved.
//

import UIKit
import Parse
import ALCameraViewController
import ActionSheetPicker_3_0
import SCLAlertView
import MBProgressHUD


var playerId = "";


class SubmitOrderTableViewController: UITableViewController {

 
    // MARK: - Variables
    var selectedOrder : Order?
    
    // MARK: - IBActions
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    
    @IBAction func nameChangedAction(_ sender: UITextField) {
        if sender.text != ""{
            selectedOrder?.name = sender.text;
        }
    }
    
    
    @IBAction func subjectChangedAction(_ sender: Any) {
        ActionSheetMultipleStringPicker.show(withTitle: "Konu Seç", rows: [
            ["Aşk", "İş", "Sağlık"]
            ], initialSelection: [selectedOrder?.subject! ?? 0], doneBlock: {
                picker, indexes, values in
                
                if let index = indexes?[0] as? Int{
                    self.selectedOrder?.subject = index
                    
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? SubmitOrder3TableViewCell{
                        

                        if let name = values as? Array<String>{
                            cell.subjectButton.setTitle(name.first, for: .normal);
                        }
                        
                    }
                    
                }
                
                
                
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
        
        let croppingParameters: CroppingParameters = CroppingParameters(isEnabled: true,
                                                                        allowResizing: true,
                                                                        allowMoving: false,
                                                                        minimumSize: CGSize(width: 200, height: 200));
        
        /// Provides an image picker wrapped inside a UINavigationController instance
        let imagePickerViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] image, asset in
            if let image = image{
                
                if sender.tag == 0 { //ilk image
                    
                    if let cell = self?.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SubmitOrder1TableViewCell{
                        cell.image1Button.setBackgroundImage(image, for: .normal)
                    }
                    
                    if let imageData = image.jpegData(compressionQuality: 0.8){
                    
                        MBProgressHUD.showAdded(to: (self?.view)!, animated: true);
                        UIApplication.shared.beginIgnoringInteractionEvents();
                        
                        let imageObject = PFObject(className: "Images");
                        imageObject["image"] = PFFileObject(name: "image1.png", data: imageData);
                    
                        imageObject.saveInBackground(block: { (success, error) in
                            
                            MBProgressHUD.hide(for: (self?.view)!, animated: true);
                            UIApplication.shared.endIgnoringInteractionEvents();
                            
                            if error == nil{
                                self?.selectedOrder?.image1 = imageObject.objectId
                            }
                            
                        })
                        
                    }
                    
                    
                }else if sender.tag == 1{ //ikinci image
                    if let cell = self?.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SubmitOrder1TableViewCell{
                        cell.image2Button.setBackgroundImage(image, for: .normal)
                    }
                    
                    if let imageData = image.jpegData(compressionQuality: 0.8){
                        
                        MBProgressHUD.showAdded(to: (self?.view)!, animated: true);
                        UIApplication.shared.beginIgnoringInteractionEvents();
                        
                        let imageObject = PFObject(className: "Images");
                        imageObject["image"] = PFFileObject(name: "image2.png", data: imageData);
                        
                        imageObject.saveInBackground(block: { (success, error) in
                            MBProgressHUD.hide(for: (self?.view)!, animated: true);
                            UIApplication.shared.endIgnoringInteractionEvents();
                            
                            if error == nil{
                                self?.selectedOrder?.image2 = imageObject.objectId
                            }
                        })
                        
                    }
                    
                }
                
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(imagePickerViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func submitOrderAction(_ sender: Any) {
        dismissKeyboard();
        
        if let user = PFUser.current(){
            
            user.fetchInBackground { (fetchedUser, error) in
                if error == nil{
                    
                    if let fetchedUser = fetchedUser{
                        
                        let credits = fetchedUser["credits"] as! Int;
                        
                        if credits < 10{
                            SCLAlertView().showError("Hata", subTitle: "Kredi miktarınız az, lütfen kredi alın.")
                        }else{
                            self.submitOrder();
                        }
                        
                    }
                    
                }
            }
            
        }

    }
    
    
    
    
    // MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView();
        
        selectedOrder = Order();
        selectedOrder?.userId = PFUser.current()?.objectId;
        selectedOrder?.subject = 0;
        selectedOrder?.status = 0;
        selectedOrder?.text = "";
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard));
        view.addGestureRecognizer(tap);
    }

    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder0Cell", for: indexPath) as! SubmitOrder0TableViewCell
            
            // Configure the cell...
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder1Cell", for: indexPath) as! SubmitOrder1TableViewCell
            
            // Configure the cell...
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder2Cell", for: indexPath) as! SubmitOrder2TableViewCell
            
            // Configure the cell...
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder3Cell", for: indexPath) as! SubmitOrder3TableViewCell
            
            // Configure the cell...
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder4Cell", for: indexPath) as! SubmitOrder4TableViewCell
            
            // Configure the cell...
            
            return cell
            
            
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder4Cell", for: indexPath) as! SubmitOrder4TableViewCell
            
            // Configure the cell...
            
            return cell
        }
        
    }
    
    
    
    //MARK: - Functions
    func submitOrder(){
        if let selectedOrder = selectedOrder{
            let params = [
                "userId" : selectedOrder.userId,
                "subject" : selectedOrder.subject,
                "status" : selectedOrder.status,
                "image1" : selectedOrder.image1 ?? "",
                "image2" : selectedOrder.image2 ?? "",
                "name" : selectedOrder.name,
                "playerId" : playerId
                ] as [String : Any]
            
            
            PFCloud.callFunction(inBackground: "submitOrderCloud", withParameters: params) { (success, error) in
                if error == nil{
                    
                    SCLAlertView().showSuccess("Başarılı", subTitle: "Falınız başarı ile gönderildi");
                    
                }
            }
            
            
        }
    }
    
    
    @objc func dismissKeyboard(){
        view.endEditing(true);
    }

}
