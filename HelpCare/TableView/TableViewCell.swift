//
//  TableViewCell.swift
//  HelpCare
//
//  Created by Lucas Dok on 25/05/19.
//  Copyright © 2019 Lucas Dok. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var descricao1Lbl: UILabel!
    @IBOutlet weak var valorLbl: UILabel!
    @IBOutlet weak var kitLbl: UILabel!
    @IBOutlet weak var descricao2lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
