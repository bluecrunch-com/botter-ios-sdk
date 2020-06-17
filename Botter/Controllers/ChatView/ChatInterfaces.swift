//
//  ChatInterfaces.swift
//  Botter
//
//  Created by Nora on 6/3/20.
//  Copyright (c) 2020 BlueCrunch. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

protocol ChatWireframeInterface: WireframeInterface {
    func openVideo(url : String)
    func openUrl(url : String)
    func call(number: String)
}

protocol ChatViewInterface: ViewInterface {
    func reload()
    func clearTextBox()
    func showError(errorMsg : String)
    
}

protocol ChatPresenterInterface: PresenterInterface {
    var messgesList : [BasicMessage]! { get set }
    func openSocket()
    func messageReceived(message : BasicMessage)
    func sendMessage(text : String)
    func clearTextBox()
    func showError(errorMsg : String)
    func openVideo(url : String)
    func actionClicked(action : Action)
    func openUrl(url : String)
    func call(number: String)
    func triviaActionClicked(action: Action)
    
}

protocol ChatInteractorInterface: InteractorInterface {
    func openSocket()
    func sendMessage(text : String)
    func actionClicked(action : Action)
    func triviaMessage(text : String)->Bool
    
}
