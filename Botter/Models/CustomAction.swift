//
//  CustomAction.swift
//  Botter
//
//  Created by Nora on 11/4/21.
//  Copyright © 2021 BlueCrunch. All rights reserved.
//

import Foundation

class CustomAction {
    
    var title : String = "Action"
    var icon : UIImage = UIImage(named: "file", in: MyFrameworkBundle.bundle , compatibleWith: nil)!
    var action : (()->())! = {
        print("pressed")
    }
    
}
