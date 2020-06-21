//
//  AudioBotTableViewCell.swift
//  Botter
//
//  Created by Nora on 6/10/20.
//  Copyright © 2020 BlueCrunch. All rights reserved.
//

import UIKit
//import KDEAudioPlayer

class AudioBotTableViewCell: BotChatTableViewCell {

    @IBOutlet weak var imageBtn : UIButton!
    @IBOutlet weak var actionBtn : UIButton!
    @IBOutlet weak var seekBar : UISlider!
    @IBOutlet weak var progress : UIActivityIndicatorView!
    
//    var player = Player()
    
    var isCurrent = false
    var durationTxt = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func setData(msg: BasicMessage, showIcon: Bool = false ,isCurrent: Bool , index : Int){
        super.setData(msg: msg, showIcon: showIcon)
        imageBtn.tag = index
        seekBar.value = 0
        self.setDuration()
        self.msg.foundDuration = {
            self.setDuration()
        }
        
        AudioHandler.setImage(state: AudioHandler.shared.player.state, cell: self)
        
    }
    
    @IBAction func buttonTapped(){
        AudioHandler.shared.playPausePressed(cell: self)

    }

    
    override func prepareForReuse() {
//        player = AudioPlayer()
        durationTxt = ""
        imageBtn.tag = 0
    }
    
    func setDuration(){
//        if (msg.audioDuration < 60) {
//            durationTxt = String(format: "0:%02ld", msg.audioDuration)
//        } else {
//            durationTxt = String(format: "%ld:%02ld", msg.audioDuration / 60, Int(msg.audioDuration) % 60)
//        }
        durationTxt = msg.audioDuration.asString(style: .positional)
        textLbl.text = durationTxt
        seekBar.maximumValue = Float(msg.audioDuration)
        seekBar.value = 0
    }
    
    @IBAction func seekBarValueChanded(_ sender : UISlider){
        AudioHandler.shared.seekTo(sender.value, cell: self)
    }

}
extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.unitsStyle = style
    formatter.zeroFormattingBehavior = .pad
    guard let formattedString = formatter.string(from: self) else { return "" }
    return formattedString
  }
    
}
