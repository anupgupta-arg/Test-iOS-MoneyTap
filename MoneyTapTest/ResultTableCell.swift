//
//  ResultTableCell.swift
//  MoneyTapTest
//
//  Created by Uniqolabel Developer on 19/08/18.
//  Copyright © 2018 GeekGuns. All rights reserved.
//

import UIKit

class ResultTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    var pageId : String? 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
