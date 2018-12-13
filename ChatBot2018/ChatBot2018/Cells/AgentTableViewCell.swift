//
//  AgentTableViewCell.swift
//  ChatBot2018
//
//  Created by Sam Downs on 12/12/18.
//  Copyright © 2018 Samuel Downs. All rights reserved.
//

import UIKit

class AgentTableViewCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
