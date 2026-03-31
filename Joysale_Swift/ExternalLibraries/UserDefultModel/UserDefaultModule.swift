//
//  UserDefaultModule.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 08/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import Foundation

class UserDefaultModule {
    static let shared = UserDefaultModule()
    func setAppFirst(_ isFirst: Bool) {
        UserDefaults.standard.set(isFirst, forKey: "isFirst")
    }
    func getAppFirst() -> Bool {
        return (UserDefaults.standard.value(forKey: "isFirst") as? Bool ?? false)
    }
    func setAppLanguage(language: String) {
        print(language)
        UserDefaults.standard.set(language, forKey: "language")
        UserDefaults.standard.set(DEFAULT_LANGUAGE_CODE, forKey: "languagecode")
    }
    func getAppLanguage() -> String {
        DEFAULT_LANGUAGE_CODE = "en"
        if (UserDefaults.standard.value(forKey: "languagecode") != nil){
            DEFAULT_LANGUAGE_CODE = UserDefaults.standard.value(forKey: "languagecode") as! String
        }
        if (UserDefaults.standard.value(forKey: "language") != nil){
            return UserDefaults.standard.value(forKey: "language") as! String
        }
        return "english"
    }
    func setDefaultLanguage(LanguageDict:Dictionary<String, String>){
        print(LanguageDict)
        getLanguage = LanguageDict
        UserDefaults.standard.set(LanguageDict, forKey: "app_language")
    }
    
    //MARK: store & get VOIP notification token
    func setPushToken(fcm_token: String){
        UserDefaults.standard.set(fcm_token, forKey: "voip_token")
    }
    func getPushToken() -> String? {
        return UserDefaults.standard.value(forKey: "voip_token") as? String
    }
    
    //MARK: store & get fcm notification token
    func setFCMToken(fcm_token: String){
        UserDefaults.standard.set(fcm_token, forKey: "fcm_token")
    }
    func getFCMToken() -> String? {
        return UserDefaults.standard.value(forKey: "fcm_token") as? String ?? ""
    }
    func language() -> Dictionary<String, String> {
        if let language = UserDefaults.standard.value(forKey: "app_language") as? Dictionary<String, String> {
            return language
        }
        else {
            UserDefaultModule().setAppLanguage(language: DEFAULT_LANGUAGE)
            Utility.shared.configureLanguage()
            return self.language()
        }
    }
    func setSearchResult(_ searchArray: [String]) {
        print(searchArray)
        UserDefaults.standard.set(searchArray, forKey: "searchResult")
    }
    func getSearcgResult() -> [String] {
        if (UserDefaults.standard.value(forKey: "searchResult") != nil){
            return UserDefaults.standard.value(forKey: "searchResult") as! [String]
        }
        return [String]()
    }
    func setFilterData(_ filterData: FilterDataModel?) {
        if let filterVal = filterData {
            let jsonData = try! JSONEncoder().encode(filterVal)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            UserDefaults.standard.set(jsonString, forKey: "filterData")
        }
    }
    func getFilterData() -> FilterDataModel {
        let filterResult = UserDefaults.standard.value(forKey: "filterData") as? String ?? ""
        
        if filterResult != "" {
            let jsonData = filterResult.data(using: .utf8)!
            let filterVal = try! JSONDecoder().decode(FilterDataModel.self, from: jsonData)
            return filterVal
        }
        else {
            let filterVal = FilterDataModel()
            return filterVal
        }
    }
    func setUserData(_ user: LoginModel) {
        let jsonData = try! JSONEncoder().encode(user)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        UserDefaults.standard.set(jsonString, forKey: "user_data")
    }
    func getUserData() -> LoginModel? {
        let loginData = UserDefaults.standard.value(forKey: "user_data") as? String ?? ""
        if loginData != "" {
            let jsonData = loginData.data(using: .utf8)!
            let user = try! JSONDecoder().decode(LoginModel.self, from: jsonData)
            return user
        }
        return nil
    }
    //get random number
    func random() -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< 10 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return "\(UserDefaultModule.shared.getUserData()?.user_id ?? "")\(randomString)"
    }
    func setAppleLogin(fName: String, Id: String, email: String, lName: String) {
        let user = SocialDataModel(fName: fName, email: email, id: Id, image: "", lName: lName)
        
        let jsonData = try! JSONEncoder().encode(user)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        UserDefaults.standard.set(jsonString, forKey: "AppleLoginData")
    }
    func getAppleLoginData() -> SocialDataModel {
        let loginData = UserDefaults.standard.value(forKey: "AppleLoginData") as? String ?? ""
        if loginData != "" {
            let jsonData = loginData.data(using: .utf8)!
            let user = try! JSONDecoder().decode(SocialDataModel.self, from: jsonData)
            return user
        }
        else {
            let user = SocialDataModel(fName: "", email: "", id: "", image: "", lName: "")
            return user
        }
    }
    func setType(key: String){
        UserDefaults.standard.set(key, forKey: "signin_type")
    }
    func getType() -> String? {
        return UserDefaults.standard.value(forKey: "signin_type") as? String
    }
    
    func setClientId(key: String){
        UserDefaults.standard.set(key, forKey: "client_id")
    }
    func getClientId() -> String? {
        return UserDefaults.standard.value(forKey: "client_id") as? String
    }
    
    func setClientSecret(key: String){
        UserDefaults.standard.set(key, forKey: "client_secret")
    }
    func getClientSecret() -> String? {
        return UserDefaults.standard.value(forKey: "client_secret") as? String
    }
    
    func setAccesssToken(key: String){
        UserDefaults.standard.set(key, forKey: "token_access")
    }
    func getAccesssToken() -> String? {
        return UserDefaults.standard.value(forKey: "token_access") as? String
    }
    
    func setTokenType(key: String){
        UserDefaults.standard.set(key, forKey: "token_type_hint")
    }
    func getTokenType() -> String? {
        return UserDefaults.standard.value(forKey: "token_type_hint") as? String
    }
}
