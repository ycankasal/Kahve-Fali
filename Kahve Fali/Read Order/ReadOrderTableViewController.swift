//
//  ReadOrderTableViewController.swift
//  Kahve Fali
//
//  Created by ycankasal on 29.11.2018.
//  Copyright © 2018 ycankasal. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
import SCLAlertView
import UIScrollView_InfiniteScroll


class ReadOrderTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //MARK: - Variables
    var allOrders = [Order]();
    var currentPage = 0;
    var allDataDownloaded = false;


    //MARK: - IBOutlets
    @IBOutlet weak var table: UITableView!
    
    
    
    
    //MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()

        self.table.tableFooterView = UIView();
        
        if let user = PFUser.current(){
            if let userId = user.objectId{
                addInfinitiveScroll(userId);
              //  getOrdersInfo(userId);
            }
        }
    }

    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allOrders.count;
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ReadOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ReadOrderCell", for: indexPath) as! ReadOrderTableViewCell;

        cell.statusText.text = allOrders[indexPath.row].status == 0 ? "Falınız Hazırlanıyor" : "Falınız Hazır";
        
        if let date =  allOrders[indexPath.row].createdAt{
            cell.dateText.text = changeDateToString(date);
        }

        

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allOrders[indexPath.row].status == 0{
            SCLAlertView().showWait("Falınız hazır değil", subTitle: "Lütfen falınızın tamamlanmasını bekleyin.")
        }else{
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyboard.instantiateViewController(withIdentifier: "ReadOrderDetailStoryboardID") as! ReadOrderDetailTableViewController;
            
            vc.selectedOrder = allOrders[indexPath.row];
            
            self.present(vc, animated: true, completion: nil);
        }
    }

    //MARK: - Functions
    
    func addInfinitiveScroll(_ userId : String){
        if self.allDataDownloaded == false{
            self.getOrdersInfo(userId)
        }
        
        table.finishInfiniteScroll();
        
        table.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return !(self.allDataDownloaded)
        }
        
    }
    
    func getOrdersInfo(_ userId : String){
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        let query = PFQuery(className: "Orders");
        query.whereKey("user", equalTo: PFObject.init(withoutDataWithClassName: "_User", objectId: userId))
        query.limit = 8;
        query.skip = currentPage * 8;
        query.order(byDescending: "createdAt");
 
        query.findObjectsInBackground { (objects, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true);
            
            if error == nil{
                
                if let objects = objects{
                    for object in objects{
                        
                        var order = Order();
                        order.text = object["text"] as? String;
                        order.status = object["status"] as? Int;
                        order.subject = object["subject"] as? Int;
                        order.createdAt = object.createdAt;
                        
                        self.allOrders.append(order);
                    }
                    
                    self.table.reloadData();
                    self.currentPage += 1;
                    
                    if objects.count < 8{
                        self.allDataDownloaded = true;
                    }
                    
                }
                
            }else{
                print("hata oluştu \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    
    func changeDateToString(_ date : Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: date);
    }
    
}
