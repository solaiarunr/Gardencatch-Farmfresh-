//
//  AddProductPopupViewController.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 18/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

protocol AddProductPopupDelegate {
    func addProdctButtonAct(_ type: String)
}

class AddProductPopupViewController: UIViewController {

    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var successMessageLabel: UILabel!
    @IBOutlet weak var hideView: UIView!
    var delegate: AddProductPopupDelegate?
    var promotionType = ""
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    func configUI() {
        self.successMessageLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_BOLD, size: 17), align: .center, text: message)
        self.successMessageLabel.numberOfLines = 0
        self.successButton.backgroundColor = UIColor(named: "AppThemeColor")
        self.successButton.cornerMiniumRadius()
        self.successButton.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 16), align: .center, title: "promote_listing")
        if (self.promotionType == "NORMAL") && PROMOTION_FLAG {
            self.successButton.isHidden = false
        }
        else {
            self.successButton.isHidden = true
        }
    }
    @IBAction func successButtonAct(_ sender: UIButton) {
        self.delegate?.addProdctButtonAct("success")
    }
    
    @IBAction func cancelButtonAct(_ sender: UIButton) {
        self.delegate?.addProdctButtonAct("cancel")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
