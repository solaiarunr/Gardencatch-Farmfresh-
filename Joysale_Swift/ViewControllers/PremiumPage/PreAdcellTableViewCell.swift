import UIKit

class PreAdcellTableViewCell: UITableViewCell {

    @IBOutlet weak var CornerView: UIView!
    @IBOutlet weak var Plandays: UILabel!
    @IBOutlet weak var Planname: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discountlable: UILabel!

    private let contentStackView = UIStackView()
    private let benefitsStackView = UIStackView()
    private var didSetupLayout = false

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupPlanCardLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        benefitsStackView.arrangedSubviews.forEach {
            benefitsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    private func setupPlanCardLayout() {
        guard !didSetupLayout else { return }
        didSetupLayout = true

        CornerView.subviews.forEach { $0.removeFromSuperview() }

        CornerView.backgroundColor = .white
        CornerView.layer.cornerRadius = 12
        CornerView.layer.masksToBounds = false
        CornerView.layer.borderWidth = 0
        CornerView.layer.shadowColor = UIColor.black.cgColor
        CornerView.layer.shadowOpacity = 0.12
        CornerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        CornerView.layer.shadowRadius = 4

        Planname.numberOfLines = 0
        Planname.textAlignment = .left
        Planname.config(
            color: UIColor(named: "AppTextColor"),
            font: UIFont(name: APP_FONT_REGULAR, size: 15),
            align: .left,
            text: ""
        )

        price.numberOfLines = 1
        price.textAlignment = .left
        price.config(
            color: UIColor(named: "AppTextColor"),
            font: UIFont(name: APP_FONT_BOLD, size: 22),
            align: .left,
            text: ""
        )

        discountlable.textAlignment = .center
        discountlable.font = UIFont(name: APP_FONT_BOLD, size: 11) ?? .boldSystemFont(ofSize: 11)
        discountlable.textColor = .white
        discountlable.backgroundColor = UIColor(named: "redcolor") ?? .red
        discountlable.layer.cornerRadius = 10
        discountlable.layer.masksToBounds = true
        discountlable.isHidden = true
        discountlable.translatesAutoresizingMaskIntoConstraints = false

        benefitsStackView.axis = .vertical
        benefitsStackView.spacing = 10
        benefitsStackView.alignment = .fill

        contentStackView.axis = .vertical
        contentStackView.spacing = 12
        contentStackView.alignment = .fill
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        CornerView.addSubview(contentStackView)
        CornerView.addSubview(discountlable)

        NSLayoutConstraint.activate([
            discountlable.topAnchor.constraint(equalTo: CornerView.topAnchor, constant: 12),
            discountlable.trailingAnchor.constraint(equalTo: CornerView.trailingAnchor, constant: -12),
            discountlable.heightAnchor.constraint(equalToConstant: 22),
            discountlable.widthAnchor.constraint(equalToConstant: 76),

            contentStackView.topAnchor.constraint(equalTo: CornerView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: CornerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: CornerView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: CornerView.bottomAnchor, constant: -20)
        ])

        contentStackView.addArrangedSubview(Planname)
        contentStackView.addArrangedSubview(price)
        contentStackView.addArrangedSubview(benefitsStackView)
    }

    private func updateContentInsets(isYearly: Bool) {
        contentStackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: isYearly ? 84 : 0
        )
    }

    func configure(
        planTitle: String,
        priceText: String,
        isYearly: Bool,
        benefits: [String],
        isSelected: Bool
    ) {
        Planname.text = planTitle
        price.text = priceText
        discountlable.text = getLanguage["Save20Percent"] ?? "Save 20%"
        discountlable.isHidden = !isYearly
        discountlable.backgroundColor = UIColor(named: "redcolor") ?? .red
        updateContentInsets(isYearly: isYearly)

        benefits.forEach { benefit in
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 8
            row.alignment = .top

            let bullet = UILabel()
            bullet.text = "•"
            bullet.font = UIFont(name: APP_FONT_REGULAR, size: 14) ?? .systemFont(ofSize: 14)
            bullet.textColor = UIColor(named: "AppTextColor")
            bullet.setContentHuggingPriority(.required, for: .horizontal)

            let label = UILabel()
            label.text = benefit
            label.numberOfLines = 0
            label.font = UIFont(name: APP_FONT_REGULAR, size: 14) ?? .systemFont(ofSize: 14)
            label.textColor = UIColor(named: "AppTextColor")

            row.addArrangedSubview(bullet)
            row.addArrangedSubview(label)
            benefitsStackView.addArrangedSubview(row)
        }

        CornerView.layer.borderWidth = isSelected ? 2 : 0
        CornerView.layer.borderColor = (UIColor(named: "activecolor") ?? UIColor(named: "AppThemeColor"))?.cgColor
    }
}
