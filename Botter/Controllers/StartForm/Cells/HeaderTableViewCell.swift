//
//  HeaderTableViewCell.swift
//  Botter
//
//  Created by Nora on 9/3/20.
//  Copyright © 2020 BlueCrunch. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var continueSessionView : b_AllSidsCardView!
    @IBOutlet weak var oldConvName : b_BasicMediumLbl!
    @IBOutlet weak var oldConvText : b_BasicMediumLbl!
    @IBOutlet weak var logoImage : UIImageView!
    
    var action : (()->())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        if ChatSessionManager.shared.hasActiveSession(){
            continueSessionView.isHidden = false
            oldConvName.text = BotterSettingsManager.ChatTitleText
            oldConvText.text = ChatSessionManager.shared.getActiveSessionMsg()
            logoImage.tintColor = BotterSettingsManager.FontColor
            logoImage.image = BotterSettingsManager.logo
            let logo : UIImage = UIImage(named: "botterIcon", in: MyFrameworkBundle.bundle , compatibleWith: nil)!
            
            if BotterSettingsManager.logo == logo{
                self.logoImage.contentMode = .center
            }else{
                self.logoImage.contentMode = .scaleAspectFit
            }
        }else{
            continueSessionView.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func continueConversationClicked(){
        if action != nil{
            action()
        }
    }
    
}
