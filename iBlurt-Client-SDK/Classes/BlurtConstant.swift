//
//  BlurtConstant.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation


let USER_AVAIL = "droid/api/findUserAvailablity"
let USER_VALIDATE = "droid/api/validateUser"
let CREATE_USER = "droid/api/createAccCust"
let START_CHAT = "droid/api/startChat"
let FETCH_MESSAGES = "droid/api/getAllmsgsBysessionId"
let UPDATE_SOCKET_ID = "droid/api/updateSocketId"
let UPDATE_FCM = "droid/api/updateFcmKey"
let CHAT_FEEDBACK = "droid/api/update_fdbk_rating"

let NEW_USER = "NU"
let USER_FOUND = "UF"

let DEVICE_TYPE = "2"
let SDK_VERSION = "1.0.0"

let SOCKET_URL = "https://blurtdemo.bitnamiapp.com/"






let userLocale = Locale.current.regionCode


//Chat Constants

let LEFT_CELL = "BlurtLeftTableViewCell"
let RIGHT_CELL = "BlurtRightTableViewCell"

let MESSAGE_SEND = "SEND"
let MESSAGE_SENT = "SENT"
let MESSAGE_RECEIVED = "DEL"
let MESSAGE_SEEN = "SEEN"
let MESSAGE_FAILED = "FAILED"





let ONLINE = 1
let AWAY = 2
let TYPING_STATUS = 1
let NO_TYPING_STATUS = 0

let EVENT_START_CHAT_ROOM = "startChatRoom";
let EVENT_SEND_MESSAGE = "send_msg";
let EVENT_NOTIFICATION = "notification";
let EVENT_MESSAGES = "messages";
let EVENT_MSG_HELPER = "msg_helper"
