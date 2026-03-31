//
//  Profile_TableViewCell.swift
//  Joysale_Swift
//
//  Created by HTS on 11/23/21.
//  Copyright © 2021 Hitasoft. All rights reserved.
//

import UIKit

class Profile_TableViewCell: UITableViewCell {

    
    @IBOutlet weak var profilename: UILabel!
    
    override func awakeFromNib() {
        self.configUI()
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configUI() {
        
        self.profilename.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_BOLD, size: 16), align: .left, text: "")
        
    }
    
    func loadData(_ profileResult: searchresmodel?) {
        self.profilename.text = profileResult?.username
        
    }

}
