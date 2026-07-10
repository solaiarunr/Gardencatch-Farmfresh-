//
//  ProfileTableViewCell.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 11/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }

    func configUI() {
        self.notificationButton.isHidden = true
        self.notificationButton.cornerRoundRadius()
        self.notificationButton.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 13), align: .center, title: "")
        self.titleLabel.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 17), align: .left, text: "notifications")
        self.descLabel.config(color: UIColor(named: "AppThemeColor"), font: UIFont(name: APP_FONT_REGULAR, size: 13), align: .left, text: "")
        self.descLabel.numberOfLines = 0
        self.descLabel.isHidden = true
    }

    func resetDescription() {
        self.descLabel.isHidden = true
        self.descLabel.text = ""
        self.titleLabel.textColor = UIColor(named: "AppTextColor")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
