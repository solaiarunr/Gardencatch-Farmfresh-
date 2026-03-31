//
//  AddProductViewController.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 11/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import DropDown
import NVActivityIndicatorView
import CoreLocation
class AddProductViewController: UIViewController, customLocationDelegate {

    @IBOutlet weak var activityLoader: NVActivityIndicatorView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var imageArray = [AddProductImageModel]()
    var removeArray = [AddProductImageModel]()
    var viewModel = AddProductViewModel()
    var isEditFlag = false
    var itemModel: ItemModel?
    var filterData = [ProductFilterModel]()
    let dropDown = DropDown()
    var selectedCategory: ProductCategoryModel?
    // Selected Category Filter Data
    var updateFilterData: UpdateFilterModel?
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let getDropDown = ""
    
//    var interstitial :GADInterstitialAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        loadData()
        print(getDropDown)
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: nil)
        }
        self.loadFilterData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: nil)
    }
    func configUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.customNavigationBarView(title: getLanguage["add_your_stuff"] ?? "", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 20), vc: self)
        self.navigationController?.customRightBarButtonView(title: "", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 14), imageName: "detail_back", isLeft: true, vc: self, transparantView: false)
        self.tableView.register(UINib(nibName: "AddProductTableViewCell", bundle: nil), forCellReuseIdentifier: "AddProductTableViewCell")
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 4
        self.tableView.sectionFooterHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionFooterHeight = 4

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.cancelButton.config(color: UIColor(named: "AppThemeColor"), font: UIFont(name: APP_FONT_BOLD, size: 16), align: .center, title: "cancel")
        self.cancelButton.setBorder(color: UIColor(named: "AppThemeColor"))
        self.cancelButton.backgroundColor = UIColor(named: "whitecolor")
        self.cancelButton.cornerMiniumRadius()
        self.postButton.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_BOLD, size: 16), align: .center, title: "post")
        self.postButton.backgroundColor = UIColor(named: "AppThemeColor")
        self.postButton.cornerMiniumRadius()
        if isEditFlag {
            let imageArr = ADD_EDIT_ITEM_MODEL.product_img.components(separatedBy: ",")
            for image in imageArr {
                let imageData = AddProductImageModel(isUploaded: true, image: #imageLiteral(resourceName: "applogo"), imageUrl: image)
                if !self.imageArray.contains(where: {$0.imageUrl == image}) {
                    self.imageArray.append(imageData)
                }
            }
        }

    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 1 {
            }
            else {
//                ADD_EDIT_ITEM_MODEL = AddEditViewModel()
//                self.navigationController?.isNavigationBarHidden = true
//                self.navigationController?.popViewController(animated: true)
                ADD_EDIT_ITEM_MODEL = AddEditViewModel()
                self.productCancelButtonAct(self.cancelButton)
            }
        }
    }
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        self.viewDidLayoutSubviews()
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    func loadData() {
        DispatchQueue.main.async {
            ADMIN_VIEW_MODEL.productBeforeAddData(lang_code: "en", onSuccess: { (success) in
                if (ADMIN_VIEW_MODEL.productBeforeModel?.status ?? false) {
    //                ADD_EDIT_ITEM_MODEL.currency = "\(ADMIN_VIEW_MODEL.productBeforeModel?.result.currency.first?.symbol ?? "")"
    //                self.tableView.reloadData()
                }
            }) { (failure) in
            }
        }
    }
    func loadFilterData() {
        // Get Category Filter Array & UPDATE Product condition
        if ADD_EDIT_ITEM_MODEL.category != "", let category = ADMIN_VIEW_MODEL.productBeforeModel?.result.category.filter({$0.categoryId == (ADD_EDIT_ITEM_MODEL.category)}).first {
            filterData = category.filters
            if ADD_EDIT_ITEM_MODEL.subcategory != "", let subCategory = category.subcategory.filter({$0.subId == ADD_EDIT_ITEM_MODEL.subcategory}).first {
                filterData = (filterData + subCategory.filters)
                if ADD_EDIT_ITEM_MODEL.child_category != "",let childCategory = subCategory.childCategory.filter({$0.childId == ADD_EDIT_ITEM_MODEL.child_category}).first {
                    filterData = (filterData + childCategory.filters)
                }
            }
            self.selectedCategory = category
            // Check If the category have Offer, Product condition & exchange to buy option
            ADD_EDIT_ITEM_MODEL.make_offer = ((self.selectedCategory?.makeOffer ?? "") == "disable" || ADD_EDIT_ITEM_MODEL.giving_away || ADD_EDIT_ITEM_MODEL.make_offer != 0) ? 1 : 0
            ADD_EDIT_ITEM_MODEL.item_condition = ((self.selectedCategory?.productCondition ?? "") != "enable") ? "" : ADD_EDIT_ITEM_MODEL.item_condition
            ADD_EDIT_ITEM_MODEL.exchange_to_buy = ((self.selectedCategory?.exchangeBuy ?? "") != "enable") ? false : ADD_EDIT_ITEM_MODEL.exchange_to_buy
            ADD_EDIT_ITEM_MODEL.instant_buy = (self.selectedCategory?.instantBuy ?? "" != "enable" || ADD_EDIT_ITEM_MODEL.giving_away) ? false : ADD_EDIT_ITEM_MODEL.instant_buy

            self.updateFilterData = Utility.shared.filterStringToDict(ADD_EDIT_ITEM_MODEL.filters ?? "")
        }
        self.tableView.reloadData()
    }
    
    @IBAction func productCancelButtonAct(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: getLanguage["product_discard_alert"] ?? "", preferredStyle: .alert)
        if isEditFlag {
            alert.message = getLanguage["product_edit_discard_alert"] ?? ""
        }
        alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "", style: .default, handler: { (UIAlertAction) in
            if self.isEditFlag {
                ADD_EDIT_ITEM_MODEL = AddEditViewModel()
                self.navigationController?.popViewController(animated: true)
            }
            else {
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                ADD_EDIT_ITEM_MODEL = AddEditViewModel()
                appdelegate.initVC(initialView: TabbarController())
            }
        }))
        alert.addAction(UIAlertAction(title: getLanguage["cancel"] ?? "", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func postbuttonAct(_ sender: UIButton) {
        var message = ""
        var isValid = false
        let filterMessage = self.checkFilterData()
        let titleString = ADD_EDIT_ITEM_MODEL.item_name.trimmingCharacters(in: .whitespacesAndNewlines)
        let descString = ADD_EDIT_ITEM_MODEL.item_des.trimmingCharacters(in: .whitespacesAndNewlines)
        if self.imageArray.count == 0 {
            message = "uploadimage"
        }
        else if titleString == "" {
            message = "titlecannotblank"
        }
        else if descString == "" && ADD_EDIT_ITEM_MODEL.item_des == "<br />" {
            message = "descriptioncannotblank"
        }
        else if !ADD_EDIT_ITEM_MODEL.giving_away && ADD_EDIT_ITEM_MODEL.price == "" {
            message = "pricecannotblank"
        }
        else if !ADD_EDIT_ITEM_MODEL.giving_away && ADD_EDIT_ITEM_MODEL.price == "0"{
            message = "entervalidprice"
        }
        else if !ADD_EDIT_ITEM_MODEL.giving_away && ADD_EDIT_ITEM_MODEL.currency == "" {
            message = "currencycodenotselected"
        }
        else if ADD_EDIT_ITEM_MODEL.category == "" {
            message = "select_category"
        }
        else if ADD_EDIT_ITEM_MODEL.address == "" || ADD_EDIT_ITEM_MODEL.address == "North Atlantic Ocean" {
            message = "locationnotselected"
        }
        else if ADD_EDIT_ITEM_MODEL.instant_buy && ADD_EDIT_ITEM_MODEL.shipping_cost == "" {
            message = "entershippingcost"
        }
        else if filterMessage != "" {
            message = filterMessage
        }
        else if (self.selectedCategory?.productCondition ?? "") == "enable" && (ADD_EDIT_ITEM_MODEL.item_condition == "" || ADD_EDIT_ITEM_MODEL.item_condition == "0") {
            message = "Product condition not selected"
        }
        else if ADD_EDIT_ITEM_MODEL.youtube_link != "" &&
            !ADD_EDIT_ITEM_MODEL.youtube_link.isValidURL || ADD_EDIT_ITEM_MODEL.youtube_link != "" &&
                    !ADD_EDIT_ITEM_MODEL.youtube_link.isYouTubeVideoURL {
            message = "youtube_link_format"
        }
        else {
            isValid = true
        }
        /*
         if (check.contains("@")){
             message = "youtube_link_format"
         }else if (check.contains("shorts")){
             message = "youtube_link_format"
         }else if (check.contains("channel")){
             message = "youtube_link_format"
         }else if !(check.contains("you")){
             message = "youtube_link_format"
         }
         */
        
        if isValid {
            let group = DispatchGroup()
            group.enter()
            if ADD_EDIT_ITEM_MODEL.country_id == "" {
                let location = CLLocation(latitude: Double(ADD_EDIT_ITEM_MODEL.lat) ?? 0, longitude: Double(ADD_EDIT_ITEM_MODEL.lon) ?? 0)
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location, completionHandler:
                    {
                        placemarks, error -> Void in
                        guard let placeMark = placemarks?.first else { group.leave(); return }
                        // Country
                        if let country = placeMark.country {
                            if let countryDetails = ADMIN_VIEW_MODEL.productBeforeModel?.result.country.filter({$0.countryName.lowercased() == country.lowercased()}).first {
                                ADD_EDIT_ITEM_MODEL.country_id = "\(countryDetails.countryId ?? 0)"
                            }
                            group.leave()
                        }
                        else {
                            group.leave()
                        }
                })
            }
            else {
                group.leave()
            }
            group.notify(queue: DispatchQueue.main) {
                self.uploadImageToServer()
            }
            
        }
        else {
            let alert = UIAlertController(title: nil, message: getLanguage[message] ?? message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func uploadImageToServer() {
        self.activityLoader.startAnimating()
        self.postButton.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        let group = DispatchGroup()
        var status = true
        for index in 0..<imageArray.count {
            group.enter()
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                if !self.imageArray[index].isuploaded {
                    CallParsingFunction().uploadImage(url: UPLOAD_IMAGE_URL, type: "item", image: self.imageArray[index].image, onSuccess: { (success) in
                        print("imageIndex: \(index)")
                        
                        if success["status"].boolValue == true {
                            self.imageArray[index].imageUrl = success["Image","Name"].stringValue
                            self.imageArray[index].isuploaded = true
                        }
                        else {
                            status = success["status"].boolValue
                        }
                        group.leave()
                    }) { (failure) in
                        group.leave()
                        self.view.isUserInteractionEnabled = true
                        self.activityLoader.stopAnimating()
                    }
                }
                else {
                    group.leave()
                }
            }
        }
        group.notify(queue: DispatchQueue.main) {
            if status {
                self.postProduct(self.imageArray.map({$0.imageUrl}))
            }
            else {
                self.postButton.isUserInteractionEnabled = true
                self.activityLoader.stopAnimating()
                self.view.isUserInteractionEnabled = true
                let alert = UIAlertController(title: nil, message: getLanguage["Image cannot be uploaded"] ?? "Image cannot be uploaded", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "ok", style: .default, handler: { (UIAlertAction) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func showHideView(_ promotionType: String, message: String = "successfully_posted") {
        let pageObj = AddProductPopupViewController()
        pageObj.delegate = self
        pageObj.message = message
        pageObj.promotionType = promotionType
        pageObj.modalPresentationStyle = .overCurrentContext
        pageObj.modalTransitionStyle = .crossDissolve
        self.present(pageObj, animated: true, completion: nil)
    }
    func postProduct(_ imageArray: [String]) {
        let removeImageArray = self.removeArray.map({$0.imageUrl ?? ""})
        self.view.endEditing(true)
        ADD_EDIT_ITEM_MODEL.remove_img = removeImageArray.joined(separator: ",")
        ADD_EDIT_ITEM_MODEL.product_img = imageArray.joined(separator: ",")
        self.viewModel.postProduct(user_id: UserDefaultModule.shared.getUserData()?.user_id ?? "", productModel: ADD_EDIT_ITEM_MODEL, filter: (changeFilterData() ?? ""), editFlag: isEditFlag, onSuccess: { (success) in
            if success {
                /*
                let itemImage = ADD_EDIT_ITEM_MODEL.product_img
                DispatchQueue.main.async {
                    ADD_EDIT_ITEM_MODEL.item_id = self.viewModel.addModel?.itemId ?? ""
                    self.viewModel.AWSUpload(user_id: UserDefaultModule.shared.getUserData()?.user_id ?? "", itemID: self.viewModel.addModel?.itemId ?? "", itemImage: itemImage ?? "") { (success) in
                    } onFailure: { (failure) in
                    }
                }
                 */
                if PROMOTION_FLAG {
                    self.showHideView((self.viewModel.addModel?.promotionType ?? "normal").uppercased(), message: (self.viewModel.addModel?.message ?? ""))
                }
                else {
                    let pageObj = ViewProfileViewController()
                    pageObj.userId = UserDefaultModule.shared.getUserData()?.user_id ?? ""
                    pageObj.isTabBar = true
                    ADD_EDIT_ITEM_MODEL = AddEditViewModel()
                    self.navigationController?.pushViewController(pageObj, animated: true)
                }
                self.view.isUserInteractionEnabled = true
                self.postButton.isUserInteractionEnabled = true
            }
            else {
                let alert = UIAlertController(title: getLanguage["alert"] ?? "", message: self.viewModel.addModel?.message ?? "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.postButton.isUserInteractionEnabled = true
            self.view.isUserInteractionEnabled = true
            self.activityLoader.stopAnimating()
        }) { (failure) in
            self.postButton.isUserInteractionEnabled = true
            self.view.isUserInteractionEnabled = true
            self.activityLoader.stopAnimating()
        }
    }
    func checkFilterData() -> String {
        self.updateFilterData = Utility.shared.filterStringToDict(ADD_EDIT_ITEM_MODEL.filters)
        for filterVal in filterData {
            if filterVal.type == "dropdown" {
                if let dropDownVal = self.updateFilterData?.dropdown {
                    if let parentVal = filterVal.values.filter({i in (dropDownVal.contains(where: {i.parentId == $0.id && filterVal.categoryType == $0.catType}))}).first {
                          if parentVal.parentId == ""  {
                              return "\(getLanguage["Choose"] ?? "Choose") \(filterVal.label ?? "")"
                          }
                      }
                      else {
                          return "\(getLanguage["Choose"] ?? "Choose") \(filterVal.label ?? "")"
                      }
                }
                else {
                    return "\(getLanguage["Choose"] ?? "Choose") \(filterVal.label ?? "")"
                }
            }
            else if filterVal.type == "multilevel" {
                if let multiLevelArray = updateFilterData?.multilevel {
                    let parentValue = filterVal.values.map({$0.parentValues})
                    var isEmpty = true
                    for parent in parentValue {
                        if multiLevelArray.count == 0 {
                            return "\(getLanguage["Choose"] ?? "Choose") \(filterVal.label ?? "")"
                        }
                        else {
                            if let child = parent?.filter({i in (multiLevelArray.contains(where: {$0.id == i.childId && $0.catType == filterVal.categoryType}))}).first {
                                if child.childId == "" {
//                                    return "\(getLanguage["Choose"] ?? "Choose") \(filterVal.label ?? "")"
                                }
                                else {
                                    isEmpty = false
                                }
                            }
                            else {
//                                return "\(getLanguage["Choose"] ?? "Choose") \(filterVal.label ?? "")"
                            }
                        }
                    }
                    if isEmpty {
                        return "\(getLanguage["Choose"] ?? "Choose") \(filterVal.label ?? "")"
                    }
                }
                else {
                    return "\(getLanguage["Choose"] ?? "Choose") \(filterVal.label ?? "")"
                }
            }
            else {
                if let child = updateFilterData?.range.filter({$0.id == filterVal.id}).first {
                    let minVal = Int(filterVal.minValue ?? "") ?? 0
                    let maxVal = Int(filterVal.maxValue ?? "") ?? 0
                    let value = Int(child.max_value ?? "") ?? 0
                    if child.max_value ?? "" == "" {
                        return "\(getLanguage["Enter"] ?? "Enter") \(filterVal.label ?? "")"
                    }
                    else if value < minVal || value > maxVal {
                        return "\(getLanguage["Enter range between"] ?? "Enter range between") \(minVal) - \(maxVal) \(getLanguage["for"] ?? "for") \(filterVal.label ?? "")"
                    }
                }
                else{
                    return "\(getLanguage["Enter"] ?? "Enter") \(filterVal.label ?? "")"
                }
            }
        }
        return ""
    }
    func changeFilterData() -> String? {
        self.updateFilterData = Utility.shared.filterStringToDict(ADD_EDIT_ITEM_MODEL.filters)
        var filterArray = [[String: String]]()
        for filterVal in filterData {
            if filterVal.type == "dropdown" {
                for id in updateFilterData?.dropdown ?? [FilterSubModel]() {
                    if let parentVal = filterVal.values.filter({$0.parentId == id.id && id.catType == filterVal.categoryType}).first {
                        let filterDict: [String: String] = ["parent_id": filterVal.id, "parent_label": filterVal.label, "type": "dropdown", "child_id": parentVal.parentId, "child_label": parentVal.parentLabel]
                        filterArray.append(filterDict)
                        break
                    }
                }
            }
            else if filterVal.type.lowercased() == "multilevel".lowercased() {
                for id in updateFilterData?.multilevel ?? [FilterSubModel]() {
                    if let subParent = filterVal.values.filter({$0.parentValues.contains(where: {$0.childId == id.id && filterVal.categoryType == id.catType})}).first {
                        if let child = subParent.parentValues.filter({$0.childId == id.id && filterVal.categoryType == id.catType}).first {
                            let filterDict: [String: String] = ["parent_id": filterVal.id, "parent_label": filterVal.label, "type": "multilevel", "child_id": child.childId, "child_label": child.childName, "subparent_id": subParent.parentId, "subparent_label": subParent.parentLabel]
                            filterArray.append(filterDict)
                            break
                        }
                    }
                }
            }
            else {
                if let child = updateFilterData?.range.filter({$0.id == filterVal.id}).first {
                    let filterDict: [String: String] = ["parent_id": filterVal.id, "parent_label": filterVal.label, "type": "range", "max_value": filterVal.maxValue, "min_value": filterVal.minValue, "value": child.max_value]
                    filterArray.append(filterDict)
                }
            }
        }
        return Utility.shared.dictToStringConversion(filterArray)
    }
}
extension AddProductViewController: AddProductPopupDelegate{
    func addProdctButtonAct(_ type: String) {
        self.dismiss(animated: true, completion: nil)
        if type == "success" {
            let pageObj = CreatePromotionViewController()
            pageObj.itemID = self.viewModel.addModel?.itemId ?? ""
            pageObj.isTabBar = true
            ADD_EDIT_ITEM_MODEL = AddEditViewModel()
            self.setStatusBarBackgroundColor(color: UIColor(named: "AppThemeColor") ?? .white)
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else{
            let pageObj = ViewProfileViewController()
            pageObj.userId = UserDefaultModule.shared.getUserData()?.user_id ?? ""
            pageObj.isTabBar = true
            ADD_EDIT_ITEM_MODEL = AddEditViewModel()
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
}
extension AddProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 6 {
            return self.filterData.count
        }
        if section == 8 && ((self.selectedCategory?.productCondition ?? "") == "enable" || ((self.selectedCategory?.exchangeBuy ?? "") == "enable") || ((self.selectedCategory?.makeOffer ?? "") == "enable")) {
            return 3
        }
        if section == 9 {
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 5 || indexPath.section == 7 || indexPath.section == 10 {
            // Section == 0 -> image scroll, Section == 1 -> Product title, Section == 2 -> description, Section == 5 -> Category, Section == 7 -> Location, Section == 10 -> Youtube link
            return UITableView.automaticDimension
        }
        else if indexPath.section == 3 {
            if (ADMIN_VIEW_MODEL.adminModel?.result.givingAway ?? "") == "enable" {
                return UITableView.automaticDimension
            }
            else {
                ADD_EDIT_ITEM_MODEL.giving_away = false
            }
        }
        else if indexPath.section == 4 {
            // Price Section
            if !ADD_EDIT_ITEM_MODEL.giving_away || (ADMIN_VIEW_MODEL.adminModel?.result.givingAway ?? "") == "disable" {
                return UITableView.automaticDimension
            }
        }
        else if indexPath.section == 6 && self.filterData.count > 0 {
            // Category Filter
            return UITableView.automaticDimension
        }
        else if indexPath.section == 8 {
            if (indexPath.row == 0 && (self.selectedCategory?.productCondition ?? "") == "enable") || (indexPath.row == 1 && ((self.selectedCategory?.exchangeBuy ?? "") == "enable")) || (indexPath.row == 2 && (self.selectedCategory?.makeOffer ?? "") == "enable" && !ADD_EDIT_ITEM_MODEL.giving_away) {
                return UITableView.automaticDimension
            }
        }
        else if indexPath.section == 9 {
            if indexPath.row == 0 {
                if (self.selectedCategory?.instantBuy ?? "" == "enable" && !ADD_EDIT_ITEM_MODEL.giving_away) {
                    return UITableView.automaticDimension
                }
            }
            else if indexPath.row == 1 && (self.selectedCategory?.instantBuy ?? "" == "enable" && ADD_EDIT_ITEM_MODEL.instant_buy && !ADD_EDIT_ITEM_MODEL.giving_away) {
                return UITableView.automaticDimension
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 || section == 2 || section == 5 || section == 7 || section == 10 {
            return 8
        }
        else if section == 3 {
            if (ADMIN_VIEW_MODEL.adminModel?.result.givingAway ?? "") == "enable" {
                return 8
            }
        }
        else if section == 4 {
            // Price Section
            if !ADD_EDIT_ITEM_MODEL.giving_away || (ADMIN_VIEW_MODEL.adminModel?.result.givingAway ?? "") == "disable" {
                return 8
            }
        }
        else if section == 6 && self.filterData.count > 0 {
            // Category Filter
            return 8
        }
        else if section == 8 && ((self.selectedCategory?.productCondition ?? "") == "enable" || ((self.selectedCategory?.exchangeBuy ?? "") == "enable") || ((self.selectedCategory?.makeOffer ?? "") == "enable" && !ADD_EDIT_ITEM_MODEL.giving_away)) {
            return 8
        }
        else if (self.selectedCategory?.instantBuy ?? "" == "enable" && !ADD_EDIT_ITEM_MODEL.giving_away) {
            return 8
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddProductTableViewCell") as! AddProductTableViewCell
        cell.delegate = self
        if indexPath.section == 0 {
            cell.loadImageData(imageArr: self.imageArray)
        }
        else if indexPath.section == 6 && self.filterData.count > 0 {
            self.updateFilterData = Utility.shared.filterStringToDict(ADD_EDIT_ITEM_MODEL.filters)
            cell.updateFilterData = self.updateFilterData
            cell.loadFilterData(self.filterData[indexPath.row], index: indexPath)
        }
        else {
            cell.loadData(index: indexPath)
        }   
        cell.isHidden = false
        if indexPath.section == 3 {
            //Giving Away
            if (ADMIN_VIEW_MODEL.adminModel?.result.givingAway ?? "") != "enable" {
                cell.isHidden = true
            }
        }
        else if indexPath.section == 4 && (ADD_EDIT_ITEM_MODEL.giving_away && (ADMIN_VIEW_MODEL.adminModel?.result.givingAway ?? "") == "enable"){
            // Price Section
            cell.isHidden = true
        }
        else if indexPath.section == 8 {
            if (indexPath.row == 0 && (self.selectedCategory?.productCondition ?? "") != "enable") || (indexPath.row == 1 && ((self.selectedCategory?.exchangeBuy ?? "") != "enable")) || (indexPath.row == 2 && ((self.selectedCategory?.makeOffer ?? "") != "enable" || ADD_EDIT_ITEM_MODEL.giving_away)) {
                cell.isHidden = true
            }
        }
        else if indexPath.section == 9 && ((indexPath.row == 0 && (self.selectedCategory?.instantBuy ?? "") != "enable" || ADD_EDIT_ITEM_MODEL.giving_away) || (indexPath.row == 1 && !ADD_EDIT_ITEM_MODEL.instant_buy)) {
            cell.isHidden = true
        }
        cell.switchControl.addTarget(self, action: #selector(self.switchAct(_:)), for: .touchUpInside)
        cell.dropDownButton.addTarget(self, action: #selector(self.configDropDownView(_:)), for: .touchUpInside)
        return cell
    }
    @objc func switchAct(_ sender: UISwitch) {
        let section = sender.tag / 10
        let row = sender.tag % 10
        if section == 3 {
            // Update Given Away Value
            ADD_EDIT_ITEM_MODEL.giving_away = sender.isOn
            ADD_EDIT_ITEM_MODEL.price = ""
            ADD_EDIT_ITEM_MODEL.make_offer = (sender.isOn == true) ? 2 : 0
            ADD_EDIT_ITEM_MODEL.instant_buy = false
        }
        else if section == 8 {
            if row == 1 {
                // Update Exchange to Buy Value
                ADD_EDIT_ITEM_MODEL.exchange_to_buy = sender.isOn
            }
            else {
                // Update Fixed Price Value
                let offerVal = sender.isOn == true ? 1 : 0
                ADD_EDIT_ITEM_MODEL.make_offer = offerVal
            }
        }
        else if section == 9 {
            ADD_EDIT_ITEM_MODEL.instant_buy = sender.isOn
        }
        self.tableView.reloadData()
    }
    @objc func configDropDownView(_ sender: UIButton) {
        if sender.tag == 0 {
            dropDown.anchorView = sender
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
            dropDown.width = 100
            dropDown.semanticContentAttribute = .unspecified
            dropDown.dataSource = ADMIN_VIEW_MODEL.productBeforeModel?.result.currency.map({$0.symbol}) ?? [String]()
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                ADD_EDIT_ITEM_MODEL.currency = "\(ADMIN_VIEW_MODEL.productBeforeModel?.result.currency[index].symbol ?? "")"
                sender.setTitle(item, for: .normal)
            }
            dropDown.show()
        }
        else {
            dropDown.hide()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.updateFilterData = Utility.shared.filterStringToDict(ADD_EDIT_ITEM_MODEL.filters ?? "")
        if indexPath.section == 5 {
            let pageObj = CategoryViewController()
            pageObj.isFromFilter = false
            pageObj.CategoryDetails = CategoryDetailsModel(Category_id: ADD_EDIT_ITEM_MODEL.category, subcategory_id: ADD_EDIT_ITEM_MODEL.subcategory, child_category_id: ADD_EDIT_ITEM_MODEL.child_category)
            pageObj.delegate = self
            pageObj.categoryViewType = 1
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else if indexPath.section == 6{
            if self.filterData[indexPath.row].type != "range" {
                let pageObj = ProductConditionViewController()
                pageObj.isProductCondition = false
                pageObj.productDelegate = self
                pageObj.updateFilterData = self.updateFilterData
                pageObj.categoryFilter = self.filterData[indexPath.row]
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
        }
        else if indexPath.section == 7 {
            // MARK: Mabbox Addon
            /*
            let pageObj = MapViewController()
            pageObj.lat = ADD_EDIT_ITEM_MODEL.lat
            pageObj.long = ADD_EDIT_ITEM_MODEL.lon
            pageObj.locationString = ADD_EDIT_ITEM_MODEL.address
            pageObj.delegate = self
            pageObj.viewType = "addProduct"
            self.navigationController?.pushViewController(pageObj, animated: true)
             */
            
            let pageObj = LocationViewController()
            pageObj.locationString = ADD_EDIT_ITEM_MODEL.address
            pageObj.delegate = self
            pageObj.viewType = "addProduct"
            self.navigationController?.pushViewController(pageObj, animated: true)
    
        }
        else if indexPath.section == 8  && indexPath.row == 0{
            let pageObj = ProductConditionViewController()
            pageObj.productDelegate = self
            pageObj.selectedProductCondition = ADD_EDIT_ITEM_MODEL.item_condition
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
    
}
extension AddProductViewController: CategoryDelegate {
    func locationAct(city: String, state: String, country: String, countryCode:String, lat: String, long: String, location: String) {
        ADD_EDIT_ITEM_MODEL.address = location
        ADD_EDIT_ITEM_MODEL.lat = lat
        ADD_EDIT_ITEM_MODEL.lon = long
        ADD_EDIT_ITEM_MODEL.state = state
        print("country \(ADMIN_VIEW_MODEL.productBeforeModel?.result.country)")
        if let countryDetails = ADMIN_VIEW_MODEL.productBeforeModel?.result.country.filter({$0.countryName.lowercased() == country.lowercased()}).first {
            ADD_EDIT_ITEM_MODEL.country_id = "\(countryDetails.countryId ?? 0)"
        }
        self.tableView.reloadData()
    }
    func updateCategoryData(_ searchData: CategoryDetailsModel) {
        ADD_EDIT_ITEM_MODEL.category = searchData.Category_id
        ADD_EDIT_ITEM_MODEL.subcategory = searchData.subcategory_id
        ADD_EDIT_ITEM_MODEL.child_category = searchData.child_category_id
        ADD_EDIT_ITEM_MODEL.filters = ""
        self.tableView.reloadData()
    }
}
extension AddProductViewController: ProductConditionDelegate, AddProductDelegate {
    func updateFilterData(_ updateFilterData: UpdateFilterModel) {
        self.updateFilterData = updateFilterData
        ADD_EDIT_ITEM_MODEL.filters = Utility.shared.filterDictToString(updateFilterData)
        self.tableView.reloadData()
    }
    func updateProductCondition(_ productCondition: String) {
        ADD_EDIT_ITEM_MODEL.item_condition = productCondition
        self.tableView.reloadData()
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
            DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
                self.presentInterstitialAds()
            }
        }
        )
 */
    }
    func presentInterstitialAds() {
        /*
        if interstitial != nil {
            print("Ad was ready")
            interstitial?.present(fromRootViewController: self.view.window?.rootViewController ?? self)
          } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.presentInterstitialAds()
            }
            print("Ad wasn't ready")
          }
         */
    }
    func didSelectAddImageButtonAct(_ isAdd: Bool, tag: Int) {
        self.loadAds()
        if isAdd {
            self.view.endEditing(true)
            let pageObj = CameraViewController()
            pageObj.isTabBar = false
            pageObj.addProductVC = self
            pageObj.imageArray = self.imageArray
            pageObj.removedArray = self.removeArray
            pageObj.selectedImageArray = self.imageArray
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else {
            if self.imageArray.count > tag {
                if self.imageArray[tag].isuploaded {
                    self.removeArray.append(self.imageArray[tag])
                }
                self.imageArray.remove(at: tag)
                self.tableView.reloadData()
            }
        }
    }
}
/*
extension AddProductViewController: GADFullScreenContentDelegate {
    
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
}
*/
