//
//  ExchangeCollectionViewCell.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 29/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class ExchangeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var exchangeImageView: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var memberShipView: UIView!
    @IBOutlet weak var memberShipImageView: UIImageView!
    @IBOutlet weak var memberShipLabel: UILabel!
    @IBOutlet weak var memberShipImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var memberShipImageViewleading: NSLayoutConstraint!
    @IBOutlet weak var memberShipViewWidth: NSLayoutConstraint!
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
        self.buttonStackView.isHidden = true
        self.selectedView.isHidden = true
        self.statusButton.cornerMiniumRadius(2)
        self.statusButton.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .center, title: "")
        self.dateButton.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 13), align: .right, title: "")
        self.dateButton.layer.insertSublayer(gradientLayer, at: 0)
        self.memberShipView.cornerViewMiniumRadius()
        self.memberShipView.isHidden = true
    }
    func loadData(_ item: ItemModel) {
        self.exchangeImageView.sd_setImage(with: URL(string: item.photos?.first?.itemUrlMain350 ?? "")) { (image, error, cache, url) in
            if error != nil {
                self.exchangeImageView.image = #imageLiteral(resourceName: "applogo")
            }
        }
    }
    func loadListLikeData(_ itemData: ItemModel) {
//        self.exchangeImageView.sd_cancelCurrentImageLoad()
//        self.exchangeImageView.image = nil
        self.exchangeImageView.sd_setImage(with: URL(string: itemData.photos?.first?.itemUrlMain350 ?? "")) { (image, error, cache, url) in
            if error != nil {
                print("error?.localizedDescription \(error?.localizedDescription ?? "")")
//                self.exchangeImageView.image = #imageLiteral(resourceName: "applogo")
            }
        }
        if itemData.itemStatus == "onsale" {
            if itemData.promotionType != "Normal" && PROMOTION_FLAG {
                self.statusButton.setTitle(itemData.promotionType, for: .normal)
                self.memberShipView.isHidden = false
                if itemData.promotionType == "Urgent" {
//                    self.statusButton.setTitle(getLanguage["urgent"] ?? "", for: .normal)
//                    self.statusButton.setBackgroundColor(color: UIColor(named: "UrgentColor") ?? .white, forState: .normal)
                    if itemData.membership_enable == "enable"{
                        self.memberShipView.backgroundColor = UIColor(named: "UrgentColor")
                        self.memberShipLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .center, text: "")
                        self.memberShipLabel.text = getLanguage["urgent"]
                        self.memberShipViewWidth.constant = 110
                        self.memberShipImageView.isHidden = false
                        self.memberShipImageViewWidth.constant = 15
                        self.memberShipImageViewleading.constant = 5
                        self.memberShipImageView.image = UIImage(named: "member_icon")
                    }else{
                        self.memberShipView.backgroundColor = UIColor(named: "UrgentColor")
                        self.memberShipLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .center, text: "")
                        self.memberShipLabel.text = getLanguage["urgent"]
                        self.memberShipImageView.isHidden = true
                        self.memberShipImageViewleading.constant = 0
                        self.memberShipImageViewWidth.constant = 0
                        self.memberShipViewWidth.constant = 90
                    }
                }
                else if itemData.promotionType == "Ad" {
//                    self.statusButton.setTitle(getLanguage["ad"] ?? "", for: .normal)
//                    self.statusButton.setBackgroundColor(color: UIColor(named: "NameColor") ?? .white, forState: .normal)
                    if itemData.membership_enable == "enable"{
                        self.memberShipView.backgroundColor = UIColor(named: "AdColor")
                        self.memberShipLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .center, text: "")
                        self.memberShipLabel.text = getLanguage["ad"]
                        self.memberShipViewWidth.constant = 110
                        self.memberShipImageView.isHidden = false
                        self.memberShipImageViewWidth.constant = 15
                        self.memberShipImageViewleading.constant = 5
                        self.memberShipImageView.image = UIImage(named: "member_icon")
                    }else{
                        self.memberShipView.backgroundColor = UIColor(named: "AdColor")
                        self.memberShipLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .center, text: "")
                        self.memberShipLabel.text = getLanguage["ad"]
                        self.memberShipViewWidth.constant = 90
                        self.memberShipImageView.isHidden = true
                        self.memberShipImageViewleading.constant = 0
                        self.memberShipImageViewWidth.constant = 0
                    }
                }
            }
            else {
                if itemData.membership_enable == "enable"{
                    self.memberShipView.isHidden = false
                    self.memberShipView.backgroundColor = UIColor(named: "AppThemeColor")
                    self.memberShipLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .center, text: "")
                    self.memberShipLabel.text = getLanguage["stewardship"]
                    self.memberShipViewWidth.constant = 100
                    self.memberShipImageViewWidth.constant = 15
                    self.memberShipImageViewleading.constant = 5
                    self.memberShipImageView.isHidden = false
                    self.memberShipImageView.image = UIImage(named: "member_icon")
                }else{
                    self.memberShipView.isHidden = true
                }
                self.statusButton.setTitle("", for: .normal)
                self.statusButton.setBackgroundColor(color: UIColor(named: "clearcolor") ?? .white, forState: .normal)
            }
        }
        else if itemData.itemStatus == "sold" {
//            self.statusButton.setTitle(getLanguage["sold"] ?? "", for: .normal)
//            self.statusButton.setBackgroundColor(color: UIColor(named: "soldOutColor") ?? .white, forState: .normal)
            self.memberShipView.isHidden = false
            if itemData.membership_enable == "enable"{
                self.memberShipView.backgroundColor = UIColor(named: "soldOutColor")
                self.memberShipLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .center, text: "")
                self.memberShipLabel.text = getLanguage["sold"]
                self.memberShipViewWidth.constant = 55
                self.memberShipImageView.isHidden = false
                self.memberShipImageViewWidth.constant = 15
                self.memberShipImageViewleading.constant = 5
                self.memberShipImageView.image = UIImage(named: "member_icon")
            }else{
                self.memberShipView.backgroundColor = UIColor(named: "soldOutColor")
                self.memberShipLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .center, text: "")
                self.memberShipLabel.text = getLanguage["sold"]
                self.memberShipViewWidth.constant = 55
                self.memberShipImageView.isHidden = true
                self.memberShipImageViewleading.constant = 0
                self.memberShipImageViewWidth.constant = 0
            }
        }
        let dateString = Utility.shared.timeStampWithDateFormat(timeStamp: "\(itemData.postedTime ?? 0)", dateFormat: "EEE, dd MMM yy HH:mm:ss VVVV")
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "EEE, dd MMM yy HH:mm:ss VVVV"
        let date = dateFormatterGet.date(from: dateString)
        if let dateVal = date {
            self.dateButton.setTitle(Date().offset(from: dateVal), for: .normal)
        }
        self.dateButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.dateButton.bounds.width, height: self.dateButton.bounds.height)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.exchangeImageView.image = nil
    }
}
