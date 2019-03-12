//
//  BlurtChatBaseViewController.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 27/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import UIKit
import SocketIO

class BlurtChatBaseViewController: UIViewController {
    
    var socket:SocketIOClient!
    var manager: SocketManager!
    var chatSessionId = ""
    var userProfile: UserProfileModel?
    var userId = ""
    
    var isAgentJoined = false
    var agentId = ""
    
    var placeHolderText = "Type a message..."
    let welcomeMessage = "Hi, Welcome to Blurt. How can we help you?"
    let typingStatusString = "Typing…"
    let onlineStatus = "Online"
    let offlineStatus = "Offline"
    let awayStatus = "Away"
    let unknownErrorString = "Unknown error occurred. Please try again."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfile = BlurtPrefrenceManager.getUserData()
        userId = (userProfile?.userId)!
        
    }
    
    //Settinng handler cell data
    func setHanlderData(_ cell: BlurtLeftTableViewCell, _ message: ConversationModel) -> BlurtLeftTableViewCell {
        
        cell.messageLabel.text = message.message
        cell.timeStampLabel.text = BlurtDateUtils.convertDateForChatMessageDisplay(timeStamp: message.timestamp.toDouble()!)
        return cell
    }
    
    //Setting own message cell data
    func setSelfData(_ cell: BlurtRightTableViewCell, _ message: ConversationModel) -> BlurtRightTableViewCell {
        
        cell.messageLabel.text = message.message
        if (message.messageStatus?.isEqualToString(find: MESSAGE_SEEN))! {
            cell.tickImageView.image = UIImage(named: "two_tick")
        }else if (message.messageStatus?.isEqualToString(find: MESSAGE_SEND))! {
            cell.tickImageView.image = UIImage(named: "clock")
        }else if (message.messageStatus?.isEqualToString(find: MESSAGE_SENT))! {
            cell.tickImageView.image = UIImage(named: "icon_tick")
        }else if (message.messageStatus?.isEqualToString(find: MESSAGE_RECEIVED))! {
            cell.tickImageView.image = UIImage(named: "gray_two_tick")
        }
        
        cell.timeStampLabel.text = BlurtDateUtils.convertDateForChatMessageDisplay(timeStamp: message.timestamp.toDouble()!)
        return cell
    }
    
    
    /// Loading xib files of chat_table cells
    func loadingChatCellNibs(_ chatTableView: UITableView) {
        chatTableView.register( UINib(nibName: "LeftCellView", bundle: nil), forCellReuseIdentifier: LEFT_CELL)
        chatTableView.register( UINib(nibName: "RightCellView", bundle: nil), forCellReuseIdentifier: RIGHT_CELL)
    }
    
    
    
    
    
    func addWelcomeMessage() -> ConversationModel {
        let message = ConversationModel()
        message.message = welcomeMessage
        message.messageId =  1
        message.senderId = (userProfile?.userId)!
        message.sessionId = chatSessionId
        message.messageStatus = MESSAGE_SEND
        message.timestamp = String(Date().toMillis())
        return message
    }
    
    //scroll chat to bottom
    func scrollToBottom(_ tableView: UITableView, _ messages: [ConversationModel]){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: messages.count, section: 0)
            if messages.count > 1{
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    
    //Manage keyboard and bottom view move up
    func manageKeyBoardandBottomView()   {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func deregisterFromKeyboardNotifications()   {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
}
