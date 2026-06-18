//
//  Config.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 06/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import Foundation
import UIKit

let APP_NAME = "Farm Fresh 24/7"
let BUNDLE_NAME = "com.app.gardencatch"     //need to add

let API_USER_NAME = "joySale"
let API_PASSWORD = "0RWK9XM8"

//let GOOGLE_API_KEY = "AIzaSyBPKdfZs9pGzxPQ4MHM3iUPVAKDWC31fPw"    //check while running this from pms  need to change
//let GOOGLE_API_KEY = "AIzaSyA2lLglPIdWyLvCn7bTTbqiDYG_ua5kAuI"  //Gardencatch
let GOOGLE_CLIENT_KEY = "916288168071-o66c5t13r06rsie4jtn300qvvaph0gr2.apps.googleusercontent.com"    //Gardencatch              //need to add
let GOOGLE_URL = "https://maps.google.com/maps/api/geocode/json?sensor=false"


//let BASE_URL = "https://dev.gardencatch.com/"
//let chatURL = "https://adjunction.in:8081"
//let APP_RTC_URL = "http://yourturn_url:0000"

         //MARK: Live Url before custom work
//let BASE_URL = "https://gardencatch.com/"
//"https://appservices.hitasoft.in/gardencatch/"
//let chatURL =  "https://gardencatch.com:8081"
let APP_RTC_URL = "http://yourturn_url:0000"

//MARK: NEW DOMAIN CHANGES
/*
let BASE_URL = "https://farmfresh247.com/"
let chatURL =  "https://farmfresh247.com:8081"
 */
let BASE_URL = "https://appservices.hitasoft.in/farmfresh/"
let chatURL =  "https://appservices.hitasoft.in:2089"


/*
//MARK: Custom Work url
let BASE_URL = "https://appservices.hitasoft.in/gardencatch/"
//"https://appservices.hitasoft.in/gardencatch/"
let chatURL =  "https://appservices.hitasoft.in:8097"
let APP_RTC_URL = "http://yourturn_url:0000"
*/
//API SERVICE
let SITE_URL = BASE_URL+"api/"
let MEDIA_URL = BASE_URL+"media/user/"
let UPLOAD_IMAGE_URL = BASE_URL+"api/uploadimage"
let CHAT_IMAGE_URL = BASE_URL+"images/message/"
let UPLOAD_AUDIO_URL = BASE_URL+"api/uploadaudio"
let ADD_IMAGE_URL = BASE_URL+"media/item"
let USER_URL = BASE_URL+"media/user"
let WEB_ROOT_URL = BASE_URL+"tos.html"
let RESIZE_MEDIA_URL = BASE_URL+"user/resized/40/"
let PROFILE_URL = BASE_URL+"profile/"
let INVITE_URL = "https://apps.apple.com/us/app/Farm Fresh 24/7/id1078268802"
let INVITE_URL_2 = "https://gardencatch.com/buy"
var REST_AUTH: [String : String] = ["api_username": "joySale", "api_password": "0RWK9XM8"]

let MAP_URL = "https://maps.google.com/maps/api/staticmap?center="

let DEVICE_MODE = "1"
//let DEVICE_MODE = "0"


// Authentication URLS
let TOS_URL = "tos"
let LOGIN_URL = "login"
let SOCIAL_LOGIN_URL = "sociallogin"
let SIGNUP_URL = "signup"
let FORGOT_PASSWORD_URL = "forgetpassword"
let MOBILE_LOGIN_URL = "phonelogin"


// Profile URLS
let GET_PROFILE_URL = "profile"
let CHANGE_PASSWORD_URL = "changepassword"
let ADD_STRIPE_DETAILS_URL = "addstripedetails"
let GET_FOLLOWER_ID_URL = "Getfollowerid"
let FOLLOW_USER_URL = "Followuser"
let UNFOLLOW_USER_URL = "Unfollowuser"
let EDIT_PROFILE_URL = "Editprofile"

let FOLLOWER_DETAILS_URL = "Followersdetails"
let FOLLOWING_DETAILS_URL = "Followingdetails"
let GET_REVIEW_URL = "getreview"

let GET_ITEMS_URL = "getItems"
let ADMIN_DATAS_URL = "admindatas"
let GET_CATEGORY_URL = "getcategory"
let BRAINTREE_CLIENT_TOKEN_URL = "braintreeClientToken"
let GET_COUNT_DETAILS_URL = "getcountdetails"
let SEARCH_USER = "search_user_list"

// ItemDetails URLS
let GET_USER_PRODUCTS_URL = "getuserproducts"
let ITEM_LIKED_URL = "Itemlike"
let SOLD_ITEM_URL = "solditem"
let DELETE_PRODUCT_URL = "deleteproduct"
let REPORT_ITEM_URL = "reportitem"
let GET_CHAT_ID_URL = "getchatid"
let SEND_OFFER_REQ_URL = "Sendofferreq"
let GET_SHIPPING_ADDRESS_URL = "getShippingAddress"
let SET_DEFAULT_SHIPPING_URL = "setdefaultshipping"
let REMOVE_SHIPPING_URL = "removeshipping"
let BUYNOW_PAYMENT_URL = "buynowPayment"
let GET_INSIGHTS_URL = "getinsights"
let GET_COMMENTS_URL = "getcomments"
let DELETE_COMMENT_URL = "deletecomment"
let POST_COMMENT_URL = "postcomment"
let UPDATE_VIEW_URL = "updateview"

let ADD_SHIPPING_URL = "addshipping"
let CREATE_EXCHANGE_URL = "createexchange"

// Chat URLS
let MESSAGE_URL = "messages"
let GET_CHAT_URL = "getchat"
let OFFER_STATUS_URL = "offerstatus"
let SEARCH_BY_ITEM_URL = "searchbyitem"
let SEND_CHAT_URL = "sendchat"
let SAFETY_TIPS_URL = "SafetyTips"
let PRIVACY_POLICY = "privacypolicy"
let CHAT_ACTION_URL = "chataction"

// Exchange URLS
let MY_EXCHANGE_URL = "myexchanges"
let EXCHANGE_STATUS_URL = "exchangestatus"

let HELP_PAGE_URL = "helppage"

// My Orders & Sales URL
let MY_ORDERS_URL = "myorders"
let MY_SALES_URL = "mysales"
let ORDER_STATUS_URL = "orderstatus"
let UPDATE_REVIEW_URL = "updatereview"
let GET_TRACKING_DETAILS_URL = "gettrackdetails"
let BALLENCE_SHEET_URL = "balancesheet"

let NOTIFICATION_URL = "notification"
let GET_AD_WITH_US_URL = "getadwithus"
let GET_HISTORY_URL = "getadhistory"
let BANNER_AVAILABILITY_URL = "banneravailability"
let ADD_BANNER_URL = "addbanner"

// PROMOTION URL
let MY_PROMOTIONS_URL = "mypromotions"
let GET_PROMOTION_URL = "getpromotion"
let PROCESSING_PAYMENT_URL = "processingPayment"
let CHECK_PROMOTION_URL = "Checkpromotion"

// ADDPRODUCT
let PRODUCT_BEFORE_ADD_URL = "productbeforeadd"
let ADD_PRODUCT_URL = "addproduct"

// PUSH NOTIFICATION
let ADD_DEVICE_ID_URL = "adddeviceid"
let RESET_BADGE_URL = "resetbadge"
let PUSH_SIGNOUT_URL = "pushsignout"


// Socket
 
let MESSAGE_TYPEING_ON = "messageTyping"
let MESSAGE_ON = "message"
let EX_MESSAGE_TYPEING_ON = "exmessageTyping"
let EX_MESSAGE_ON = "exmessage"


let JOIN_EMIT = "join"
let MESSAGE_EMIT = "message"
let MESSAGE_TYPING_EMIT = "messageTyping"

let EXCHANGE_JOIN_EMIT = "exchangejoin"
let EX_MESSAGE_EMIT = "exmessage"
let EX_MESSAGE_TYPING_EMIT = "exmessageTyping"

// Addons
let POST_DETAILS_URL = "postdetails"
let Subcription_PAYMENT = "subscriptionPayment"
let subscribe_URL = "mysubscription"
let get_subcribe_plan = "getsubscription"
let SOLD_TO = "soldto"
let REVIEW_DETAILS = "reviewdetails"


// CALL URLS
let MAKE_CALL_URL = "makecall"
let CHECK_ROOM_URL = "checkroom"
let MISSED_CALL_URL = "missedcall"
let END_CALL_URL = "endcall"

//Account Deletion
let DELETE_ACCOUNT = "deleteaccount"

let AWS_UPLOAD_URL = "awsupload" // Server side timeout error when upload 5 images. so use this api to save image name

let getpremium = "getpremium"
let Subscriptiondetails = "subscriptiondetails"
