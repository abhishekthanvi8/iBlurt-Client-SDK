//
//  BlurtChatViewController.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 27/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import UIKit
import SocketIO

class BlurtChatViewController: BlurtChatBaseViewController , UITableViewDelegate,UITableViewDataSource, UITextViewDelegate {
    
    //50 to show and 0 to hide
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewTitleLabel: UILabel!
    @IBOutlet weak var chatTableViewTopConstraint: NSLayoutConstraint!
    var messages = [ConversationModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextView.inputAccessoryView = UIView()
        inputTextView.delegate = self
        self.loadingChatCellNibs(chatTableView)
        
        
        self.bottomViewInit()
        hideKeyboardWhenTappedAround()
        sendButton.isUserInteractionEnabled = false
        sendButton.setImage(UIImage(named: "send_white"), for: UIControl.State.normal)
        self.showHideTopView(hidden: true, showAlertMessage: "")
        
        self.navigationItem.setSubTitle(subtitle: "Offline")
        print("chat sessiion id", self.chatSessionId)
        
        
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        manageKeyBoardandBottomView()
        self.getMessageAPI()
        self.ConnectToSocket()
    }
    
    //initalizing bottomviews
    func bottomViewInit()  {
        inputTextView.text = placeHolderText
        inputTextView.textColor = UIColor.white
        
        chatTableView.reloadData()
        scrollToBottom(self.chatTableView , self.messages)
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        self.sendMessage()
        self.emptyTypeMessage()
        updateTypingStatus(0)
        //        if !isAgentJoined {
        //            emptyTypeMessage()
        //        }else{
        //            // Send Message
        //            self.sendMessage()
        //            self.emptyTypeMessage()
        //            updateTypingStatus(0)
        //        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        chatTableView.addGestureRecognizer(tap)
    }
    
    //Empty TextFiled
    func emptyTypeMessage()  {
        // self.dismissKeyboard()
        inputTextView.text = ""
        sendButton.isUserInteractionEnabled = false
        bottomViewHeightConstraint.constant = 50
        sendButton.setImage(UIImage(named: "send_white"), for: UIControl.State.normal)
    }
    
    
    
    
    
    // TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count + 1
    }
    
    //Setting TableView Cells with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: LEFT_CELL, for: indexPath as IndexPath) as! BlurtLeftTableViewCell
            cell = self.setHanlderData(cell as! BlurtLeftTableViewCell, self.addWelcomeMessage())
        }else{
            let index = indexPath.row - 1
            
            if messages[index].senderId != userProfile?.userId{
                cell = tableView.dequeueReusableCell(withIdentifier: LEFT_CELL, for: indexPath as IndexPath) as! BlurtLeftTableViewCell
                cell = self.setHanlderData(cell as! BlurtLeftTableViewCell, self.messages[index])
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: RIGHT_CELL, for: indexPath as IndexPath) as! BlurtRightTableViewCell
                
                cell = self.setSelfData(cell as! BlurtRightTableViewCell, self.messages[index])
            }
        }
        return cell
    }
    
    
    //Showing and Hiding Top View
    func showHideTopView(hidden: Bool,showAlertMessage: String) -> Void {
        topViewTitleLabel.text = showAlertMessage
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            if !hidden {
                self.chatTableViewTopConstraint.constant = 30
            }else{
                self.chatTableViewTopConstraint.constant = 0
            }
            self.topView.isHidden = hidden
        })
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count > 0 {
            sendButton.isUserInteractionEnabled = true
            sendButton.setImage(UIImage(named: "send_selected"), for: UIControl.State.normal)
            
        }else{
            // send non typing here
            updateTypingStatus(0)
            sendButton.isUserInteractionEnabled = false
            sendButton.setImage(UIImage(named: "send_white"), for: UIControl.State.normal)
        }
        
        if newText.count == 1 {
            updateTypingStatus(1)
        }
        
        return true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEqualToString(find: placeHolderText) {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = UIColor.white
        }
    }
    
    
    //Manage Socket Connections
    func ConnectToSocket() {
        
        manager = SocketManager(socketURL: URL(string: SOCKET_URL)!, config: [.log(false), .reconnectWait(500)])
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print(data)
            print("socket connected",self.socket.sid)
            self.updateScoketId()
        }
        
        socket.on(clientEvent: .error) { (data, eck) in
            print("socket error")
        }
        
        socket.on(clientEvent: .disconnect) { (data, eck) in
            print("socket disconnect")
        }
        
        socket.on(clientEvent: SocketClientEvent.reconnect) { (data, eck) in
            print("socket reconnect")
        }
        
        readNotificationEvent { (notificationInfo) -> Void in
        }
        
        readMessageEvent{ (messageInfo) -> Void in
        }
        
        messageHelperEvent{ (messageInfo) -> Void in
        }
        
        socket.connect()
    }
    
    
    
    // Managing Notification Events from Agent
    func manageEventnotifications(_ eventType: String, _ notificationDictionary: [String: AnyObject]) -> Void {
        
        var chatId = ""
        var eventType = ""
        var senderId = ""
        var storedMsgs =  NSMutableArray()
        
        if notificationDictionary["chat_id"] != nil{
            chatId = notificationDictionary["chat_id"] as! String
        }
        
        if notificationDictionary["TYPE"] != nil{
            eventType = notificationDictionary["TYPE"] as! String
        }
        
        if notificationDictionary["sender"] != nil{
            senderId = notificationDictionary["sender"] as! String
        }
        
        if notificationDictionary["result"] != nil{
            storedMsgs = notificationDictionary["result"] as! NSMutableArray
        }
        
        switch eventType {
        case "WAITING_TO_JOIN":
            if !self.isAgentJoined{
                self.showHideTopView(hidden: false, showAlertMessage: "Waiting to join by handler.")
            }
            break
        case "AGENT_JOINED":
            if (!self.isAgentJoined) {
                var agent_id = ""
                if notificationDictionary["agent_id"] != nil{
                    agent_id = notificationDictionary["agent_id"] as! String
                }
                self.showHideTopView(hidden: true, showAlertMessage: "Agent Joined")
                self.agentId = agent_id
                self.isAgentJoined = true
                
            }
            updateClientStatus()
            self.navigationItem.setSubTitle(subtitle: "Agent (Online)") //set agent status online
            break
        case "USER_DISCONNECTED":
            //set agent status offline
            self.navigationItem.setSubTitle(subtitle: "Agent (Offline)")
            break
        case "TYPING":
            if !isCurrentUser(senderId: senderId){
                self.navigationItem.setSubTitle(subtitle: "Agent (Typing..)")
            }
            break
        case "NOT_TYPING":
            if !isCurrentUser(senderId: senderId){
                self.navigationItem.setSubTitle(subtitle: "Agent (Online)")
            }
            break
        case "STORED_MSG":
            //Get all messages when user joined
            self.getAllMessages(messages: storedMsgs)
        case "END_CHAT":
            self.messages.removeAll()
            let vc = BlurtFeedbackViewController.fromMainStoryboard()
            vc.chatSessionId = self.chatSessionId
            vc.updateNavigationStack = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
        
    }
    
    
    //Join chat Room after getting socket Id
    func joinChatRoom()  {
        let createRoom = [chatSessionId,userId]
        socket.emit(EVENT_START_CHAT_ROOM, with: createRoom)
        updateClientStatus()
    }
    
    
    //Disconnect socket
    func disconnectSocket() -> Void {
        manager.disconnectSocket(socket)
        socket.off(EVENT_NOTIFICATION)
        socket.off(EVENT_SEND_MESSAGE)
        
    }
    
    func isCurrentUser(senderId:  String) -> Bool {
        if senderId == userId {
            return true
        }else{
            return false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.disconnectSocket()
    }
    
    //Reading Notification Events From Socket
    func readNotificationEvent(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on(EVENT_NOTIFICATION) { (dataArray, socketAck) -> Void in
            var notificationDictionary = [String: AnyObject]()
            notificationDictionary = getSocketDataDictonary(dataArray)
            var eventType = ""
            
            if notificationDictionary["TYPE"] != nil{
                eventType = notificationDictionary["TYPE"] as! String
            }
            self.manageEventnotifications(eventType,notificationDictionary)
            print(notificationDictionary)
            completionHandler(notificationDictionary)
        }
    }
    
    
    //Reading Messages Events From Socket
    func readMessageEvent(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on(EVENT_MESSAGES) { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary = getSocketDataDictonary(dataArray)
            print(messageDictionary)
            self.getChatMessage(messageDictionary)
            completionHandler(messageDictionary)
        }
    }
    
    /**
     * Listen to this event to update the status of messages
     */
    func messageHelperEvent(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on(EVENT_MSG_HELPER) { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary = getSocketDataDictonary(dataArray)
            print("ACK MSG HELPER" )
            print(messageDictionary)
            self.onMsgHelper(messageDictionary)
            completionHandler(messageDictionary)
        }
    }
    
    //Managing Messages coming in from socket
    func getChatMessage(_ messageDict: [String: AnyObject]) -> Void {
        var chat_id = ""
        var msg = ""
        var sentBy = ""
        var timeStamp = 0
        var msgId = 0
        
        if messageDict["chat_id"] != nil {
            chat_id = messageDict["chat_id"] as! String
        }
        
        if messageDict["msg"] != nil {
            msg = messageDict["msg"] as! String
        }
        
        if messageDict["timestamp"] != nil {
            timeStamp = Int(truncating: messageDict["timestamp"] as! NSNumber)
        }
        
        if messageDict["sentBy"] != nil {
            sentBy = messageDict["sentBy"] as! String
        }
        
        if messageDict["msg_id"] != nil {
            msgId = messageDict["msg_id"] as! Int
        }
        
        if sentBy != userId {
            let message = ConversationModel()
            message.message = msg
            message.messageStatus = MESSAGE_RECEIVED
            message.senderId = sentBy
            message.timestamp = timeStamp.toString()
            message.sessionId = chat_id
            message.messageId = msgId
            
            self.messages.append(message)
            self.chatTableView.reloadData()
            if msgId > 0{
                self.updateMessageStatus(messageIds: [msgId])
                self.scrollToBottom(self.chatTableView, self.messages)
            }
            
        }else{
            updateChatStatus(timestamp: timeStamp.toString(), msgIds: [msgId], status: MESSAGE_SENT)
            self.scrollToBottom(self.chatTableView, self.messages)
        }
    }
    
    //Updating status of Messages for Agent
    func onMsgHelper(_ messageHelperDict: [String: AnyObject])  {
        var chat_id = ""
        var msgStatus = ""
        var sender = ""
        var msgIds = NSMutableArray()
        
        
        if messageHelperDict["chat_id"] != nil {
            chat_id = messageHelperDict["chat_id"] as! String
        }
        
        if messageHelperDict["msg_status"] != nil {
            msgStatus = messageHelperDict["msg_status"] as! String
        }
        
        
        if messageHelperDict["sender"] != nil {
            sender = messageHelperDict["sender"] as! String
        }
        
        if messageHelperDict["msg_id"] != nil {
            msgIds = messageHelperDict["msg_id"] as! NSMutableArray
        }
        
        
        if !userId.isEqualToString(find: sender) && msgIds.count > 0 {
            print("coming here ", sender)
            var mIds = [Int]()
            let firstResult = msgIds[0] as! NSArray
            for ids in firstResult{
                let id = ids as! Int
                
                mIds.append(id)
            }
            updateChatStatus(msgIds: mIds, status: msgStatus)
        }
        
        
    }
    
    func updateChatStatus(timestamp: String,msgIds: [Int],status: String) {
        // update converstion array and reload table
        for conver in 0..<self.messages.count {
            if self.messages[conver].timestamp == timestamp{
                self.messages[conver].messageStatus = status
                self.messages[conver].timestamp = timestamp
                self.messages[conver].messageId = msgIds[0]
                
                
            }
        }
        self.chatTableView.reloadData()
    }
    
    func updateChatStatus(msgIds: [Int],status: String) {
        // update converstion array and reload table
        for i in 0..<msgIds.count {
            for conver in 0..<self.messages.count {
                
                if self.messages[conver].messageId == msgIds[i]{
                    self.messages[conver].messageStatus = status
                }
                
            }
        }
        self.chatTableView.reloadData()
    }
    
    
    func sendMessage() -> Void {
        let message = ConversationModel()
        message.message = self.inputTextView.text
        message.messageStatus = MESSAGE_SENT
        message.senderId = userId
        message.timestamp = String(Date().toMillis())
        message.sessionId = chatSessionId
        
        let dict = ["msg" : self.inputTextView.text , "timestamp" : Date().toMillis(), "chat_id" : chatSessionId, "sentBy" : userId , "status" : MESSAGE_SENT, "notify" : agentId] as [String : Any]
        
        socket.emit(EVENT_SEND_MESSAGE, with: [dict])
        self.messages.append(message)
        self.chatTableView.reloadData()
        self.scrollToBottom(self.chatTableView, self.messages)
    }
    
    
    func updateTypingStatus(_ typingStatus: Int) -> Void {
        var dict = [String : Any]()
        if typingStatus == 0 {
            dict = ["chat_id" : chatSessionId , "TYPE" : "NOT_TYPING", "sender" : userId] as [String : Any]
        }else{
            dict = ["chat_id" : chatSessionId , "TYPE" : "TYPING", "sender" : userId] as [String : Any]
        }
        socket.emit(EVENT_NOTIFICATION, with: [dict])
    }
    
    
    
    
    //Update Socket ID when Socket is connected
    func updateScoketId() -> Void {
        
        userProfile = BlurtPrefrenceManager.getUserData()
        userId = (userProfile?.userId)!
        print(userId)
        let request = UpdateSocketIdRequest()
        request.socketId = socket.sid
        request.userId = userId
        
        //Calling Update Socket API
        BlurtApi.updateSocketId(request: request){ result in
            switch result {
            case .success(let data):
                if !data.errorStatus{
                    self.joinChatRoom()
                    print("socket id updated")
                }else{
                    print("socket id not updated")
                }
            case .failure(let error):
                print("Falied to Update Socket Id:  ",error)
            }
        }
    }
    
    
    //Getting all stored messages from socket
    func getAllMessages(messages: NSMutableArray) {
        self.messages.removeAll()
        if messages.count > 0 {
            for i in 0..<messages.count {
                let json = messages[i] as! NSMutableDictionary
                
                let msg = json["msg"] as! String
                let status = json["status"] as! String
                let chatId = json["chat_id"] as! String
                let timeStamp = json["timestamp"] as! String
                let sentBy = json["sentBy"] as! String
                let msgId = json["msg_id"] as! Int
                
                let singleMessage = ConversationModel()
                singleMessage.messageId = msgId
                singleMessage.messageStatus = status
                singleMessage.message = msg
                singleMessage.senderId = sentBy
                singleMessage.sessionId = chatId
                singleMessage.timestamp = timeStamp
                
                //Append Message in converstion array
                self.messages.append(singleMessage)
                
            }
            //Reload tableview after appending messages.
            self.chatTableView.reloadData()
            self.updateMessageStatus(messages: self.messages)
            self.scrollToBottom(chatTableView, self.messages)
        }else{
            print("no messages found")
        }
    }
    
    //updating clinet's messages status to SEEN
    func updateMessageStatus(messages: [ConversationModel])  {
        var messageIds = [Int]()
        for i in 0..<messages.count {
            let status = messages[i].messageStatus
            let msgId = messages[i].messageId
            let senderId =   messages[i].senderId
            if !self.isCurrentUser(senderId: senderId){
                if !(status?.isEqualToString(find: MESSAGE_SEEN))!{
                    messageIds.append(msgId)
                }
            }
        }
        if messageIds.count > 0 {
            self.updateMessageStatus(messageIds: messageIds)
        }
    }
    
    //Updating Messages status to SEEN
    func updateClientStatus()  {
        var dict = [String : Any]()
        dict = ["chat_id" : self.chatSessionId , "TYPE" : "USER_IS_LIVE", "sender" : userId] as [String : Any]
        socket.emit(EVENT_NOTIFICATION, with: [dict])
    }
    
    //Updating Messages status to SEEN
    func updateMessageStatus(messageIds: [Int])  {
        var dict = [String : Any]()
        dict = ["chat_id" : self.chatSessionId , "TYPE" : "MSG_DELIVERY", "sender" : userId,"notify":agentId,
                "msg_status":MESSAGE_SEEN,"msg_id":messageIds] as [String : Any]
        socket.emit(EVENT_MSG_HELPER, with: [dict])
    }
    
    //Get Messages from API
    func getMessageAPI() -> Void {
        BlurtProgress.showProgressBar()
        let request = FetchMessageRequest()
        request.sessionId = chatSessionId
        
        //Calling Get Message API
        BlurtApi.getMessageAPI(request: request){ result in
            switch result {
            case .success(let data):
                if data.errorStatus{
                    showAlertBox(errorTitle: "Error", errorMessage: data.errorMessage, sender: self)
                }else{
                    self.messages = data.conversation!
                    self.chatTableView.reloadData()
                    self.scrollToBottom(self.chatTableView, self.messages)
                }
                BlurtProgress.dismissProgressBar()
            case .failure(let error ):
                BlurtProgress.dismissProgressBar()
                print("Falied to Get Messages:  ",error)
            }
        }
    }
}
