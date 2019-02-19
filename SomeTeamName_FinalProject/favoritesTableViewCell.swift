//
//  favoritesTableViewCell.swift
//  SomeTeamName_FinalProject
//
//  Created by Wu, Justin on 12/3/18.
//  Copyright © 2018 Wu, Justin. All rights reserved.
//

import UIKit

class favoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
