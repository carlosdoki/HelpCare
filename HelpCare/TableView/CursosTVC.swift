//
//  CursosTVC.swift
//  HelpCare
//
//  Created by Carlos Doki on 26/05/19.
//  Copyright © 2019 Lucas Dok. All rights reserved.
//

import UIKit

class CursosTVC: UITableViewCell {

    @IBOutlet weak var cursoLbl: UILabel!
    @IBOutlet weak var valorLbl: UILabel!
    @IBOutlet weak var localLbl: UILabel!
    @IBOutlet weak var switchS: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func enablePressed(_ sender: Any) {
        let number = Double(valorLbl.text!)
        if switchS.isOn {
            total = total + number!
        } else {
            if total > 0 {
                total = total - number!
            }
        }
    }
}
