//  PremiumAdvc.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 16/07/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//
 

import UIKit
import StoreKit
import Stripe
import StripeCore
import StripeApplePay
import Foundation
import StripeUICore
class PremiumAdvc: UIViewController {
    
    @IBOutlet weak var noItemDesLabel: UILabel!
    @IBOutlet weak var noItemTitleLabel: UILabel!
    @IBOutlet weak var noItemStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Continue: UIButton!
    @IBOutlet weak var PlanView: UIView!
    @IBOutlet weak var PlanName: UILabel!
    @IBOutlet weak var PlanNameDetailLbl: UILabel!
    @IBOutlet weak var PlanNameDaysLbl: UILabel!
    @IBOutlet weak var PlanNameDaysDetailLbl: UILabel!
    @IBOutlet weak var ExpireLbl: UILabel!
    @IBOutlet weak var ExpireDateLbl: UILabel!
    @IBOutlet weak var DesLbl: UILabel!
    @IBOutlet weak var promotion4Label: UILabel!
    @IBOutlet weak var promotion3Label: UILabel!
    @IBOutlet weak var promotion2Label: UILabel!
    @IBOutlet weak var promotion1Label: UILabel!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var selectedIndex: IndexPath?
    
 
    var onPremiumActivated: (() -> Void)?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        self.configUI()
    }
    
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return self.updateStatusBarStyle()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: nil)
    }
    
   
    


    
    @objc func barButtonAction(_ notification: Notification) {
        if let isLeft = notification.userInfo?["isLeft"] as? Int, isLeft == 0 {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: UI
    func configUI() {
        navigationController?.customNavigationBarView(title: "MembershipSubscription",
                                                      fColor: "whitecolor",
                                                      fontName: UIFont(name: APP_FONT_REGULAR, size: 20),
                                                      vc: self)
        
        navigationController?.customRightBarButtonView(title: "",
                                                       fColor: "whitecolor",
                                                       fontName: UIFont(name: APP_FONT_REGULAR, size: 14),
                                                       imageName: "detail_back",
                                                       isLeft: true,
                                                       vc: self, transparantView: true)
        tableView.register(UINib(nibName: "PreAdcellTableViewCell", bundle: nil), forCellReuseIdentifier: "PreAdcellTableViewCell")
        
        Continue.cornerMiniumRadius()
        Continue.backgroundColor = UIColor(named: "AppThemeColor")
        Continue.config(color: UIColor(named: "whitecolor"),
                        font: UIFont(name: APP_FONT_REGULAR, size: 15),
                        align: .center,
                        title: "continue")
        tableView.reloadData()
       
    }



    
    // MARK: - Continue Button Action
    
    @IBAction func ContinuebtnTapped(_ sender: Any) {
        guard let selectedIndex = selectedIndex else {
            showAlertmsg(Message: "Please select a plan.")
            return
        }
        
       
    }
    func showAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
   


    func showAlertmsg(Message:String) {
        let alert = UIAlertController(title: nil, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}

// MARK: - TableView Delegate
extension PremiumAdvc: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreAdcellTableViewCell",for: indexPath) as! PreAdcellTableViewCell
        cell.CornerView.backgroundColor =
        (selectedIndex == indexPath) ?
        UIColor(named: "AppThemeColorTrans") :
        UIColor(named: "BlackColorad")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        tableView.reloadData()
    }
}


