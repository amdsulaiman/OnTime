//
//  SettingsTableViewCell.swift
//  OnTime
//
//  
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let identifier = "SettingsTableViewCell"
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func nib() -> UINib {
        return UINib(nibName: "SettingsTableViewCell", bundle: nil)
    }
    
}
