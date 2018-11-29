//
//  ReadOrderDetailCloseTableViewCell.swift
//  Kahve Fali
//
//  Created by ycankasal on 29.11.2018.
//  Copyright © 2018 ycankasal. All rights reserved.
//

import UIKit

class ReadOrderDetailCloseTableViewCell: UITableViewCell {

    
    //MARK: - IBOutlets
    @IBOutlet weak var closeButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        closeButton.layer.cornerRadius = closeButton.layer.frame.width / 2;
        closeButton.layer.masksToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
