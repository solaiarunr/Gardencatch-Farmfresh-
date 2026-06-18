//
//  StripeViewModel.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 01/07/21.
//  Copyright © 2021 Hitasoft. All rights reserved.
//

import Foundation

class StripeDataViewModel {
    
    var stripeModel: StripeDataModel?
    func getStripeDetails(
        amount: String,
        currency: String,
        payment_mode: String = "",
        plan_id: String = "",user_id:String = "",
        onSuccess success: @escaping (Bool) -> Void,
        onFailure failure: @escaping (String) -> Void
    ) {
        
        var parameter: [String: Any] = [
            "amount": amount,
            "currency": currency
        ]
        
        if !payment_mode.isEmpty {
            parameter["payment_mode"] = payment_mode
        }
        
        if !plan_id.isEmpty {
            parameter["plan_id"] = plan_id
        }
        
        if !user_id.isEmpty {
            parameter["user_id"] = user_id
        }
        
        CallParsingFunction().postDataCall(
            subURl: BALLENCE_SHEET_URL,
            params: parameter,
            onSuccess: { response in
                print(response)
                let rootClass = StripeDataModel(fromJson: response)
                self.stripeModel = rootClass
                success(rootClass.status ?? false)
            },
            onFailure: { error in
                failure(error?.localizedDescription ?? "")
            }
        )
    }
}
