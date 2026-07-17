//
//  HelpViewController.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 09/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var webStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var denyButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var headerLogo: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    
    var viewModel = HelpViewModel()
    var helpResult: HelpResultModel?
    var viewType = ""
    var donateContent = ""                                                              //MARK: Custom Work
    var isFromHelp = false
    private var helpWebView: WKWebView?
    private var selectedHelpPageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.viewType == "" {
            return .default
        }
          return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        if viewType != "" {
            self.navigationController?.isNavigationBarHidden = false
        }
        else {
            self.navigationController?.isNavigationBarHidden = true
        }
        
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
            else if self.isFromHelp && self.tableView.isHidden && viewType != "donate"{
                self.isFromHelp = false
                self.viewType = "help"
                self.helpResult = nil
                self.selectedHelpPageName = ""
                self.navigationController?.customNavigationBarView(title: getLanguage["help"] ?? "help", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 20), vc: self)
                self.helpWebView?.isHidden = true
                self.webStackView.isHidden = true
                self.tableView.isHidden = false
                self.textView.isHidden = true
                self.tableView.reloadData()
                Utility.shared.stopAnimation(viewController: self)
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.setContentOffset(CGPoint.zero, animated: false)
    }

    func configUI() {
        self.tableView.register(UINib(nibName: "HelpTableViewCell", bundle: nil), forCellReuseIdentifier: "HelpTableViewCell")
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 0
        self.denyButton.config(color: UIColor(named: "AppThemeColor"), font: UIFont(name: APP_FONT_BOLD, size: 15), align: .center, title: "deny")

        self.denyButton.setBorder(color: UIColor(named: "AppThemeColor"))
        self.denyButton.backgroundColor = UIColor(named: "whitecolor")
        self.acceptButton.config(color: UIColor(named: "whitecolor"), font: UIFont(name: APP_FONT_BOLD, size: 15), align: .center, title: "accept")
        self.textView.config(color: UIColor(named: "AppTextColor") ?? .black, font: UIFont(name: APP_FONT_REGULAR, size: 15), align: .left, text: "")
        self.textView.dataDetectorTypes = .link
        UITextView.appearance().linkTextAttributes = [ .foregroundColor: UIColor.blue ]

        self.acceptButton.backgroundColor = UIColor(named: "AppThemeColor")
        self.view.addSubview(indicatorView)
        self.backBtn.isHidden = true
        if !UserDefaultModule.shared.getAppFirst() {
            Utility.shared.startAnimation(viewController: self)
        }
        self.acceptButton.cornerMiniumRadius()
        if viewType == "" {
        }
        else {
            self.navigationController?.customNavigationBarView(title: getLanguage[self.viewType] ?? self.viewType, fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 20), vc: self)
            self.navigationController?.customRightBarButtonView(title: "", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 17), imageName: "detail_back", isLeft: true, vc: self, transparantView: false)
        }
        self.loadData()
    }
    
    private func ensureAdminDataLoaded(completion: @escaping () -> Void) {
        if let apiUrl = ADMIN_VIEW_MODEL.adminModel?.result?.api_url, !apiUrl.isEmpty {
            updateBaseURL(from: apiUrl)
            completion()
            return
        }
        ADMIN_VIEW_MODEL.getAdminData(onSuccess: { _ in
            completion()
        }) { _ in
            completion()
        }
    }
    
    func loadData() {
        self.textView.isHidden = false
        self.webStackView.isHidden = false
        self.tableView.isHidden = true
        if !isFromHelp {
            self.ensureAdminDataLoaded { [weak self] in
                self?.loadContentData()
            }
        }
        else if self.viewType == "donate"{                                  //MARK: Custom Work
            print("THIS ELSE IF FUNCTION")
            self.showHelpPageContent(self.donateContent)
        }
        else {
            self.showHelpPageContent(self.helpResult?.pageContent ?? "")
        }
    }
    
    private func loadContentData() {
            if viewType == "safety_tips" {
                self.headerView.isHidden = true
                self.bottomView.isHidden = true
                self.viewModel.getSaftyTips(onSuccess: { (success) in
                    print(success)
                    self.textView.attributedText = NSAttributedString(string: (self.viewModel.tosModel?.message ?? "").html2String, attributes: [NSAttributedString.Key.font: UIFont(name: APP_FONT_REGULAR, size: 15) ?? UIFont.systemFont(ofSize: 14)])
//                    self.textView.text = (self.viewModel.tosModel?.message ?? "").html2String
                    DispatchQueue.main.async {
                        self.textView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    Utility.shared.stopAnimation(viewController: self)
                }) { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
            }
            else if viewType == "privacy_policy"{
                self.headerLogo.isHidden = true
                self.bottomView.isHidden = true
                self.backBtn.isHidden = false
                self.viewModel.getPrivacyPolic(onSuccess: { (success) in
                    print(success)
                    self.textView.attributedText = NSAttributedString(string: (self.viewModel.tosModel?.message ?? "").html2String, attributes: [NSAttributedString.Key.font: UIFont(name: APP_FONT_REGULAR, size: 15) ?? UIFont.systemFont(ofSize: 14)])
//                    self.textView.text = (self.viewModel.tosModel?.message ?? "").html2String
                    DispatchQueue.main.async {
                        self.textView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    Utility.shared.stopAnimation(viewController: self)
                }) { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
            }
            else if viewType == "help" {
                self.headerView.isHidden = false
                self.bottomView.isHidden = false
                self.webStackView.isHidden = true
                self.tableView.isHidden = false
                self.textView.isHidden = true
                self.helpWebView?.isHidden = true
                self.viewModel.getHelpPageData(onSuccess: { (success) in
                    self.tableView.reloadData()
                    Utility.shared.stopAnimation(viewController: self)
                }) { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
            }
            else {
                self.viewModel.getTOSData(onSuccess: { (success) in
                    print(success)
                    self.textView.attributedText = NSAttributedString(string: (self.viewModel.tosModel?.message ?? "").html2String, attributes: [NSAttributedString.Key.font: UIFont(name: APP_FONT_REGULAR, size: 15) ?? UIFont.systemFont(ofSize: 14)])

//                    self.textView.text = (self.viewModel.tosModel?.message ?? "").html2String
                    DispatchQueue.main.async {
                        self.textView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    Utility.shared.stopAnimation(viewController: self)
                }) { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
            }
    }
    
    private func setupHelpWebViewIfNeeded() {
        guard self.helpWebView == nil else { return }
        
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isOpaque = true
        webView.backgroundColor = UIColor(named: "BackGroundColor") ?? .white
        webView.scrollView.backgroundColor = UIColor(named: "BackGroundColor") ?? .white
        webView.isHidden = true
        
        self.view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            webView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        self.helpWebView = webView
    }
    
    private func helpHTMLWrapper(_ pageContent: String) -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
        <style>
        body {
            font-family: '\(APP_FONT_REGULAR)', -apple-system, sans-serif;
            font-size: 15px;
            color: #000000;
            margin: 0;
            padding: 0 4px 16px;
            word-wrap: break-word;
        }
        img { max-width: 100%; height: auto; }
        iframe { max-width: 100%; }
        a { color: #0563c1; }
        </style>
        </head>
        <body>\(pageContent)</body>
        </html>
        """
    }
    
    private func showHelpPageContent(_ pageContent: String, pageName: String = "") {
        self.selectedHelpPageName = pageName
        self.tableView.isHidden = true
        self.webStackView.isHidden = true
        self.textView.isHidden = true
        
        guard !pageContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.helpWebView?.isHidden = true
            self.webStackView.isHidden = false
            self.textView.isHidden = false
            self.textView.text = getLanguage["sorry"] ?? "No content available"
            Utility.shared.stopAnimation(viewController: self)
            self.view.isUserInteractionEnabled = true
            return
        }
        
        self.setupHelpWebViewIfNeeded()
        self.helpWebView?.isHidden = false
        self.view.bringSubviewToFront(self.helpWebView!)
        self.helpWebView?.loadHTMLString(self.helpHTMLWrapper(pageContent), baseURL: URL(string: BASE_URL))
        Utility.shared.stopAnimation(viewController: self)
        self.view.isUserInteractionEnabled = true
    }
    @IBAction func acceptButtonAct(_ sender: Any) {
        UserDefaultModule.shared.setAppFirst(true)
        let delegate = UIApplication.shared.delegate as! AppDelegate

        FILTER_DATA.city = "\(delegate.currentLocation?.subLocality ?? "")"
        FILTER_DATA.state = "\(delegate.currentLocation?.administrativeArea ?? "")"
        FILTER_DATA.country = "\(delegate.currentLocation?.country ?? "")"
        if FILTER_DATA.city != "" && FILTER_DATA.state != "" && FILTER_DATA.country != "" {
            FILTER_DATA.location = "\(FILTER_DATA.city ?? ""), \(FILTER_DATA.state ?? ""), \(FILTER_DATA.country ?? "")"
            FILTER_DATA.lat = "\(delegate.currentLocation?.location?.coordinate.latitude ?? 0)"
            FILTER_DATA.long = "\(delegate.currentLocation?.location?.coordinate.longitude ?? 0)"
        }
        if FILTER_DATA.location != "" && FILTER_DATA.location.lowercased() != "worldwide" && FILTER_DATA.location.lowercased() != CURRENT_LOCATION {
            FILTER_DATA.distance = "\(Int(ADMIN_VIEW_MODEL.productBeforeModel?.result.distance ?? "200") ?? 200)"
            FILTER_DATA.distance_type = "\(ADMIN_VIEW_MODEL.productBeforeModel?.result.searchType ?? "")"
            FILTER_DATA.isDistanceSlider = false
        }
        UserDefaultModule.shared.setFilterData(FILTER_DATA)

        let vc = InitialViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func denyButtonAct(_ sender: UIButton) {
        exit(0);
    }
    
    @IBAction func backBtnAct(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
extension HelpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.viewModel.helpModel?.result.count ?? 0)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = #colorLiteral(red: 0.9567790627, green: 0.9569163918, blue: 0.956749022, alpha: 1)
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpTableViewCell") as! HelpTableViewCell
        cell.textLabel?.text = (self.viewModel.helpModel?.result[indexPath.section].pageName ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let helpResult = self.viewModel.helpModel?.result[indexPath.section] else { return }
        
        self.isFromHelp = true
        self.helpResult = helpResult
        self.viewType = helpResult.pageName ?? ""
        
        if self.viewType != "" {
            self.navigationController?.customNavigationBarView(title: getLanguage[self.viewType] ?? self.viewType, fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 20), vc: self)
            self.navigationController?.customRightBarButtonView(title: "", fColor: "whitecolor", fontName: UIFont(name: APP_FONT_REGULAR, size: 17), imageName: "detail_back", isLeft: true, vc: self, transparantView: false)
        }
        
        self.showHelpPageContent(helpResult.pageContent ?? "", pageName: helpResult.pageName ?? "")
    }
}
