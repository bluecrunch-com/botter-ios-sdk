//
//  StartFormPresenter.swift
//  Botter
//
//  Created by Nora on 7/15/20.
//  Copyright (c) 2020 BlueCrunch. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation
import UIKit

final class StartFormPresenter {
    
    // MARK: - Private properties -
    
    var botData : b_BotData!
    var dataCells : [UITableViewCell]!
    var faqsData = [b_FaqData]()
    
    private unowned let view: StartFormViewInterface
    private let interactor: StartFormInteractorInterface
    private let wireframe: StartFormWireframeInterface
    
    // MARK: - Lifecycle -
    
    init(view: StartFormViewInterface, interactor: StartFormInteractorInterface, wireframe: StartFormWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.botData = b_BotData()
        self.dataCells = [UITableViewCell]()
    }
}

// MARK: - Extensions -

extension StartFormPresenter: StartFormPresenterInterface {
    func faqsError(error: String) {
        self.view.showMsg(msg: error)
    }
    
    func fetchedFaqsSuccessfully(faqsResponse: [b_FaqData]) {
        self.faqsData = faqsResponse
        self.view.setFaqsData(faqsData: faqsData)
    }
    
    func getFaqsData(searchText: String) {
        interactor.loadFaqs(searchText: searchText)
    }
    
    
    func loadForms(){
        interactor.loadForms()
    }
    
    func showLoader() {
        view.showLoader()
    }
    
    func hideLoader() {
        view.hideLoader()
    }
    
    func reload() {
        self.view.reload()
    }
    
    func getCells(){
        dataCells.removeAll()
        var dataList = [UITableViewCell]()
        
        if B_SocketManager.first{
           
            for action in BotterSettingsManager.actions{
                if let view = self.view as? b_StartFormViewController {
                let cCell = view.tableView.dequeueReusableCell(withIdentifier: "CustomActionTableViewCell") as? CustomActionTableViewCell
                cCell?.setData(customAction: action)
                dataList.append(cCell ?? UITableViewCell())
                }
            }
            
            if let view = self.view as? b_StartFormViewController {
                let header = view.tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as? HeaderTableViewCell
                header!.action = {
                    view.continueConversationClicked()
                }
                dataList.append(header ?? UITableViewCell())
            }
            
            for item in self.botData.startForm.inputs {
                if let view = self.view as? b_StartFormViewController {
                    switch item.type {
                    case .textfield:
                        let cell = view.tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as? TextInputTableViewCell
                        cell?.setData(input: item)
                        dataList.append(cell ?? UITableViewCell())
                        break
                    case .textarea:
                        let cell = view.tableView.dequeueReusableCell(withIdentifier: "TextAreaInputTableViewCell") as? TextAreaInputTableViewCell
                        cell?.setData(input: item)
                        dataList.append(cell ?? UITableViewCell())
                        break
                    case .date:
                        let cell = view.tableView.dequeueReusableCell(withIdentifier: "DateIntputTableViewCell") as? DateIntputTableViewCell
                        cell?.setData(input: item ,parent: view )
                        dataList.append(cell ?? UITableViewCell())
                        break
                    case .time:
                        let cell = view.tableView.dequeueReusableCell(withIdentifier: "TimeInputTableViewCell") as? TimeInputTableViewCell
                        cell?.setData(input: item, parent: view )
                        dataList.append(cell ?? UITableViewCell())
                        break
                    case .radio :
                        let cell = view.tableView.dequeueReusableCell(withIdentifier: "RadioInputTableViewCell") as? RadioInputTableViewCell
                        cell?.setData(input: item)
                        dataList.append(cell ?? UITableViewCell())
                        break
                    case .select :
                        if item.multiple{
                            let cell = view.tableView.dequeueReusableCell(withIdentifier: "SelectInputTableViewCell") as? SelectInputTableViewCell
                            cell?.setData(input: item)
                            dataList.append(cell ?? UITableViewCell())
                        }else{
                            let cell = view.tableView.dequeueReusableCell(withIdentifier: "RadioInputTableViewCell") as? RadioInputTableViewCell
                            cell?.setData(input: item)
                            dataList.append(cell ?? UITableViewCell())
                            break
                        }
                        break
                    default:
                        let cell = view.tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as? TextInputTableViewCell
                        cell?.setData(input: item)
                        dataList.append(cell ?? UITableViewCell())
                        break
                    }
                    
                }
            }
        }
        
        self.dataCells = dataList
        self.reload()
    }
    
    func validateThenSubmitForm() {
        self.interactor.validateForm()
    }
    
    func openChat() {
        self.wireframe.openChat(data: botData)
    }
}
