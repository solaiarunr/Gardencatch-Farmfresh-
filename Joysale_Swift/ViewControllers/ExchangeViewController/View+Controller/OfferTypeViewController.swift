//
//  OfferTypeViewController.swift
//  Joysale_Swift
//

import UIKit

enum ExchangeOfferType {
    case product
    case cash
}

class OfferTypeViewController: UIViewController {

    var itemDetails: ItemModel?
    var onConfirm: ((ExchangeOfferType) -> Void)?

    private var selectedType: ExchangeOfferType = .product

    private let dimButton = UIButton(type: .custom)
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .custom)
    private let optionsContainer = UIView()
    private let productRow = UIControl()
    private let cashRow = UIControl()
    private let productRadio = UIView()
    private let cashRadio = UIView()
    private let productDot = UIView()
    private let cashDot = UIView()
    private let confirmButton = UIButton(type: .system)

    private let themeGreen = UIColor(named: "AppThemeColor") ?? UIColor(red: 0.18, green: 0.49, blue: 0.20, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateRadioUI()
    }

    private func setupUI() {
        view.backgroundColor = .clear

        dimButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimButton.addTarget(self, action: #selector(closeAct), for: .touchUpInside)
        dimButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimButton)

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)

        titleLabel.text = getLanguage["what_youll_offer"] ?? "WHAT YOU'LL OFFER"
        titleLabel.font = UIFont(name: APP_FONT_BOLD, size: 15) ?? .boldSystemFont(ofSize: 15)
        titleLabel.textColor = UIColor(named: "AppTextColor") ?? .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)

        // Circular close button like Figma
        closeButton.backgroundColor = UIColor(white: 0.92, alpha: 1)
        closeButton.layer.cornerRadius = 12
        closeButton.clipsToBounds = true
        if let closeImg = UIImage(named: "cancelbtn")?.withRenderingMode(.alwaysOriginal) {
            closeButton.setImage(closeImg, for: .normal)
        } else if let closeImg = UIImage(named: "cancelbtn")?.withRenderingMode(.alwaysOriginal) {
            closeButton.setImage(closeImg, for: .normal)
        } else {
            closeButton.setTitle("✕", for: .normal)
            closeButton.setTitleColor(UIColor(white: 0.45, alpha: 1), for: .normal)
            closeButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        }
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        closeButton.addTarget(self, action: #selector(closeAct), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(closeButton)

        // Bordered options box (Figma)
        optionsContainer.backgroundColor = UIColor(named: "viewcolorr")
        optionsContainer.layer.cornerRadius = 10
        optionsContainer.layer.borderWidth = 1
        optionsContainer.layer.borderColor =  UIColor(named: "viewcolorrborder")?.cgColor
        optionsContainer.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(optionsContainer)

        configureOptionRow(productRow, radio: productRadio, dot: productDot, title: getLanguage["product"] ?? "Product", action: #selector(selectProduct))
        configureOptionRow(cashRow, radio: cashRadio, dot: cashDot, title: getLanguage["cash"] ?? "Cash", action: #selector(selectCash))

        let optionsStack = UIStackView(arrangedSubviews: [productRow, cashRow])
        optionsStack.axis = .vertical
        optionsStack.spacing = 4
        optionsStack.translatesAutoresizingMaskIntoConstraints = false
        optionsContainer.addSubview(optionsStack)

        confirmButton.setTitle(getLanguage["confirm"] ?? "Confirm", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: APP_FONT_BOLD, size: 14) ?? .boldSystemFont(ofSize: 14)
        confirmButton.backgroundColor = themeGreen
        confirmButton.layer.cornerRadius = 8
        confirmButton.clipsToBounds = true
        confirmButton.addTarget(self, action: #selector(confirmAct), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(confirmButton)

        NSLayoutConstraint.activate([
            dimButton.topAnchor.constraint(equalTo: view.topAnchor),
            dimButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -40),

            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),

            optionsContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            optionsContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            optionsContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),

            optionsStack.topAnchor.constraint(equalTo: optionsContainer.topAnchor, constant: 14),
            optionsStack.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor, constant: 14),
            optionsStack.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor, constant: -14),
            optionsStack.bottomAnchor.constraint(equalTo: optionsContainer.bottomAnchor, constant: -14),

            confirmButton.topAnchor.constraint(equalTo: optionsContainer.bottomAnchor, constant: 18),
            confirmButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            confirmButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18),
            confirmButton.widthAnchor.constraint(equalToConstant: 100),
            confirmButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }

    private func configureOptionRow(_ row: UIControl, radio: UIView, dot: UIView, title: String, action: Selector) {
        row.addTarget(self, action: action, for: .touchUpInside)
        row.translatesAutoresizingMaskIntoConstraints = false
        // Larger tap target so Cash / Product are easy to select
        row.contentVerticalAlignment = .center

        radio.translatesAutoresizingMaskIntoConstraints = false
        radio.isUserInteractionEnabled = false
        radio.layer.cornerRadius = 9
        radio.layer.borderWidth = 2
        radio.layer.borderColor = themeGreen.cgColor
        radio.backgroundColor = .white
        row.addSubview(radio)

        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.isUserInteractionEnabled = false
        dot.backgroundColor = themeGreen
        dot.layer.cornerRadius = 4.5
        dot.isHidden = true
        radio.addSubview(dot)

        let label = UILabel()
        label.text = title
        label.font = UIFont(name: APP_FONT_REGULAR, size: 14) ?? .systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.35, alpha: 1)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(label)

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 44),
            radio.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            radio.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            radio.widthAnchor.constraint(equalToConstant: 18),
            radio.heightAnchor.constraint(equalToConstant: 18),
            dot.centerXAnchor.constraint(equalTo: radio.centerXAnchor),
            dot.centerYAnchor.constraint(equalTo: radio.centerYAnchor),
            dot.widthAnchor.constraint(equalToConstant: 9),
            dot.heightAnchor.constraint(equalToConstant: 9),
            label.leadingAnchor.constraint(equalTo: radio.trailingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: row.trailingAnchor)
        ])
    }

    private func updateRadioUI() {
        let isProduct = selectedType == .product
        productDot.isHidden = !isProduct
        cashDot.isHidden = isProduct
        // Figma: both rings stay green; only inner dot shows selection
        productRadio.layer.borderColor = themeGreen.cgColor
        cashRadio.layer.borderColor = themeGreen.cgColor
    }

    @objc private func selectProduct() {
        selectedType = .product
        updateRadioUI()
    }

    @objc private func selectCash() {
        selectedType = .cash
        updateRadioUI()
    }

    @objc private func confirmAct() {
        let type = selectedType
        dismiss(animated: true) { [weak self] in
            self?.onConfirm?(type)
        }
    }

    @objc private func closeAct() {
        dismiss(animated: true, completion: nil)
    }
}
