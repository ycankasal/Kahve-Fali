//
//  ReadOrderTableViewCell.swift
//  Kahve Fali
//
//  Created by ycankasal on 29.11.2018.
//  Copyright © 2018 ycankasal. All rights reserved.
//

import UIKit

class ReadOrderTableViewCell: UITableViewCell {

    
    //MARK: - IBOutlets
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
