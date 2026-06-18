//
//  GetMembershipPromotionModel.swift
//  Joysale_Swift
//


import Foundation
import SwiftyJSON

class GetMembershipPromotionModel {

    @IBOutlet weak var TitleLbl: UILabel!
    var result : MembershipPromotionResultModel!
    var status : Bool!

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }

        let resultJson = json["result"]
        if !resultJson.isEmpty {
            result = MembershipPromotionResultModel(fromJson: resultJson)
        }

        status = json["status"].boolValue
    }
}

class MembershipPromotionResultModel {

    var currencyPosition : String!
    var currencyCode : String!
    var currencySymbol : String!
    var currencyMode : String!

    var membershipEnableUrgent : String!
    var formattedUrgent : String!

    var monthlyPromotions : [PromotionPlanModel]!
    var yearlyPromotions : [PromotionPlanModel]!

    init(fromJson json: JSON!) {

        if json.isEmpty {
            return
        }

        currencyPosition = json["currency_position"].stringValue
        currencyCode = json["currency_code"].stringValue
        currencySymbol = json["currency_symbol"].stringValue
        currencyMode = json["currency_mode"].stringValue

        membershipEnableUrgent = json["membership_enable_urgent"].stringValue
        formattedUrgent = json["formatted_urgent"].stringValue

        monthlyPromotions = [PromotionPlanModel]()
        let monthlyArray = json["monthly_promotions"].arrayValue
        for item in monthlyArray {
            let value = PromotionPlanModel(fromJson: item)
            monthlyPromotions.append(value)
        }

        yearlyPromotions = [PromotionPlanModel]()
        let yearlyArray = json["yearly_promotions"].arrayValue
        for item in yearlyArray {
            let value = PromotionPlanModel(fromJson: item)
            yearlyPromotions.append(value)
        }
    }
}

class PromotionPlanModel {
    var isSelected = false
    var id : Int!
    var name : String!
    var days : Int!
    var price : Float!
    var formattedPrice : String!
    var membershipEnableAd : String!

    init(fromJson json: JSON!) {

        if json.isEmpty {
            return
        }

        id = json["id"].intValue
        name = json["name"].stringValue
        days = json["days"].intValue
        price = json["price"].floatValue
        formattedPrice = json["formatted_price"].stringValue
        membershipEnableAd = json["membership_enable_ad"].stringValue
    }
}
