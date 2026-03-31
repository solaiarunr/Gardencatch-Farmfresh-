//
//  PromotionOptionViewController.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 22/07/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import Stripe
import BraintreeDropIn
import Braintree
import NVActivityIndicatorView

class PromotionOptionViewController: UIViewController {
    
    @IBOutlet weak var activityLoader: NVActivityIndicatorView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = PromotionViewModel()
    var selectedTag: Int!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var itemID = ""
    var stripeModel = StripeDataModel()
    var paymentSheetFlowController: PaymentSheet.FlowController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        self.configUI()
        self.loadData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func configUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PromotionOptionTableViewCell", bundle: nil), forCellReuseIdentifier: "PromotionOptionTableViewCell")
        self.tableView.register(UINib(nibName: "PromotionHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "PromotionHeaderTableViewCell")
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 50
        self.tableView.sectionFooterHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionFooterHeight = 50
        self.payButton.backgroundColor = UIColor(named: "AppThemeColor") ?? .white
        self.payButton.cornerMiniumRadius()
        self.payButton.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 15), align: .center, title: "pay_and_promote")
    }
    func loadData() {
        self.activityLoader.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.viewModel.getPromotionData(onSuccess: { (success) in
            self.tableView.reloadData()
            self.activityLoader.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }) { (failure) in
            self.activityLoader.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    @IBAction func payButtonAct(_ sender: UIButton) {
        var isValid = true
        if self.view.tag == 1 {
            var promotionID = "0"
            if let selectedCell = self.selectedTag, (self.viewModel.getPromotionModel?.result.otherPromotions.count ?? 0) > selectedCell {
                promotionID = "\(self.viewModel.getPromotionModel?.result.otherPromotions[selectedCell].id ?? 0)"
            }
            if promotionID == "0" {
                isValid = false
            }
        }
        if isValid {
            if ADMIN_VIEW_MODEL.adminModel?.result.adminPaymentType == "braintree" {
                self.presentDropInController()
            }
            else {
                self.presentStripe()
//                let pageObj = StripeViewController()
//                pageObj.delegate = self
//                self.delegate.navigationController.pushViewController(pageObj, animated: true)
            }
        }
        else {
            let alert = UIAlertController(title: nil, message: getLanguage["Please select the Promotion, you like to pay for"] ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @objc func presentStripe() {
        let cSymbol = (self.viewModel.getPromotionModel?.result.currencyCode ?? "").trimmingCharacters(in: .whitespaces)
        var price = "\(self.viewModel.getPromotionModel?.result.urgent ?? 0)"
        if self.view.tag == 1 {
            if let selectedCell = self.selectedTag, (self.viewModel.getPromotionModel?.result.otherPromotions.count ?? 0) > selectedCell {
                price = "\(self.viewModel.getPromotionModel?.result.otherPromotions[selectedCell].price ?? "0")"
            }
        }
        var paymentSheet: PaymentSheet?
        let viewModel = StripeDataViewModel()
        viewModel.getStripeDetails(amount: price, currency: cSymbol) { (success) in
            if viewModel.stripeModel?.status ?? false {
                guard let viewData = viewModel.stripeModel else {
                    return
                }
                self.stripeModel = viewData
                
                var configuration = PaymentSheet.Configuration()
                configuration.merchantDisplayName = "Garden Catch LLC"
//                configuration.redir
                configuration.customer = .init(id: self.stripeModel.customer, ephemeralKeySecret: self.stripeModel.ephemeralKey)
                paymentSheet = PaymentSheet(paymentIntentClientSecret: self.stripeModel.paymentIntent, configuration: configuration)
                DispatchQueue.main.async {
                    let delegate = UIApplication.shared.delegate as! AppDelegate

                    paymentSheet?.present(from: delegate.navigationController) { paymentResult in
                      // MARK: Handle the payment result
                      switch paymentResult {
                      case .completed:
                        print("Your order is confirmed")
                        let token = self.stripeModel.paymentIntent.components(separatedBy: "_secret_")
                        self.payAct(type: "stripe", token: token.first ?? "")
                      case .canceled:
                        print("Canceled!")
                      case .failed(let error):
                        print("Payment failed: \n\(error.localizedDescription)")
                      }
                    }
                }
            }
            else {
                let alert = UIAlertController(title: nil, message: getLanguage["amount_too_small"] ?? "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } onFailure: { (failure) in
            let alert = UIAlertController(title: nil, message: getLanguage["amount_too_small"] ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    @objc func presentDropInController() {
       // BTUIKAppearance.sharedInstance()?.colorScheme = BTUIKColorScheme(rawValue: 0)!
        let dropInRequest = BTDropInRequest()
        let dropInController = BTDropInController(authorization: BRAINTREE_TOKEN, request: dropInRequest) { (dropInController, result, error) in
            guard let result = result, error == nil else {
                print("Error: \(error!)")
                let alert = UIAlertController(title: nil, message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            if result.isCanceled {
                print("Cancelled🎲")
            } else if result.paymentMethodType == .applePay {
                print("Ready for checkout...")
            } else if let nonce = result.paymentMethod?.nonce {
                print("Ready for checkout...")
                self.payAct(type: "braintree", token: "\(nonce)")
            }
            dropInController.dismiss(animated: true, completion: nil)
        }

        guard let dropIn = dropInController else {
            return
        }
        self.delegate.navigationController.present(dropIn, animated: true, completion: nil)
        //present(dropIn, animated: true, completion: nil)
    }
}
extension PromotionOptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.view.tag == 0 {
            return 0
        }
        return self.viewModel.getPromotionModel?.result.otherPromotions.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PromotionHeaderTableViewCell") as! PromotionHeaderTableViewCell
        let member_enable = self.viewModel.getPromotionModel?.result.membership_enable_urgent ?? ""
        cell.loadFooterData(viewTag: self.view.tag, Member_enable: member_enable)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PromotionHeaderTableViewCell") as! PromotionHeaderTableViewCell
        cell.loadHeaderData(viewTag: self.view.tag)
        if self.view.tag == 0 {
            cell.priceLabel.text = self.viewModel.getPromotionModel?.result.formattedUrgent ?? ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionOptionTableViewCell") as! PromotionOptionTableViewCell
        if let promotionData = self.viewModel.getPromotionModel?.result.otherPromotions[indexPath.row] {
            cell.loadData(promotionData: promotionData, index: indexPath.row)
        }
        if let selectedCell = self.selectedTag, selectedCell == indexPath.row {
            cell.selectedView.isHidden = false
        }
        else {
            cell.selectedView.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTag = indexPath.row
        self.tableView.reloadData()
    }
}
extension PromotionOptionViewController: PaymentViewControllerDelegate {
    func paymentViewController(_ token: STPToken) {
        self.payAct(type: "stripe", token: "\(token)")
    }
    
    func payAct(type: String, token: String) {
        let cSymbol = (self.viewModel.getPromotionModel?.result.currencyCode ?? "").trimmingCharacters(in: .whitespaces)
        var promotionID = "0"
        if self.view.tag == 1 {
            if let selectedCell = self.selectedTag, (self.viewModel.getPromotionModel?.result.otherPromotions.count ?? 0) > selectedCell {
                promotionID = "\(self.viewModel.getPromotionModel?.result.otherPromotions[selectedCell].id ?? 0)"
            }
        }
        self.activityLoader.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.viewModel.processingPayment(user_id: (UserDefaultModule.shared.getUserData()?.user_id ?? ""), item_id: self.itemID, promotion_id: promotionID, currency_code: cSymbol, pay_nonce: "\(token)", payment_type: type, onSuccess: { (success) in
            self.activityLoader.stopAnimating()
            self.view.isUserInteractionEnabled = true
            let alert = UIAlertController(title: getLanguage["alert"] ?? "", message: getLanguage[(self.viewModel.checkoutModel?.message ?? "")] ?? (self.viewModel.checkoutModel?.message ?? ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["ok"], style: .cancel, handler: { (UIAlertAction) in
                let pageObj = ViewProfileViewController()
                pageObj.userId = UserDefaultModule.shared.getUserData()?.user_id ?? ""
                pageObj.isTabBar = true
                ADD_EDIT_ITEM_MODEL = AddEditViewModel()
                self.delegate.navigationController.pushViewController(pageObj, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }) { (failure) in
            self.activityLoader.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
        
    }
}
