//
//  SubmitOrder4TableViewCell.swift
//  Kahve Fali
//
//  Created by ycankasal on 28.11.2018.
//  Copyright © 2018 ycankasal. All rights reserved.
//

import UIKit

class SubmitOrder4TableViewCell: UITableViewCell {

    
    //MARK: - IBOutlets
    @IBOutlet weak var sendButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sendButton.layer.cornerRadius = 4;
        sendButton.layer.masksToBounds = true;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
