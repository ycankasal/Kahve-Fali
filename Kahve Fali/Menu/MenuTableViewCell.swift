//
//  MenuTableViewCell.swift
//  Kahve Fali
//
//  Created by ycankasal on 28.11.2018.
//  Copyright © 2018 ycankasal. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuText: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
