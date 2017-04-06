//
//  FvMyProgramTableViewCell.swift
//  Fastaval App
//
//  Created by Peter Lind on 30/03/17.
//  Copyright © 2017 Fastaval. All rights reserved.
//

import UIKit

class FvMyProgramTableViewCell: UITableViewCell {

    @IBOutlet weak var myProgramTime: UILabel!
    
    @IBOutlet weak var myProgramIcon: UIImageView!
    
    @IBOutlet weak var myProgramTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
