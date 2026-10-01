//
//  ExchangeProductConfirmViewController.swift
//  Joysale_Swift
//

import UIKit

class ExchangeProductConfirmViewController: UIViewController {

    var wantedItem: ItemModel?
    var offerItem: ItemModel?
    var onCreateExchange: ((_ wantedQty: Int, _ offerQty: Int) -> Void)?

    private var wantedQuantity = 1
    private var offerQuantity = 1

    private let themeGreen = UIColor(named: "AppThemeColor") ?? UIColor(red: 0.18, green: 0.49, blue: 0.20, alpha: 1)
    private let borderGray = UIColor().hexValue(hex: "666666").withAlphaComponent(0.12)
    private let labelGray = UIColor(white: 0.45, alpha: 1)
    private let circleGray = UIColor(white: 0.93, alpha: 1)

    private let dimButton = UIButton(type: .custom)
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .custom)
    private let createButton = UIButton(type: .system)

    private let wantedNameLabel = UILabel()
    private let wantedAvailableLabel = UILabel()
    private let wantedQtyLabel = UILabel()

    private let offerNameLabel = UILabel()
    private let offerAvailableLabel = UILabel()
    private let offerQtyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
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

        titleLabel.text = getLanguage["exchange_product"] ?? "Exchange Product"
        titleLabel.font = UIFont(name: APP_FONT_BOLD, size: 17) ?? .boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor(named: "AppTextColor") ?? .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)

        closeButton.backgroundColor = circleGray
        closeButton.layer.cornerRadius = 12
        closeButton.clipsToBounds = true
        if let closeImg = UIImage(named: "cancelbtn")?.withRenderingMode(.alwaysOriginal) {
            closeButton.setImage(closeImg, for: .normal)
        } else if let closeImg = UIImage(named: "cancelbtn")?.withRenderingMode(.alwaysOriginal) {
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

        let wantedSection = makeSection(
            header: getLanguage["what_you_want"] ?? "What You Want",
            nameLabel: wantedNameLabel,
            availableLabel: wantedAvailableLabel,
            qtyCaption: getLanguage["quantity_wanted"] ?? "Quantity wanted",
            qtyLabel: wantedQtyLabel,
            minusAction: #selector(wantedMinusAct),
            plusAction: #selector(wantedPlusAct)
        )

        let offerSection = makeSection(
            header: getLanguage["your_offer"] ?? "Your Offer",
            nameLabel: offerNameLabel,
            availableLabel: offerAvailableLabel,
            qtyCaption: getLanguage["quantity_to_offer"] ?? "Quantity to offer",
            qtyLabel: offerQtyLabel,
            minusAction: #selector(offerMinusAct),
            plusAction: #selector(offerPlusAct)
        )

        let contentStack = UIStackView(arrangedSubviews: [wantedSection, offerSection])
        contentStack.axis = .vertical
        contentStack.spacing = 18
        contentStack.distribution = .fill
        contentStack.alignment = .fill
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

        NSLayoutConstraint.activate([
            dimButton.topAnchor.constraint(equalTo: view.topAnchor),
            dimButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerY,
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
    }

    private func makeSection(header: String, nameLabel: UILabel, availableLabel: UILabel, qtyCaption: String, qtyLabel: UILabel, minusAction: Selector, plusAction: Selector) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.setContentHuggingPriority(.required, for: .vertical)
        container.setContentCompressionResistancePriority(.required, for: .vertical)

        let headerLabel = UILabel()
        headerLabel.text = header
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

        // Left: product name + available
        nameLabel.font = UIFont(name: APP_FONT_BOLD, size: 17) ?? .boldSystemFont(ofSize: 17)
        nameLabel.textColor = UIColor(named: "AppTextColor") ?? .black
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        availableLabel.font = UIFont(name: APP_FONT_REGULAR, size: 14) ?? .systemFont(ofSize: 14)
        availableLabel.translatesAutoresizingMaskIntoConstraints = false

        let infoStack = UIStackView(arrangedSubviews: [nameLabel, availableLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 6
        infoStack.alignment = .leading
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        let leftPanel = UIView()
        leftPanel.translatesAutoresizingMaskIntoConstraints = false
        leftPanel.addSubview(infoStack)

        // Divider
        let divider = UIView()
        divider.backgroundColor = borderGray
        divider.translatesAutoresizingMaskIntoConstraints = false

        // Right: quantity caption + stepper
        let qtyCaptionLabel = UILabel()
        qtyCaptionLabel.text = qtyCaption
        qtyCaptionLabel.font = UIFont(name: APP_FONT_REGULAR, size: 14) ?? .systemFont(ofSize: 14)
        qtyCaptionLabel.textColor = UIColor().hexValue(hex: "444444")
        qtyCaptionLabel.textAlignment = .right
        qtyCaptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let stepper = makeStepper(qtyLabel: qtyLabel, minusAction: minusAction, plusAction: plusAction)

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
        row.spacing = 0
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

            // Equal left / right halves (Figma)
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

    private func makeStepper(qtyLabel: UILabel, minusAction: Selector, plusAction: Selector) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        let minusButton = makeCircleButton(imageName: "minusssico", titleFallback: "−", action: minusAction)
        let plusButton = makeCircleButton(imageName: "plusiconn", titleFallback: "+", action: plusAction)

        qtyLabel.font = UIFont(name: APP_FONT_BOLD, size: 17) ?? .boldSystemFont(ofSize: 17)
        qtyLabel.textColor = themeGreen
        qtyLabel.textAlignment = .center
        qtyLabel.setContentHuggingPriority(.required, for: .horizontal)
        qtyLabel.translatesAutoresizingMaskIntoConstraints = false
        qtyLabel.widthAnchor.constraint(equalToConstant: 28).isActive = true

        stack.addArrangedSubview(minusButton)
        stack.addArrangedSubview(qtyLabel)
        stack.addArrangedSubview(plusButton)
        return stack
    }

    private func makeCircleButton(imageName: String, titleFallback: String, action: Selector) -> UIButton {
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
        offerNameLabel.text = offerItem?.itemTitle ?? ""
        setAvailableText(wantedAvailableLabel, count: wantedItem?.quantity ?? 0)
        setAvailableText(offerAvailableLabel, count: offerItem?.quantity ?? 0)
        wantedQuantity = min(max(1, wantedQuantity), max(1, wantedItem?.quantity ?? 1))
        offerQuantity = min(max(1, offerQuantity), max(1, offerItem?.quantity ?? 1))
        updateQtyLabels()
    }

    private func setAvailableText(_ label: UILabel, count: Int) {
        let prefix = "\(getLanguage["available"] ?? "Available") : "
        let countText = "\(count)"
        let font = UIFont(name: APP_FONT_REGULAR, size: 14) ?? .systemFont(ofSize: 14)
        let attributed = NSMutableAttributedString(
            string: prefix,
            attributes: [
                .font: font,
                .foregroundColor: labelGray
            ]
        )
        attributed.append(NSAttributedString(
            string: countText,
            attributes: [
                .font: font,
                .foregroundColor: UIColor(named: "AppTextColor") ?? .black
            ]
        ))
        label.attributedText = attributed
    }

    private func updateQtyLabels() {
        wantedQtyLabel.text = "\(wantedQuantity)"
        offerQtyLabel.text = "\(offerQuantity)"
    }

    private var maxWanted: Int { max(1, wantedItem?.quantity ?? 1) }
    private var maxOffer: Int { max(1, offerItem?.quantity ?? 1) }

    @objc private func wantedMinusAct() {
        if wantedQuantity > 1 {
            wantedQuantity -= 1
            updateQtyLabels()
        }
    }

    @objc private func wantedPlusAct() {
        if wantedQuantity < maxWanted {
            wantedQuantity += 1
            updateQtyLabels()
        }
    }

    @objc private func offerMinusAct() {
        if offerQuantity > 1 {
            offerQuantity -= 1
            updateQtyLabels()
        }
    }

    @objc private func offerPlusAct() {
        if offerQuantity < maxOffer {
            offerQuantity += 1
            updateQtyLabels()
        }
    }

    @objc private func createAct() {
        let wanted = wantedQuantity
        let offer = offerQuantity
        dismiss(animated: true) { [weak self] in
            self?.onCreateExchange?(wanted, offer)
        }
    }

    @objc private func closeAct() {
        dismiss(animated: true, completion: nil)
    }
}
