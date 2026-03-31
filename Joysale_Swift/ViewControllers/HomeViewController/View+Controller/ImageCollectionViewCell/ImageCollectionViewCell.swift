//
//  ImageCollectionViewCell.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 12/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var newView: UIImageView!
    
    @IBOutlet weak var memberShipView: UIView!
    @IBOutlet weak var memberShipLabel: UILabel!
    @IBOutlet weak var membershipImageView: UIImageView!
    @IBOutlet weak var memberShipViewWidth: NSLayoutConstraint!
    @IBOutlet weak var memberShipImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var memberShipImageViewleading: NSLayoutConstraint!
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear]
        gradient.startPoint = CGPoint(x: 0.3, y: 1)
        gradient.endPoint = CGPoint(x: 0.3, y: 0)
        return gradient
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI() {
        
        self.statusButton.cornerMiniumRadius(2)
        self.shadowView.cornerViewMiniumRadius()
        self.priceLabel.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_BOLD, size: 14), align: .left, text: "")
        self.productTitleLabel.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .left, text: "")
        self.locationLabel.config(color: UIColor(named: "ThirdryTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .left, text: "")
        self.statusButton.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .center, title: "")
        self.dateButton.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 13), align: .right, title: "")
        self.memberShipView.backgroundColor = UIColor(named: "AppThemeColor") ?? .white
        self.memberShipLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .center, text: "")
        self.memberShipLabel.text = getLanguage["stewardship"]
        self.membershipImageView.image = UIImage(named: "member_icon")
        self.memberShipView.cornerViewMiniumRadius()
        self.memberShipView.isHidden = true
    }
    func loadData(_ itemData: ItemModel) {
        if itemData.photos.count > 0 {
            self.profileImageView.sd_setImage(with: URL(string: itemData.photos?.first?.itemUrlMain350 ?? ""), placeholderImage: nil , completed: nil)
        }
        else {
            self.profileImageView.image = #imageLiteral(resourceName: "profilelogo")
        }
        
        if itemData.itemStatus == "onsale" {
            if itemData.promotionType != "Normal" && PROMOTION_FLAG {
                self.statusButton.setTitle(itemData.promotionType, for: .normal)
                if itemData.promotionType == "Urgent" {
                    if itemData.membership_enable == "enable"{
                        self.statusButton.isHidden = true
                        self.newView.image = UIImage(named: "business_withicon")
                        self.newView.isHidden = false
                    }else{
                        self.statusButton.isHidden = true
                        self.newView.image = #imageLiteral(resourceName: "business")
                        self.newView.isHidden = false
                    }

//                    self.statusButton.setTitle(getLanguage["urgent"] ?? "", for: .normal)
//                    self.statusButton.setBackgroundColor(color: UIColor(named: "UrgentColor") ?? .white, forState: .normal)
                }
                else if itemData.promotionType == "Ad" {
                    if itemData.membership_enable == "enable"{
                        self.statusButton.isHidden = true
                        self.newView.image = UIImage(named: "ad_new_withicon")
                        self.newView.isHidden = false
                    }else{
                        self.statusButton.isHidden = true
                        self.newView.image = #imageLiteral(resourceName: "ad_new")
                        self.newView.isHidden = false
                    }
//                    self.statusButton.setTitle(getLanguage["ad"] ?? "", for: .normal)
//                    self.statusButton.backgroundColor = UIColor(named: "NameColor")
//                    self.statusButton.setBackgroundColor(color: UIColor(named: "NameColor") ?? .white, forState: .normal)
                }else{
                    self.newView.isHidden = true

                }
            }
            else {
//                self.statusButton.isHidden = true
                self.statusButton.setTitle("", for: .normal)
                self.statusButton.backgroundColor = UIColor(named: "clearcolor")
                self.statusButton.setBackgroundColor(color: UIColor(named: "clearcolor") ?? .white, forState: .normal)
                self.newView.isHidden = true
                if itemData.membership_enable == "enable"{
                    self.statusButton.isHidden = true
                    self.newView.image = UIImage(named: "memberTag_withicon")
                    self.newView.isHidden = false
                }else{
                    self.memberShipView.isHidden = true
                }

            }
        }
        else if itemData.itemStatus == "sold" {
//            self.statusButton.setTitle(getLanguage["sold"] ?? "", for: .normal)
//            self.statusButton.setBackgroundColor(color: UIColor(named: "soldOutColor") ?? .white, forState: .normal)
//            self.newView.isHidden = true
            /*
            self.memberShipView.isHidden = false
            if itemData.membership_enable == "enable"{
                self.memberShipView.backgroundColor = UIColor(named: "soldOutColor") ?? .white
                self.memberShipLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .center, text: "")
                self.memberShipLabel.text = getLanguage["sold"]
                self.membershipImageView.isHidden = false
                self.membershipImageView.image = UIImage(named: "member_icon")
                self.memberShipViewWidth.constant = 55
                self.memberShipImageViewWidth.constant = 15
                self.memberShipImageViewleading.constant = 5
            }else{
                self.memberShipView.backgroundColor = UIColor(named: "soldOutColor") ?? .white
                self.memberShipLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .center, text: "")
                self.memberShipLabel.text = getLanguage["sold"]
                self.membershipImageView.isHidden = true
                self.memberShipViewWidth.constant = 55
                self.memberShipImageViewWidth.constant = 0
                self.memberShipImageViewleading.constant = 0
//                self.membershipImageView.image = UIImage(named: "member_icon")
            }
            */
            if itemData.membership_enable == "enable"{
                self.statusButton.isHidden = true
                self.newView.image = UIImage(named: "sold_withicon")
                self.newView.isHidden = false
            }else{
                self.statusButton.isHidden = true
                self.newView.image = UIImage(named: "sold")
                self.newView.isHidden = false
            }

        }
        if Float(itemData.price ?? "0") != 0 {
            self.priceLabel.text = itemData.formattedPrice
            self.priceLabel.textColor = UIColor(named: "AppTextColor") ?? .white
        }
        else {
            self.priceLabel.text = getLanguage["giving_away"]
            self.priceLabel.textColor = UIColor(named: "AppThemeColor") ?? .white
        }
        let dateString = Utility.shared.timeStampWithDateFormat(timeStamp: "\(itemData.postedTime ?? 0)", dateFormat: "EEE, dd MMM yy HH:mm:ss VVVV")
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "EEE, dd MMM yy HH:mm:ss VVVV"
        let date = dateFormatterGet.date(from: dateString)
        if let dateVal = date {
            self.dateButton.setTitle(Date().offset(from: dateVal), for: .normal)
        }
//        self.priceLabel.sizeToFit()
        self.productTitleLabel.text = itemData.itemTitle
        self.locationLabel.text = itemData.location
        self.imageViewHeightConst.constant = self.frame.width
        self.dateButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    override func layoutSubviews() {
        self.imageViewHeightConst.constant = self.frame.width
        self.dateButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.dateButton.bounds.width, height: self.dateButton.bounds.height)
    }
}
