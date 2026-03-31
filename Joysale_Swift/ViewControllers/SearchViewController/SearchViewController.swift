//
//  SearchViewController.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 15/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import Stripe
import MXSegmentedPager

protocol SearchDelegate {
    func updateSearchData(_ searchData: FilterDataModel)
}

class SearchViewController: UIViewController {
    @IBOutlet weak var noItemDesLabel: UILabel!
    @IBOutlet weak var noItemTitleLabel: UILabel!
    @IBOutlet weak var noItemStackView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var productBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var tabview: UIView!
    
    @IBOutlet var profileBtn: UIButton!
    
    
    @IBOutlet weak var UserLineView: UIView!
    
    @IBOutlet weak var ProductLineView: UIView!
    
    //global variables
    //Adiing
    var ButtonArray = [UIButton]()
    var searchArray = [String]()
    var userArray = [String]()
    var profileuserarray = [searchresmodel]()
    
    //void userArray
    // If VC from filterViewController FILTER_DATA value be updated
    /*
     ViewType == 0 -> List Title Search || -> Category ||
     viewType == 2 -> Category Filter  || viewType == 3 -> Product Condition
     */
    
    //Adding
    var searchuserdata = searchuserviewmodel()
    var updateFilterData: UpdateFilterModel?
    var viewType = 0
    var profile = false
    var searchDelegate: SearchDelegate?
    var isFromFilter = false
    var categoryFilter: ProductFilterModel?
    var viewModel = AdminViewModel()
    var selectedCategory: CategoryModel?
    var selectedSubIndex: Int!
    var isSearchFlag = false
    var filterCategory = [SubcategoryModel]()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var categoryData = FilterDataModel()
    var profileOrProduct = Bool()
    var searchEndEditing = false
  
    
    
    //view didload
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configUI()
        self.configtableview()
        self.changeToRTL()
        //var profileBtn = true
        self.showprofilelist(profileBtn)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    //MARK: -  Config
    
    func configUI() {
        self.view.addSubview(indicatorView)
        self.updateCategoryValues()
        self.noItemStackView.isHidden = true
        
        self.noItemTitleLabel.config(color: UIColor(named: "AppTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 15), align: .center, text: "sorry")
        self.noItemDesLabel.config(color: UIColor(named: "SecondaryTextColor"), font: UIFont(name: APP_FONT_REGULAR, size: 14), align: .center, text: "No users found")
        self.navigationController?.customNavigationBarView(title: "search", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 20), vc: self)
        if self.viewType == 1 {self.title = (self.selectedCategory?.categoryName ?? "")}
        else if self.viewType == 2 {self.title = (self.categoryFilter?.label) ?? ""}
        else if self.viewType == 3 {self.title = getLanguage["itemcondition"] ?? ""}
        self.navigationController?.customRightBarButtonView(title: "", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 14), imageName: "detail_back", isLeft: true, vc: self, transparantView: false)
        
        self.searchTextField.config(color: UIColor(named: "appblackcolor"), align: .left, placeHolder: "search", font: UIFont(name: APP_FONT_REGULAR, size: 15))
        ButtonArray = [profileBtn,productBtn]
       // profileBtn.tag = 100
       // productBtn.tag = 101
       // styleButtons(tag: 102)
        self.searchTextField.textFieldWithRightView(title: "", image: #imageLiteral(resourceName: "search_btn"))
        self.searchArray = UserDefaultModule.shared.getSearcgResult()
        /*1*/   self.tableView.estimatedSectionHeaderHeight = 45
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionFooterHeight = 10
        self.tableView.sectionFooterHeight = UITableView.automaticDimension
        self.searchTextField.cornerMiniumRadius()
        if self.viewType == 1 {self.loadData()}
        //self.searchTextField.becomeFirstResponder()
        
//                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//

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


    
    //MARK: - TableView Config
    func configtableview(){
        self.tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        self.tableView.delegate = self
        // self.tableView.datasource = self
        self.tableView.register(UINib(nibName: "FilterHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "FilterHeaderTableViewCell")
//        self.tableView.register(UINib(nibName: "profileTableViewCell", bundle: nil), forCellReuseIdentifier: "profileTableViewCell")
        self.tableView.register(UINib(nibName: "Profile_TableViewCell", bundle: nil), forCellReuseIdentifier: "Profile_TableViewCell")

        //self.tableview1.datasource = self
        
    }
    func changeToRTL() {
            
            if UserDefaultModule.shared.getAppLanguage() == "Arabic" {
           
                self.tabview.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.profileBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.productBtn.transform = CGAffineTransform(scaleX: -1, y:1)

            }
            else{
               // self.view.transform = .identity
                
                //self.profilename.transform = .identity
              //  self.profilename.textAlignment = .left
               // self.profileimageview.transform = .identity
            }
        }
    
    //MARK: - Button Actions
    
   //Adding
    @IBAction func showproductlist(_ sender: UIButton) {
        self.searchEndEditing = false
        self.searchTextField.text = ""
        self.searchTextField.endEditing(true)
       // self.searchTextField.config(color: UIColor(named: "appblackcolor"), align: .left, placeHolder: "search", font: UIFont(name: APP_FONT_REGULAR, size: 15))

     //   self.searchTextField.textFieldWithRightView(title: "", image: #imageLiteral(resourceName: "search_btn"))

        self.styleButtons(tag: sender.tag)
        self.profile = false
        self.tableView.reloadData()
        self.UserLineView.isHidden = true
        self.ProductLineView.isHidden = false
    }
    
    
    @IBAction func showprofilelist(_ sender: UIButton) {
        self.searchEndEditing = false
        self.searchTextField.text = ""
        self.searchTextField.endEditing(true)
        profile = true
        tableView.reloadData()
      //  self.searchTextField.config(color: UIColor(named: "appblackcolor"), align: .left, placeHolder: "search", font: UIFont(name: APP_FONT_REGULAR, size: 15))

       // self.searchTextField.textFieldWithRightView(title: "", image: #imageLiteral(resourceName: "search_btn"))

    self.styleButtons(tag: sender.tag)
        self.profile = true
        self.ProductLineView.isHidden = true
        self.UserLineView.isHidden = false
        

//        searchuserdata.getsearchuserData(user_id:UserDefaultModule.shared.getUserData()?.userId ?? "", suggestion_name:" ") { (status) in
//            if status {
//                self.profileOrProduct = true
//                self.profileuserarray.removeAll()
//                self.profileuserarray += self.searchuserdata.Searchusermodel!.user_list
//                self.tableView.reloadData()
//            }
//        } onFailure: { (error) in
//            print("error: \(error)")
//        }
    }
    
    //Adding
    
    func styleButtons(tag: Int) {
        let tag = tag
        ButtonArray.forEach{ (button) in
            if button.tag == tag {
                button.setTitleColor(UIColor(named: "AppThemeColor"), for: .normal)
                button.setBackgroundColor(color:.white, forState: .normal)
            } else {
                button.setTitleColor(.white, for: .normal)
                button.setBackgroundColor(color:UIColor(named: "AppThemeColor")! , forState: .normal)
            }}}
    
    func updateCategoryValues() {
        // Check is from FilterVC then update CategoryValue to FILTER_DATA
        if isFromFilter {self.categoryData = FILTER_DATA}
        else {//self.categoryData = ADD_EDIT_ITEM_MODEL
            
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: nil)
        //self.searchEndEditing(true)
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: nil)
    }
    
    
    
    
    
    
    func loadData() {
        
        if self.viewType != 0 {
            ADMIN_VIEW_MODEL.getAdminData(onSuccess: { (success) in
                                            /*1*/                    self.tableView.reloadData()})
                { (failure) in}}}
    
    
    
    
    ///this is showing previosly searched things
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 1 {
                if self.viewType == 2, let filters = self.updateFilterData {
                    categoryData.filters = Utility.shared.filterDictToString(filters)
                    self.searchDelegate?.updateSearchData(categoryData)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                self.searchDelegate?.updateSearchData(categoryData)
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    
    
    
    
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        var subCategorySet = [SubcategoryModel]()
        if let subCategoryArray = self.selectedCategory?.subcategory, subCategoryArray.count > 0 {
            subCategorySet = subCategoryArray
        }
        if subCategorySet.contains(where: {$0.subName.localizedCaseInsensitiveContains(sender.text!)}) {
            if subCategorySet.filter({i in filterCategory.contains(where: {i.subId == $0.subId})}).count == 0 {
                let filterVal = subCategorySet.filter({$0.subName.localizedCaseInsensitiveContains(sender.text!)})
                if let firstVal = filterVal.first {
                    filterCategory.append(firstVal)
                }
                
            }
        }
        if filterCategory.count > 0 && sender.text != "" {
            self.isSearchFlag = true
        }
        else {
            self.isSearchFlag = false
        }
        
        self.tableView.reloadData()
    }
    
}









//OUTSIDE FROM VIEWDIDLOAD





extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    //mark :- number of rows in section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //viewtype ==0(used to show number of rows after the search)
        if !profile{
            if self.viewType == 0 {
                if self.searchArray.count > 0
                {
                    return (self.searchArray.count + 1)                        }
                
                
                // return self.searchArray.count
            }
            //view type ==1
            else if self.viewType == 1
            {
                if selectedSubIndex != nil, section == selectedSubIndex
                {
                    if let childCategory = self.selectedCategory?.subcategory[section]
                    {
                        return childCategory.childCategory.count }
                }
            } //view type ==2
            else if self.viewType == 2 {
                if self.categoryFilter?.type == "multilevel" && selectedSubIndex != nil {
                    return (self.categoryFilter?.values[section].parentValues.count ?? 0)
                }
                else {
                    return 0
                }
            }
            
        }
        else{
                        return profileuserarray.count
                    }
        return 0
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !profile{  if self.viewType == 0 {
            return 1
        }
        else {
            if !isSearchFlag {
                if self.viewType == 1{
                    return (self.selectedCategory?.subcategory.count ?? 0)
                }
                else if self.viewType == 2 {
                    return (self.categoryFilter?.values.count ?? 0)
                }
                else if self.viewType == 3 {
                    return (ADMIN_VIEW_MODEL.productBeforeModel?.result.productCondition.count ?? 0)
                }
            }
            else {
                if self.viewType == 1{
                    return self.filterCategory.count
                }
                else if self.viewType == 2 {
                    
                }
                
            }}
        
        }
        else {
//            return self.searchuserdata.Searchusermodel!.user_list.count
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !profile{
            return 50
        }
        else
        {
            return 60
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !profile{
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FilterHeaderTableViewCell") as! FilterHeaderTableViewCell
            if self.viewType == 0 {
                
                return nil
            }
            else {
                
                cell.headerLabel.textColor = UIColor(named: "AppTextColor")
                cell.overAllView.backgroundColor = UIColor(named: "whitecolor")
                cell.checkImageView.isHidden = true
                cell.arrowImageView.isHidden = true
                if self.viewType == 1 {
                    if self.isSearchFlag {
                        cell.headerLabel.text = self.filterCategory[section].subName ?? ""
                    }
                    else{
                        cell.headerLabel.text = self.selectedCategory?.subcategory[section].subName ?? ""
                        
                    }
                    if (self.selectedCategory?.subcategory[section].childCategory.count ?? 0) > 0 {
                        cell.arrowImageView.isHidden = false
                    }
                    
                    if self.selectedSubIndex == section {
                        cell.checkImageView.isHidden = false
                    }
                }
                else if self.viewType == 2 {
                    cell.headerLabel.text = self.categoryFilter?.values[section].parentLabel
                    if self.updateFilterData?.dropdown.contains(where: {$0.id == self.categoryFilter?.values[section].parentId && $0.catType == self.categoryFilter?.categoryType}) ?? false {
                        cell.headerLabel.textColor = UIColor(named: "AppThemeColor")
                    }
                    if (self.categoryFilter?.values[section].parentValues.count ?? 0) > 0 {
                        cell.arrowImageView.isHidden = false
                        if (self.updateFilterData?.dropdown.filter({i in (self.categoryFilter?.values[section].parentValues.contains(where: {i.id == $0.childId}) ?? false && i.catType == self.categoryFilter?.categoryType)}).count ?? 0) > 0 {
                            cell.headerLabel.textColor = UIColor(named: "AppThemeColor")
                        }
                    }
                }
                else if self.viewType == 3 {
                    cell.arrowImageView.isHidden = false
                    cell.headerLabel.text = ADMIN_VIEW_MODEL.productBeforeModel?.result.productCondition[section].name ?? ""
                    if categoryData.product_condition == (cell.headerLabel.text!) {
                        cell.headerLabel.textColor = UIColor(named: "AppThemeColor")
                    }
                }
                cell.contentView.tag = section
                cell.contentView.isUserInteractionEnabled = true
                cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sectionHeaderAct(_:))))
                
            }
            return cell
            
        }
        else{
            
            //Adiing
            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableViewCell") as! profileTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "Profile_TableViewCell") as! Profile_TableViewCell

            return cell
        }
        
    }
    @objc func sectionHeaderAct(_ tap: UITapGestureRecognizer) {
        let tapView = tap.view
        
        if self.viewType == 1 {
            self.selectedSubIndex = tapView?.tag ?? 0
            /*1*/             self.tableView.reloadData()
            categoryData.Category_id = "\(self.selectedCategory?.categoryId ?? 0)"
            if let subcategory = self.selectedCategory?.subcategory[selectedSubIndex] {
                categoryData.subcategory_id = "\(subcategory.subId ?? 0)"
                if subcategory.childCategory.count == 0 {
                    UserDefaultModule.shared.setFilterData(FILTER_DATA)
                    FILTER_DATA = categoryData
                    delegate.setInitialViewController(initialView: TabbarController())
                }
            }
        }
        else if self.viewType == 2 {
            self.selectedSubIndex = tapView?.tag ?? 0
            if let values = self.categoryFilter?.values[self.selectedSubIndex] {
                if values.parentValues.count == 0 {
                    if !(self.updateFilterData?.dropdown.contains(where: {$0.id == values.parentId && $0.catType == (self.categoryFilter?.type ?? "")}) ?? false) {
                        self.updateFilterData?.dropdown.append(FilterSubModel(catType: (self.categoryFilter?.type ?? ""), id: values.parentId))
                    }
                }
            }
            /*1*/             self.tableView.reloadData()
            self.addRightView()
        }
        else if self.viewType == 3 {
            categoryData.product_condition = ADMIN_VIEW_MODEL.productBeforeModel?.result.productCondition[tapView?.tag ?? 0].name ?? ""
            self.searchDelegate?.updateSearchData(categoryData)
            self.navigationController?.popViewController(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()

        if !profile{
            let customecell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
            self.noItemStackView.isHidden = true
            customecell.searchStackView.spacing = 10


            if self.viewType == 0 {
                if indexPath.row < self.searchArray.count {
                    customecell.searchImageView.image = #imageLiteral(resourceName: "clock")
                    customecell.searchLabel.text = self.searchArray[indexPath.row]
                }
                else {
                    customecell.searchImageView.image = #imageLiteral(resourceName: "close-gray")
                    customecell.searchLabel.text = getLanguage["Clear History"]
                }
            }
            else if self.viewType == 1 {
                if let subcategory = self.selectedCategory?.subcategory[indexPath.section] {
                    customecell.loadCategoryData(subcategory.childCategory[indexPath.row].childName)
                }
            }
            else if self.viewType == 2 {
                if let value = self.categoryFilter?.values[indexPath.section] {
                    customecell.searchLabel.textColor = UIColor(named: "appblackcolor")
                    customecell.loadCategoryData(value.parentValues[indexPath.row].childName)
                    if (self.updateFilterData?.dropdown.filter({i in (value.parentValues.contains(where: {i.id == $0.childId && i.catType == (self.categoryFilter?.categoryType ?? "")}))}).count ?? 0) > 0 {
                        customecell.searchLabel.textColor = UIColor(named: "AppThemeColor")
                    }
                }
            }
            cell = customecell
        }
       else
        {
            //Adding
            
//            let profilecell = tableView.dequeueReusableCell(withIdentifier: "profileTableViewCell")as! profileTableViewCell
            let profilecell = tableView.dequeueReusableCell(withIdentifier: "Profile_TableViewCell")as! Profile_TableViewCell
            
            cell.selectionStyle = .none

            if self.profileuserarray.count>indexPath.row{
                profilecell.loadData(self.profileuserarray[indexPath.row])
            }
            cell = profilecell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !profile{ if self.viewType == 0 {
            if indexPath.row < self.searchArray.count {
                categoryData.Search_key = self.searchArray[indexPath.row]
                IS_FILTER_FOUND = true
                self.searchDelegate?.updateSearchData(categoryData)
                self.navigationController?.popViewController(animated: true)
            }
            else {
                IS_FILTER_FOUND = false
                self.searchArray.removeAll()
                UserDefaultModule.shared.setSearchResult(self.searchArray)
                categoryData.Search_key = ""
                //                self.searchDelegate?.updateSearchData(categoryData)
                /*1*/                self.tableView.reloadData()
            }
        }
        else if self.viewType == 1 {
            if let subcategory = self.selectedCategory?.subcategory[selectedSubIndex], subcategory.childCategory.count > indexPath.row {
                categoryData.child_category_id = "\(subcategory.childCategory[indexPath.row].childId ?? 0)"
                FILTER_DATA = categoryData
                delegate.setInitialViewController(initialView: TabbarController())
            }
        }
        else if self.viewType == 2 {
            if let values = self.categoryFilter?.values[self.selectedSubIndex] {
                if values.parentValues.count > indexPath.row {
                    if !(self.updateFilterData?.dropdown.contains(where: {i in (values.parentValues[indexPath.row].childId == i.id && (self.categoryFilter?.categoryType ?? "") == i.catType)}) ?? false) {
                        self.updateFilterData?.dropdown.append(FilterSubModel(catType: (self.categoryFilter?.categoryType ?? ""), id: values.parentValues[indexPath.row].childId))
                    }
                }
            }
            self.addRightView()
        }}
        else
        {
            /*let dict = profileuserarray[indexPath.row]
             if let userid = dict["userId"] as?String ,
             userid != UserDefaultModule.shared.userId(){
             let otherprofile =
             }*/
            
            
            /*  let pageObj = ViewProfileViewController()
             pageObj.userId = profileuserarray[indexPath.row].user_id
             self.navigationController?.pushViewController(pageObj, animated: true)*/
            
            let pageObj = ViewProfileViewController()
            pageObj.userId = profileuserarray[indexPath.row].user_id
            self.navigationController?.pushViewController(pageObj, animated: true)
            
        }
        
        
        
    }
    func addRightView() {
        if (self.updateFilterData?.dropdown.count ?? 0) > 0 {
            self.navigationController?.customRightBarButtonView(title: "", fColor:"AppThemeColor", fontName: UIFont(name: APP_FONT_BOLD, size: 12), imageName: "select-tick-white", isLeft: false, vc: self, transparantView: false)
        }
        else {
            self.navigationController?.customRightBarButtonView(title: "", fColor: "", fontName: UIFont(name: APP_FONT_BOLD, size: 12), imageName: "", isLeft: false, vc: self, transparantView: false)}}
    
}







extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
       if self.viewType == 1 {
            
        }
        if !profile{   if self.viewType == 0 {
            if textField.text != "" {
              // self.searchArray.append(textField.text!)
                //IS_FILTER_FOUND = true
               // UserDefaultModule.shared.setSearchResult(self.searchArray)
                //categoryData.Search_key = textField.text!
                //self.searchDelegate?.updateSearchData(categoryData)
               // self.navigationController?.popViewController(animated: true)
            }
        }}
        else
        {
           // var combinedtext = ""
            var combinedtext:String = textField.text!
            if(string==""){
                combinedtext = textField.text ?? ""
                combinedtext = String(combinedtext.dropLast())
            }else{
                combinedtext = textField.text! + string
                //combinedtext = String(combinedtext.dropLast())
            }
            searchuserdata.getsearchuserData(user_id: UserDefaultModule.shared.getUserData()?.user_id ?? "", suggestion_name: combinedtext ) { (status) in
                if status {
                    self.profileOrProduct = true
                    self.profileuserarray.removeAll()
                    self.profileuserarray = self.searchuserdata.Searchusermodel!.user_list

                    if(self.profileuserarray.count == 0){
                        self.noItemStackView.isHidden = false
                   }

                    else{
                        self.noItemStackView.isHidden = true
                    }
                    self.tableView.reloadData()
                }else{
                    self.profileuserarray.removeAll()
                    self.noItemStackView.isHidden = false
                    self.tableView.reloadData()
                }
            } onFailure: { (error) in
                print("error: \(error)")
                self.noItemStackView.isHidden = false

            }
            
            /* searchuserdata.getsearchuserData(user_id: UserDefaultModule.shared.getUserData()?.userId ?? "", suggestion_name: textField.text??  "") { (status) in}*/
            
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.placeholder = getLanguage["search"] ?? "search"
       // if self.searchEndEditing{
       // self.searchEndEditing = true
       // }else
        //{
        if !profile{   if self.viewType == 0 {
            if textField.text != "" {
                               self.searchArray.append(textField.text!)
                                IS_FILTER_FOUND = true
                                UserDefaultModule.shared.setSearchResult(self.searchArray)
                                categoryData.Search_key = textField.text!
                                self.searchDelegate?.updateSearchData(categoryData)
                                self.navigationController?.popViewController(animated: true)}

        }}
        else
        {
            searchuserdata.getsearchuserData(user_id: UserDefaultModule.shared.getUserData()?.user_id ?? "", suggestion_name: textField.text ?? "") { (status) in
                if status {
                    self.profileOrProduct = true
                   // self.profileuserarray.removeAll()
                    self.profileuserarray = self.searchuserdata.Searchusermodel!.user_list

                    if(self.profileuserarray.count == 0){

                        self.noItemStackView.isHidden = false
                    }

                else{
                        self.noItemStackView.isHidden = true
                    }
                    self.tableView.reloadData()
                }else{
                    self.profileuserarray.removeAll()
                    self.noItemStackView.isHidden = false
                    self.tableView.reloadData()
                }
            } onFailure: { (error) in
                print("error: \(error)")
                self.noItemStackView.isHidden = false

            }
//
            /* searchuserdata.getsearchuserData(user_id: UserDefaultModule.shared.getUserData()?.userId ?? "", suggestion_name: textField.text??  "") { (status) in}*/
            
        }
        }
    }

//}

