//
//  ItemDetailsViewController.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 19/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
import FBSDKShareKit
import ImageSlideshow
//import GoogleMobileAds
//import MapboxStatic
//import Mapbox

protocol likeDelegate {
    func likeAct(_ id: Int, isLiked: String)
}
class ItemDetailsViewController: UIViewController {
    func locationAct(city: String, state: String, country: String,countryCode: String, lat: String, long: String, location: String) {
        
    }
    
    @IBOutlet weak var youtubeLabel: UILabel!
    @IBOutlet weak var youtubeView: UIView!
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var topViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var itemDetails: ItemModel?
    var viewModel = ItemDetailsViewModel()
    var itemModel: GetItemsModel?
     var likeDelegate: likeDelegate?
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate? = nil
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var getLikeData = ""
    var getLikeId = Int()
    var soldTitle = ""
    var refreshLike: (() -> Void)?
   //var bannerView1:GADBannerView!
//    var snapshotImage = #imageLiteral(resourceName: "profilelogo")


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        self.configUI()
       // self.loadBannerView()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: nil)
        self.tableView.reloadData()
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
                 self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func configUI() {
        self.youtubeView.isHidden = true
        self.playerView.isHidden = true
        self.playerView.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: "", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 18), imageName: "detail_back", isLeft: true, vc: self, transparantView: false)
        self.rightNavigationBarButtonItem()
        tableView.contentInset = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 40
        self.tableView.sectionFooterHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionFooterHeight = 50
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
//        self.tableView.sectionfoot
        self.buyNowButton.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 16), align: .center, title: "instantbuy")
        self.buyNowButton.backgroundColor = UIColor(named: "AppThemeColor")
        self.buyNowButton.cornerMiniumRadius()
        self.chatButton.config(color: UIColor(named: "AppThemeColor"), font: UIFont(name: APP_FONT_REGULAR, size: 16), align: .center, title: "chat")
        self.pageView.cornerViewRadius()
        self.photoLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .left, text: "")
        self.youtubeLabel.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .left, text: "play_video")
        self.chatButton.setBorder(color: UIColor(named: "AppThemeColor"))
        self.chatButton.backgroundColor = UIColor(named: "whitecolor")
        self.chatButton.cornerMiniumRadius()
        self.collectionView.register(UINib(nibName: "ItemDetailsImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemDetailsImageCollectionViewCell")
        self.tableView.register(UINib(nibName: "itemDetailsImageTableViewCell", bundle: nil), forCellReuseIdentifier: "itemDetailsImageTableViewCell")
        self.tableView.register(UINib(nibName: "ItemDetailsMapTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemDetailsMapTableViewCell")
        self.tableView.register(UINib(nibName: "ItemDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemDetailsTableViewCell")
        self.tableView.register(UINib(nibName: "FilterHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "FilterHeaderTableViewCell")
        self.getYoutubeId()
        DispatchQueue.main.async {
            self.loadData()
        }
        self.setBottonButton()
        
        // load Images
        if (self.itemDetails?.photos.count ?? 0) > 1 {
            self.pageView.isHidden = false
            self.photoLabel.text = "1/\(self.itemDetails?.photos.count ?? 0)"
        }
        else {
            self.pageView.isHidden = true
        }
        let lat =  itemDetails?.latitude ?? 0
        let lon =  itemDetails?.longitude ?? 0
        /*
        DispatchQueue.main.async {
            let cameras = SnapshotCamera(
                lookingAtCenter: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon)), zoomLevel: 12)
            let optioned = SnapshotOptions(styleURL: MGLStyle.streetsStyleURL, camera: cameras, size: CGSize(width: self.view.frame.width, height: 255))
            let snapshots = Snapshot(options: optioned, accessToken: MAPBOXACCESSTOKEN)
            self.snapshotImage = snapshots.image ?? #imageLiteral(resourceName: "applogo")
        }
        */
        
    }
    func loadBannerView() {
        /*
        if (ADMIN_VIEW_MODEL.adminModel?.result.googleAds ?? "").lowercased() == "enable" {
            // MARK: Banner Ads AddOn
            bannerView1 = GADBannerView(adSize: kGADAdSizeBanner)
            bannerView1.translatesAutoresizingMaskIntoConstraints = false
            bannerView1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
            self.bannerView1.adUnitID = BANNNER_ID
            self.bannerView1.load(GADRequest())
            self.bannerView1.delegate = self
            self.bannerView1.rootViewController = self
//            self.tableView.tableFooterView = self.bannerView1
        }
 */
    }
    func rightNavigationBarButtonItem() {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        if UserDefaultModule.shared.getUserData()?.user_id ?? "" == itemDetails?.sellerId ?? "" {
            button.setImage(#imageLiteral(resourceName: "editBtn"), for: UIControl.State.normal)
            button.tintColor = UIColor(named: "whitecolor")
        }
        else {
            print(self.getLikeData)
            if (itemDetails?.liked ?? "") == "yes"{
                button.setImage(#imageLiteral(resourceName: "like"), for: UIControl.State.normal)
            }
            else{
                button.setImage(#imageLiteral(resourceName: "unlike"), for: UIControl.State.normal)
            }
        }
        button.tag = 0
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
        button.addTarget(self, action: #selector(self.rightBarButtonAct(_:)), for: .touchUpInside)
        
        let button1: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button1.setImage(#imageLiteral(resourceName: "share"), for: UIControl.State.normal)
        button1.tag = 1
        button1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button1.contentEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
        button1.addTarget(self, action: #selector(self.rightBarButtonAct(_:)), for: .touchUpInside)
        
        let button2: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button2.setImage(#imageLiteral(resourceName: "option"), for: UIControl.State.normal)
        button2.tintColor = UIColor(named: "whitecolor") ?? .white
        button2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button2.contentEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
        button2.tag = 2
        button2.addTarget(self, action: #selector(self.rightBarButtonAct(_:)), for: .touchUpInside)
        let stackview = UIStackView.init(arrangedSubviews: [button,button1, button2])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 15

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackview)
    }
    func getYoutubeId() {
        if (self.itemDetails?.youtubeLink ?? "") != "" {
            let check = (self.itemDetails?.youtubeLink)!
            var checkVid = false
            if (check.contains("@")){
                checkVid = true
            }else if (check.contains("shorts")){
                checkVid = true
            }else if (check.contains("channel")){
                checkVid = true
            }else if !(check.contains("you")){
                checkVid = true
            }
            else{
                checkVid = false
            }
            if checkVid == true{
                self.youtubeView.isHidden = true
            }else{
                do {
                    let regex = try NSRegularExpression(pattern: "(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)", options: NSRegularExpression.Options.caseInsensitive)
                    let match = regex.firstMatch(in: (self.itemDetails?.youtubeLink ?? ""), options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: (self.itemDetails?.youtubeLink ?? "").lengthOfBytes(using: .utf8)))
                    let range = match?.range(at: 0)
                    print("YOUTUBELINK:\(self.itemDetails?.youtubeLink ?? "")")
                    let youTubeID = ((self.itemDetails?.youtubeLink ?? "") as NSString).substring(with: range!)
                    print(youTubeID)
                    if youTubeID != "" {
                        let playerVars = ["origin": "https://youtu.be", "playsinline": "0"]
                        self.youtubeView.isHidden = false
                        self.playerView.load(withVideoId: youTubeID, playerVars: playerVars)
                    }
                } catch {
                }
            }
        }
        /*
        if (self.itemDetails?.youtubeLink ?? "") != "" {
            do {
                let regex = try NSRegularExpression(pattern: "(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)", options: NSRegularExpression.Options.caseInsensitive)
                let match = regex.firstMatch(in: (self.itemDetails?.youtubeLink ?? ""), options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: (self.itemDetails?.youtubeLink ?? "").lengthOfBytes(using: .utf8)))
                let range = match?.range(at: 0)
                let youTubeID = ((self.itemDetails?.youtubeLink ?? "") as NSString).substring(with: range!)
                print(youTubeID)
                if youTubeID != "" {
                    let playerVars = ["origin": "https://youtu.be", "playsinline": "0"]
                    self.youtubeView.isHidden = false
                    self.playerView.load(withVideoId: youTubeID, playerVars: playerVars)
                }
            } catch {
            }
        }
        */
    }
    @objc func rightBarButtonAct(_ sender: UIButton) {
        if sender.tag == 0 {
            if UserDefaultModule.shared.getUserData()?.user_id ?? "" == itemDetails?.sellerId ?? "" {
                let pageObj = AddProductViewController()
                pageObj.isEditFlag = true
                let productImage = itemDetails?.photos.map({$0.itemImage}).joined(separator: ",") ?? ""
                let currencyArray = (itemDetails?.currencyCode ?? "").components(separatedBy: "-")
                 var formattedCurrency = (itemDetails?.currencyCode ?? "")
                 if currencyArray.count > 0 {
                    formattedCurrency = currencyArray.count > 1 ? "\(currencyArray[1])-\(currencyArray[0])" : (itemDetails?.currencyCode ?? "")
                }

                let addEditModel = AddEditViewModel(item_id: "\(itemDetails?.id ?? 0)", item_name: itemDetails?.itemTitle ?? "", item_des: (itemDetails?.itemDescription ?? ""), price: "\(itemDetails?.price ?? "0")", size: itemDetails?.size ?? "", category: "\(itemDetails?.categoryId ?? 0)", subcategory: itemDetails?.subcatId ?? "", chat_to_buy: "0", exchange_to_buy: (itemDetails?.exchangeBuy ?? "0") == "0" ? false : true, currency: "\(ADMIN_VIEW_MODEL.productBeforeModel?.result.currency.filter({$0.symbol == formattedCurrency}).first?.symbol ?? "")", lat: "\(itemDetails?.latitude ?? 0)", lon: "\(itemDetails?.longitude ?? 0)", address: itemDetails?.location ?? "", shipping_time: itemDetails?.shippingTime ?? "", remove_img: "", product_img: productImage, shipping_detail: "", item_condition: "\(ADMIN_VIEW_MODEL.productBeforeModel?.result.productCondition.filter({$0.name == (itemDetails?.itemCondition ?? "")}).first?.id ?? 0)", make_offer: Int(itemDetails?.makeOffer ?? "0") ?? 0, instant_buy: itemDetails?.instantBuy ?? "0" == "0" ? false : true, paypal_id: "", shipping_cost: itemDetails?.shippingCost ?? "", country_id: (itemDetails?.countryId ?? ""), giving_away: (itemDetails?.price ?? "0") == "0" ? true : false, sold: (itemDetails?.itemStatus ?? "") == "sold" ? true : false, filters: changeFilterDict(), youtube_link: itemDetails?.youtubeLink ?? "", child_category: "\(itemDetails?.childCategoryId ?? "0")")
                ADD_EDIT_ITEM_MODEL = addEditModel
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else {
                if UserDefaultModule.shared.getUserData()?.user_id ?? "" != "" {
                    if (self.itemDetails?.liked ?? "") == "yes" {
                        sender.setImage(#imageLiteral(resourceName: "unlike"), for: .normal)
                        self.itemDetails?.liked = "no"
                         self.itemDetails?.likesCount = (self.itemDetails?.likesCount ?? 0) > 0 ? ((self.itemDetails?.likesCount ?? 0)-1) : 0
                    }
                    else {
                        self.itemDetails?.liked = "yes"
                        sender.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                         self.itemDetails?.likesCount = ((self.itemDetails?.likesCount ?? 0) + 1)
                    }
                    self.likeDelegate?.likeAct((self.itemDetails?.id ?? 0), isLiked: (self.itemDetails?.liked ?? ""))
                      self.tableView.reloadData()
                    self.viewModel.itemLikedAct(user_id: (UserDefaultModule.shared.getUserData()?.user_id ?? ""), item_id: "\(self.itemDetails?.id ?? 0)", onSuccess: { (success) in
                    }) { (failure) in
                    }
                }
                else {
                    self.loadInitialVC()
                }
            }
        }
        else if sender.tag == 1 {
            let text = (self.itemDetails?.productUrl ?? "")
            let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
            
            if vc.popoverPresentationController != nil{
                popoverPresentationController?.sourceView = self.view
                popoverPresentationController?.sourceRect = self.view.bounds
            }
            self.present(vc, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            if (UserDefaultModule.shared.getUserData()?.user_id ?? "") == (itemDetails?.sellerId ?? "") {
                var soldValue = 0
                if (itemDetails?.itemStatus ?? "") == "onsale" {
                    soldTitle = getLanguage["mark_as_sold"] ?? ""
                    soldValue = 1
                }
                else {
                    soldTitle = getLanguage["back_to_sale"] ?? ""
                    soldValue = 0
                }
                alert.addAction(UIAlertAction(title: soldTitle, style: .default, handler: { (UIAlertAction) in
                    if UserDefaultModule.shared.getUserData()?.user_id ?? "" != "" {
                        self.soldItemAct("\(self.itemDetails?.id ?? 0)", value: "\(soldValue)")
                    }
                    else {
                        self.loadInitialVC()
                    }
                }))
                alert.addAction(UIAlertAction(title: (getLanguage["delete_product"] ?? ""), style: .default, handler: { (UIAlertAction) in
                    if UserDefaultModule.shared.getUserData()?.user_id ?? "" != "" {
                        self.deleteProductAct()
                    }
                    else {
                        self.loadInitialVC()
                    }
                }))
            }
            else {
                if (self.itemDetails?.makeOffer ?? "") == "0" {
                    alert.addAction(UIAlertAction(title: getLanguage["make_an_offer"], style: .default, handler: { (UIAlertAction) in
                        if UserDefaultModule.shared.getUserData()?.user_id ?? "" != "" {
                            let pageObj = ExchangeOfferViewController()
                            pageObj.itemDetails = self.itemDetails
                            pageObj.modalPresentationStyle = .overCurrentContext
                            pageObj.modalTransitionStyle = .crossDissolve
                            self.navigationController?.present(pageObj, animated: true, completion: nil)
                        }
                        else {
                            self.loadInitialVC()
                        }

                    }))
                }
                if (self.itemDetails?.exchangeBuy ?? "") == "1" && EXCHANGE_MODEL_FLAG {
                    alert.addAction(UIAlertAction(title: getLanguage["create_exchange"], style: .default, handler: { (UIAlertAction) in
                        if UserDefaultModule.shared.getUserData()?.user_id ?? "" != "" {
                            self.exchangeAct()
                        }
                        else {
                            self.loadInitialVC()
                        }
                    }))
                }
                var reportTitle = ""
                var reportVal = 0
                if itemDetails?.report ?? "" == "yes" {
                    reportTitle = getLanguage["undo_report"] ?? ""
                    reportVal = 1
                }
                else {
                    reportTitle = getLanguage["report_product"] ?? ""
                    reportVal = 0
                }
                alert.addAction(UIAlertAction(title: reportTitle, style: .default, handler: { (UIAlertAction) in
                    if UserDefaultModule.shared.getUserData()?.user_id ?? "" != "" {
                        self.reportAct(reportVal)
                    }
                    else {
                        self.loadInitialVC()
                    }
                }))
                
            }
            alert.addAction(UIAlertAction(title: getLanguage["cancel"], style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func loadInitialVC() {
        let vc = InitialViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.isFromList = true
        self.present(vc, animated: true, completion: nil)
    }
    func changeFilterDict() -> String {
        if let filterArr = self.itemDetails?.filters {
            var filterRangeArray = [FilterRangeModel]()
            var filterDropDownArray = [FilterSubModel]()
            var filterMultiLevelArray = [FilterSubModel]()
            
            let filterArray = Utility.shared.getFilterFromCategory(category: "\(self.itemDetails?.categoryId ?? 0)", subCategory: "\(self.itemDetails?.subcatId ?? "0")", childCategory: "\(self.itemDetails?.childCategoryId ?? "0")")
            //1616610600
            for filter in filterArr {
                for prodFilter in filterArray {
                    if prodFilter.type == filter.type {
                        if prodFilter.type == "dropdown" {
                            filterDropDownArray.append(FilterSubModel(catType: prodFilter.categoryType, id: filter.childId))
                        }
                        else if filter.type == "multilevel" {
                            filterMultiLevelArray.append(FilterSubModel(catType: prodFilter.categoryType, id: filter.childId))
                        }
                        else {
                            let range = FilterRangeModel(max_value: filter.value, id: filter.parentId, min_value: filter.value)
                            filterRangeArray.append(range)
                        }
                    }
                }
            }
            
            let updateArray = UpdateFilterModel(range: filterRangeArray, dropdown: filterDropDownArray, multilevel: filterMultiLevelArray)
            return Utility.shared.filterDictToString(updateArray)
        }
        return ""
    }
    
    func exchangeAct() {
        if self.itemDetails?.itemStatus ?? "" == "sold" {
            let alert = UIAlertController(title: nil, message: getLanguage["Product already sold out"] ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let pageObj = ExchangeViewController()
            pageObj.itemDetails = self.itemDetails
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
    func reportAct(_ reportVal: Int) {
        var reportTitle = ""
        if reportVal == 0 {
            reportTitle = getLanguage["Did you like to report this item?"] ?? ""
        }
        else {
            reportTitle = getLanguage["Did you like to undo report this item?"] ?? ""
        }
        let alert = UIAlertController(title: getLanguage["alert"], message: reportTitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: getLanguage["ok"], style: .default, handler: { (UIAlertAction) in
            Utility.shared.startAnimation(viewController: self)
            self.viewModel.reportItemAct(user_id: (UserDefaultModule.shared.getUserData()?.user_id ?? ""), item_id: "\(self.itemDetails?.id ?? 0)", onSuccess: { (success) in
                Utility.shared.stopAnimation(viewController: self)
                var reportMessage = (self.viewModel.alertModel?.message ?? "")

                if success {
                    if self.itemDetails?.report ?? "" == "yes" {
                        self.itemDetails?.report = "no"
                    }
                    else {
                        self.itemDetails?.report = "yes"
                    }
                    if reportMessage == "Reported Successfully" {
                        reportMessage = "reported_successfully"
                    }
                    else {
                        reportMessage = "unreported_successfully"
                    }
                }
                self.showAlert(getLanguage[reportMessage] ?? reportMessage)
            }) { (failure) in
                Utility.shared.stopAnimation(viewController: self)
            }
        }))
        alert.addAction(UIAlertAction(title: getLanguage["cancel"] ?? "", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlert(_ message: String) {
        let reportAlert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        reportAlert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "", style: .cancel, handler: nil))
        self.present(reportAlert, animated: true, completion: nil)
    }
    func deleteProductAct() {
        let alert = UIAlertController(title: getLanguage["alert"], message: getLanguage["Do you want to surely delete this product?"], preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: getLanguage["ok"], style: .default, handler: { (UIAlertAction) in
            Utility.shared.startAnimation(viewController: self)
            self.viewModel.deleteProductAct(user_id: (UserDefaultModule.shared.getUserData()?.user_id ?? ""), item_id: "\(self.itemDetails?.id ?? 0)", onSuccess: { (success) in
                self.navigationController?.popViewController(animated: true)
                Utility.shared.stopAnimation(viewController: self)
            }) { (failure) in
                Utility.shared.stopAnimation(viewController: self)
            }
        }))
        alert.addAction(UIAlertAction(title: getLanguage["cancel"], style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func soldItemAct(_ itemID: String, value: String) {
        
        // ****** Review & Ratings Addons **** //
        /*
        if !((self.buyNowButton.titleLabel?.text ?? "") == (getLanguage["back_to_sale"] ?? "back_to_sale")){
            Utility.shared.startAnimation(viewController: self)
            self.viewModel.getSoldToAddon(user_id:(UserDefaultModule.shared.getUserData()?.user_id ?? "") , item_id: "\(self.itemDetails?.id ?? 0)", onSuccess: { (success) in
                print(self.viewModel.soldToModel?.result.first?.userId ?? "")
                if self.viewModel.soldToModel?.result.first?.userId != nil{
                    if (self.viewModel.soldToModel?.result.count ?? 0) > 0 {
                        let pageObj = SoldOutViewController()
                        pageObj.refreshSold = { sold in
                            print("Sold \(sold)")
                            self.itemDetails?.itemStatus = sold
                            self.setBottonButton()
                        }
                        pageObj.itemId = "\(self.itemDetails?.id ?? 0)"
                        self.itemDetails?.itemStatus = self.itemDetails?.itemStatus ?? "" == "sold" ? "onsale" : "sold"
                        self.navigationController?.pushViewController(pageObj, animated: true)
                    }
                }
                else {
                    Utility.shared.startAnimation(viewController: self)
                    self.viewModel.soldItemAct(value: value, item_id: itemID, onSuccess: { (success) in
                        self.itemDetails?.itemStatus = self.itemDetails?.itemStatus ?? "" == "sold" ? "onsale" : "sold"
                        if self.itemDetails?.itemStatus ?? "" == "onsale" {
                            self.itemDetails?.promotionType = "Normal"
                        }
                        self.configUI()
                        Utility.shared.stopAnimation(viewController: self)
                    }) { (failure) in
                        Utility.shared.stopAnimation(viewController: self)
                    }
                }
                Utility.shared.stopAnimation(viewController: self)
            }) { (failure) in
                Utility.shared.stopAnimation(viewController: self)
            }
        }
        else{
 */
            let soldTitle = (itemDetails?.itemStatus ?? "") == "onsale" ? getLanguage["mark_as_sold"] ?? "" : getLanguage["back_to_sale"] ?? ""

            let alert = UIAlertController(title: nil, message: soldTitle, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["cancel"] ?? "cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "ok", style: .default, handler: { (UIAlertAction) in
                Utility.shared.startAnimation(viewController: self)
                self.viewModel.soldItemAct(value: value, item_id: itemID, onSuccess: { (success) in
                    self.itemDetails?.itemStatus = self.itemDetails?.itemStatus ?? "" == "sold" ? "onsale" : "sold"
                    if self.itemDetails?.itemStatus ?? "" == "onsale" {
                        self.itemDetails?.promotionType = "Normal"
                    }
                    self.configUI()
                    Utility.shared.stopAnimation(viewController: self)
                }) { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
            }))
            self.present(alert, animated: true, completion: nil)
//        }
    }
    func loadData() {
        let group = DispatchGroup()
        group.enter()
        self.viewModel.getUserProductsData(category_id: "\(self.itemDetails?.categoryId ?? 0)", subcategory_id: "\(self.itemDetails?.subcatId ?? "0")", user_id: self.itemDetails?.sellerId ?? "", product_id: "\(self.itemDetails?.id ?? 0)", onSuccess: { (success) in
            group.leave()
        }) { (failure) in
            group.leave()
        }
        group.enter()
        self.viewModel.getItems(type: "moreitems", price: "", search_key: "", category_id: "", subcategory_id: "", user_id: (UserDefaultModule.shared.getUserData()?.user_id ?? ""), item_id: "\(self.itemDetails?.id ?? 0)", seller_id: (self.itemDetails?.sellerId ?? ""), sorting_id: "1", offset: "0", limit: "50", posted_within: "", distance: "", distance_type: "", lang_type: DEFAULT_LANGUAGE_CODE, filters: "", product_condition: "", child_category_id: "", lon: "", lat: "", onSuccess: { (success) in
            group.leave()
        }) { (failure) in
            group.leave()
        }
        group.enter()
        let chatViewModel = ChatViewModel()
        chatViewModel.searchItemData(item_id: "\(self.itemDetails?.id ?? 0)", user_id: (UserDefaultModule.shared.getUserData()?.user_id ?? ""), onSuccess: { (success) in
            if success {
                if let itemModel = chatViewModel.itemModel?.result.items.first {
                    let productURL = self.itemDetails?.productUrl ?? ""
                    let totalPrice = self.itemDetails?.formattedTotalPrice ?? "0"
                    self.itemDetails = itemModel
                    self.itemDetails?.productUrl = productURL
                    self.itemDetails?.formattedTotalPrice = totalPrice
                }
            }
            group.leave()
        }) { (failure) in
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
            self.collectionView.reloadData()
            DispatchQueue.main.async {
                self.viewModel.updateViewCount(item_id: "\(self.itemDetails?.id ?? 0)", user_id: (UserDefaultModule.shared.getUserData()?.user_id ?? ""))
            }
        }
    }
    
    func setBottonButton() {
        if (UserDefaultModule.shared.getUserData()?.user_id ?? "") == (self.itemDetails?.sellerId ?? "") {
            if (itemDetails?.itemStatus ?? "") == "onsale" {
                if (self.itemDetails?.promotionType ?? "") != "Normal" {
                    self.buyNowButton.setTitle(getLanguage["Promotion Details"] ?? "", for: .normal)
                }
                else {
                    if (ADMIN_VIEW_MODEL.adminModel?.result.promotion ?? "") == "enable"{
                        self.buyNowButton.setTitle(getLanguage["promote_your_product"] ?? "", for: .normal)
                    }else{
                        self.buyNowButton.isHidden = true
                    }
                 }
            }
            else {
                if (itemDetails?.itemStatus ?? "") == "sold" {
                    self.buyNowButton.setTitle(getLanguage["back_to_sale"] ?? "", for: .normal)
                }
            }
            
            self.chatButton.setTitle(getLanguage["insights"] ?? "", for: .normal)
        }
        else{
            if BUYNOW_MODEL_FLAG {
                if (self.itemDetails?.instantBuy ?? "") == "1" && (self.itemDetails?.itemStatus ?? "") == "onsale" {
                    self.buyNowButton.isHidden = false
                }
                else {
                    self.chatButton.backgroundColor = UIColor(named: "AppThemeColor")
                    self.chatButton.setTitleColor(UIColor(named: "whitecolor"), for: .normal)
                    self.buyNowButton.isHidden = true
                }
            }
            else {
                self.chatButton.backgroundColor = UIColor(named: "AppThemeColor")
                self.chatButton.setTitleColor(UIColor(named: "whitecolor"), for: .normal)
                self.buyNowButton.isHidden = true
            }
        }

    }
    
    @IBAction func youtubeButtonAct(_ sender: UIButton) {
        if sender.tag == 0 {
            self.playerView.isHidden = false
            self.playerView.playVideo()
        }
    }
    @IBAction func buyNowButtonAct(_ sender: UIButton) {
        if (UserDefaultModule.shared.getUserData()?.user_id ?? "") == (self.itemDetails?.sellerId ?? "") {
            if (itemDetails?.itemStatus ?? "") == "sold" {
                self.soldItemAct("\(self.itemDetails?.id ?? 0)", value: "0")
            }
            else {
                if (self.itemDetails?.promotionType ?? "") == "Normal" {
                    let pageObj = CreatePromotionViewController()
                    pageObj.itemID = "\(self.itemDetails?.id ?? 0)"
                    self.navigationController?.pushViewController(pageObj, animated: true)
                }
                else {
                    let pageObj = MyPromotionDetailViewController()
                    pageObj.isFromItemDetails = true
                    pageObj.itemDetails = self.itemDetails
                    self.navigationController?.pushViewController(pageObj, animated: true)
                }
            }
        }
        else {
            
            if sender.tag == 0 {
                if (UserDefaultModule.shared.getUserData()?.user_id ?? "") != "" {
                    if BUYNOW_MODEL_FLAG && (self.itemDetails?.itemApprove ?? "") == "1" {
                        Utility.shared.startAnimation(viewController: self)
                        let addressModel = AddressViewModel()
                        addressModel.getShippingAddressAct(user_id: (UserDefaultModule.shared.getUserData()?.user_id ?? ""), item_id: "\(self.itemDetails?.id ?? 0)", onSuccess: { (success) in
                            Utility.shared.stopAnimation(viewController: self)
                            if !success {
                                let pageObj = AddressViewController()
                                pageObj.itemDetails = self.itemDetails
                                pageObj.viewType = 1
                                self.navigationController?.pushViewController(pageObj, animated: true)
                            }
                            else {
                                if addressModel.addressListModel?.result.count ?? 0 == 1 {
                                    let pageObj = BuyNowViewController()
                                    pageObj.addressDetails = addressModel.addressListModel?.result.first
                                    pageObj.itemDetails = self.itemDetails
                                    self.navigationController?.pushViewController(pageObj, animated: true)
                                }
                                else {
                                    let pageObj = AddressListViewController()
                                    pageObj.itemDetails = self.itemDetails
                                    pageObj.isFromItemDetails = true
                                    self.navigationController?.pushViewController(pageObj, animated: true)
                                }
                            }
                        }) { (failure) in
                            Utility.shared.stopAnimation(viewController: self)
                        }
                    }
                }
                else {
                    self.loadInitialVC()
                }
            }
            else {
                
            }
            
        }
    }
        
    @IBAction func chatButtonAct(_ sender: UIButton) {
        if UserDefaultModule.shared.getUserData()?.user_id ?? "" != "" {
            if (UserDefaultModule.shared.getUserData()?.user_id ?? "") == (self.itemDetails?.sellerId ?? "") {
                let pageObj = InsightViewController()
                pageObj.itemData = self.itemDetails
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else {
                self.view.endEditing(true)
                Utility.shared.startAnimation(viewController: self)
                self.viewModel.getChatIdAct(sender_id: (UserDefaultModule.shared.getUserData()?.user_id ?? ""), receiver_id: (self.itemDetails?.sellerId ?? ""), onSuccess: { (success) in
                    Utility.shared.stopAnimation(viewController: self)

                    if success {
                        let pageObj = ChatViewController()
                        pageObj.receiverId = self.itemDetails?.sellerId ?? ""
                        pageObj.isFromItemDetails = true
                        pageObj.chatId = (self.viewModel.itemChatModel?.chatId ?? "")
                        pageObj.itemDetails = self.itemDetails
                        self.navigationController?.pushViewController(pageObj, animated: true)
                    }
                }) { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
            }
        }
        else {
            self.loadInitialVC()
        }
    }
}
extension ItemDetailsViewController: UITableViewDelegate, UITableViewDataSource, itemDetailsImageDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return (self.itemDetails?.filters.count ?? 0)
        }
        else if section == 5 && (self.viewModel.relatedProductModel?.result == nil) {
            return 0
        }
        else if section == 6 && (self.viewModel.getItemModel?.result == nil)
        {
            return 0
        }
        
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 || (section == 1 && (self.itemDetails?.filters.count ?? 0)>0) || (section == 6 && (self.viewModel.getItemModel?.result != nil)) || (section == 5 && (self.viewModel.relatedProductModel?.result != nil)) {
            return UITableView.automaticDimension
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 6 {
            return 50
        }
        return 0
    }
    /*
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 6 {
            
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
            self.bannerView1.frame = footerView.bounds
            footerView.addSubview(self.bannerView1)
            return footerView
             
        }
        else {
            return nil
        }
    }
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 5 || indexPath.section == 6 {
            return 255
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FilterHeaderTableViewCell") as! FilterHeaderTableViewCell
        cell.viewTopConst.constant = 0
        cell.viewBottomConst.constant = 0
        cell.headerLabel.font = UIFont(name: APP_FONT_BOLD, size: 16)
          if section == 1 {
            cell.viewType = 1
            cell.overAllView.backgroundColor = UIColor(named: "whitecolor")
            cell.headerLabel.text = (getLanguage["details"] ?? "").capitalized
        }
        else if section == 2 {
            cell.viewType = 1
            cell.overAllView.backgroundColor = UIColor(named: "whitecolor")
            cell.headerLabel.text = (getLanguage["description"] ?? "").capitalized
        }
        else if (section == 5 && (self.viewModel.relatedProductModel?.result != nil)) {
            cell.overAllView.backgroundColor = UIColor(named: "clearcolor")
            cell.viewType = 0
            cell.headerLabel.text = "\(getLanguage["more_items_from"] ?? "") \(self.itemDetails?.sellerUsername ?? "")"
            cell.viewTopConst.constant = 10
        }
        else if (section == 6 && (self.viewModel.getItemModel?.result != nil)) {
            cell.viewTopConst.constant = 0
            cell.overAllView.backgroundColor = UIColor(named: "clearcolor")
            cell.viewType = 0
            cell.headerLabel.text = (getLanguage["related_products"] ?? "").capitalized
        }
//        cell.viewBottomConst.constant = 10
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailsMapTableViewCell") as! ItemDetailsMapTableViewCell
             if let itemDetails = self.itemDetails{
                cell.loadData(itemDetails)
                if itemDetails.mobileVerification && itemDetails.showSellerMobile {
                    cell.callButton.isHidden = false
                }
                else {
                    cell.callButton.isHidden = true
                }
                /*
                DispatchQueue.main.async {
                    cell.mapImageView.image = self.snapshotImage
                }
                 */
            }
            
            cell.callButton.addTarget(self, action: #selector(self.callButtonAct(_:)), for: .touchUpInside)
            cell.mapImageView.isUserInteractionEnabled = true
            cell.mapImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.directionGestureAct)))
             cell.userImageView.isUserInteractionEnabled = true
            cell.userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewUserAct(_:))))
            return cell
         }
        else if indexPath.section == 5 || indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemDetailsImageTableViewCell") as! itemDetailsImageTableViewCell
            cell.delegate = self
            if indexPath.section == 5 && self.viewModel.relatedProductModel?.result != nil {
                cell.loadData(self.viewModel.relatedProductModel?.result.items ?? [ItemModel]())
            }
            else if indexPath.section == 6 && self.viewModel.getItemModel?.result != nil{
                cell.loadData(self.viewModel.getItemModel?.result.items ?? [ItemModel]())
            }
             return cell
         }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailsTableViewCell") as! ItemDetailsTableViewCell
            if let itemDetails = self.itemDetails{
                cell.loadData(index: indexPath, item: itemDetails)
            }
            if soldTitle == getLanguage["back_to_sale"] ?? ""{
                cell.adButton.isHidden = true
            }
            cell.facebookButton.tag = 0
            cell.twitterButton.tag = 1
            cell.whatsappButton.tag = 2
            cell.moreButton.tag = 3
            cell.commentButton.addTarget(self, action: #selector(self.commentButtonAct), for: .touchUpInside)
            cell.facebookButton.addTarget(self, action: #selector(self.shareAct(_:)), for: .touchUpInside)
            cell.twitterButton.addTarget(self, action: #selector(self.shareAct(_:)), for: .touchUpInside)
            cell.whatsappButton.addTarget(self, action: #selector(self.shareAct(_:)), for: .touchUpInside)
            cell.moreButton.addTarget(self, action: #selector(self.shareAct(_:)), for: .touchUpInside)

            return cell
        }
    }
    @objc func directionGestureAct()  {
        if let url = URL(string: "http://maps.google.com/?saddr=\(self.delegate.currentLocation?.location?.coordinate.latitude ?? 0),\(self.delegate.currentLocation?.location?.coordinate.longitude ?? 0)&daddr=\(itemDetails?.latitude ?? 0),\(itemDetails?.longitude ?? 0)&directionsmode=driving"){
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
       }
  
     @objc func callButtonAct(_ sender: UIButton) {
        if (itemDetails?.mobileNo ?? "") != "" && (UserDefaultModule.shared.getUserData()?.user_id ?? "") != "" {
            if let callUrl = URL(string: "telprompt://+\(itemDetails?.mobileNo ?? "")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), UIApplication.shared.canOpenURL(callUrl) {
                UIApplication.shared.open(callUrl, options: [:], completionHandler: nil)
            }
            else {
            }
        }
        else{
            self.loadInitialVC()
        }
    }
    @objc func commentButtonAct() {
        let pageObj = CommentViewController()
        pageObj.itemVC = self
        pageObj.itemModel = self.itemDetails
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @objc func shareAct(_ sender: UIButton) {
        let alert = UIAlertController(title: getLanguage["alert"] ?? "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "", style: .cancel, handler: nil))
        let message = "\(itemDetails?.itemTitle ?? "") \n \(itemDetails?.productUrl ?? "")"

        if let url = URL(string: (itemDetails?.productUrl ?? "")) {
            if sender.tag == 0 {
                if let fbURL = URL(string: "fb://"), UIApplication.shared.canOpenURL(fbURL) {
                    let content = ShareLinkContent()
                    content.contentURL = url
                    content.quote = (itemDetails?.itemTitle ?? "")
                    let dialog = ShareDialog(viewController: self, content: content, delegate: nil)
                    dialog.fromViewController = self
                    dialog.shareContent = content
                    dialog.mode = .shareSheet
                    dialog.show()
                }
                else {
                    alert.message = getLanguage["Facebook not installed"] ?? ""
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else if sender.tag == 1 {
                if let twitterURL = URL(string: "twitter://post?message=\(message)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""), UIApplication.shared.canOpenURL(twitterURL) {
                    UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
                }
                else {
                    alert.message = getLanguage["twitter_installed"] ?? ""
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else if sender.tag == 2 {
                if let whatsAppUrl = URL(string: "whatsapp://send?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), UIApplication.shared.canOpenURL(whatsAppUrl) {
                    UIApplication.shared.open(whatsAppUrl, options: [:], completionHandler: nil)
                }
                else {
                    alert.message = getLanguage["whatsapp_installed"] ?? ""
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                let textToShare = [(itemDetails?.productUrl ?? "")]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                 self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    @objc func viewUserAct(_ sender: UITapGestureRecognizer) {
        let pageObj = ViewProfileViewController()
        pageObj.userId = "\(self.itemDetails?.sellerId ?? "")"
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            let y = 300 - (scrollView.contentOffset.y + 300)
            let height = min(max(y, 0), 400)
            topViewHeightConst.constant = height
//            self.collectionView.reloadData()
            if self.topViewHeightConst.constant < 10 {
                self.pageView.isHidden = true
                self.collectionView.isHidden = true
                self.topView.isHidden = true
                self.youtubeView.isHidden = true
                self.navigationController?.NavigationBarWithBackButtonAndTitle(title: (self.itemDetails?.itemTitle ?? ""), fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 18), imageName: "detail_back", isLeft: true, vc: self, transparantView: false)

            }
            else {
                if ((self.itemDetails?.photos.count ?? 0) > 1) {
                    self.pageView.isHidden = false
                }
                self.navigationController?.NavigationBarWithBackButtonAndTitle(title: "", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 18), imageName: "detail_back", isLeft: true, vc: self, transparantView: false)
                if (self.itemDetails?.youtubeLink ?? "") != "" {
                    self.youtubeView.isHidden = false
                }
                self.collectionView.isHidden = false
                self.topView.isHidden = false
            }
        }
        else if scrollView == collectionView {
            
        }
    }
    func didSelectAct(_ itemModel: ItemModel) {
        let pageObj = ItemDetailsViewController()
        pageObj.itemDetails = itemModel
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
}
extension ItemDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.itemDetails?.photos.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailsImageCollectionViewCell", for: indexPath) as! ItemDetailsImageCollectionViewCell
        if self.itemDetails?.membership_enable == "enable"{
            cell.memberShipView.isHidden = false
        }else{
            cell.memberShipView.isHidden = true
        }
        if let photos = self.itemDetails?.photos[indexPath.row] {
            cell.loadData(photos)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.photoLabel.text = "\(indexPath.row + 1)/\(self.itemDetails?.photos.count ?? 0)"
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullScreenController = FullScreenSlideshowViewController()
        if let imageArr = self.itemDetails?.photos.map({$0.itemUrlMainOriginal}) {
            var imageSource = [SDWebImageSource]()
            for img in imageArr {
                if let image = SDWebImageSource(urlString: img ?? "", placeholder: #imageLiteral(resourceName: "applogo")) {
                    imageSource.append(image)
                }
                else {
                    imageSource.append(SDWebImageSource(urlString: self.itemDetails?.photos.first?.itemUrlMain350 ?? "", placeholder: #imageLiteral(resourceName: "profilelogo"))!)
                 }
            }
            let pageIndicatorLabel = LabelPageIndicator()
            pageIndicatorLabel.textColor = UIColor(named: "whitecolor")
            pageIndicatorLabel.widthAnchor
            pageIndicatorLabel.textAlignment = .center
            fullScreenController.slideshow.pageIndicator = pageIndicatorLabel
            fullScreenController.slideshow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .customBottom(padding: 20))

            fullScreenController.slideshow.circular = false
            fullScreenController.backgroundColor = UIColor(white: 0, alpha: 0.7)
            fullScreenController.closeButton.setImage(#imageLiteral(resourceName: "takeclose"), for: .normal)
            fullScreenController.closeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            fullScreenController.closeButton.tintColor = .black
            fullScreenController.inputs = imageSource
            fullScreenController.initialPage = indexPath.row

            fullScreenController.slideshow.currentPageChanged = { [weak self] page in
                if let cell = collectionView.cellForItem(at: indexPath) as? ItemDetailsImageCollectionViewCell, let imageView = cell.itemImageView {
                    self?.slideshowTransitioningDelegate?.referenceImageView = imageView
                }
            }
            present(fullScreenController, animated: true, completion: nil)
        }
    }
    
}
extension ItemDetailsViewController: WKYTPlayerViewDelegate {
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        if state == .playing {
            playerView.isHidden = false
        }
        else if state == .paused {
            playerView.isHidden = true
        }
    }
}
 /*
extension ItemDetailsViewController: GADBannerViewDelegate{
    //banner view delegate
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        bannerView.isHidden = false
//        bannerViews.isHidden = false
//        UIView.animate(withDuration: 1, animations: {
//            self.bannerViews.isHidden = false
//        })
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
//        self.bannerViews.isHidden = true
//        bannerView.isHidden = true
        print("BANNER ERROR \(error.localizedDescription)")
    }
}
*/
