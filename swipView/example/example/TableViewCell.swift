//
//  TableViewCell.swift
//  example
//
//  Created by CAU on 10/02/2019.
//  Copyright © 2019 fjae. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var selectTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
