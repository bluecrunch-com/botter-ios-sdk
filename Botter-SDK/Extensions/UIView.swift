//
//  UIView.swift
//  AHA! Journal
//
//  Created by George Naiem on 9/3/16.
//  Copyright © 2016 ahealthadventure. All rights reserved.
//

import UIKit

extension UIView {
    
       @IBInspectable var b_cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            clipsToBounds = newValue > 0
        }
    }
    
    @IBInspectable var b_drobShadow: Bool {
        get{
            return false
        }
        set {
            self.dropShadow(apply: newValue)
            
        }
    }
   
    
    @IBInspectable var b_borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var b_borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    
    func b_startRotating() {
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations:
            { () -> Void in
                self.transform = self.transform.rotated(by: CGFloat(Double.pi/2))
        }) { (finished) -> Void in
            if self.tag == 10{
                self.b_startRotating()
            }else{
                self.isHidden = true
            }
        }
        tag = 10
    }

    
    
    func stopRotating() {
        
        tag = 0
        
    }
    
    func dropShadow(apply : Bool) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = apply ? UIColor.black.cgColor : UIColor.clear.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: -1, height: 0.5)
        self.layer.shadowRadius = 0.5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func appIsArabic()->Bool{
        let language = Bundle.main.preferredLocalizations[0] as NSString
        if language.contains("ar"){
            return true
        }
        else{
            return false
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
//        if self is chatView{
//            self.semanticContentAttribute = .forceLeftToRight
//        }else{
//            if BotterSettingsManager.language == .english{
//                UIView.appearance().semanticContentAttribute = .forceLeftToRight
//            }else{
//                UIView.appearance().semanticContentAttribute = .forceRightToLeft
//            }
//        }
    }
    
}

