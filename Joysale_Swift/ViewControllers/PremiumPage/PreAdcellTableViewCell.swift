import UIKit

class PreAdcellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var CornerView: UIView!
    @IBOutlet weak var Plandays: UILabel!
    @IBOutlet weak var Planname: UILabel!
    @IBOutlet weak var price: UILabel!
    
    private let shadowContainer = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadowView()
    }

    private func setupShadowView() {
        CornerView.layer.cornerRadius = 10
        CornerView.layer.masksToBounds = true
        CornerView.backgroundColor = UIColor(named: "BlackColorad")
        CornerView.layer.borderColor = UIColor.lightGray.cgColor
        CornerView.layer.borderWidth = 1
                price.config(color: UIColor(named: "AppThemeColor"),
                                      font: UIFont(name: APP_FONT_REGULAR, size: 16),
                                      align: .right,
                                      text: "")
                Planname.config(color: UIColor(named: "LightTextColor"),
                                      font: UIFont(name: APP_FONT_BOLD, size: 15),
                                      align: .left,
                                      text: "")
                Plandays.config(color: UIColor(named: "LightTextColor"),
                                      font: UIFont(name: APP_FONT_BOLD, size: 15),
                                      align: .left,
                                      text: "")
    }

}

