//
//  MyExchangeTableViewCell.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 03/07/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

protocol MyExchangeTableViewCellDelegate: AnyObject {
    func didTapViewDetail(at index: Int)
}

class MyExchangeTableViewCell: UITableViewCell {

    weak var delegate: MyExchangeTableViewCellDelegate?
    var index: Int = 0

    let userImageView = UIImageView()
    let userNameLabel = UILabel()
    let dateLabel = UILabel()
    let myProductImageView = UIImageView()
    let myProductNameLabel = UILabel()
    let myProductQtyLabel = UILabel()
    let exchangerImageView = UIImageView()
    let exchangeProductNameLabel = UILabel()
    let exchangeProductQtyLabel = UILabel()
    let exchangeStatusButton = UIButton(type: .custom)
    private let viewDetailLabel = UILabel()
    private let viewDetailContainer = UIView()
    private let viewDetailDotLayer = CAShapeLayer()

    private let cashTitleLabel = UILabel()
    private let cashTitleSeparator = UIView()
    private let cashRowsStack = UIStackView()
    private let rightProductStack = UIStackView()
    private let cashDetailStack = UIStackView()
    private let exchangeArrowImageView = UIImageView()
    private let middleStack = UIStackView()
    private let leftColumn = UIView()
    private let rightColumn = UIStackView()
    private let arrowContainer = UIView()

    private let productImageSize: CGFloat = 90
    private let cashKeyColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
    private let cashValueColor = UIColor.black

    private var equalColumnWidthConstraint: NSLayoutConstraint?
    private var leftColumnFixedWidthConstraint: NSLayoutConstraint?
    private var arrowHeightConstraint: NSLayoutConstraint?

    private let cashPriceLabel = UILabel()
    private let cashStatusLabel = UILabel()
    private let cashBuyerLabel = UILabel()
    private let cashSellerLabel = UILabel()
    private let cashInitiatedLabel = UILabel()
    private let cashCompletedLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        configUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        configUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        myProductImageView.layer.cornerRadius = myProductImageView.bounds.height / 2
        exchangerImageView.layer.cornerRadius = exchangerImageView.bounds.height / 2
        updateViewDetailDots()
    }

    private func setupViews() {
        selectionStyle = .none
        backgroundColor = UIColor(named: "whitecolor") ?? .white
        contentView.backgroundColor = UIColor(named: "whitecolor") ?? .white

        let rootStack = UIStackView()
        rootStack.axis = .vertical
        rootStack.alignment = .center
        rootStack.spacing = 14
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rootStack)

        // MARK: Header — avatar + name + date
        let headerContainer = UIView()
        let userRow = UIStackView()
        userRow.axis = .horizontal
        userRow.alignment = .center
        userRow.spacing = 10
        userRow.translatesAutoresizingMaskIntoConstraints = false

        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: 48),
            userImageView.heightAnchor.constraint(equalToConstant: 48)
        ])

        let nameDateStack = UIStackView(arrangedSubviews: [userNameLabel, dateLabel])
        nameDateStack.axis = .vertical
        nameDateStack.spacing = 2
        userRow.addArrangedSubview(userImageView)
        userRow.addArrangedSubview(nameDateStack)

        headerContainer.addSubview(userRow)
        NSLayoutConstraint.activate([
            userRow.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            userRow.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            userRow.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
            userRow.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor)
        ])

        // MARK: Middle — product | icon | product/cash  (Figma: top align, icon mid of product image)
        middleStack.axis = .horizontal
        middleStack.alignment = .top
        middleStack.distribution = .fill
        middleStack.spacing = 14

        let leftProductStack = makeProductStack(
            imageView: myProductImageView,
            nameLabel: myProductNameLabel,
            qtyLabel: myProductQtyLabel
        )
        leftProductStack.translatesAutoresizingMaskIntoConstraints = false
        leftColumn.addSubview(leftProductStack)
        NSLayoutConstraint.activate([
            leftProductStack.topAnchor.constraint(equalTo: leftColumn.topAnchor),
            leftProductStack.centerXAnchor.constraint(equalTo: leftColumn.centerXAnchor),
            leftProductStack.leadingAnchor.constraint(greaterThanOrEqualTo: leftColumn.leadingAnchor),
            leftProductStack.trailingAnchor.constraint(lessThanOrEqualTo: leftColumn.trailingAnchor),
            leftProductStack.bottomAnchor.constraint(equalTo: leftColumn.bottomAnchor),
            leftColumn.widthAnchor.constraint(greaterThanOrEqualToConstant: productImageSize)
        ])

        exchangeArrowImageView.image = Self.preparedExchangeIcon()
        exchangeArrowImageView.contentMode = .scaleAspectFit
        exchangeArrowImageView.tintColor = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1)
        exchangeArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowContainer.addSubview(exchangeArrowImageView)
        arrowHeightConstraint = arrowContainer.heightAnchor.constraint(equalToConstant: productImageSize)
        arrowHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            arrowContainer.widthAnchor.constraint(equalToConstant: 30),
            exchangeArrowImageView.widthAnchor.constraint(equalToConstant: 26),
            exchangeArrowImageView.heightAnchor.constraint(equalToConstant: 26),
            exchangeArrowImageView.centerXAnchor.constraint(equalTo: arrowContainer.centerXAnchor),
            exchangeArrowImageView.centerYAnchor.constraint(equalTo: arrowContainer.centerYAnchor)
        ])

        rightProductStack.axis = .vertical
        rightProductStack.alignment = .center
        rightProductStack.spacing = 4
        exchangerImageView.translatesAutoresizingMaskIntoConstraints = false
        exchangerImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            exchangerImageView.widthAnchor.constraint(equalToConstant: productImageSize),
            exchangerImageView.heightAnchor.constraint(equalToConstant: productImageSize)
        ])
        exchangeProductNameLabel.numberOfLines = 2
        exchangeProductNameLabel.textAlignment = .center
        exchangeProductQtyLabel.textAlignment = .center
        rightProductStack.addArrangedSubview(exchangerImageView)
        rightProductStack.addArrangedSubview(exchangeProductNameLabel)
        rightProductStack.addArrangedSubview(exchangeProductQtyLabel)

        // MARK: Cash block (Figma)
        cashDetailStack.axis = .vertical
        cashDetailStack.alignment = .leading
        cashDetailStack.spacing = 0
        cashDetailStack.isHidden = true

        cashTitleSeparator.backgroundColor = UIColor(white: 0.82, alpha: 1)
        cashTitleSeparator.translatesAutoresizingMaskIntoConstraints = false
        cashTitleSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

        cashRowsStack.axis = .vertical
        cashRowsStack.alignment = .leading
        cashRowsStack.spacing = 3
        [cashPriceLabel, cashStatusLabel, cashBuyerLabel,
         cashSellerLabel, cashInitiatedLabel, cashCompletedLabel].forEach {
            cashRowsStack.addArrangedSubview($0)
        }

        viewDetailLabel.isUserInteractionEnabled = true
        viewDetailLabel.textAlignment = .center
        viewDetailLabel.setContentHuggingPriority(.required, for: .horizontal)
        viewDetailLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        viewDetailLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDetailAct)))

        viewDetailContainer.translatesAutoresizingMaskIntoConstraints = false
        viewDetailContainer.addSubview(viewDetailLabel)
        viewDetailDotLayer.fillColor = nil
        viewDetailDotLayer.lineCap = .round
        viewDetailDotLayer.lineWidth = 1.5
        viewDetailContainer.layer.addSublayer(viewDetailDotLayer)
        viewDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewDetailLabel.topAnchor.constraint(equalTo: viewDetailContainer.topAnchor),
            viewDetailLabel.leadingAnchor.constraint(equalTo: viewDetailContainer.leadingAnchor),
            viewDetailLabel.trailingAnchor.constraint(equalTo: viewDetailContainer.trailingAnchor),
            viewDetailLabel.bottomAnchor.constraint(equalTo: viewDetailContainer.bottomAnchor, constant: -4)
        ])

        cashDetailStack.addArrangedSubview(cashTitleLabel)
        cashDetailStack.addArrangedSubview(cashTitleSeparator)
        cashDetailStack.addArrangedSubview(cashRowsStack)
        cashDetailStack.addArrangedSubview(viewDetailContainer)
        cashDetailStack.setCustomSpacing(5, after: cashTitleLabel)
        cashDetailStack.setCustomSpacing(8, after: cashTitleSeparator)
        cashDetailStack.setCustomSpacing(8, after: cashRowsStack)
        cashTitleSeparator.widthAnchor.constraint(equalTo: cashDetailStack.widthAnchor).isActive = true
        // Figma: View Detail centered under Cash Exchange block
        viewDetailContainer.widthAnchor.constraint(equalTo: cashDetailStack.widthAnchor).isActive = true

        // Keep cash block full width of right column; children stay leading (View Detail left)
        rightColumn.axis = .vertical
        rightColumn.alignment = .fill
        rightColumn.spacing = 0
        rightColumn.addArrangedSubview(rightProductStack)
        rightColumn.addArrangedSubview(cashDetailStack)

        middleStack.addArrangedSubview(leftColumn)
        middleStack.addArrangedSubview(arrowContainer)
        middleStack.addArrangedSubview(rightColumn)

        equalColumnWidthConstraint = leftColumn.widthAnchor.constraint(equalTo: rightColumn.widthAnchor)
        equalColumnWidthConstraint?.priority = .required
        equalColumnWidthConstraint?.isActive = true

        leftColumnFixedWidthConstraint = leftColumn.widthAnchor.constraint(equalToConstant: 118)
        leftColumnFixedWidthConstraint?.isActive = false

        // Keep icon centered: left/right share remaining width equally
        leftColumn.setContentHuggingPriority(.defaultLow, for: .horizontal)
        leftColumn.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        arrowContainer.setContentHuggingPriority(.required, for: .horizontal)
        rightColumn.setContentHuggingPriority(.defaultLow, for: .horizontal)
        rightColumn.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        exchangeStatusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Figma Success / Pending button size
            exchangeStatusButton.heightAnchor.constraint(equalToConstant: 36),
            exchangeStatusButton.widthAnchor.constraint(equalToConstant: 168)
        ])
        exchangeStatusButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)

        rootStack.addArrangedSubview(headerContainer)
        rootStack.addArrangedSubview(middleStack)
        rootStack.addArrangedSubview(exchangeStatusButton)

        NSLayoutConstraint.activate([
            rootStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            headerContainer.leadingAnchor.constraint(equalTo: rootStack.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: rootStack.trailingAnchor),
            middleStack.leadingAnchor.constraint(equalTo: rootStack.leadingAnchor, constant: 16),
            middleStack.trailingAnchor.constraint(equalTo: rootStack.trailingAnchor, constant: -16)
        ])
    }

    private func makeProductStack(imageView: UIImageView, nameLabel: UILabel, qtyLabel: UILabel) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, qtyLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: productImageSize),
            imageView.heightAnchor.constraint(equalToConstant: productImageSize)
        ])
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center
        qtyLabel.textAlignment = .center
        return stack
    }

    func configUI() {
        userImageView.contentMode = .scaleAspectFill
        myProductImageView.contentMode = .scaleAspectFill
        exchangerImageView.contentMode = .scaleAspectFill

        userNameLabel.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_BOLD, size: 16), align: .left, text: "")
        dateLabel.config(color: UIColor(named: "SecondaryTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .left, text: "")
        myProductNameLabel.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_BOLD, size: 13), align: .center, text: "")
        myProductQtyLabel.config(color: UIColor(named: "SecondaryTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .center, text: "")
        exchangeProductNameLabel.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_BOLD, size: 13), align: .center, text: "")
        exchangeProductQtyLabel.config(color: UIColor(named: "SecondaryTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 12), align: .center, text: "")

        cashTitleLabel.font = UIFont(name: APP_FONT_BOLD, size: 15) ?? .boldSystemFont(ofSize: 15)
        cashTitleLabel.textColor = .black
        cashTitleLabel.textAlignment = .left

        applyViewDetailStyle()

        exchangeStatusButton.cornerMiniumRadius(6)
        exchangeStatusButton.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .center, title: "")
        exchangeStatusButton.backgroundColor = UIColor(named: "AppThemeColor")
        exchangeStatusButton.setTitleColor(UIColor(named: "whitecolor") ?? .white, for: .normal)
        exchangeStatusButton.titleLabel?.adjustsFontSizeToFitWidth = true
        exchangeStatusButton.titleLabel?.minimumScaleFactor = 0.85
    }

    func loadData(_ exchangeData: ExchangeListModel) {
        userNameLabel.text = exchangeData.exchangerName
        userImageView.sd_setImage(
            with: URL(string: exchangeData.exchangerImage ?? ""),
            placeholderImage: #imageLiteral(resourceName: "applogo"),
            completed: nil
        )
        dateLabel.text = exchangeData.exchangeTime

        let qtyPrefix = getLanguage["qty"] ?? "Qty"
        let cashQty = exchangeData.quantity ?? 0
        // Product: qty from my_product.quantity / exchange_product.quantity
        let myProductQty = exchangeData.myProduct?.quantity ?? 0
        let exchangeProductQty = exchangeData.exchangeProduct?.quantity ?? 0

        myProductImageView.sd_setImage(
            with: URL(string: exchangeData.myProduct?.itemImage ?? ""),
            placeholderImage: #imageLiteral(resourceName: "applogo"),
            completed: nil
        )
        myProductNameLabel.text = exchangeData.myProduct?.itemName ?? ""

        let statusKey = (exchangeData.status ?? "").lowercased()
        exchangeStatusButton.setTitle(getLanguage[statusKey] ?? exchangeData.status, for: .normal)

        if exchangeData.isCashExchange {
            rightProductStack.isHidden = true
            cashDetailStack.isHidden = false
            // Figma: same balanced columns as product — icon stays screen-center
            leftColumnFixedWidthConstraint?.isActive = false
            equalColumnWidthConstraint?.isActive = true
            rightColumn.alignment = .fill
            middleStack.alignment = .top
            arrowHeightConstraint?.constant = productImageSize
            arrowHeightConstraint?.isActive = true
            middleStack.spacing = 12

            myProductQtyLabel.text = "\(qtyPrefix) : \(cashQty)"
            myProductQtyLabel.isHidden = cashQty <= 0

            cashTitleLabel.text = getLanguage["cash_exchange"] ?? "Cash Exchange"
            let priceText = (exchangeData.price ?? "").isEmpty
                ? "$\(exchangeData.cashAmount ?? 0)"
                : (exchangeData.price ?? "")

            setCashRow(cashPriceLabel, key: getLanguage["price"] ?? "Price", value: priceText)
            setCashRow(cashStatusLabel, key: getLanguage["Status"] ?? "Status", value: (exchangeData.status ?? "").uppercased())
            setCashRow(cashBuyerLabel, key: getLanguage["buyer"] ?? "Buyer", value: exchangeData.buyer ?? "")
            setCashRow(cashSellerLabel, key: getLanguage["seller"] ?? "Seller", value: exchangeData.seller ?? "")
            setCashRow(cashInitiatedLabel, key: getLanguage["initiated_on"] ?? "Initiatedon", value: formatDate(exchangeData.initiatedOn))

            let completed = exchangeData.completedOn ?? ""
            setCashRow(cashCompletedLabel, key: getLanguage["completed"] ?? "Completed", value: completed.isEmpty ? "-" : formatDate(completed))
            cashCompletedLabel.isHidden = false
            applyViewDetailStyle()
        } else {
            rightProductStack.isHidden = false
            cashDetailStack.isHidden = true
            leftColumnFixedWidthConstraint?.isActive = false
            equalColumnWidthConstraint?.isActive = true
            rightColumn.alignment = .center
            middleStack.alignment = .top
            arrowHeightConstraint?.constant = productImageSize
            arrowHeightConstraint?.isActive = true
            middleStack.spacing = 16

            exchangerImageView.sd_setImage(
                with: URL(string: exchangeData.exchangeProduct?.itemImage ?? ""),
                placeholderImage: #imageLiteral(resourceName: "applogo"),
                completed: nil
            )
            exchangeProductNameLabel.text = exchangeData.exchangeProduct?.itemName ?? ""

            // Figma: Qty under both products
            myProductQtyLabel.text = "\(qtyPrefix) : \(myProductQty)"
            exchangeProductQtyLabel.text = "\(qtyPrefix) : \(exchangeProductQty)"
            myProductQtyLabel.isHidden = myProductQty <= 0
            exchangeProductQtyLabel.isHidden = exchangeProductQty <= 0
        }
    }

    /// Figma style: grey key + bold value in one line  "Price : $200.00"
    private func setCashRow(_ label: UILabel, key: String, value: String) {
        let keyFont = UIFont(name: APP_FONT_REGULAR, size: 12) ?? .systemFont(ofSize: 12)
        let valueFont = UIFont(name: APP_FONT_BOLD, size: 12) ?? .boldSystemFont(ofSize: 12)
        let text = NSMutableAttributedString(
            string: "\(key) : ",
            attributes: [.foregroundColor: cashKeyColor, .font: keyFont]
        )
        text.append(NSAttributedString(
            string: value,
            attributes: [.foregroundColor: cashValueColor, .font: valueFont]
        ))
        label.attributedText = text
        label.numberOfLines = 1
    }

    private func applyViewDetailStyle() {
        let title = getLanguage["view_detail"] ?? "View Detail"
        let color = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
        viewDetailLabel.text = title
        viewDetailLabel.textColor = color
        viewDetailLabel.font = UIFont(name: APP_FONT_REGULAR, size: 12) ?? .systemFont(ofSize: 12)
        viewDetailLabel.textAlignment = .center
        viewDetailLabel.numberOfLines = 1
        viewDetailDotLayer.strokeColor = color.cgColor
        setNeedsLayout()
    }

    private func updateViewDetailDots() {
        guard !viewDetailLabel.isHidden,
              let text = viewDetailLabel.text, !text.isEmpty else {
            viewDetailDotLayer.path = nil
            return
        }
        let textSize = viewDetailLabel.sizeThatFits(
            CGSize(width: CGFloat.greatestFiniteMagnitude, height: viewDetailLabel.bounds.height)
        )
        let textWidth = min(textSize.width, viewDetailLabel.bounds.width)
        guard textWidth > 0, viewDetailLabel.bounds.height > 0 else {
            viewDetailDotLayer.path = nil
            return
        }
        let originX = viewDetailLabel.frame.midX - (textWidth / 2)
        let y = viewDetailLabel.frame.maxY + 1.5
        let path = UIBezierPath()
        path.move(to: CGPoint(x: originX, y: y))
        path.addLine(to: CGPoint(x: originX + textWidth, y: y))
        viewDetailDotLayer.path = path.cgPath
        // Round dots: tiny dash + gap, round line caps
        viewDetailDotLayer.lineDashPattern = [0.01, 3.5]
    }

    private func formatDate(_ value: String?) -> String {
        guard let value = value, !value.isEmpty else { return "-" }
        let inputFormats = ["yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss", "dd-MM-yyyy"]
        let output = DateFormatter()
        output.dateFormat = "yy-MM-dd"
        for format in inputFormats {
            let input = DateFormatter()
            input.dateFormat = format
            if let date = input.date(from: value) {
                return output.string(from: date)
            }
        }
        return value
    }

    /// exchangeImg white-on-black → transparent mask + grey tint (Figma icon)
    private static func preparedExchangeIcon() -> UIImage? {
        guard let source = UIImage(named: "exchangeImg"),
              let cgImage = source.cgImage else {
            return UIImage(named: "exchangeImg")
        }
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerRow = 4 * width
        var pixels = [UInt8](repeating: 0, count: height * bytesPerRow)
        guard let context = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return source }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        for i in stride(from: 0, to: pixels.count, by: 4) {
            let r = Int(pixels[i]), g = Int(pixels[i + 1]), b = Int(pixels[i + 2])
            let brightness = (r + g + b) / 3
            if brightness < 50 {
                pixels[i] = 0; pixels[i + 1] = 0; pixels[i + 2] = 0; pixels[i + 3] = 0
            } else {
                pixels[i] = 255; pixels[i + 1] = 255; pixels[i + 2] = 255; pixels[i + 3] = 255
            }
        }
        guard let output = context.makeImage() else { return source }
        return UIImage(cgImage: output, scale: source.scale, orientation: source.imageOrientation)
            .withRenderingMode(.alwaysTemplate)
    }

    @objc private func viewDetailAct() {
        delegate?.didTapViewDetail(at: index)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        rightProductStack.isHidden = false
        cashDetailStack.isHidden = true
        leftColumnFixedWidthConstraint?.isActive = false
        equalColumnWidthConstraint?.isActive = true
        rightColumn.alignment = .center
        middleStack.alignment = .top
        arrowHeightConstraint?.constant = productImageSize
        arrowHeightConstraint?.isActive = true
        myProductQtyLabel.isHidden = false
        exchangeProductQtyLabel.isHidden = false
        cashCompletedLabel.isHidden = false
        delegate = nil
    }
}
