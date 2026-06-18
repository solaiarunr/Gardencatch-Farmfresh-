import UIKit
import Stripe
import BraintreeDropIn
import Braintree
enum PremiumType {
    case monthly
    case yearly
}

class PremiumListVc: UIViewController {

    @IBOutlet weak var ListTV: UITableView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var payBtn: UIButton!

    var premiumType: PremiumType = .monthly
    var monthlyPromotions: [PromotionPlanModel] = []
    var yearlyPromotions: [PromotionPlanModel] = []
    var getMembershipPromotionModel: GetMembershipPromotionModel?
    var selectedMonthlyIndex: Int?
    var selectedYearlyIndex: Int?
    var stripeModel = StripeDataModel()
    var paymentSheetFlowController: PaymentSheet.FlowController?
    let appdelegatecall = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var LoaderView: UIView!
    @IBOutlet weak var Loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        getPremiumData()
    }
    func showLoader() {
        self.LoaderView.isHidden = false
        self.Loader.startAnimating()
    }

    func hideLoader() {
        self.LoaderView.isHidden = true
        self.Loader.stopAnimating()
    }
    func configUI() {
        ListTV.delegate = self
        ListTV.dataSource = self
      

        ListTV.register(
            UINib(nibName: "PreAdcellTableViewCell", bundle: nil),
            forCellReuseIdentifier: "PreAdcellTableViewCell"
        )
        TitleLbl.config(color: UIColor(named: "LightTextColor"),
                              font: UIFont(name: APP_FONT_REGULAR, size: 15),
                              align: .left,
                              text: "Upgradecontent")
     
       
    }
    func clearSelection() {
        selectedMonthlyIndex = nil
        selectedYearlyIndex = nil
        ListTV.reloadData()
    }
    @IBAction func payBtnAction(_ sender: UIButton) {
        sender.isEnabled = false
        let selectedPlanIndex = premiumType == .monthly
            ? selectedMonthlyIndex
            : selectedYearlyIndex

        guard selectedPlanIndex != nil else {
            sender.isEnabled = true
            let alert = UIAlertController(
                title: nil,
                message: "Please select a plan",
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(title: "OK", style: .cancel)
            )

            present(alert, animated: true)
            return
        }

        if ADMIN_VIEW_MODEL.adminModel?.result.adminPaymentType == "braintree" {
            presentDropInController()
        } else {
            presentStripe()
        }
    }
    
    func getSelectedPlan() -> PromotionPlanModel? {

        switch premiumType {

        case .monthly:

            guard let index = selectedMonthlyIndex,
                  index < monthlyPromotions.count else {
                return nil
            }

            return monthlyPromotions[index]

        case .yearly:

            guard let index = selectedYearlyIndex,
                  index < yearlyPromotions.count else {
                return nil
            }

            return yearlyPromotions[index]
        }
    }
    func presentStripe() {

        guard let plan = getSelectedPlan() else {
            self.payBtn.isEnabled = true
            return
        }

        let amount = "\(plan.price ?? 0.0)"

        let currency = getMembershipPromotionModel?
            .result?
            .currencyCode ?? "USD"

        let vm = StripeDataViewModel()

        vm.getStripeDetails(
            amount: amount,
            currency: currency,
            payment_mode: "subscription",
            plan_id: "\(plan.id ?? 0)",user_id:UserDefaultModule.shared.getUserData()?.user_id ?? ""
        ) { success in

            guard success else {

                self.payBtn.isEnabled = true

                let alert = UIAlertController(
                    title: "Error",
                    message:  "Unable to create payment",
                    preferredStyle: .alert
                )

                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default
                    )
                )

                self.present(alert, animated: true)
                return
            }

            guard let stripeData = vm.stripeModel else {

                self.payBtn.isEnabled = true

                let alert = UIAlertController(
                    title: "Error",
                    message: "Invalid payment response",
                    preferredStyle: .alert
                )

                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default
                    )
                )

                self.present(alert, animated: true)
                return
            }

            self.stripeModel = stripeData

            var configuration = PaymentSheet.Configuration()

            configuration.merchantDisplayName = "Garden Catch LLC"

            configuration.customer = .init(
                id: stripeData.customer,
                ephemeralKeySecret: stripeData.ephemeralKey
            )

            let paymentSheet = PaymentSheet(
                paymentIntentClientSecret: stripeData.paymentIntent,
                configuration: configuration
            )

            let delegate = UIApplication.shared.delegate as! AppDelegate

            paymentSheet.present(
                from: delegate.navigationController
            ) { result in

                switch result {

                case .completed:

                    let token = stripeData.paymentIntent
                        .components(separatedBy: "_secret_")

                    self.payAct(
                        type: "stripe",
                        token: token.first ?? "",
                        currency: currency
                    )

                case .canceled:

                    self.payBtn.isEnabled = true

                case .failed(let error):

                    self.payBtn.isEnabled = true

                    let alert = UIAlertController(
                        title: "Payment Failed",
                        message: error.localizedDescription,
                        preferredStyle: .alert
                    )

                    alert.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: .default
                        )
                    )

                    self.present(alert, animated: true)
                }
            }

        } onFailure: { error in

            self.payBtn.isEnabled = true

            let alert = UIAlertController(
                title: "Error",
                message: error,
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default
                )
            )

            self.present(alert, animated: true)
        }
    }
    func presentDropInController() {

        let dropInRequest = BTDropInRequest()

        let dropInController = BTDropInController(
            authorization: BRAINTREE_TOKEN,
            request: dropInRequest
        ) { controller, result, error in

            guard let result = result,
                  error == nil else {
                self.payBtn.isEnabled = true
                print(error?.localizedDescription ?? "")
                return
            }

            if let nonce = result.paymentMethod?.nonce {

                self.payAct(
                    type: "braintree",
                    token: nonce,currency: ""
                )
            }

            controller.dismiss(animated: true)
        }

        guard let dropIn = dropInController else { return }

        present(dropIn, animated: true)
    }
    func payAct(type: String,
                token: String,currency:String = "") {

        guard let plan = getSelectedPlan() else {
            return
        }
        showLoader()
        let parameter: [String: Any] = [
            "user_id":
                UserDefaultModule.shared.getUserData()?.user_id ?? "",
            "plan_id":
                plan.id ?? 0,
            "payment_type":
                type,
            "pay_nonce":
                token,
            "type":"localbusiness",
            "lang_type":DEFAULT_LANGUAGE_CODE,
            "currency_code":currency
            
        ]


        CallParsingFunction().postDataCall(
            subURl: PROCESSING_PAYMENT_URL,
            params: parameter
        ) { response in
            self.hideLoader()
            print(response)

            let alert = UIAlertController(
                title: "Success",
                message: "Membership activated successfully",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default
            ) { _ in

                let pageObj = TabbarController()
                pageObj.selectedIndex = 0

                self.appdelegatecall.initVC(initialView: pageObj)
            })

            self.present(alert, animated: true)

        } onFailure: { error in
            self.hideLoader()
            print(error?.localizedDescription ?? "")
        }
    }

    public func getPremiumData() {
        self.showLoader()
        let parameter: [String: Any] = [
            "lang_type": DEFAULT_LANGUAGE_CODE,
            "user_id": UserDefaultModule.shared.getUserData()?.user_id ?? ""
        ]

        CallParsingFunction().postDataCall(
            subURl: getpremium,
            params: parameter,
            onSuccess: { response in
                self.hideLoader()
                let rootClass = GetMembershipPromotionModel(fromJson: response)

                self.getMembershipPromotionModel = rootClass

                self.monthlyPromotions =
                    rootClass.result?.monthlyPromotions ?? []

                self.yearlyPromotions =
                    rootClass.result?.yearlyPromotions ?? []

                DispatchQueue.main.async {
                    self.ListTV.reloadData()
                }

            },
            onFailure: { error in
                self.hideLoader()
                print(error?.localizedDescription ?? "")
            }
        )
    }
}

extension PremiumListVc: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        switch premiumType {

        case .monthly:
            return monthlyPromotions.count

        case .yearly:
            return yearlyPromotions.count
        }
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PreAdcellTableViewCell",
            for: indexPath
        ) as! PreAdcellTableViewCell

        let model = premiumType == .monthly
            ? monthlyPromotions[indexPath.row]
            : yearlyPromotions[indexPath.row]

        cell.Planname.text = model.name ?? ""
        cell.price.text = model.formattedPrice ?? ""
        cell.Plandays.text = premiumType == .monthly ? "Monthly" : "Yearly"

        // ✅ Check selected index and apply background
        let isSelected = premiumType == .monthly
            ? selectedMonthlyIndex == indexPath.row
            : selectedYearlyIndex == indexPath.row

        cell.CornerView.backgroundColor = isSelected
            ? UIColor(named: "AppThemeColorTrans")  // ✅ Selected - highlighted
            : UIColor(named: "BlackColorad")         // ✅ Unselected - normal
        
        return cell
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        switch premiumType {
        case .monthly:
            // ✅ Tap same row again = deselect, tap new row = select
            if selectedMonthlyIndex == indexPath.row {
                selectedMonthlyIndex = nil  // deselect
            } else {
                selectedMonthlyIndex = indexPath.row  // select
            }

        case .yearly:
            if selectedYearlyIndex == indexPath.row {
                selectedYearlyIndex = nil  // deselect
            } else {
                selectedYearlyIndex = indexPath.row  // select
            }
        }

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
