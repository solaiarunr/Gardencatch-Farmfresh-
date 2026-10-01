//
//  ExchangeModel.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 03/07/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//
import Foundation
import SwiftyJSON


class ExchangeModel {

    var result : ExchageResultModel!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = ExchageResultModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
    }
}
class ExchageResultModel {

    var exchange : [ExchangeListModel]!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        exchange = [ExchangeListModel]()
        let exchangeArray = json["exchange"].arrayValue
        for exchangeJson in exchangeArray{
            let value = ExchangeListModel(fromJson: exchangeJson)
            exchange.append(value)
        }
    }
}
class ExchangeListModel {

    var exchangeId : Int!
    var exchangeProduct : ExchangeProductModel!
    var exchangeTime : String!
    var exchangerId : Int!
    var exchangerImage : String!
    var exchangerName : String!
    var exchangerUsername : String!
    var myProduct : MyProductModel!
    var requestByMe : Bool!
    var status : String!
    var type : String!
    var exchangeType : String!
    var cashExchangeId : Int!
    var cashAmount : Double!
    var price : String!
    var quantity : Int!
    var buyer : String!
    var buyerId : Int!
    var seller : String!
    var sellerId : Int!
    var initiatedOn : String!
    var completedOn : String!
    var receiptUrl : String!
    var receiptToken : String!

    var isCashExchange: Bool {
        return (exchangeType ?? "").lowercased() == "cash"
    }

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        exchangeId = json["exchange_id"].intValue
        let exchangeProductJson = json["exchange_product"]
        if !exchangeProductJson.isEmpty{
            exchangeProduct = ExchangeProductModel(fromJson: exchangeProductJson)
        } else {
            exchangeProduct = ExchangeProductModel(fromJson: JSON([:]))
        }
        exchangeTime = json["exchange_time"].stringValue
        exchangerId = json["exchanger_id"].intValue
        exchangerImage = json["exchanger_image"].stringValue
        exchangerName = json["exchanger_name"].stringValue
        exchangerUsername = json["exchanger_username"].stringValue
        let myProductJson = json["my_product"]
        if !myProductJson.isEmpty{
            myProduct = MyProductModel(fromJson: myProductJson)
        } else {
            myProduct = MyProductModel(fromJson: JSON([:]))
        }
        requestByMe = json["request_by_me"].boolValue
        status = json["status"].stringValue
        type = json["type"].stringValue
        exchangeType = json["exchange_type"].stringValue
        cashExchangeId = json["cash_exchange_id"].intValue
        cashAmount = json["cash_amount"].doubleValue
        price = json["price"].stringValue
        quantity = json["quantity"].intValue
        buyer = json["buyer"].stringValue
        buyerId = json["buyer_id"].intValue
        seller = json["seller"].stringValue
        sellerId = json["seller_id"].intValue
        initiatedOn = json["initiated_on"].stringValue
        completedOn = json["completed_on"].stringValue
        receiptUrl = json["receipt_url"].stringValue
        receiptToken = json["receipt_token"].stringValue
    }
}
class MyProductModel {

    var itemId : Int!
    var itemImage : String!
    var itemName : String!
    var quantity : Int!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        itemId = json["item_id"].intValue
        itemImage = json["item_image"].stringValue
        itemName = json["item_name"].stringValue
        quantity = json["quantity"].intValue
        if quantity == 0, let str = json["quantity"].string, let parsed = Int(str) {
            quantity = parsed
        }
    }
}
class ExchangeProductModel {

    var itemId : Int!
    var itemImage : String!
    var itemName : String!
    var quantity : Int!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        itemId = json["item_id"].intValue
        itemImage = json["item_image"].stringValue
        itemName = json["item_name"].stringValue
        quantity = json["quantity"].intValue
        if quantity == 0, let str = json["quantity"].string, let parsed = Int(str) {
            quantity = parsed
        }
    }
}
