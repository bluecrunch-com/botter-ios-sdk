//
//  CustomActionTableViewCell.swift
//  Botter
//
//  Created by Nora on 11/4/21.
//  Copyright © 2021 BlueCrunch. All rights reserved.
//

import Foundation
import UIKit


class CustomActionTableViewCell : UITableViewCell {
    
    var action = CustomAction()
    
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var iconImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(customAction : CustomAction){
        self.action = customAction
        titleLbl.text = self.action.title
        iconImage.image = self.action.icon
    }
    
}
