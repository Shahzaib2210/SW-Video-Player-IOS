//
//  TableViewCell.swift
//  SW Player
//
//  Created by Shahzaib on 10/27/21.
//  Copyright © 2021 Shahzaib. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var watchtime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbnail.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
