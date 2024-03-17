//
//  ImageBotTableViewCell.swift
//  Botter
//
//  Created by Nora on 6/4/20.
//  Copyright © 2020 BlueCrunch. All rights reserved.
//

import UIKit


class ImageBotTableViewCell: BotChatTableViewCell {
    
    @IBOutlet weak var msgImage : UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setData(msg: b_BasicMessage, showIcon: Bool = false) {
        super.setData(msg: msg, showIcon: showIcon)
        self.msgImage?.image = nil
        DispatchQueue.main.async {
            self.msg.lazyImage.show(imageView: self.msgImage!, url: msg.mediaUrl) { (lazyError) in
                //            print(lazyError?.localizedDescription)
            }
        }
        
    }

    
    override func prepareForReuse() {
           self.msg = b_BasicMessage()
           self.msgImage?.image = nil
       }
}
