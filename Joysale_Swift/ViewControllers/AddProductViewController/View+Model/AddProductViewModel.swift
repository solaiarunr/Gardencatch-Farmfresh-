//
//  AddProductViewModel.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 24/07/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import Foundation

class AddProductViewModel {
    var addModel: AddPoductResultModel?
    public func postProduct(user_id: String,productModel: AddEditViewModel,filter: String,editFlag: Bool = false, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let currencyArray = ADD_EDIT_ITEM_MODEL.currency.components(separatedBy: "-")
        let itemID = ADD_EDIT_ITEM_MODEL.item_id == "0" ? "" : ADD_EDIT_ITEM_MODEL.item_id
        let descText = productModel.item_des
 
          let formattedCurrency = currencyArray.count > 1 ? "\(currencyArray[1])-\(currencyArray[0])" : ADD_EDIT_ITEM_MODEL.currency
        
         
        var parameter: [String: Any] = ["user_id":user_id, "item_id": itemID ?? "", "item_name": productModel.item_name ?? "", "item_des": descText ?? "" , "price": productModel.price ?? "", "size": productModel.size ?? "", "category": productModel.category ?? "", "subcategory": productModel.subcategory ?? "", "chat_to_buy": productModel.chat_to_buy ?? "", "exchange_to_buy": productModel.exchange_to_buy == true ? 1 : 0, "currency": formattedCurrency ?? "", "lat": productModel.lat ?? "", "lon": productModel.lon ?? "", "address": productModel.address ?? "", "shipping_time": productModel.shipping_time ?? "", "remove_img": productModel.remove_img ?? "", "product_img": productModel.product_img ?? "", "shipping_detail": productModel.shipping_detail ?? "", "item_condition": productModel.item_condition ?? "", "make_offer": productModel.make_offer ?? 2, "instant_buy": productModel.instant_buy == true ? 1 : 0, "paypal_id": productModel.paypal_id ?? "", "shipping_cost": productModel.shipping_cost ?? "", "country_id": productModel.country_id ?? "", "giving_away":productModel.giving_away == true ? "yes": "no", "filters": filter, "youtube_link": productModel.youtube_link ?? "", "child_category": productModel.child_category ?? "", "sold": productModel.sold ?? false, "city":productModel.state ?? ""]
        if editFlag {
            parameter["post_flag"] = "edit" // This flag is used for subscription
        }
        CallParsingFunction().postDataCall(subURl: ADD_PRODUCT_URL, params: parameter, onSuccess: { (response) in
            print(response)
            let rootClass = AddPoductResultModel.init(fromJson: response)
            self.addModel = rootClass
            success(rootClass.status ?? false)
        }) { (error) in
            failure(error?.localizedDescription ?? "")
        }
    }
    public func AWSUpload(user_id: String,itemID: String, itemImage: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let parameter: [String: Any] = ["user_id":user_id, "item_id": itemID , "product_img": itemImage]
        
        CallParsingFunction().postDataCall(subURl: AWS_UPLOAD_URL, params: parameter, onSuccess: { (response) in
            print(response)
            let rootClass = AddPoductResultModel.init(fromJson: response)
            success(rootClass.status ?? false)
        }) { (error) in
            failure(error?.localizedDescription ?? "")
        }
    }
    func descText(_ desc: String)-> String {
        let attrString = NSAttributedString(string: desc, attributes: nil)
        let x = attrString
        var resultHtmlText = ""
        do {
            let r = NSRange(location: 0, length: x.length)
            let att = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
            let d = try x.data(from: r, documentAttributes: att)

            if let h = String(data: d, encoding: .utf8) {
                resultHtmlText = h
            }
        }
        catch {
            print("utterly failed to convert to html!!! \n>\(x)<\n")
        }
        print(resultHtmlText)
        return resultHtmlText
    }
}
