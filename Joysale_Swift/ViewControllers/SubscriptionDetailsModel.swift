//
//  SubscriptionDetailsModel.swift
//  Joysale_Swift
//
//  Created by HTS-PRO-2018 on 29/05/26.
//  Copyright © 2026 Hitasoft. All rights reserved.
//


import Foundation
import SwiftyJSON

class SubscriptionDetailsModel {

    var status: Bool!
    var message: String!
    var result: SubscriptionResultModel!

    init(fromJson json: JSON!) {

        if json.isEmpty {
            return
        }

        status = json["status"].boolValue
        message = json["message"].stringValue

        result = SubscriptionResultModel(fromJson: json)
    }
}

class SubscriptionResultModel {

    var subscriptionStatus: String!
    var planName: String!
    var planPrice: Float!
    var currency: String!
    var subscriptionStart: String!
    var subscriptionEnd: String!
    var autoRenewal: String!

    init(fromJson json: JSON!) {

        if json.isEmpty {
            return
        }

        subscriptionStatus = json["subscription_status"].stringValue
        planName = json["plan_name"].stringValue
        planPrice = json["plan_price"].floatValue
        currency = json["currency"].stringValue
        subscriptionStart = json["subscription_start"].stringValue
        subscriptionEnd = json["subscription_end"].stringValue
        autoRenewal = json["auto_renewal"].stringValue
    }
}
