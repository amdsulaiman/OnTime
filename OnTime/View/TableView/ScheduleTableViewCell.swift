//
//  ScheduleTableViewCell.swift
//  OnTime
//
//  
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    static let identifier = "ScheduleTableViewCell"
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var notesLbl: UILabel!
    @IBOutlet weak var baseView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 12
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func nib() -> UINib {
        return UINib(nibName: "ScheduleTableViewCell", bundle: nil)
    }
    
}
