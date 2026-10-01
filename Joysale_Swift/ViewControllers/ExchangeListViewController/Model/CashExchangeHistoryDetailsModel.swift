//
//  CashExchangeHistoryDetailsModel.swift
//  Joysale_Swift
//

import Foundation
import SwiftyJSON

class CashExchangeHistoryDetailsModel {

    var status: Bool!
    var message: String!
    var result: CashExchangeHistoryResultModel!

    init(fromJson json: JSON!) {
        if json.isEmpty { return }
        status = json["status"].boolValue
        message = json["message"].stringValue
        let resultJson = json["result"]
        if !resultJson.isEmpty {
            result = CashExchangeHistoryResultModel(fromJson: resultJson)
        }
    }
}

class CashExchangePersonModel {

    var userId: Int!
    var fullName: String!
    var userName: String!

    init(fromJson json: JSON!) {
        if json.isEmpty { return }
        userId = json["user_id"].intValue
        fullName = json["full_name"].stringValue
        userName = json["user_name"].stringValue
    }

    var displayName: String {
        if let name = fullName, !name.isEmpty { return name }
        if let name = userName, !name.isEmpty { return name }
        return "-"
    }
}

class CashExchangeProductInfoModel {

    var productId: Int!
    var name: String!

    init(fromJson json: JSON!) {
        if json.isEmpty { return }
        productId = json["product_id"].intValue
        name = json["name"].stringValue
    }
}

class CashExchangeHistoryResultModel {

    var cashExchangeId: Int!
    var status: String!
    var quantity: Int!
    var cashAmount: Double!
    var createdAt: Int!
    var completedAt: Int!
    var role: String!
    var shareUrl: String!
    var downloadUrl: String!
    var receiptUrl: String!
    var receiptToken: String!
    var transaction_id: String!
    var buyer: CashExchangePersonModel!
    var seller: CashExchangePersonModel!
    var counterparty: CashExchangePersonModel!
    var product: CashExchangeProductInfoModel!
    var history: [CashExchangeHistoryItemModel]!

    /// UI helpers mapped from API
    var transactionId: String { "\(cashExchangeId ?? 0)" }
    var productName: String { product?.name ?? "-" }
    var buyerName: String { buyer?.displayName ?? "-" }
    var sellerName: String { seller?.displayName ?? "-" }

    init(fromJson json: JSON!) {
        if json.isEmpty { return }
        transaction_id = json["transaction_id"].stringValue
        cashExchangeId = json["cash_exchange_id"].intValue
        status = json["status"].stringValue
        quantity = json["quantity"].intValue
        cashAmount = json["cash_amount"].doubleValue
        createdAt = json["created_at"].intValue
        completedAt = json["completed_at"].intValue
        role = json["role"].stringValue
        shareUrl = json["share_url"].stringValue
        downloadUrl = json["download_url"].stringValue
        receiptUrl = json["receipt_url"].stringValue
        receiptToken = json["receipt_token"].stringValue

        let buyerJson = json["buyer"]
        if !buyerJson.isEmpty { buyer = CashExchangePersonModel(fromJson: buyerJson) }
        let sellerJson = json["seller"]
        if !sellerJson.isEmpty { seller = CashExchangePersonModel(fromJson: sellerJson) }
        let counterpartyJson = json["counterparty"]
        if !counterpartyJson.isEmpty { counterparty = CashExchangePersonModel(fromJson: counterpartyJson) }
        let productJson = json["product"]
        if !productJson.isEmpty { product = CashExchangeProductInfoModel(fromJson: productJson) }

        var nameByUserId: [Int: String] = [:]
        if let b = buyer { nameByUserId[b.userId ?? 0] = b.displayName }
        if let s = seller { nameByUserId[s.userId ?? 0] = s.displayName }
        if let c = counterparty { nameByUserId[c.userId ?? 0] = c.displayName }

        history = [CashExchangeHistoryItemModel]()
        let historyJson = json["transaction_history"].arrayValue
        let legacyHistory = json["history"].arrayValue
        let rows = historyJson.isEmpty ? legacyHistory : historyJson
        for item in rows {
            history.append(CashExchangeHistoryItemModel(fromJson: item, nameByUserId: nameByUserId))
        }
    }
}

class CashExchangeHistoryItemModel {

    var status: String!
    var userId: Int!
    var user: String!
    var dateTimestamp: Int!
    var date: String!

    init(fromJson json: JSON!, nameByUserId: [Int: String] = [:]) {
        if json.isEmpty { return }
        status = json["status"].stringValue
        userId = json["user"].intValue
        if userId == 0, let raw = json["user"].string, let parsed = Int(raw) {
            userId = parsed
        }
        if let mapped = nameByUserId[userId ?? 0], !mapped.isEmpty {
            user = mapped
        } else if json["user"].type == .string {
            user = json["user"].stringValue
        } else {
            let id = userId ?? 0
            user = id > 0 ? "\(id)" : "-"
        }

        // API sends unix timestamp; older mock used "yyyy-MM-dd" string
        if json["date"].type == .number || json["date"].intValue > 0 {
            dateTimestamp = json["date"].intValue
            date = CashExchangeHistoryItemModel.formatTimestamp(dateTimestamp)
        } else {
            dateTimestamp = 0
            date = json["date"].stringValue
        }
    }

    static func formatTimestamp(_ timestamp: Int?) -> String {
        guard let timestamp = timestamp, timestamp > 0 else { return "-" }
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
