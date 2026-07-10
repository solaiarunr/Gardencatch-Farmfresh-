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
    @IBOutlet weak var cancellbl: UILabel!
    @IBOutlet weak var deslbl: UILabel!
    @IBOutlet weak var benifitslbl: UILabel!
    @IBOutlet weak var benitfisstackview: UIStackView!

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

    private let planBenefitKeys = [
        "benefit_unlimited_listings",
        "benefit_local_business_badge",
        "benefit_priority_placement",
        "benefit_business_tools",
        "benefit_faster_approval"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        getPremiumData()
    }

    func showLoader() {
        LoaderView.isHidden = false
        Loader.startAnimating()
    }

    func hideLoader() {
        LoaderView.isHidden = true
        Loader.stopAnimating()
    }

    func configUI() {
        ListTV.delegate = self
        ListTV.dataSource = self
        ListTV.separatorStyle = .none
        ListTV.backgroundColor = UIColor(named: "BackGroundColor")
        ListTV.register(
            UINib(nibName: "PreAdcellTableViewCell", bundle: nil),
            forCellReuseIdentifier: "PreAdcellTableViewCell"
        )
        ListTV.rowHeight = UITableView.automaticDimension
        ListTV.estimatedRowHeight = 320

        TitleLbl.config(
            color: UIColor(named: "AppTextColor"),
            font: UIFont(name: APP_FONT_BOLD, size: 16),
            align: .left,
            text: "Upgradecontent"
        )
        TitleLbl.numberOfLines = 0

        deslbl.config(
            color: UIColor(named: "AppTextColor"),
            font: UIFont(name: APP_FONT_REGULAR, size: 14),
            align: .left,
            text: "Upgradecontentdes"
        )
        deslbl.numberOfLines = 0

        benifitslbl.isHidden = true
        benitfisstackview.isHidden = true
        benitfisstackview.arrangedSubviews.forEach {
            benitfisstackview.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        cancellbl.config(
            color: UIColor(named: "AppTextColor"),
            font: UIFont(name: APP_FONT_REGULAR, size: 13),
            align: .left,
            text: "cancel_des"
        )
        cancellbl.numberOfLines = 0

        payBtn.config(
            color: UIColor(named: "whitecolor"),
            font: UIFont(name: APP_FONT_BOLD, size: 16),
            align: .center,
            title: "ActivateBusinessSubscription"
        )
        payBtn.backgroundColor = UIColor(named: "activecolor") ?? UIColor(named: "AppThemeColor")
        payBtn.layer.cornerRadius = 8
        payBtn.clipsToBounds = true
    }

    func planBenefits() -> [String] {
        planBenefitKeys.compactMap { getLanguage[$0] }
    }

    func planTitle(for type: PremiumType) -> String {
        switch type {
        case .monthly:
            return getLanguage["MonthlyPlanTitle"] ?? "Local Business Subscription - Monthly Plan"
        case .yearly:
            return getLanguage["YearlyPlanTitle"] ?? "Local Business Subscription - Yearly Plan"
        }
    }

    func formattedPriceText(for model: PromotionPlanModel, type: PremiumType) -> String {
        let suffix = type == .monthly
            ? (getLanguage["per_month"] ?? "/ month")
            : (getLanguage["per_year"] ?? "/ year")
        let priceValue = model.formattedPrice ?? ""
        if priceValue.isEmpty {
            return suffix.trimmingCharacters(in: .whitespaces)
        }
        return "\(priceValue) \(suffix)"
    }

    func selectDefaultPlan() {
        switch premiumType {
        case .monthly:
            selectedMonthlyIndex = monthlyPromotions.isEmpty ? nil : 0
        case .yearly:
            selectedYearlyIndex = yearlyPromotions.isEmpty ? nil : 0
        }
        ListTV.reloadData()
    }

    func clearSelection() {
        selectedMonthlyIndex = nil
        selectedYearlyIndex = nil
        ListTV.reloadData()
    }

    @IBAction func payBtnAction(_ sender: UIButton) {
        sender.isEnabled = false

        if getSelectedPlan() == nil {
            selectDefaultPlan()
        }

        guard getSelectedPlan() != nil else {
            sender.isEnabled = true
            let alert = UIAlertController(
                title: nil,
                message: "Please select a plan",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
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
            payBtn.isEnabled = true
            return
        }

        let amount = "\(plan.price ?? 0.0)"
        let currency = getMembershipPromotionModel?.result?.currencyCode ?? "USD"
        let vm = StripeDataViewModel()

        vm.getStripeDetails(
            amount: amount,
            currency: currency,
            payment_mode: "subscription",
            plan_id: "\(plan.id ?? 0)",
            user_id: UserDefaultModule.shared.getUserData()?.user_id ?? ""
        ) { success in
            guard success else {
                self.payBtn.isEnabled = true
                let alert = UIAlertController(
                    title: "Error",
                    message: "Unable to create payment",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
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
                alert.addAction(UIAlertAction(title: "OK", style: .default))
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

            paymentSheet.present(from: delegate.navigationController) { result in
                switch result {
                case .completed:
                    let token = stripeData.paymentIntent.components(separatedBy: "_secret_")
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
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
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
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    func presentDropInController() {
        let dropInRequest = BTDropInRequest()
        let dropInController = BTDropInController(
            authorization: BRAINTREE_TOKEN,
            request: dropInRequest
        ) { controller, result, error in
            guard let result = result, error == nil else {
                self.payBtn.isEnabled = true
                print(error?.localizedDescription ?? "")
                return
            }

            if let nonce = result.paymentMethod?.nonce {
                self.payAct(type: "braintree", token: nonce, currency: "")
            }

            controller.dismiss(animated: true)
        }

        guard let dropIn = dropInController else { return }
        present(dropIn, animated: true)
    }

    func payAct(type: String, token: String, currency: String = "") {
        guard let plan = getSelectedPlan() else {
            return
        }

        showLoader()

        let parameter: [String: Any] = [
            "user_id": UserDefaultModule.shared.getUserData()?.user_id ?? "",
            "plan_id": plan.id ?? 0,
            "payment_type": type,
            "pay_nonce": token,
            "type": "localbusiness",
            "lang_type": DEFAULT_LANGUAGE_CODE,
            "currency_code": currency
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

            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
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
        showLoader()

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
                self.monthlyPromotions = rootClass.result?.monthlyPromotions ?? []
                self.yearlyPromotions = rootClass.result?.yearlyPromotions ?? []

                DispatchQueue.main.async {
                    self.selectDefaultPlan()
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch premiumType {
        case .monthly:
            return monthlyPromotions.count
        case .yearly:
            return yearlyPromotions.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PreAdcellTableViewCell",
            for: indexPath
        ) as! PreAdcellTableViewCell

        let model = premiumType == .monthly
            ? monthlyPromotions[indexPath.row]
            : yearlyPromotions[indexPath.row]

        let isSelected = premiumType == .monthly
            ? selectedMonthlyIndex == indexPath.row
            : selectedYearlyIndex == indexPath.row

        cell.configure(
            planTitle: planTitle(for: premiumType),
            priceText: formattedPriceText(for: model, type: premiumType),
            isYearly: premiumType == .yearly,
            benefits: planBenefits(),
            isSelected: isSelected
        )

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch premiumType {
        case .monthly:
            selectedMonthlyIndex = selectedMonthlyIndex == indexPath.row ? nil : indexPath.row
        case .yearly:
            selectedYearlyIndex = selectedYearlyIndex == indexPath.row ? nil : indexPath.row
        }
        tableView.reloadData()
    }
}
