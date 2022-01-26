//
//  NotesTableViewCell.swift
//  OnTime
//
//  
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    static let identifier = "NotesTableViewCell"
    
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var pinIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 8
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func nib() -> UINib {
        return UINib(nibName: "NotesTableViewCell", bundle: nil)
    }
    
}
