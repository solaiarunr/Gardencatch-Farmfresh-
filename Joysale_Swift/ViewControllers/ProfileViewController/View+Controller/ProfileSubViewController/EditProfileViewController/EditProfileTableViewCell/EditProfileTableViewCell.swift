//
//  EditProfileTableViewCell.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 13/07/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
protocol editProfileDelegate {
    func textFieldEndEditingAct(_ textField: UITextField)
}
class EditProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var verifyStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var nextButton: UIButton!
    var delegate: editProfileDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI() {
        self.textField.delegate = self
        self.userImageView.cornerViewRadius()
        self.verifyLabel.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 15), align: .left, text: "")
        self.titleLabel.config(color: UIColor(named: "ThemeTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 15), align: .left, text: "")
        self.nextButton.tintColor = UIColor(named: "ThemeTextColor")
        self.descLabel.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 15), align: .left, text: "")
        self.textField.config(color: UIColor(named: "AppTextColor"), align: .left, placeHolder: "", font: UIFont(name: APP_FONT_REGULAR, size: 15))
        self.switchButton.semanticContentAttribute = .forceLeftToRight
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            self.switchButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    func loadData(_ profileData: ProfileResultModel, index: IndexPath) {
        self.textField.tag = index.row
        self.userImageView.isHidden = true
        self.verifyStackView.isHidden = true
        self.nextButton.isHidden = true
        self.switchButton.isHidden = true
        self.descLabel.isHidden = true
        self.textField.isHidden = true
        self.verifyButton.isHidden = false
        self.nextButton.setImage(#imageLiteral(resourceName: "InArrowImg").imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        self.verifyLabel.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 15), align: .left, text: "")

        if index.section == 0 {
            self.nextButton.isHidden = false
            self.userImageView.isHidden = false
            var imageName = profileData.userImg ?? ""
            if !profileData.userImg.contains("https") {
                imageName = BASE_URL + "profile/\(profileData.userImg ?? "")"
            }
            self.userImageView.sd_setImage(with: URL(string: imageName), placeholderImage: #imageLiteral(resourceName: "applogo"), completed: nil)
 
//            self.userImageView.sd_setImage(with: URL(string: imageName)) { (image, error, cache, url) in
//                if error != nil {
//                    self.userImageView.image = #imageLiteral(resourceName: "applogo")
//                }
//            }
            self.titleLabel.text = getLanguage["Edit"] ?? "Edit"
        }
        else if index.section == 1 {
            self.textField.isHidden = false
            self.descLabel.isHidden = true

            if index.row == 0 || index.row == 1 {
                if index.row == 0 {
                    self.titleLabel.text = (getLanguage["Name"] ?? "").capitalized
                    self.textField.text = profileData.fullName
                    self.textField.isUserInteractionEnabled = true
                }
                else {
                    self.titleLabel.text = (getLanguage["username"] ?? "").capitalized
                    self.textField.text = profileData.userName
                    self.textField.isUserInteractionEnabled = false
                }
            }
            else if index.row == 2{
                self.textField.text = "***************"
                self.textField.isUserInteractionEnabled = false
                self.titleLabel.text = (getLanguage["changepassword"] ?? "").capitalized
                self.nextButton.isHidden = false
            }else if index.row == 3{
                self.titleLabel.text = (getLanguage["PostCount"] ?? "").capitalized
                self.textField.text = profileData.freepostcount
                self.textField.isUserInteractionEnabled = false
            }else{
                self.titleLabel.text = (getLanguage["RemainingDays"] ?? "").capitalized
                self.textField.text = profileData.freepost_remainingdays
                self.textField.isUserInteractionEnabled = false
            }
        }
        else if index.section == 2 {
            self.descLabel.isHidden = false
            if index.row == 0 || index.row == 1 || index.row == 6 {
                self.nextButton.isHidden = false
                self.verifyStackView.isHidden = false
                self.verifyButton.isHidden = true
                if index.row == 0 {
                    self.titleLabel.text = (getLanguage["location"] ?? "")
                    self.descLabel.text = profileData.location
                }
                else {
                    self.descLabel.isHidden = true
                    if index.row == 1 {
                        self.titleLabel.text = (getLanguage["manage_stripe"] ?? "")
                    }
                    else {
                        self.verifyStackView.isHidden = false
                        self.verifyButton.isHidden = true
                        self.verifyLabel.config(color: UIColor(named: "textfiledBackGroundColor"), font: UIFont(name: APP_FONT_REGULAR, size: 15), align: .left, text: "")
                        self.verifyLabel.text = getLanguage[UserDefaultModule.shared.getAppLanguage().lowercased()]
                        self.titleLabel.text = (getLanguage["language"] ?? "")
                    }
                }
            }
            else {
                self.verifyStackView.isHidden = false
                self.verifyButton.isHidden = false
                self.switchButton.isHidden = true
                self.descLabel.isHidden = false
                if index.row == 2 {
                    self.titleLabel.text = (getLanguage["Email"] ?? "").capitalized
                    self.descLabel.text = profileData.email
                    if profileData.emailVerification == "enable"{
                        if profileData.verification.email == true{
                            self.verifyLabel.text = getLanguage["verified"]
                            self.verifyButton.setImage(#imageLiteral(resourceName: "tick-green"), for: .normal)
                        }
                    }
                    else if profileData.emailVerification == "disable"{
                        self.verifyLabel.text = ""
                        self.verifyButton.isHidden = true
                     }
                 }
                else if index.row == 3 {
                    self.titleLabel.text = (getLanguage["Phone"] ?? "").capitalized
                    if profileData.mobileNo.contains("+") {
                        self.descLabel.text = profileData.mobileNo
                    }
                    else {
                        self.descLabel.text = "+\(profileData.mobileNo ?? "")"
                    }
                    if (profileData.mobileNo == ""){
                        self.descLabel.text = getLanguage["link_your_account"] ?? ""
                    }
                   self.verifyLabel.text = (profileData.mobileNo != "") ? (getLanguage["verified"] ?? "") : (getLanguage["unverified"] ?? "")
                    self.verifyButton.setImage((profileData.mobileNo != "") ? #imageLiteral(resourceName: "tick-green") : #imageLiteral(resourceName: "cancel-1"), for: .normal)
                }
                else if index.row == 4 {
                    self.titleLabel.text = (getLanguage["Facebook"] ?? "").capitalized
                    if (profileData.verification.facebook == false){
                        self.descLabel.isHidden = false
                        self.descLabel.text = getLanguage["link_your_account"] ?? ""
                    }
                    else {
                        self.descLabel.isHidden = true
                    }
                    self.verifyLabel.text = (profileData.verification.facebook == true) ? (getLanguage["verified"] ?? "") : (getLanguage["unverified"] ?? "")
                    self.verifyButton.setImage((profileData.verification.facebook == true) ? #imageLiteral(resourceName: "tick-green") : #imageLiteral(resourceName: "cancel-1"), for: .normal)
                }
                else if index.row == 5 {
                    self.verifyStackView.isHidden = true
                    self.switchButton.isHidden = false
                    self.titleLabel.text = (getLanguage["Allow calls"] ?? "").capitalized
                    self.descLabel.text = getLanguage["Allow user to call you"] ?? ""
                    self.switchButton.isOn = profileData.showMobileNo
                }
            }
        }
        else {
            self.nextButton.setImage(#imageLiteral(resourceName: "InArrowImg"), for: .normal)
            self.descLabel.isHidden = true
            self.titleLabel.text = (getLanguage["logout"] ?? "")
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension EditProfileTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldEndEditingAct(textField)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        let strLength = textField.text?.count ?? 0
        let lngthToAdd = string.count
        let lengthCount = strLength + lngthToAdd
        if lengthCount > 30 {
            return false
        }
        return true
    }
}
