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
    @IBOutlet weak var tagimage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI(){
        self.memberShipLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .center, text: "")
        self.memberShipLabel.text = getLanguage["stewardship"]
        self.memberShipImageView.image = UIImage(named: "member_icon")
        self.tagimage.cornerViewMiniumRadius()
        self.tagimage.isHidden = true
    }
    func loadData(_ photos: PhotoModel) {
        self.itemImageView.sd_setImage(with: URL(string: photos.itemUrlMainOriginal)) { (image, error, cache, url) in
            if error != nil {
                self.itemImageView.image = #imageLiteral(resourceName: "applogo")
            }
        }
    }
    func loadData1(item: ItemModel) {
      
        self.tagimage.isHidden = true
        
        
            if item.itemStatus == "onsale" {
                if item.promotionType != "Normal" && PROMOTION_FLAG {
                    self.tagimage.isHidden = false
//                     self.adButton.setTitle(item.promotionType, for: .normal)
                    
                    if item.promotionType == "Urgent" {
                        if item.membership_enable == "enable" {
                            self.tagimage.image = UIImage(named: "business_withicon")
                            self.tagimage.isHidden = false
                        } else {
                            self.tagimage.image = #imageLiteral(resourceName: "business")
                            self.tagimage.isHidden = false
                        }
                    } else if item.promotionType == "local business" {
                        if item.membership_enable == "enable" {
                            self.tagimage.image = UIImage(named: "businesslocalpremium")
                            self.tagimage.isHidden = false
                        } else {
                            self.tagimage.image = #imageLiteral(resourceName: "businesslocal")
                            self.tagimage.isHidden = false
                        }
                    } else if item.promotionType == "Ad" {
                        if item.membership_enable == "enable" {
                            self.tagimage.image = UIImage(named: "ad_new_withicon")
                            self.tagimage.isHidden = false
                        } else {
                            self.tagimage.image = #imageLiteral(resourceName: "ad_new")
                            self.tagimage.isHidden = false
                        }
                    } else {
                        self.tagimage.isHidden = true
                    }
                }
                else {
                        self.tagimage.isHidden = true
                    if item.membership_enable == "enable"{
                        
                       tagimage.image = UIImage(named: "memberTag_withicon")
                        self.tagimage.isHidden = false
                    }else{
                        self.memberShipView.isHidden = true
                    }

                }
            }
            else if item.itemStatus == "sold" {
  
                if item.membership_enable == "enable"{
                    self.tagimage.image = UIImage(named: "sold_withicon")
                    self.tagimage.isHidden = false
                }else{
                    self.tagimage.image = UIImage(named: "sold")
                    self.tagimage.isHidden = false
                }

            }
                   
        

    }

}
