//
//  MyExchangeViewModel.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 03/07/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import Foundation

class MyExchangeViewModel {
    
    var resultModel: ExchangeModel?
    var cashHistoryDetailsModel: CashExchangeHistoryDetailsModel?
    
    public func exchangeData(user_id: String, type: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let parameter: [String: Any] = ["user_id":user_id, "type": type]
        CallParsingFunction().postDataCall(subURl: MY_EXCHANGE_URL, params: parameter, onSuccess: { (response) in
            print(response)
            let rootClass = ExchangeModel.init(fromJson: response)
            self.resultModel = rootClass
            success(rootClass.status ?? false)
        }) { (error) in
            failure(error?.localizedDescription ?? "")
        }
    }
    public func exchangeDetailsData(user_id: String, type: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let parameter: [String: Any] = ["user_id":user_id, "type": type]
        CallParsingFunction().postDataCall(subURl: MY_EXCHANGE_URL, params: parameter, onSuccess: { (response) in
            print(response)
            let rootClass = ExchangeModel.init(fromJson: response)
            self.resultModel = rootClass
            success(rootClass.status ?? false)
        }) { (error) in
            failure(error?.localizedDescription ?? "")
        }
    }

    /// POST /api/cashexchangedetails
    public func cashExchangeHistoryDetails(
        user_id: String,
        cash_exchange_id: Int,
        onSuccess success: @escaping (Bool) -> Void,
        onFailure failure: @escaping (String) -> Void
    ) {
        let parameter: [String: Any] = [
            "user_id": Int(user_id) ?? 0,
            "cash_exchange_id": cash_exchange_id
        ]
        CallParsingFunction().postDataCall(subURl: CASH_EXCHANGE_HISTORY_DETAILS_URL, params: parameter, onSuccess: { (response) in
            print(response)
            let rootClass = CashExchangeHistoryDetailsModel(fromJson: response)
            self.cashHistoryDetailsModel = rootClass
            success(rootClass.status ?? false)
        }) { (error) in
            failure(error?.localizedDescription ?? "")
        }
    }
}
