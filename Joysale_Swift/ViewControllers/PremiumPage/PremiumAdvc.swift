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
    @IBOutlet weak var WholeView: UIView!
    @IBOutlet weak var SubstatusLbl: UILabel!
    @IBOutlet weak var PlanName: UILabel!
    @IBOutlet weak var PlanPrice: UILabel!
    @IBOutlet weak var Substart: UILabel!
    @IBOutlet weak var Subend: UILabel!
    @IBOutlet weak var AutoLbl: UILabel!
    @IBOutlet weak var SubstatusBtn: UIButton!
    @IBOutlet weak var PlanBtn: UIButton!
    @IBOutlet weak var PriceBtn: UIButton!
    @IBOutlet weak var StartBtn: UIButton!
    @IBOutlet weak var EndBtn: UIButton!
    @IBOutlet weak var AutoBtn: UIButton!
    @IBOutlet weak var Cancelbtn: UIButton!
    
    @IBOutlet weak var PlanLbl: UILabel!
    let promotionVM = PromotionViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        self.configUI()
        self.WholeView.isHidden = true
        self.Cancelbtn.isHidden = true
        getSubscriptionDetails()
        
    }
 
  
    func getSubscriptionDetails() {
        indicatorView.startAnimating()
        promotionVM.getSubscriptionDetails { [weak self] status in
            DispatchQueue.main.async {
                indicatorView.stopAnimating()
                if status {
                    self?.WholeView.isHidden = false
                    self?.Cancelbtn.isHidden = false
                    if let details = self?.promotionVM.subscriptionDetailsModel?.result {
                        print("Plan Name:", details.planName ?? "")
                        print("Price:", details.planPrice ?? 0)
                        print("Status:", details.subscriptionStatus ?? "")
                        print("Start Date:", details.subscriptionStart ?? "")
                        print("End Date:", details.subscriptionEnd ?? "")
                        print("autoRenewal:", details.autoRenewal ?? "")
                        if details.autoRenewal  == "true"{
                            self?.Cancelbtn.isHidden = false
                        }else{
                            self?.Cancelbtn.isHidden = true
                        }
                        self?.PlanLbl.text  = details.planName ?? ""
                        self?.PlanBtn.setTitle(details.planName ?? "", for: .normal)
                        self?.PriceBtn.setTitle("\(details.planPrice ?? 0)", for: .normal)
                        self?.StartBtn.setTitle(details.subscriptionStart ?? "", for: .normal)
                        self?.EndBtn.setTitle(details.subscriptionEnd ?? "", for: .normal)
                        self?.AutoBtn.setTitle(details.autoRenewal ?? "", for: .normal)
                        if details.subscriptionStatus ?? "" == "true"{
                            self?.SubstatusBtn.setTitle("Active", for: .normal)
                        }else{
                            self?.SubstatusBtn.setTitle("Inactive", for: .normal)
                        }
                        if details.autoRenewal ?? "" == "true" {
                            self?.AutoBtn.setTitle("Enabled", for: .normal)
                        }else{
                            self?.AutoBtn.setTitle("Disabled", for: .normal)
                        }
                    }
                }else{
                    let alert = UIAlertController(
                        title: "Alert",
                        message: "No subscription details found",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                    self?.present(alert, animated: true)
                }
            }

        } onFailure: { error in

            DispatchQueue.main.async {
                indicatorView.stopAnimating()
                let alert = UIAlertController(
                    title: "Alert",
                    message: "Not Found Subscription Details",
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })

                self.present(alert, animated: true)
                print(error)
            }
        }
    }
    @IBAction func cancelbtnTapped(_ sender: Any) {

        let confirmAlert = UIAlertController(
            title: "Cancel Subscription",
            message: "Are you sure you want to cancel your subscription?",
            preferredStyle: .alert
        )

        confirmAlert.addAction(UIAlertAction(
            title: "No",
            style: .cancel
        ))

        confirmAlert.addAction(UIAlertAction(
            title: "Yes",
            style: .destructive
        ) { _ in

            indicatorView.startAnimating()

            self.promotionVM.cancelSubscription { status, message in

                print("Status: \(status)")
                print("Message: \(message)")

                DispatchQueue.main.async {

                    indicatorView.stopAnimating()

                    let alert = UIAlertController(
                        title: status ? "Success" : "Alert",
                        message: "Your autosubscription was cancelled successfully",
                        preferredStyle: .alert
                    )

                    alert.addAction(UIAlertAction(
                        title: "OK",
                        style: .default
                    ) { _ in

                        if status {
                            self.navigationController?.popViewController(animated: true)
                        }
                    })

                    self.present(alert, animated: true)
                }

            } onFailure: { error in

                DispatchQueue.main.async {

                    indicatorView.stopAnimating()

                    let errorAlert = UIAlertController(
                        title: "Error",
                        message: error,
                        preferredStyle: .alert
                    )

                    errorAlert.addAction(UIAlertAction(
                        title: "OK",
                        style: .default
                    ))

                    self.present(errorAlert, animated: true)
                }
            }
        })

        present(confirmAlert, animated: true)
    }
    
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
      
        self.WholeView.layer.borderColor = UIColor.lightGray.cgColor
        self.WholeView.layer.borderWidth = 1.0
        for lbl in [SubstatusLbl,PlanName,PlanPrice,Substart,Subend,AutoLbl]{
            lbl?.config(color: UIColor.black, font: UIFont(name: APP_FONT_BOLD, size: 15), align: .left, text: "")
        }
        SubstatusLbl.text = getLanguage["subscription_status"]
        PlanName.text = getLanguage["plan_name"]
        PlanPrice.text =  getLanguage["plan_price"]
        Substart.text =  getLanguage["subscription_start"]
        Subend.text =  getLanguage["subscription_end"]
        AutoLbl.text =  getLanguage["auto_renewal"]
        self.Cancelbtn.config(color: UIColor.white, font: UIFont(name: APP_FONT_REGULAR, size: 15), align: .center, title: "cancelsub")
        self.SubstatusBtn.config(color: UIColor.white, font: UIFont(name: APP_FONT_REGULAR, size: 15), align: .center, title: "")
        self.AutoBtn.config(color: UIColor.white, font: UIFont(name: APP_FONT_REGULAR, size: 15), align: .center, title: "")
        
        for btn in [PlanBtn,PriceBtn,StartBtn,EndBtn]{
            btn?.config(color: UIColor.black, font: UIFont(name: APP_FONT_REGULAR, size: 15), align: .right, title: "")
            self.PlanLbl.config(color: UIColor.black, font: UIFont(name: APP_FONT_REGULAR, size:13), align: .right, text: "")
        }
       
    }


 
}



