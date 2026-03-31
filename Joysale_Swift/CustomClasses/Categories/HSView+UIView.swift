//
//  HSView+UIView.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 14/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    //MARK: shadow effect
    func elevationEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 1
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.shadowColor = UIColor(named: "TransparentBlack")?.cgColor
        self.clipsToBounds = true
        self.specificCornerRadius(radius: Int(self.frame.height / 2))
    }
    func darkElevationEffect() {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true

        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        self.layer.shadowRadius = 3;
//        self.layer.shouldRasterize = true
        self.layer.shadowOpacity = 1;
        self.layer.shadowColor = UIColor(named: "appblackcolor")?.cgColor
//        self.specificCornerRadius(radius: Int(self.frame.height / 2))

    }
    func previewelevationEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.5;
        //        self.layer.borderWidth = 1
        //        self.layer.borderColor = TEXT_PRIMARY_COLOR
    }
    func elevationEffectOnBottom() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0.5)
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.2;
        //        self.layer.borderWidth = 1
        //        self.layer.borderColor = TEXT_PRIMARY_COLOR
    }
    //MARK: round corner radius
    func cornerViewRadius() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    func blurEffect() {
        let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.bounds
        self.addSubview(blurView)
    }
    //MARK: minimum corner radius
    func cornerViewMiniumRadius() {
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
    //MARK: minimum corner radius
    func invitecornerViewMiniumRadius(_ radius: Int) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
    //MARK: remove corner radius
    func removeCornerRadius() {
        self.layer.cornerRadius = 0.0
        self.layer.masksToBounds = false
        self.clipsToBounds =  false
    }
    func viewRadius(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    //MARK: apply gradient effect
    func applyGradient()  {
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = [UIColor(named: "buttonTopColor") ?? .white,UIColor(named: "BottomColor") ?? .white ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.2)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.addSublayer(gradientLayer)
        gradientLayer.frame = self.bounds
    }
    
    func removeGrandient()  {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    //MARK:Specific corner radius
    func specificCornerRadius(radius:Int)  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight , .topLeft, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
//        self.layer.backgroundColor = UIColor.green.cgColor
        //Here I'm masking the textView's layer with rectShape layer
        self.layer.mask = rectShape
    }
    
    //MARK: Set border
    func setViewBorder(color:UIColor) {
        self.cornerViewRadius()
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
    }
    func setViewMinBorder(color:UIColor) {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = color.cgColor
    }
    
    func updateborder(color: UIColor, borderWidth: Int, radius: Int) {
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
    
}


extension UIViewController {
    func makeErrorAlert(title: String, message: String, isValid: Bool) {
        let alert = UIAlertController(title: getLanguage[title] ?? "", message: getLanguage[message] ?? "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "", style: .default, handler: { (alertAction) in
            let imageDataDict:[String: Bool] = ["isValid": isValid]

            NotificationCenter.default.post(name: Notification.Name("alertAction"), object: nil, userInfo: imageDataDict)
        }))
        self.present(alert, animated: true)
    }
    func setStatusBarBackgroundColor(color: UIColor) {
        let sharedApplication = UIApplication.shared
//        sharedApplication.delegate?.window??.tintColor = color
        if #available(iOS 13.0, *) {
//            let app = UIApplication.shared
//            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            let statusBar = UIView(frame: (sharedApplication.delegate?.window??.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = color
            sharedApplication.delegate?.window??.addSubview(statusBar)
//            let statusbarView = UIView()
//            statusbarView.backgroundColor = color
//            view.addSubview(statusbarView)
//
//            statusbarView.translatesAutoresizingMaskIntoConstraints = false
//            statusbarView.heightAnchor
//                .constraint(equalToConstant: statusBarHeight).isActive = true
//            statusbarView.widthAnchor
//                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
//            statusbarView.topAnchor
//                .constraint(equalTo: view.topAnchor).isActive = true
//            statusbarView.centerXAnchor
//                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        }
        else {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
            statusBar.backgroundColor = color
        }
    }

}
