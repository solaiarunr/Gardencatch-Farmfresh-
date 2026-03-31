//
//  CallParsingFunction.swift
//  Howzu_swift
//
//  Created by Hitasoft on 08/04/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import SystemConfiguration

public typealias Parameters = [String: Any]
public var isAlertPresented = false
class CallParsingFunction {
    // POST METHOD
    init() {
        self.notifyStatus()
    }
    public func postDataCall(subURl: String, params: Parameters, onSuccess success: @escaping (JSON) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let BaseUrl = SITE_URL+subURl
        var parameters = params
        parameters.merge(REST_AUTH){(_, new) in new}
        print("BASEURL: \(BaseUrl)")
        print("PARAMETER : \(parameters)")
        if NetStatus.shared.isConnected || subURl == ADMIN_DATAS_URL || subURl == PRODUCT_BEFORE_ADD_URL {
            AF.request(BaseUrl, method: .post, parameters: parameters, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json) URL: \(BaseUrl) PARAMS: \(parameters)")
                    if json["status"].stringValue == "error" {
                        
                        self.adminDisableAlert()
                    }
                    else {
                        success(json)
                    }
                case .failure(let error):
                    print(error)
                    print("hbhbdhbds")
                    failure(error)
                }
            }
        }
        else {
            self.showAlert()
        }
    }
    func adminDisableAlert() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        indicatorView.stopAnimating()
        UIView.appearance().isUserInteractionEnabled = true
        let alert = UIAlertController(title: nil, message: getLanguage["your_account_blocked_by_admin"] ?? "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: getLanguage["ok"], style: .default, handler: { (UIAlertAction) in
            let fcmToken = UserDefaultModule.shared.getFCMToken()
            let appFirst = UserDefaultModule.shared.getAppFirst()
            let appLanguage = UserDefaultModule.shared.getAppLanguage()
            let domain = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: domain ?? "")
            UserDefaults.standard.synchronize()
            UserDefaultModule.shared.setAppFirst(appFirst)
            UserDefaultModule.shared.setFCMToken(fcm_token: fcmToken ?? "")
            UserDefaultModule().setAppLanguage(language: appLanguage)
            delegate.initVC(initialView: InitialViewController())
        }))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    public func getDataCall(subURl: String, params: Parameters, onSuccess success: @escaping (JSON) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let BaseUrl = subURl
        var parameters = params
        parameters.merge(REST_AUTH){(_, new) in new}
        if NetStatus.shared.isConnected {
            AF.request(BaseUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    if json["status"].stringValue == "error" {
                        self.adminDisableAlert()
                    }
                    else {
                        success(json)
                    }
                case .failure(let error):
                    print(error)
                    failure(error)
                }
            }
        }
        else {
            self.showAlert()
        }
        
    }
    
//    public func uploadDoc(fileData:Data, uploaddoctype:String,fileName:String, type: String, onSuccess success: @escaping (ImageModel) -> Void, onFailure failure: @escaping (String) -> Void) {
//        let BaseUrl = URL(string: UPLOAD_IMAGE_URL)
//        print("BASE URL : \(UPLOAD_IMAGE_URL)")
//        var parameters = ["type":type] as [String : Any]
//        if UserDefaultModule.shared.getUserData()?.user_id != nil{
//            parameters["user_id"] = UserDefaultModule.shared.getUserData()?.user_id
//        }
//        print("REQUEST : \(parameters)")
//        print("data\(fileData)")
//        var mime_type = String()
//        if uploaddoctype == ".jpeg" || uploaddoctype.lowercased() == "jpeg"{
//            mime_type = "image/jpg"
//        }else{
//            mime_type = "application/pdf"
//        }
//
//        AF.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(fileData, withName: "images", fileName:fileName, mimeType: mime_type)
//            for (key, value) in parameters {
//                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
//            }
//        }, to:BaseUrl!,method:.post)
//        { (result) in
//            switch result {
//             case .success(let upload):
//                upload.uploadProgress(closure: { (progress) in
//                })
//                upload.responseJSON { response in
//                    let jsonVal = response.result.value as? NSDictionary
//                    print("RESPONSE \(response)")
//                    if jsonVal != nil {
//                        let json = JSON(jsonVal)
//                        let rootclass = ImageModel.init(fromJson: json)
//                        success(rootclass)
//                    }
//                    else {
//                        failure("failed")
//                    }
//                }
//                success(json)
//            case .failure(let error):
//                print("FAILURE RESPONSE: \(error.localizedDescription)")
//                if error._code == NSURLErrorTimedOut{
//
//                }else if error._code == NSURLErrorNotConnectedToInternet{
//                }else{
//                }
//                failure(error.localizedDescription)
//            }
//        }
//    }
    
    public func postResCall(subURl: String, params: Parameters, encodingType: ParameterEncoding = URLEncoding.httpBody,  onSuccess success: @escaping (JSON) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let BaseUrl = URL(string:subURl)
        print("BASE URL : \(subURl)")
        print("PARAMETER : \(params)")

        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Ios-Bundle-Identifier": (Bundle.main.bundleIdentifier ?? "")
        ]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        AF.request(BaseUrl!, method:.post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            //sucesss block
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                if json["status"].boolValue == false {
                    if json["message"].stringValue == "Your account is blocked, please contact Admin to unblock" {
                        let alertController = UIAlertController(title: "Joysale", message: json["message"].stringValue, preferredStyle: .actionSheet)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                            // appDelegate.setInitialViewController(initialView: SigninFrontPage())
                            ADMIN_VIEW_MODEL.pushSignout()
                        }
                        alertController.addAction(okAction)
                        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                    }
                }
                success(json)
            case .failure(let error):
                print(error)
                if error.localizedDescription == "The Internet connection appears to be offline." || error.localizedDescription == "Could not connect to the server." {
                    let alertController = UIAlertController(title: getLanguage["network_error"] ?? "", message: getLanguage["network_error"] ?? "", preferredStyle: .actionSheet)
                    
                    let okAction = UIAlertAction(title: getLanguage["cancel"] ?? "", style: .cancel, handler: nil)
                    let settingAction = UIAlertAction(title: getLanguage["settings"] ?? "", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                    alertController.addAction(settingAction)
                    alertController.addAction(okAction)
                    appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
                debugPrint(String(data: response.data!, encoding: String.Encoding.utf8) ?? "")
                failure(error)
            }
            
        }
    }
    public func uploadAudio(url: String,type: String,audioData:Data, onSuccess success: @escaping (JSON) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        var parameters = ["type":type]
        parameters.merge(REST_AUTH){(_, new) in new}
        // Image to upload:
        // Server address (replace this with the address of your own server):
        // Use Alamofire to upload the image
        if NetStatus.shared.isConnected {
            AF.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(audioData, withName: "audio" , fileName: "audio.wav", mimeType: "voice/m4a")
                for (key, value) in parameters {
                    multipartFormData.append((value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!), withName: key)
                }
            }, to: url, method: .post, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    if json["status"].stringValue == "error" {
                        self.adminDisableAlert()
                    }
                    else {
                        success(json)
                    }
                case .failure(let error):
                    print(error)
                    failure(error)
                }
            }
        }
        else {
            self.showAlert()
        }
    }
    public func uploadImage(url: String,type: String,image:UIImage?, onSuccess success: @escaping (JSON) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        var parameters = ["type":type]
        parameters.merge(REST_AUTH){(_, new) in new}
        let fixedImage = image?.fixedOrientation()
        var imageData = fixedImage!.jpegData(compressionQuality: 0.5)!
//        var isHeicSupported: Bool {
//            (CGImageDestinationCopyTypeIdentifiers() as! [String]).contains("public.heic")
//        }
//        if isHeicSupported, let heicData = image?.heic(compressionQuality: 0.5) {
//            print("is Heic Data")
//            imageData = heicData
//            // write your compressed heic image data to disk
//        }
        print("URL\(url)")
        print("parameters\(parameters)")
        // Image to upload:
        // Server address (replace this with the address of your own server):
        // Use Alamofire to upload the image
        if NetStatus.shared.isConnected {
            AF.upload(multipartFormData: { (multipartFormData) in
               
                multipartFormData.append(imageData, withName: "images" , fileName: "file.jpg", mimeType: "image/jpeg")
                for (key, value) in parameters {
                    multipartFormData.append((value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!), withName: key)
                }
                
            }, to: url, method: .post, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    if json["status"].stringValue == "error" {
                        self.adminDisableAlert()
                    }
                    else {
                        success(json)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    failure(error)
                }
            }
        }
        else {
            self.showAlert()
        }
    }
    func notifyStatus() {
        NetStatus.shared.didStopMonitoringHandler = { [] in
        }
        NetStatus.shared.didStartMonitoringHandler = { [] in
        }
        NetStatus.shared.netStatusChangeHandler = {
//            self.showAlert()
        }
    }
    func showAlert() {
        DispatchQueue.main.async { [] in
            if !NetStatus.shared.isConnected {
                if !isAlertPresented {
                    let alert = UIAlertController(title: nil, message: getLanguage["Could not connect to Joysale.Please check your network connection and try again."] ?? "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

extension UIApplication {

    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

