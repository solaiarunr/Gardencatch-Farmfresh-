//
//  ExchangeCashConfirmViewController.swift
//  Joysale_Swift
//

import UIKit

class ExchangeCashConfirmViewController: UIViewController {

    var wantedItem: ItemModel?
    var onCreateExchange: ((_ wantedQty: Int, _ cashAmount: String) -> Void)?

    private var wantedQuantity = 1

    private let themeGreen = UIColor(named: "AppThemeColor") ?? UIColor(red: 0.18, green: 0.49, blue: 0.20, alpha: 1)
    private let borderGray = UIColor().hexValue(hex: "666666").withAlphaComponent(0.12)
    private let labelGray = UIColor(white: 0.45, alpha: 1)
    private let circleGray = UIColor(white: 0.93, alpha: 1)

    private let dimButton = UIButton(type: .custom)
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .custom)
    private let createButton = UIButton(type: .system)
    private let amountTextField = UITextField()

    private let wantedNameLabel = UILabel()
    private let wantedAvailableLabel = UILabel()
    private let wantedQtyLabel = UILabel()

    private var cardCenterYConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        setupKeyboardObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupUI() {
        view.backgroundColor = .clear

        dimButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimButton.addTarget(self, action: #selector(closeAct), for: .touchUpInside)
        dimButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimButton)

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 18
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)

        titleLabel.text = getLanguage["exchange_cash"] ?? "Exchange Cash"
        titleLabel.font = UIFont(name: APP_FONT_BOLD, size: 17) ?? .boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor(named: "AppTextColor") ?? .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)

        closeButton.backgroundColor = circleGray
        closeButton.layer.cornerRadius = 12
        closeButton.clipsToBounds = true
        if let closeImg = UIImage(named: "cancelbtn")?.withRenderingMode(.alwaysOriginal)
            ?? UIImage(named: "close-gray")?.withRenderingMode(.alwaysOriginal) {
            closeButton.setImage(closeImg, for: .normal)
        } else {
            closeButton.setTitle("✕", for: .normal)
            closeButton.setTitleColor(labelGray, for: .normal)
            closeButton.titleLabel?.font = .systemFont(ofSize: 11, weight: .medium)
        }
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        closeButton.addTarget(self, action: #selector(closeAct), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(closeButton)

        let wantedSection = makeWantedSection()
        let cashSection = makeCashSection()

        let contentStack = UIStackView(arrangedSubviews: [wantedSection, cashSection])
        contentStack.axis = .vertical
        contentStack.spacing = 18
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(contentStack)

        createButton.setTitle(getLanguage["create_exchange_btn"] ?? "Create Exchange", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.titleLabel?.font = UIFont(name: APP_FONT_BOLD, size: 15) ?? .boldSystemFont(ofSize: 15)
        createButton.backgroundColor = themeGreen
        createButton.layer.cornerRadius = 10
        createButton.clipsToBounds = true
        createButton.addTarget(self, action: #selector(createAct), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(createButton)

        let centerY = cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerY.priority = UILayoutPriority(999)
        cardCenterYConstraint = centerY

        NSLayoutConstraint.activate([
            dimButton.topAnchor.constraint(equalTo: view.topAnchor),
            dimButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerY,
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cardView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cardView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 44),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -44),

            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),

            contentStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            createButton.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 22),
            createButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            createButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18),
            createButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingAct))
        tap.cancelsTouchesInView = false
        tap.delaysTouchesBegan = false
        tap.delaysTouchesEnded = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let keyboardHeight = keyboardFrame.height
        let availableHeight = view.bounds.height - keyboardHeight
        let targetCenterY = availableHeight / 2.0
        let offset = targetCenterY - (view.bounds.height / 2.0)
        cardCenterYConstraint?.constant = min(offset, -20)
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            cardCenterYConstraint?.constant = 0
            return
        }
        cardCenterYConstraint?.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    private func makeWantedSection() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let headerLabel = UILabel()
        headerLabel.text = getLanguage["what_you_want"] ?? "What You Want"
        headerLabel.font = UIFont(name: APP_FONT_Medium, size: 12) ?? .systemFont(ofSize: 14, weight: .medium)
        headerLabel.textColor = UIColor().hexValue(hex: "666666")
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(headerLabel)

        let box = UIView()
        box.backgroundColor = .white
        box.layer.cornerRadius = 12
        box.layer.borderWidth = 1
        box.layer.borderColor = borderGray.cgColor
        box.clipsToBounds = true
        box.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(box)

        wantedNameLabel.font = UIFont(name: APP_FONT_BOLD, size: 17) ?? .boldSystemFont(ofSize: 17)
        wantedNameLabel.textColor = UIColor(named: "AppTextColor") ?? .black
        wantedNameLabel.numberOfLines = 1
        wantedNameLabel.lineBreakMode = .byTruncatingTail
        wantedNameLabel.translatesAutoresizingMaskIntoConstraints = false

        wantedAvailableLabel.font = UIFont(name: APP_FONT_REGULAR, size: 14) ?? .systemFont(ofSize: 14)
        wantedAvailableLabel.translatesAutoresizingMaskIntoConstraints = false

        let infoStack = UIStackView(arrangedSubviews: [wantedNameLabel, wantedAvailableLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 6
        infoStack.alignment = .leading
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        let leftPanel = UIView()
        leftPanel.translatesAutoresizingMaskIntoConstraints = false
        leftPanel.addSubview(infoStack)

        let divider = UIView()
        divider.backgroundColor = borderGray
        divider.translatesAutoresizingMaskIntoConstraints = false

        let qtyCaptionLabel = UILabel()
        qtyCaptionLabel.text = getLanguage["quantity_wanted"] ?? "Quantity wanted"
        qtyCaptionLabel.font = UIFont(name: APP_FONT_REGULAR, size: 14) ?? .systemFont(ofSize: 14)
        qtyCaptionLabel.textColor = UIColor().hexValue(hex: "444444")
        qtyCaptionLabel.textAlignment = .right
        qtyCaptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let stepper = makeStepper()
        let qtyStack = UIStackView(arrangedSubviews: [qtyCaptionLabel, stepper])
        qtyStack.axis = .vertical
        qtyStack.spacing = 6
        qtyStack.alignment = .trailing
        qtyStack.translatesAutoresizingMaskIntoConstraints = false

        let rightPanel = UIView()
        rightPanel.translatesAutoresizingMaskIntoConstraints = false
        rightPanel.addSubview(qtyStack)

        let row = UIStackView(arrangedSubviews: [leftPanel, divider, rightPanel])
        row.axis = .horizontal
        row.alignment = .center
        row.distribution = .fill
        row.translatesAutoresizingMaskIntoConstraints = false
        box.addSubview(row)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: container.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            box.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            box.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            box.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            box.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            box.heightAnchor.constraint(equalToConstant: 80),

            row.topAnchor.constraint(equalTo: box.topAnchor),
            row.leadingAnchor.constraint(equalTo: box.leadingAnchor),
            row.trailingAnchor.constraint(equalTo: box.trailingAnchor),
            row.bottomAnchor.constraint(equalTo: box.bottomAnchor),

            leftPanel.widthAnchor.constraint(equalTo: rightPanel.widthAnchor),
            leftPanel.heightAnchor.constraint(equalTo: row.heightAnchor),
            rightPanel.heightAnchor.constraint(equalTo: row.heightAnchor),
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.heightAnchor.constraint(equalToConstant: 44),

            infoStack.leadingAnchor.constraint(equalTo: leftPanel.leadingAnchor, constant: 14),
            infoStack.trailingAnchor.constraint(equalTo: leftPanel.trailingAnchor, constant: -10),
            infoStack.centerYAnchor.constraint(equalTo: leftPanel.centerYAnchor),

            qtyStack.trailingAnchor.constraint(equalTo: rightPanel.trailingAnchor, constant: -12),
            qtyStack.centerYAnchor.constraint(equalTo: rightPanel.centerYAnchor),
            qtyStack.leadingAnchor.constraint(greaterThanOrEqualTo: rightPanel.leadingAnchor, constant: 8)
        ])

        return container
    }

    private func makeCashSection() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let headerLabel = UILabel()
        headerLabel.text = getLanguage["cash_amount_to_offer"] ?? "Cash Amount To Offer"
        headerLabel.font = UIFont(name: APP_FONT_Medium, size: 12) ?? .systemFont(ofSize: 14, weight: .medium)
        headerLabel.textColor = UIColor().hexValue(hex: "666666")
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(headerLabel)

        amountTextField.borderStyle = .none
        amountTextField.font = UIFont(name: APP_FONT_REGULAR, size: 15) ?? .systemFont(ofSize: 15)
        amountTextField.textColor = UIColor(named: "AppTextColor") ?? .black
        amountTextField.keyboardType = .decimalPad
        amountTextField.addDoneButtonOnKeyboard()
        amountTextField.layer.cornerRadius = 12
        amountTextField.layer.borderWidth = 1
        amountTextField.layer.borderColor = borderGray.cgColor
        amountTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 48))
        amountTextField.leftViewMode = .always
        amountTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 48))
        amountTextField.rightViewMode = .always
        amountTextField.attributedPlaceholder = NSAttributedString(
            string: getLanguage["enter_amount"] ?? "Enter Amount",
            attributes: [.foregroundColor: UIColor(white: 0.7, alpha: 1),
                         .font: UIFont(name: APP_FONT_REGULAR, size: 15) ?? .systemFont(ofSize: 15)]
        )
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.delegate = self
        container.addSubview(amountTextField)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: container.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            amountTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            amountTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            amountTextField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            amountTextField.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            amountTextField.heightAnchor.constraint(equalToConstant: 48)
        ])

        return container
    }

    private func makeStepper() -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        let minusButton = makeCircleButton(titleFallback: "−", action: #selector(wantedMinusAct), imageName: "minusssico")
        let plusButton = makeCircleButton(titleFallback: "+", action: #selector(wantedPlusAct), imageName: "plusiconn")

        wantedQtyLabel.font = UIFont(name: APP_FONT_BOLD, size: 17) ?? .boldSystemFont(ofSize: 17)
        wantedQtyLabel.textColor = themeGreen
        wantedQtyLabel.textAlignment = .center
        wantedQtyLabel.translatesAutoresizingMaskIntoConstraints = false
        wantedQtyLabel.widthAnchor.constraint(equalToConstant: 28).isActive = true

        stack.addArrangedSubview(minusButton)
        stack.addArrangedSubview(wantedQtyLabel)
        stack.addArrangedSubview(plusButton)
        return stack
    }

    private func makeCircleButton(titleFallback: String, action: Selector, imageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = circleGray
        button.layer.cornerRadius = 13
        button.clipsToBounds = true
        if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal) {
            button.setImage(image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        } else {
            button.setTitle(titleFallback, for: .normal)
            button.setTitleColor(UIColor(white: 0.35, alpha: 1), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        }
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 26).isActive = true
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        return button
    }

    private func loadData() {
        wantedNameLabel.text = wantedItem?.itemTitle ?? ""
        setAvailableText(wantedAvailableLabel, count: wantedItem?.quantity ?? 0)
        wantedQuantity = min(max(1, wantedQuantity), max(1, wantedItem?.quantity ?? 1))
        wantedQtyLabel.text = "\(wantedQuantity)"
    }

    private func setAvailableText(_ label: UILabel, count: Int) {
        let prefix = "\(getLanguage["available"] ?? "Available") : "
        let font = UIFont(name: APP_FONT_REGULAR, size: 14) ?? .systemFont(ofSize: 14)
        let attributed = NSMutableAttributedString(string: prefix, attributes: [.font: font, .foregroundColor: labelGray])
        attributed.append(NSAttributedString(string: "\(count)", attributes: [.font: font, .foregroundColor: UIColor(named: "AppTextColor") ?? .black]))
        label.attributedText = attributed
    }

    private var maxWanted: Int { max(1, wantedItem?.quantity ?? 1) }

    @objc private func wantedMinusAct() {
        if wantedQuantity > 1 {
            wantedQuantity -= 1
            wantedQtyLabel.text = "\(wantedQuantity)"
        }
    }

    @objc private func wantedPlusAct() {
        if wantedQuantity < maxWanted {
            wantedQuantity += 1
            wantedQtyLabel.text = "\(wantedQuantity)"
        }
    }

    @objc private func endEditingAct() {
        view.endEditing(true)
    }

    @objc private func createAct() {
        view.endEditing(true)
        let amount = (amountTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if amount.isEmpty || (Float(amount) ?? 0) <= 0 {
            let alert = UIAlertController(title: getLanguage["alert"] ?? "", message: getLanguage["price should not be empty"] ?? "Please enter amount", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let qty = wantedQuantity
        dismiss(animated: true) { [weak self] in
            self?.onCreateExchange?(qty, amount)
        }
    }

    @objc private func closeAct() {
        dismiss(animated: true, completion: nil)
    }
}

extension ExchangeCashConfirmViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var touchedView = touch.view
        while let current = touchedView {
            if current is UIControl {
                return false
            }
            touchedView = current.superview
        }
        return true
    }
}

extension ExchangeCashConfirmViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji { return false }
        let current = (textField.text ?? "") as NSString
        let newString = current.replacingCharacters(in: range, with: string) as NSString
        let regex = "\\d{0,\(ADMIN_VIEW_MODEL.adminModel?.result.priceRange.beforeDecimalNotation ?? "5")}(\\.\\d{0,\(ADMIN_VIEW_MODEL.adminModel?.result.priceRange.afterDecimalNotation ?? "2")})?"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let allowed = CharacterSet(charactersIn: ".0123456789")
        return predicate.evaluate(with: newString) && allowed.isSuperset(of: CharacterSet(charactersIn: string))
    }
}
