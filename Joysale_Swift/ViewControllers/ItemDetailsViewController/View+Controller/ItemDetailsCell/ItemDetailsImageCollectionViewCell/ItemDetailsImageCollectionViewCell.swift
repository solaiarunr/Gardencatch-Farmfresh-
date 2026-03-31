//
//  ItemDetailsImageCollectionViewCell.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 22/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class ItemDetailsImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var memberShipView: UIView!
    @IBOutlet weak var memberShipImageView: UIImageView!
    @IBOutlet weak var memberShipLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI(){
        self.memberShipView.backgroundColor = UIColor(named: "AppThemeColor") ?? .white
        self.memberShipLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .center, text: "")
        self.memberShipLabel.text = getLanguage["stewardship"]
        self.memberShipImageView.image = UIImage(named: "member_icon")
        self.memberShipView.cornerViewMiniumRadius()
        self.memberShipView.isHidden = true
    }
    func loadData(_ photos: PhotoModel) {
        self.itemImageView.sd_setImage(with: URL(string: photos.itemUrlMainOriginal)) { (image, error, cache, url) in
            if error != nil {
                self.itemImageView.image = #imageLiteral(resourceName: "applogo")
            }
        }
    }

}
