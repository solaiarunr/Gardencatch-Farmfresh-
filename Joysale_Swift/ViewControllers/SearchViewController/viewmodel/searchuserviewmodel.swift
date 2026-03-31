//
//  searchuserviewmodel.swift
//  Joysale_Swift
//
//  Created by Apple on 15/01/22.
//  Copyright © 2022 Hitasoft. All rights reserved.
//

import Foundation
class searchuserviewmodel {
    
    var Searchusermodel:searchusermodel?
   
    public func getsearchuserData(user_id: String,suggestion_name: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
            let parameter: [String: Any] = ["user_id":user_id, "suggestion_name": suggestion_name]
            
            CallParsingFunction().postDataCall(subURl: SEARCH_USER, params: parameter, onSuccess: { (response) in
                print(response)
                let rootClass = searchusermodel.init(fromJson: response)
               self.Searchusermodel = rootClass
                success(rootClass.status )
            }) { (error) in
                failure(error?.localizedDescription ?? "")
            }
        }

    
}
