//
//  CreatePremiumvc.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 22/07/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MXSegmentedPager

class CreatePremiumvc: MXSegmentedPagerController {

    let urgentVC = PremiumListVc()
    let adVC = PremiumListVc()

    var titleArray = ["MonthlyLocalBusiness", "YearlyLocalBusiness"]
    var promotionArr = [PremiumListVc]()
    var itemID = ""
    var isTabBar = false
    let delegate = UIApplication.shared.delegate as! AppDelegate

    private let tabUnderlineColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1)
    private var tabBaselineView: UIView?
    private var yearlyDiscountBadge: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        segmentedPager.pager.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBaseline()
        setupYearlyDiscountBadge()
        updateTabStyles(selectedIndex: segmentedPager.segmentedControl.selectedIndex)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: nil)
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 1 {
            }
            else {
                if isTabBar {
                    delegate.initVC(initialView: TabbarController())
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    func configUI() {
        urgentVC.premiumType = .monthly
        adVC.premiumType = .yearly
        self.promotionArr = [urgentVC, adVC]
        self.navigationController?.customNavigationBarView(
            title: "create_promotionn",
            fColor: "whitecolor",
            fontName: UIFont(name: APP_FONT_BOLD, size: 20),
            vc: self
        )
        self.navigationController?.customRightBarButtonView(
            title: "",
            fColor: "whitecolor",
            fontName: UIFont(name: APP_FONT_REGULAR, size: 18),
            imageName: "detail_back",
            isLeft: true,
            vc: self,
            transparantView: false
        )
        segmentedPager.backgroundColor = UIColor(named: "BackGroundColor")
        segmentedPager.segmentedControl.backgroundColor = UIColor(named: "whitecolor")
        segmentedPager.segmentedControl.textColor = UIColor(named: "AppTextColor") ?? .darkGray
        segmentedPager.segmentedControl.font = UIFont(name: APP_FONT_REGULAR, size: 14) ?? .systemFont(ofSize: 14)
        segmentedPager.segmentedControl.selectedTextColor = UIColor(named: "activecolor") ?? UIColor(named: "AppThemeColor")
        segmentedPager.segmentedControl.indicator.lineView.backgroundColor = UIColor(named: "activecolor") ?? UIColor(named: "AppThemeColor")
        segmentedPager.segmentedControl.indicator.lineHeight = 2
        segmentedPager.segmentedControl.segmentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        segmentedPager.parallaxHeader.height = 0
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            self.segmentedPager.segmentedControl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.segmentedPager.pager.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.urgentVC.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.adVC.view.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }

    private func setupTabBaseline() {
        let segmentedControl = segmentedPager.segmentedControl
        if tabBaselineView == nil {
            let baseline = UIView()
            baseline.backgroundColor = tabUnderlineColor
            segmentedControl.addSubview(baseline)
            tabBaselineView = baseline
        }
        tabBaselineView?.frame = CGRect(
            x: 0,
            y: segmentedControl.bounds.height - 2,
            width: segmentedControl.bounds.width,
            height: 1
        )
    }

    private func setupYearlyDiscountBadge() {
        let segmentedControl = segmentedPager.segmentedControl
        guard segmentedControl.count > 1,
              let yearlySegment = segmentedControl.segment(at: 1) else {
            return
        }

        yearlySegment.layoutIfNeeded()
        segmentedControl.layoutIfNeeded()

        if yearlyDiscountBadge == nil {
            let badge = UILabel()
            badge.text = getLanguage["Save20Percent"] ?? "Save 20%"
            badge.font = UIFont(name: APP_FONT_BOLD, size: 9) ?? .boldSystemFont(ofSize: 9)
            badge.textColor = .white
           // badge.backgroundColor = UIColor(named: "redcolor") ?? .red
            badge.textAlignment = .center
            badge.layer.cornerRadius = 7
            badge.layer.masksToBounds = true
            segmentedControl.addSubview(badge)
            yearlyDiscountBadge = badge
        }

        yearlyDiscountBadge?.backgroundColor = UIColor(named: "redcolor") ?? .red

        let badgeSize = CGSize(width: 54, height: 14)
        let segmentFrame = yearlySegment.convert(yearlySegment.bounds, to: segmentedControl)
        let badgeX = segmentFrame.maxX - badgeSize.width - 10
        let badgeY = segmentFrame.minY + 2
        yearlyDiscountBadge?.frame = CGRect(origin: CGPoint(x: badgeX, y: badgeY), size: badgeSize)
        yearlyDiscountBadge?.isHidden = false
        segmentedControl.bringSubviewToFront(yearlyDiscountBadge!)
    }

    private func updateTabStyles(selectedIndex: Int) {
        for index in 0..<segmentedPager.segmentedControl.count {
            let isSelected = index == selectedIndex
            let fontName = isSelected ? APP_FONT_BOLD : APP_FONT_REGULAR
            segmentedPager.segmentedControl.segment(at: index)?.titleLabel?.font =
                UIFont(name: fontName, size: 14) ?? .systemFont(ofSize: 14, weight: isSelected ? .bold : .regular)
        }
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return getLanguage[titleArray[index]] ?? ""
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
    }
    override func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return titleArray.count
    }

    override func segmentedPager(_ segmentedPager: MXSegmentedPager, viewControllerForPageAt index: Int) -> UIViewController {
        let vc = promotionArr[index]
        vc.view.tag = index
        return vc
    }

    // ✅ Add below this
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewAt index: Int) {
        updateTabStyles(selectedIndex: index)
        switch index {
        case 0:
            urgentVC.selectDefaultPlan()
        case 1:
            adVC.selectDefaultPlan()
        default:
            break
        }
    }
    
}

extension CreatePremiumvc: MXPagerViewDelegate {
    func pagerView(_ pagerView: MXPagerView, didMoveToPage page: UIView, at index: Int) {
        updateTabStyles(selectedIndex: index)
        if index == 0 {
            urgentVC.selectDefaultPlan()
        } else {
            adVC.selectDefaultPlan()
        }
    }
}
