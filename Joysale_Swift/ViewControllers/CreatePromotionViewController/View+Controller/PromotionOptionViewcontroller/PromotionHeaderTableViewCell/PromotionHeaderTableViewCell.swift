//
//  PromotionHeaderTableViewCell.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 22/07/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class PromotionHeaderTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var descStackView: UIStackView!
    @IBOutlet weak var promotionImageView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var promotion4Label: UILabel!
    @IBOutlet weak var promotion3Label: UILabel!
    @IBOutlet weak var promotion2Label: UILabel!
    @IBOutlet weak var promotion1Label: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var promotionTitleLabel: UILabel!
    @IBOutlet weak var OraganicImageview: UIImageView!
    
    @IBOutlet weak var TickImage: UIImageView!
    @IBOutlet weak var Tickimage3: UIImageView!
    @IBOutlet weak var Tickimage2: UIImageView!
    @IBOutlet weak var ickimage4: UIImageView!
    @IBOutlet weak var newpromotionImage: UIImageView!
    



    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.priceLabel.config(color: UIColor(named: "AppThemeColor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .center, text: "")
        self.lineView.isHidden = true
        self.statusButton.isHidden = true
        self.promotion1Label.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .left, text: "")
        self.promotion2Label.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .left, text: "")
        self.promotion3Label.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .left, text: "")
        self.promotion4Label.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .left, text: "")
        self.statusButton.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .center, title: "")
    }
    func loadHeaderData(viewTag: Int) {
        self.promotionTitleLabel.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 17), align: .center, text: "")
        self.descStackView.isHidden = true
        self.lineView.isHidden = true
        self.promotionImageView.isHidden = true
        self.priceLabel.isHidden = true
        if viewTag == 0 {
            self.priceLabel.isHidden = false
            self.promotionTitleLabel.text = getLanguage["urgent_ads_highlighted"] ?? ""
        }
        else {
            self.priceLabel.isHidden = true
            self.promotionTitleLabel.text = getLanguage["ads_instant_viewable"] ?? ""
        }
    }
    func loadFooterData(viewTag: Int,Member_enable: String) {
        self.promotionTitleLabel.config(color: UIColor(named: "AppThemeColor"), font: UIFont(name: APP_FONT_BOLD, size: 16), align: .center, text: "")
        self.descStackView.isHidden = false
        self.lineView.isHidden = false
        self.promotionImageView.isHidden = false
        self.priceLabel.isHidden = true

        if viewTag == 0 {
            self.statusButton.setTitle(getLanguage["urgent2"] ?? "", for: .normal)
            if Member_enable == "enable"{
                self.newpromotionImage.image = UIImage(named: "business_withicon")
            }else{
                self.newpromotionImage.image = UIImage(named: "business")
            }
            self.statusButton.backgroundColor = UIColor.red
            self.promotionTitleLabel.text = getLanguage["urgent_tag_features"] ?? ""
            self.promotionTitleLabel.textColor = UIColor.red
            self.lineView.backgroundColor = UIColor.red
            self.promotion1Label.text = getLanguage["urgent_feature_list1"] ?? ""
            self.promotion2Label.text = getLanguage["urgent_feature_list2"] ?? ""
            self.promotion3Label.text = getLanguage["urgent_feature_list3"] ?? ""
            self.promotion4Label.text = getLanguage["urgent_feature_list4"] ?? ""
        }
        else {
            self.statusButton.setTitle(getLanguage["ad"] ?? "", for: .normal)
            self.OraganicImageview.image = UIImage(named: "promote_urgent2")
            if Member_enable == "enable"{
                self.newpromotionImage.image = UIImage(named: "ad_new_withicon")
            }else{
                self.newpromotionImage.image = UIImage(named: "ad_new")
            }
            self.statusButton.backgroundColor = UIColor(named: "AdColor")
            self.TickImage.image = UIImage(named: "tick-green")
            self.Tickimage2.image = UIImage(named: "tick-green")
            self.Tickimage3.image = UIImage(named: "tick-green")
            self.ickimage4.image = UIImage(named: "tick-green")

            self.promotionTitleLabel.text = getLanguage["promote_tag_features"] ?? ""
            self.promotion1Label.text = getLanguage["promote_feature_list1"] ?? ""
            self.promotion2Label.text = getLanguage["promote_feature_list2"] ?? ""
            self.promotion3Label.text = getLanguage["promote_feature_list3"] ?? ""
            self.promotion4Label.text = getLanguage["promote_feature_list4"] ?? ""
        }
    }
}
