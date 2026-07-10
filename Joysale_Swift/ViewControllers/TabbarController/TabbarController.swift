//
//  TabbarController.swift
//  Howzu_swift
//
//  Created by Hitasoft on 13/04/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
//import GoogleMobileAds

class TabbarController: UITabBarController, UITabBarControllerDelegate {
    
    let homeVC = HomeViewController()
    let categoryVC = CategoryViewController()
    let addProductVC = CameraViewController()
    let chatVC = ChatListViewController()
    let profileVC = ProfileViewController()
    var isFromNotification = false
    var profileNavigationController = UINavigationController()
    var viewModel = AdminViewModel()
    var profileData: ProfileResultModel?
    var viewModels = ProfileViewModel()
//    var interstitial :GADInterstitialAd?

    var getFreePost = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileNavigationController.setNavigationBarHidden(true, animated: false)
        setNavigationDetails()
        self.configUI()
        self.loadData()
        
        // Do any additional setup after loading the view.
    }
    func loadAds() {
        /*
        interstitial = nil
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:INTERESTITIAL_KEY, request: request, completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
         */
    }
    
    func loadProfile(){
        self.viewModels.getProfileData(user_id: UserDefaultModule.shared.getUserData()?.user_id ?? "", onSuccess: { (success) in
            print(success)
            if success {
                if let profileData = self.viewModels.profileModel?.result {
                    self.profileData = profileData
                    if self.profileData?.freepost == "true"{
                        self.tabBar.isUserInteractionEnabled = true
                        self.selectedIndex = 2
                    }
                    else if self.profileData?.freepost == "false"{
                        if self.profileData?.subscriptionEnable == "true"{
                            self.tabBar.isUserInteractionEnabled = true
                            self.selectedIndex = 2
                        }else{
                            self.showAlerts()
                        }
                    }else{
                        self.showAlerts()
                    }
                }
            }
        }) { (failure) in
        }
        
     
    }
    func showAlerts() {

        let popup = PremiumPopupView(frame: UIScreen.main.bounds)

        popup.cancelAction = {
            self.tabBar.isUserInteractionEnabled = true
        }

        popup.upgradeAction = {

            self.tabBar.isUserInteractionEnabled = true

            if !(UserDefaultModule.shared.getUserData()?.user_id ?? "").isEmpty {

                let vc = CreatePremiumvc()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

        UIApplication.shared.windows.first?.addSubview(popup)
    }
//    func showAlerts() {
//        
//        let alertController = UIAlertController(
//            title: "Unlock Premium Visibliity",
//            message: "You've reached your free posting limit. Upgrade to unlock unlimited posting and premium visibility.",
//            preferredStyle: .alert
//        )
//
//        let upgradeAction = UIAlertAction(title: "Upgrade", style: .default) { _ in
//            
//            if (UserDefaultModule.shared.getUserData()?.user_id ?? "") != "" {
//                let pageObj = CreatePremiumvc()
//                self.navigationController?.pushViewController(pageObj, animated: true)
//            }
//            
//            self.tabBar.isUserInteractionEnabled = true
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
//            self.tabBar.isUserInteractionEnabled = true
//        }
//
//        alertController.addAction(upgradeAction)
//        alertController.addAction(cancelAction)
//
//        present(alertController, animated: true)
//    }

    override func viewDidAppear(_ animated: Bool) {
        self.loadAds()
        if self.selectedIndex != 2 {
            self.navigationController?.isNavigationBarHidden = false
        }
        else {
            self.navigationController?.isNavigationBarHidden = true
        }
        if self.isFromNotification {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.titleView = nil
            self.navigationController?.customNavigationBarView(title: "chat", fColor: "whitecolor",fontName: UIFont(name: APP_FONT_REGULAR, size: 20),vc: self)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        self.delegate = self
        
        categoryVC.CategoryDetails = CategoryDetailsModel(Category_id: FILTER_DATA.Category_id, subcategory_id: FILTER_DATA.subcategory_id, child_category_id: FILTER_DATA.child_category_id)
        categoryVC.delegate = self
        
        homeVC.refreshFilter = { refresh in
            self.setNavigationDetails()
        }
        homeVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_home"), selectedImage: #imageLiteral(resourceName: "tab_home_sel"))
        homeVC.tabBarItem.tag = 0
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        categoryVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_category"), selectedImage: #imageLiteral(resourceName: "tab_category_sel"))
        categoryVC.tabBarItem.tag = 1
        categoryVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        addProductVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_camera"), selectedImage: #imageLiteral(resourceName: "tab_camera_sel"))
        addProductVC.tabBarItem.tag = 2
        addProductVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        chatVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_messages"), selectedImage: #imageLiteral(resourceName: "tab_messages_sel"))
        chatVC.tabBarItem.tag = 3
        chatVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        profileVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_profile"), selectedImage: #imageLiteral(resourceName: "tab_profile_sel"))
        profileVC.tabBarItem.tag = 4
        profileVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        //        profileNavigationController = UINavigationController(rootViewController: profileVC)
        self.profileNavigationController.isNavigationBarHidden = true
        let tabBarList = [homeVC, categoryVC, addProductVC, chatVC, profileVC]
        
        //        if #av ailable(iOS 13.0, *) {
        //            UITabBarItemAppearance().normal.iconColor = UIColor(named: "BlackTextColor") ?? .white
        //            UITabBarItemAppearance().selected.iconColor = UIColor(named: "AppThemeColor") ?? .white
        //
        //        } else {
        //            self.tabBar.unselectedItemTintColor = UIColor(named: "BlackTextColor") ?? .white
        //            self.tabBar.tintColor = UIColor(named: "AppThemeColor") ?? .white
        //        }
        self.tabBar.unselectedItemTintColor = UIColor(named: "BlackTextColor") ?? .white
        self.tabBar.tintColor = UIColor(named: "AppThemeColor") ?? .white
        //        self.tabBar.isTranslucent = false
        viewControllers = tabBarList
        self.extendedLayoutIncludesOpaqueBars = true
        self.setStatusBarBackgroundColor(color: UIColor(named: "AppThemeColor") ?? .black)
        //        self.edgesForExtendedLayout = .bottom
    }
    
    @objc func filterButtonAct(_ sender: UIButton) {
        if sender.tag == 0 {
            let pageObj = SearchViewController()
            pageObj.categoryData = FILTER_DATA
            pageObj.searchDelegate = self
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else {
            let pageObj = FilterViewController()
            pageObj.filterDelegate = self
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }

    @objc func notificationButtonAct() {
        if (UserDefaultModule.shared.getUserData()?.user_id ?? "") == "" {
            let vc = InitialViewController()
            vc.isFromList = true
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true, completion: nil)
            return
        }
        let pageObj = NotificationViewController()
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if !(viewController.isKind(of: HomeViewController.self) || viewController.isKind(of: CategoryViewController.self)){
            if (UserDefaultModule.shared.getUserData()?.user_id ?? "" == "") {
                let vc = InitialViewController()
                vc.isFromList = true
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
                return false
            }
            // Camera tab tapped
                 if viewController.isKind(of: CameraViewController.self) {
                     self.loadProfile()
                     return false
                 }
            
            else if !(viewController.isKind(of: ChatListViewController.self) || viewController.isKind(of: ProfileViewController.self)){
                self.tabBar.isUserInteractionEnabled = false
                self.loadSubScriptionData()
                return false
            }
            else {
                return true
            }
        }
        return true
    }
    func loadSubScriptionData(){
        self.tabBar.isUserInteractionEnabled = true
        self.selectedIndex = 2
        //self.presentInterstitialAds()

        /*
        let group = DispatchGroup()
        group.enter()
        var value = false
        self.viewModel.getProfileDetailCount(user_id:  UserDefaultModule.shared.getUserData()?.user_id ?? "", onSuccess:{ (val) in
            print(val)
            if self.viewModel.postProductModel?.status ?? false{
                let res = self.viewModel.postProductModel?.result.first
                self.getFreePost = res!.subscriptionEnable
                if self.getFreePost != 0{
                    value = false
                }else{
                    value = true
                }
            }
            group.leave()
        })
        { (failure) in
            value = true
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            if value {
                self.tabBar.isUserInteractionEnabled = true
                self.selectedIndex = 2
//                self.presentInterstitialAds()
            }
            else {
                let pageObj = SubscribePlanPage()
                self.tabBar.isUserInteractionEnabled = true
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
        }
         */
    }
    func loadData() {
        ADMIN_VIEW_MODEL.getCountData(onSuccess: { (success) in
            if success {
                if (ADMIN_VIEW_MODEL.getCountModel?.notificationCount ?? 0) > 0 {
                    self.profileVC.tabBarItem.badgeValue = "\(ADMIN_VIEW_MODEL.getCountModel?.notificationCount ?? 0)"
                }
                else {
                    self.profileVC.tabBarItem.badgeValue = nil
                }
                if (ADMIN_VIEW_MODEL.getCountModel?.chatCount ?? 0) > 0 {
                    self.chatVC.tabBarItem.badgeValue = "\(ADMIN_VIEW_MODEL.getCountModel?.chatCount ?? 0)"
                }
                else {
                    self.chatVC.tabBarItem.badgeValue = nil
                }
            }
        }) { (failure) in
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 0 || item.tag == 1) || (UserDefaultModule.shared.getUserData()?.user_id ?? "") != "" {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.titleView = nil
            if item.tag == 0 || item.tag == 2 {
                self.setNavigationDetails()
            }
             else if item.tag == 1 {
//                self.navigationController?.customNavigationBarView(title: "category", fColor: "whitecolor",fontName: UIFont(name: APP_FONT_REGULAR, size: 20),vc: self)
                 self.navigationController?.customNavigationBarView(title: "category", fColor: "whitecolor",fontName: UIFont(name: APP_FONT_REGULAR, size: 20),vc: self)
                 self.navigationController?.customRightBarButtonView(title: "", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 14), imageName: "", isLeft: true, vc: self, transparantView: false)
            }
             
            else if item.tag == 3 {
                 self.navigationController?.customNavigationBarView(title: "chat", fColor: "whitecolor",fontName: UIFont(name: APP_FONT_REGULAR, size: 20),vc: self)
                self.navigationController?.customRightBarButtonView(title: "", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 14), imageName: "", isLeft: true, vc: self, transparantView: false)
            }
            else {
                
                self.navigationController?.customNavigationBarView(title: "myprofile", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 20), vc: self)
                self.navigationController?.customRightBarButtonView(title: "", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 14), imageName: "", isLeft: true, vc: self, transparantView: false)
            }
        }
        self.loadData()
    }
   
    func setNavigationDetails() {
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.backgroundColor = UIColor(named: "AppThemeColor")
        self.navigationController?.isNavigationBarHidden = false
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        imageView.image = #imageLiteral(resourceName: "app_headerlogo")
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        self.navigationItem.titleView?.tintColor = UIColor(named: "whitecolor")
        let searchImage = self.scaledNavigationImage(named: "new_search", size: 22)?
            .withHorizontallyFlippedOrientation()
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(searchImage, for: UIControl.State.normal)
        button.tag = 0
        button.addTarget(self, action: #selector(self.filterButtonAct(_:)), for: .touchUpInside)
        button.tintColor = UIColor(named: "whitecolor")
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 32),
            button.heightAnchor.constraint(equalToConstant: 32)
        ])

        let button1: MFBadgeButton = MFBadgeButton(type: UIButton.ButtonType.custom)
        button1.setImage(self.scaledNavigationImage(named: "search_adv", size: 22), for: UIControl.State.normal)
        if FILTER_DATA.toDictionary().keys.count > 0 {
             button1.badgeValue = "●"
        }
        else {
            button1.badgeValue = nil
        }
        button1.tag = 1
        button1.addTarget(self, action: #selector(self.filterButtonAct(_:)), for: .touchUpInside)
        button1.tintColor = UIColor(named: "whitecolor")
        button1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button1.widthAnchor.constraint(equalToConstant: 32),
            button1.heightAnchor.constraint(equalToConstant: 32)
        ])

        let notificationContainer = self.makeNotificationBarButton()
        let rightButtonStack = UIStackView(arrangedSubviews: [notificationContainer, button])
        rightButtonStack.axis = .horizontal
        rightButtonStack.spacing = 14
        rightButtonStack.alignment = .center
        rightButtonStack.distribution = .fill
        rightButtonStack.translatesAutoresizingMaskIntoConstraints = false

        let rightButtonContainer = UIView()
        rightButtonContainer.clipsToBounds = false
        rightButtonContainer.addSubview(rightButtonStack)
        NSLayoutConstraint.activate([
            rightButtonStack.topAnchor.constraint(equalTo: rightButtonContainer.topAnchor),
            rightButtonStack.bottomAnchor.constraint(equalTo: rightButtonContainer.bottomAnchor),
            rightButtonStack.leadingAnchor.constraint(equalTo: rightButtonContainer.leadingAnchor),
            rightButtonStack.trailingAnchor.constraint(equalTo: rightButtonContainer.trailingAnchor)
        ])

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButtonContainer)
        navigationBarAppearace.barTintColor = UIColor(named: "AppThemeColor")
        let barButton = UIBarButtonItem(customView: button1)
        self.navigationItem.leftBarButtonItem = barButton
        
        navigationBarAppearace.isTranslucent = false
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor(named: "AppThemeColor") ?? .white
        
        navigationBar?.isTranslucent = false
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
         
        // Change Tabbar Background Color
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            appearance.backgroundColor = UIColor(named: "whitecolor")
            tabBar.standardAppearance = appearance;
        } else {
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
            // Fallback on earlier versions
        }
        tabBar.layer.backgroundColor = (UIColor(named: "whitecolor") ?? .white).cgColor
    }

    private func makeNotificationBarButton() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = false

        let button = UIButton(type: .custom)
        button.setImage(self.scaledNavigationImage(named: "notifybell", size: 22), for: .normal)
        button.tintColor = UIColor(named: "whitecolor")
        button.addTarget(self, action: #selector(self.notificationButtonAct), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(button)

        let badgeButton = UIButton(type: .custom)
        badgeButton.isUserInteractionEnabled = false
        badgeButton.titleLabel?.font = UIFont(name: APP_FONT_BOLD, size: 10) ?? .boldSystemFont(ofSize: 10)
        badgeButton.setTitleColor(.white, for: .normal)
        badgeButton.backgroundColor = UIColor(named: "redcolor") ?? .systemRed
        badgeButton.contentEdgeInsets = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
        badgeButton.layer.cornerRadius = 8
        badgeButton.clipsToBounds = true
        badgeButton.translatesAutoresizingMaskIntoConstraints = false

        let count = ADMIN_VIEW_MODEL.getCountModel?.notificationCount ?? 0
        if count > 0 {
            badgeButton.setTitle(count > 99 ? "99+" : "\(count)", for: .normal)
            badgeButton.isHidden = false
        } else {
            badgeButton.isHidden = true
        }

        container.addSubview(badgeButton)

        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 36),
            container.heightAnchor.constraint(equalToConstant: 36),
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 28),
            button.heightAnchor.constraint(equalToConstant: 28),
            badgeButton.topAnchor.constraint(equalTo: container.topAnchor),
            badgeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            badgeButton.heightAnchor.constraint(equalToConstant: 16)
        ])

        return container
    }

    private func scaledNavigationImage(named: String, size: CGFloat) -> UIImage? {
        guard let image = UIImage(named: named) else { return nil }
        let targetSize = CGSize(width: size, height: size)
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        return UIGraphicsImageRenderer(size: targetSize, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }.withRenderingMode(.alwaysOriginal)
    }
    
}
extension TabbarController: SearchDelegate, CategoryDelegate, FilterDelegate {
    func filterAct(_ filterData: FilterDataModel) {
        self.setNavigationDetails()
        FILTER_DATA = filterData
        self.homeVC.itemModel.removeAll()
        self.homeVC.collectionView.reloadData()
        self.homeVC.offset = 0
        self.homeVC.isFound = true
        self.homeVC.loadFilterData()
        self.homeVC.loadData()
    }
    func updateSearchData(_ searchData: FilterDataModel) {
        self.setNavigationDetails()
        FILTER_DATA = searchData
        if FILTER_DATA.location.lowercased() != CURRENT_LOCATION.lowercased() && FILTER_DATA.location.lowercased() != "WorldWide".lowercased(){
            FILTER_DATA.isDistanceSlider = true
        }
        UserDefaultModule.shared.setFilterData(FILTER_DATA)
        self.homeVC.itemModel.removeAll()
        self.homeVC.collectionView.reloadData()
        self.homeVC.offset = 0
        self.homeVC.isFound = true
        self.homeVC.loadFilterData()
        self.homeVC.loadData()
    }
    func updateCategoryData(_ searchData: CategoryDetailsModel) {
        self.setNavigationDetails()
        FILTER_DATA.Category_id = searchData.Category_id
        FILTER_DATA.subcategory_id = searchData.subcategory_id
        FILTER_DATA.child_category_id = searchData.child_category_id
        FILTER_DATA.filters = ""
        UserDefaultModule.shared.setFilterData(FILTER_DATA)
        self.homeVC.itemModel.removeAll()
        self.homeVC.collectionView.reloadData()
        self.homeVC.offset = 0
        self.homeVC.isFound = true
        self.homeVC.loadFilterData()
        self.homeVC.loadData()
    }
}


class PremiumPopupView: UIView {

    var upgradeAction: (() -> Void)?
    var cancelAction: (() -> Void)?

    private let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])

        let titleLabel = UILabel()
        titleLabel.text = "Unlock Premium Visibility"
        titleLabel.font = UIFont(name: APP_FONT_BOLD, size: 18)
        titleLabel.textColor = UIColor(named: "appblackcolor")
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        let messageLabel = UILabel()
        messageLabel.text = "You've reached your free posting limit.\nUpgrade to unlock unlimited posting and premium visibility."
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont(name: APP_FONT_REGULAR, size: 15)
        messageLabel.textColor = UIColor(named: "appblackcolor")
        messageLabel.textAlignment = .center

        let benefits = [
            "Unlimited product listings",
            "Biz Spotlight & Local Spotlight boosts",
            "Local Business badge for trust",
            "Priority placement in search results"
        ]

        let benefitStack = UIStackView()
        benefitStack.axis = .vertical
        benefitStack.spacing = 8
        benefitStack.alignment = .leading

        for item in benefits {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 8
            row.alignment = .top

            let bullet = UILabel()
            bullet.text = "•"
            bullet.font = UIFont(name: APP_FONT_BOLD, size: 16)
            bullet.textColor = UIColor(named: "appblackcolor")

            let label = UILabel()
            label.text = item
            label.numberOfLines = 0
            label.font = UIFont(name: APP_FONT_REGULAR, size: 15)
            label.textColor = UIColor(named: "appblackcolor")

            row.addArrangedSubview(bullet)
            row.addArrangedSubview(label)
            benefitStack.addArrangedSubview(row)
        }

        let tagStack = UIStackView(arrangedSubviews: [
            makeTagSample(imageName: "business_withicon"),
            makeTagSample(imageName: "ad_new_withicon"),
            makeTagSample(imageName: "businesslocal")
        ])
        tagStack.axis = .horizontal
        tagStack.spacing = 12
        tagStack.distribution = .fillEqually
        tagStack.alignment = .center

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Not Now", for: .normal)
        cancelButton.backgroundColor = UIColor(named: "notnowcolor")
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: APP_FONT_BOLD, size: 16)
        cancelButton.layer.cornerRadius = 8
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        let upgradeButton = UIButton(type: .system)
        upgradeButton.setTitle("Activate Premium", for: .normal)
        upgradeButton.backgroundColor = UIColor(named: "activecolor") ?? .systemGreen
        upgradeButton.setTitleColor(.white, for: .normal)
        upgradeButton.titleLabel?.font = UIFont(name: APP_FONT_BOLD, size: 16)
        upgradeButton.layer.cornerRadius = 8
        upgradeButton.translatesAutoresizingMaskIntoConstraints = false
        upgradeButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        upgradeButton.addTarget(self, action: #selector(upgradeTapped), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, upgradeButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        let mainStack = UIStackView(arrangedSubviews: [
            titleLabel,
            messageLabel,
            benefitStack,
            tagStack,
            buttonStack
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }

    private func makeTagSample(imageName: String) -> UIView {
        let wrapper = UIView()
        wrapper.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        wrapper.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: wrapper.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 28),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: wrapper.widthAnchor)
        ])

        return wrapper
    }

    @objc func cancelTapped() {
        removeFromSuperview()
        cancelAction?()
    }

    @objc func upgradeTapped() {
        removeFromSuperview()
        upgradeAction?()
    }
}
/*
extension TabbarController: GADFullScreenContentDelegate {
    func loadIntesterialAd() {
        if interstitial != nil {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
                self.presentInterstitialAds()
            }
        }
        else {
            let request = GADRequest()
            GADInterstitialAd.load(withAdUnitID:INTERESTITIAL_KEY, request: request, completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
            })
        
            interstitial?.fullScreenContentDelegate = self
            DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
                self.presentInterstitialAds()
            }
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.\(error.localizedDescription)")
//        presentInterstitialAds()
    }

    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did dismiss full screen content.")
    }
    func presentInterstitialAds() {
        if interstitial != nil {
            print("Ad was ready")
            interstitial?.present(fromRootViewController: self)
          } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.presentInterstitialAds()
            }
            print("Ad wasn't ready")
          }
    }
}
*/

