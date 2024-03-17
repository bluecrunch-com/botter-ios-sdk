//
//  VideoBotTableViewCell.swift
//  Botter
//
//  Created by Nora on 6/4/20.
//  Copyright © 2020 BlueCrunch. All rights reserved.
//

import UIKit

class VideoBotTableViewCell: ImageBotTableViewCell {
    
    var openVideo : ((String)->())!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func playVideoClicked(){
        if openVideo != nil{
            openVideo(msg.url)
        }
    }
    
    override func setData(msg: b_BasicMessage, showIcon: Bool = false) {
        super.setData(msg: msg, showIcon: showIcon)
        DispatchQueue.main.async {
            self.msg.lazyImage.show(imageView: self.msgImage!, url: msg.mediaUrl) { (lazyError) in
                //            print(lazyError?.localizedDescription)
            }
        }
    }
    
}
extension String{
    func extractYouTubeId() -> String? {
        let typePattern = "(?:(?:\\.be\\/|embed\\/|v\\/|\\?v=|\\&v=|\\/videos\\/)|(?:[\\w+]+#\\w\\/\\w(?:\\/[\\w]+)?\\/\\w\\/))([\\w-_]+)"
        let regex = try? NSRegularExpression(pattern: typePattern, options: .caseInsensitive)
        return regex
            .flatMap { $0.firstMatch(in: self, range: NSMakeRange(0, self.count)) }
            .flatMap { Range($0.range(at: 1), in: self) }
            .map { String(self[$0]) }
    }
    
    func isYoutubeLink() -> Bool {

    let youtubeRegex = "(http(s)?:\\/\\/)?(www\\.|m\\.)?youtu(be\\.com|\\.be)(\\/watch\\?([&=a-z]{0,})(v=[\\d\\w]{1,}).+|\\/[\\d\\w]{1,})"

    let youtubeCheckResult = NSPredicate(format: "SELF MATCHES %@", youtubeRegex)
        return youtubeCheckResult.evaluate(with: self)
    }
}
