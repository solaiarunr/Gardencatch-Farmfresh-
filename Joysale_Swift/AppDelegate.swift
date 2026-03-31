//
//  AppDelegate.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 05/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import CoreLocation
import GoogleMaps
import GooglePlaces
import Stripe
import Firebase
import SwiftyJSON
import SafariServices
import FirebaseMessaging
import UserNotifications
//import PushKit
//import CallKit
import AVFoundation
import AVKit


//
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation!
    var currentLocation: CLPlacemark?
    lazy var geocoder = CLGeocoder()
    var navigationController = UINavigationController()
    var deviceTokenString = ""
    var newlanguagecodevalue = String()
    var chattranslate = String()
    var chattranslateCode = String()
    var GoogelMapKey = String()
    
    
    // CALL DECLARATION
    /*
    var callStarted = Bool()
    var baseUUId = UUID()
    var callStatus : String!
    var callController = CXCallController()
    var provider: CXProvider!
    /// The app's provider configuration, representing its CallKit capabilities.
    static let providerConfiguration: CXProviderConfiguration = {
        let localizedName = NSLocalizedString("Calling From", comment: "Joysale")
        let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)

        // Prevents multiple calls from being grouped.
        providerConfiguration.maximumCallsPerCallGroup = 1
        
        providerConfiguration.supportsVideo = true
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        return providerConfiguration
    }()
    var callKitPopup = false
    var currentCallerID = String()
    var isAlreadyInCall = false
    var callNotifyDict: JSON!
     */
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        if #available(iOS 15, *) {
//                    let appearance = UINavigationBarAppearance()
//                    appearance.configureWithOpaqueBackground()
//                    appearance.backgroundColor = UIColor(named: "AppThemeColor")
//                    UINavigationBar.appearance().standardAppearance = appearance
//                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
//                }
//        
        
        UserDefaults.standard.set(APP_RTC_URL, forKey: "web_rtc_web")
        window = UIWindow(frame: UIScreen.main.bounds)
//        FULL_WIDTH = self.window?.frame.width ?? UIScreen.main.bounds.width
//        FULL_HEIGHT = self.window?.frame.height ?? UIScreen.main.bounds.height
        NetStatus.shared.startMonitoring()
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_KEY
//        GMSServices.provideAPIKey(GOOGLE_API_KEY)
//        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Utility.shared.configureLanguage()
        UserDefaults.standard.set([DEFAULT_LANGUAGE_CODE], forKey: "AppleLanguages")
        self.loadAdminData()
        self.registerForPushNotification(application)
        self.setInitialViewController()
        
        
        // Navigation title color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: APP_FONT_REGULAR, size: 20) ?? UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor(named: "whitecolor") ?? .black]
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        return true
    }
    func setInitialViewController() {
        let filterVal = UserDefaultModule.shared.getFilterData()
        if filterVal.location != "" && filterVal.location.lowercased() != "worldwide" && filterVal.location.lowercased() != CURRENT_LOCATION.lowercased() {
            FILTER_DATA.city = filterVal.city
            FILTER_DATA.state = filterVal.state
            FILTER_DATA.country = filterVal.country
            FILTER_DATA.location = filterVal.location
            FILTER_DATA.lat = filterVal.lat
            FILTER_DATA.long = filterVal.long
        }
        else {
            FILTER_DATA.city = ""
            FILTER_DATA.state = ""
            FILTER_DATA.country = CURRENT_LOCATION
            FILTER_DATA.location = CURRENT_LOCATION
            FILTER_DATA.lat = ""
            FILTER_DATA.long = ""
            self.getCurrentLocation()
        }
        if #available(iOS 15, *) {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = UIColor(named: "AppThemeColor")
                    UINavigationBar.appearance().standardAppearance = appearance
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }
        if let userData = UserDefaultModule.shared.getUserData()?.user_id, (userData != "") {
            self.initVC(initialView: TabbarController())
        }
        else{
            if UserDefaultModule.shared.getAppFirst() == false {
                self.initVC(initialView: HelpViewController())
            }
            else {
                self.initVC(initialView: TabbarController())
            }
        }
    }
    //MARK: Register for push notification
    func registerForPushNotification(_ application: UIApplication)  {
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {granted, error in
          })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        // MARK: Audio and Video Call Addon
        /*
        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        voipRegistry.delegate = self
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        */
    }
    func initVC(initialView: UIViewController) {
        UserDefaultModule.shared.setFilterData(FILTER_DATA)
        self.getCurrentLocation()
        if let tabBarController = self.window!.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 0
        }
        self.navigationController = UINavigationController(rootViewController: initialView)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
    }
    func setInitialViewController(initialView: UIViewController)
    {
        let vc = initialView
        let window = UIWindow()
        self.window = window
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController = UINavigationController(rootViewController: initialView)
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
    }
    func getCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            self.locationManager.startUpdatingLocation()
            currentLoc = locationManager.location
            if currentLoc != nil {
                print(currentLoc.coordinate.latitude)
                print(currentLoc.coordinate.longitude)
                FILTER_DATA.lat = "\(currentLoc.coordinate.latitude)"
                FILTER_DATA.long = "\(currentLoc.coordinate.longitude)"
            }
            else {
                // MARK: Location based personalization
                FILTER_DATA.lat = ""
                FILTER_DATA.long = ""
            }
            
        }
    }
    
    func loadAdminData() {
        
        let group = DispatchGroup()
        group.enter()
        
        ADMIN_VIEW_MODEL.getAdminData(onSuccess: { (success) in
            StripeAPI.defaultPublishableKey = (ADMIN_VIEW_MODEL.adminModel?.result.stripePublicKey ?? "")
            self.GoogelMapKey = ADMIN_VIEW_MODEL.adminModel?.result.googlemapkey_ios ?? ""
            GMSServices.provideAPIKey(self.GoogelMapKey)
            GMSPlacesClient.provideAPIKey(self.GoogelMapKey)
            //Stripe.setDefaultPublishableKey(ADMIN_VIEW_MODEL.adminModel?.result.stripePublicKey ?? "")
            group.leave()
        }) { (failure) in
            group.leave()
        }
        group.enter()
        ADMIN_VIEW_MODEL.productBeforeAddData(onSuccess: { (success) in
            group.leave()
        }) { (failure) in
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            if ADMIN_VIEW_MODEL.productBeforeModel?.result != nil && ADMIN_VIEW_MODEL.adminModel?.result != nil{
                if FILTER_DATA.location != "" && FILTER_DATA.location.lowercased() != "worldwide" {
                    FILTER_DATA.distance = (ADMIN_VIEW_MODEL.productBeforeModel?.result.distance ?? "")
                    FILTER_DATA.isDistanceSlider = false
                    FILTER_DATA.distance_type = (ADMIN_VIEW_MODEL.adminModel?.result.distanceType ?? "")
                }
                DispatchQueue.main.async {
                    if ADMIN_VIEW_MODEL.adminModel?.status ?? false && (ADMIN_VIEW_MODEL.adminModel?.result.adminPaymentType ?? "") == "braintree"{
                        ADMIN_VIEW_MODEL.getBraintreeToken(currency_code: (ADMIN_VIEW_MODEL.adminModel?.result.adminCurrencyCode.trimmingCharacters(in: .whitespaces) ?? ""))
                    }
                }
            }
        }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        if ApplicationDelegate.shared.application(app,open: url,sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplication.OpenURLOptionsKey.annotation]) {
            return true
        }
        else if ((GIDSignIn.sharedInstance()?.handle(url))!){
            return true
        }
        return false
    }
    func applicationDidEnterBackground(_ application: UIApplication) {

//        SocketIOManager.sharedInstance.disconnect()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.getCurrentLocation()
        self.resetBadge()
//        SocketIOManager.sharedInstance.establishConnection()
    }
    func resetBadge() {
        DispatchQueue.main.async {
            ADMIN_VIEW_MODEL.resetBadge(deviceToken: (UserDefaultModule.shared.getFCMToken() ?? ""))
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
        if (UserDefaultModule.shared.getUserData()?.user_id ?? "") == "" {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        if (UserDefaultModule.shared.getUserData()?.user_id ?? "") == "" {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            self.locationManager.stopUpdatingLocation()
        }
    }
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placeMarker = placemarks?.first {
                self.currentLocation = placeMarker
                self.currentLoc = location
                if self.currentLoc != nil {
                    print("latt: location.coordinate.latitude")
                    print(location.coordinate.longitude)
                    FILTER_DATA.lat = "\(self.currentLoc.coordinate.latitude)"
                    FILTER_DATA.long = "\(self.currentLoc.coordinate.longitude)"
                }
                else {
                    // MARK: Location based personalization
                    FILTER_DATA.lat = ""
                    FILTER_DATA.long = ""
                }
                
            }
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    // authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case CLAuthorizationStatus.restricted: break
            case CLAuthorizationStatus.denied: break
            case CLAuthorizationStatus.notDetermined:break
            default:
                locationManager.startUpdatingLocation()
        }
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate,MessagingDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let FirebaseAuth = Auth.auth()
        if (FirebaseAuth.canHandleNotification(userInfo)){
            print(userInfo)
        }
        print("UserInfo \(userInfo)")
        let notificationData = JSON(userInfo)
        print(" NOTIFICATION \(notificationData)")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let jsonDict = JSON(response.notification.request.content.userInfo)
        print(jsonDict)
        let type = jsonDict["gcm.notification.type"].stringValue
        if type == "normal"{
            let pageObj = TabbarController()
            pageObj.selectedIndex = 3
            pageObj.isFromNotification = true
            navigationController = UINavigationController(rootViewController: pageObj)
            window!.rootViewController = navigationController
            window!.makeKeyAndVisible()
        }
        else {
            let pageObj = NotificationViewController()
            pageObj.isFromNotification = true
            navigationController = UINavigationController(rootViewController: pageObj)
            window!.rootViewController = navigationController
            window!.makeKeyAndVisible()
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let jsonDict = JSON(notification.request.content.userInfo)
        print(jsonDict)
        let type = jsonDict["gcm.notification.type"].stringValue
        let alertArray = jsonDict["aps","alert"].stringValue.components(separatedBy: " : ")
        if type == "message" || type == "exchange" || type == "normal" {
            if CURRENT_CHAT == alertArray.first ?? ""{
            }
            else {
                completionHandler([.alert, .badge, .sound])
            }
        }
        else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    func convertToString(_ userinfo: String) -> [String: AnyObject] {
        if userinfo != "" {
            let data = Data(userinfo.utf8)
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] {
                    // try to read out a string array
                    return json
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        return [userinfo:("" as AnyObject)]
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let FIRAUTH = Auth.auth()
        FIRAUTH.setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
        //FIRAUTH.setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
         Messaging.messaging().apnsToken = deviceToken
        self.deviceTokenString = deviceToken.hexString
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        UserDefaultModule.shared.setFCMToken(fcm_token: "\(fcmToken ?? "")")
        print("Firebase Token: \(fcmToken ?? "")")
        if ( UserDefaultModule.shared.getFCMToken() != nil) {
            self.addDeviceTokenToServer()
        }
        
    }
    func addDeviceTokenToServer() {
        if (UserDefaultModule.shared.getUserData()?.user_id ?? "") != "" {
            ADMIN_VIEW_MODEL.loadNotification(onSuccess: { (success) in
            }) { (failure) in
            }
        }
    }
}

/*
//MARK: - PKPushRegistryDelegate
extension AppDelegate : PKPushRegistryDelegate {
  
  // Handle updated push credentials
  func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
      print(credentials.token)
      //         let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
      let deviceTokenString = credentials.token.hexString
      print("PUSH KIT TOKEN \(deviceTokenString)")
    UserDefaultModule().setPushToken(fcm_token: deviceTokenString)
    if (UserDefaultModule().getFCMToken() != nil && UserDefaultModule().getPushToken() != nil){
        Utility.shared.registerPushServices()
   }
  }
  func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
      print("pushRegistry:didInvalidatePushTokenForType:")
  }
  func pushRegistry(_ registry: PKPushRegistry,
                    didReceiveIncomingPushWith payload: PKPushPayload,
                    for type: PKPushType,
                    completion: @escaping () -> Void) {
    print("PUSHKIT NOTIFICATION \(payload.dictionaryPayload)")
    if (UserDefaultModule.shared.getUserData()?.user_id ?? "") != "" {
        if type == .voIP {
            let jsonDict = JSON(payload.dictionaryPayload)
            self.callNotifyDict = jsonDict
            if jsonDict["aps","type"].stringValue == "audio" || jsonDict["aps","type"].stringValue == "video"  && !callKitPopup {
                if !isAlreadyInCall {
                    self.baseUUId = UUID()
                    self.provider.setDelegate(self, queue: nil)
                    let update = CXCallUpdate()
                    let username = jsonDict["aps","alert","user_name"].stringValue
                    update.remoteHandle = CXHandle(type: .generic, value: username)
                    if jsonDict["aps","type"].stringValue == "video" {
                        update.hasVideo = true
                    }
                    else {
                        update.hasVideo = false
                    }
                    self.provider.configuration.maximumCallsPerCallGroup = 1
                    self.provider.reportNewIncomingCall(with: self.baseUUId, update: update, completion: { error in })
                    self.callKitPopup = true
                }
            }
            else {
                self.callKitPopup = false
                self.endCall()
                if (window?.rootViewController?.isKind(of: CallViewController.self))! {
                    window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
                else {
                    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                    print("hello")
                    if var topController = keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                            if topController.isKind(of: CallViewController.self) {
                                window?.rootViewController?.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
  }
    func endCall() {
        self.isAlreadyInCall = false
        let endCallAction = CXEndCallAction(call:self.baseUUId)
        let transaction = CXTransaction(action: endCallAction)
        callController.request(transaction) { error in
            if error == nil {
                self.provider.reportCall(with: self.baseUUId, endedAt: Date(), reason: .remoteEnded)
                return
            }
            else {
                
            }
        }
        self.callStarted = false
        callKitPopup = false
    }
  
}
*/
/*
extension AppDelegate: CXProviderDelegate {
  func providerDidReset(_ provider: CXProvider) {
  }
  
  func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
    action.fulfill()
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSession.Category.playback)
    let pageobj = CallViewController()
    pageobj.receiverId =  self.callNotifyDict["aps","alert","user_id"].stringValue
    pageobj.room_id = self.callNotifyDict["aps","alert","room_id"].stringValue
    pageobj.receiverImage = self.callNotifyDict["aps","alert","user_image"].stringValue
    pageobj.receiverName = self.callNotifyDict["aps","alert","user_name"].stringValue
    pageobj.senderFlag = false
    pageobj.viewType = "2"
    pageobj.call_type = self.callNotifyDict["aps","type"].stringValue
    pageobj.modalPresentationStyle = .fullScreen
    self.window!.makeKeyAndVisible()
    self.window?.rootViewController?.present(pageobj, animated: true, completion: nil)
}
  
  func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
      action.fulfill()
      let viewModel = CallViewModel()
    viewModel.endCall(toId: self.callNotifyDict["aps","alert","user_id"].stringValue, fromId: (UserDefaultModule.shared.getUserData()?.user_id ?? ""), room_id: callNotifyDict["aps","alert","room_id"].stringValue, type: "bye", chatId: callNotifyDict["aps","alert","chat_id"].stringValue)
            self.window?.rootViewController?.view.makeToast("Call declined")
  }
 
}
*/
extension SFSafariViewController {
    override open var modalPresentationStyle: UIModalPresentationStyle {
        get { return .fullScreen}
        set { super.modalPresentationStyle = newValue }
    }
}
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
