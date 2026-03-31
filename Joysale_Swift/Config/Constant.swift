//
//  Constant.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 06/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

var FULL_WIDTH = UIScreen.main.bounds.width
var FULL_HEIGHT = UIScreen.main.bounds.height
var indicatorView = NVActivityIndicatorView.init(frame: CGRect(x:FULL_WIDTH/2-30,y:FULL_HEIGHT/2-30,width:60,height:60), type: NVActivityIndicatorType.ballPulse, color: UIColor(named: "AppThemeColor") ?? .white, padding: 50)
let chat_bg = #colorLiteral(red: 0.1490196078, green: 0.5529411765, blue: 0.2156862745, alpha: 1)
let WHITE_COLOR_HEADER = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

let APP_FONT_BOLD = "ProximaNova-Bold"
let APP_FONT_REGULAR = "ProximaNova-Regular"
var DEFAULT_LANGUAGE = "english"
var DEFAULT_LANGUAGE_CODE = "en"
var BRAINTREE_TOKEN = ""

//var BUYNOW_MODEL_FLAG = false
var BUYNOW_MODEL_FLAG = true
var PAID_BANNER_FLAG = true
var PROMOTION_FLAG = true
var EXCHANGE_MODEL_FLAG = true
var FILTER_DATA = FilterDataModel()
var IS_FILTER_FOUND = false

var ADD_EDIT_ITEM_MODEL = AddEditViewModel()

var POSTEDARRAY = ["last24h", "last7d", "last30d", "allproducts"]
var SORTBYARRAY = ["popular", "urgent", "hightolow", "lowtohigh"]

// GET LANGUAGE
var getLanguage = [String: String]()

let REGULAR_FONT = UIFont(name: APP_FONT_BOLD, size: 15)

var ADMIN_VIEW_MODEL = AdminViewModel()
var CURRENT_CHAT = ""
var STRIPE_DETAILS: StripeDetailModel?

// ADD_ONS
var Addons_Status = false
// MARK: Banner Ads AddOn
var BANNNER_ID = "ca-app-pub-3940256099942544/2934735716"

// MARK: Single Country AddOn
let CURRENT_LOCATION = "worldwide"


var INTERESTITIAL_ADMOB = false
var INTERESTITIAL_KEY = "ca-app-pub-3940256099942544/4411468910"
var GIPHY_ENABLED = true
var GIPHY_KEY = "wUJ7RuHbc0yBZ3etnoqI5ZucdCNZkCjv"
var VOICE_CHAT = true
let IS_SMART_REPLY = true
var MAPBOXACCESSTOKEN = "pk.eyJ1Ijoic3BhcmVncnViIiwiYSI6ImNqbWs3amRlcjA2bXkzc28zMmtrYjMyZXMifQ.W9oE5te96I9amWEi4KNczA"
var UDID = ""
 

