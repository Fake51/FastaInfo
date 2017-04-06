//
//  FvProgramItemTableViewCell.swift
//  Fastaval App
//
//  Created by Peter Lind on 30/03/17.
//  Copyright © 2017 Fastaval. All rights reserved.
//

import UIKit

class FvProgramItemTableViewCell: UITableViewCell {

    @IBOutlet weak var programIcon: UIImageView!
    
    @IBOutlet weak var programTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
