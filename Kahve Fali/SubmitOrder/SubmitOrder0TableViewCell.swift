//
//  SubmitOrder0TableViewCell.swift
//  Kahve Fali
//
//  Created by ycankasal on 28.11.2018.
//  Copyright © 2018 ycankasal. All rights reserved.
//

import UIKit

class SubmitOrder0TableViewCell: UITableViewCell {

    
    //MARK: - IBOutlets
    @IBOutlet weak var closeButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        closeButton.layer.cornerRadius = closeButton.layer.frame.width / 2;
        closeButton.layer.masksToBounds = true;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
