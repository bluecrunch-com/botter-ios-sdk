//
//  LoaderView.swift
//  Masters
//
//  Created by Nora on 3/7/19.
//  Copyright © 2019 BlueCrunch. All rights reserved.
//

import UIKit

class b_LoaderView: UIView {

    @IBOutlet weak var loaderIndicator : UIActivityIndicatorView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.loaderIndicator.color = BotterSettingsManager.AccentColor
    }
    
    func animate(){
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 1.25 // or however long you want ...
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
//        self.image.layer.add(rotation, forKey: "rotationAnimation")
        
    }

}
