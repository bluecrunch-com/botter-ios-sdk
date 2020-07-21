//
//  ChatInteractor.swift
//  Botter
//
//  Created by Nora on 6/3/20.
//  Copyright (c) 2020 BlueCrunch. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

final class ChatInteractor {
    var presenter: ChatPresenterInterface!
}

// MARK: - Extensions -

extension ChatInteractor: ChatInteractorInterface {
    
    func openSocket() {
        SocketManager.shared.connect()
        SocketManager.shared.messageRecieved = { msg in
            self.presenter.messageReceived(message: msg)
        }
    }
    
    func resend(msg: BasicMessage , completion:@escaping((Bool)->()))  {
        
        if SocketManager.shared.isConnected && ReachabilityManager.shared.isNetworkAvailable{
            if msg.blockValue != ""{
                SocketManager.shared.sendMessage(text: msg.blockValue) { (isSent) in
                    completion(isSent)
                }
            }else{
                SocketManager.shared.sendMessage(text: msg.text){ (isSent) in
                    completion(isSent)
                }
            }
             
        }else{
            SocketManager.shared.connect()
            completion(false)
        }
    }
    
    func sendMessage(text : String , completion:@escaping((BasicMessage)->())){
        let Message = BasicMessage()
        Message.type = "message"
        Message.isBotMsg = false
        Message.text = text
        self.presenter.clearTextBox()
        
        if SocketManager.shared.isConnected{
            SocketManager.shared.sendMessage(text: text){ isSent in
                completion(Message)
            }
        }else{
            SocketManager.shared.connect()
            Message.msgSent = false
            completion(Message)
        }
        
    }
    
    func triviaMessage(action : Action , completion:@escaping((BasicMessage)->())){
        let Message = BasicMessage()
        Message.type = "message"
        Message.isBotMsg = false
        Message.text = action.title
        if SocketManager.shared.isConnected{
            if action.action == .date{
                SocketManager.shared.sendMessage(text: action.title) { (isSent) in
                    completion(Message)
                }
            }else{
                SocketManager.shared.sendPostBack(value: action.value){ isSent in
                    completion(Message)
                }
            }
//            return true
        }else{
            SocketManager.shared.connect()
            Message.msgSent = false
//            return false
            Message.blockValue = action.value
            completion(Message)
        }
//        self.presenter.messageReceived(message: Message)
   
    }
    
    func actionClicked(action: Action) {
        switch action.action {
        case .call:
            presenter.call(number: action.value)
            break
        case .openUrl:
            presenter.openUrl(url: action.value)
            break
        case .postBack:
            SocketManager.shared.sendPostBack(value: action.value, completion: { isSent in
//                completion(isSent)
            })
            break
        default:
            break
        }
    }
    
    
    func sendMenuAction(action : MenuItem ,completion:@escaping((BasicMessage)->())){
        let Message = BasicMessage()
        Message.type = "message"
        Message.isBotMsg = false
        Message.text = action.title
        if SocketManager.shared.isConnected{
            SocketManager.shared.sendPostBack(value: action.payload){ isSent in
                completion(Message)
            }
        }else{
            SocketManager.shared.connect()
            Message.msgSent = false
            //            return false
            Message.blockValue = action.payload
            completion(Message)
        }
    }
}
