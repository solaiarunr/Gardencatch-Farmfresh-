//
//  searchusermodel.swift
//  Joysale_Swift
//
//  Created by Apple on 15/01/22.
//  Copyright © 2022 Hitasoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class searchusermodel {
    var user_list = [searchresmodel]()
    var status = Bool()
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        user_list  = [searchresmodel]()
        let resultArray = json["user_list"].arrayValue
        for resultJson in resultArray{
            let value = searchresmodel(fromJson: resultJson)
            user_list.append(value)
        }
        status = json["status"].boolValue
    }
    
}
class searchresmodel{
    var user_id: String!
     var username:String!
   
   init(fromJson json: JSON!){
       if json.isEmpty{
           return
       }
       user_id = json["id"].stringValue
       username = json["name"].stringValue
       
   
}
}
