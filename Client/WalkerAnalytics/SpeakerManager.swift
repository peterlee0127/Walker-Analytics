//
//  SpeakerManager.swift
//  WalkerAnalytics
//
//  Created by Peterlee on 11/25/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

import UIKit
import AVFoundation

class SpeakerManager: NSObject {
    var speechSyn:AVSpeechSynthesizer?
    
    class var sharedInstance: SpeakerManager {
        struct Static {
            static var instance:SpeakerManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = SpeakerManager()
        }
        return Static.instance!
    }
    override init() {
        super.init()
        speechSyn = AVSpeechSynthesizer()
    }
    func say(text:String){
        if(!speechSyn!.speaking) {
            let utt:AVSpeechUtterance = AVSpeechUtterance(string:text)
//            utt.voice = AVSpeechSynthesisVoice(language: "zh-TW")
            utt.rate = 0.01
            
            speechSyn!.speakUtterance(utt)
        }
        else {
            
        }
    }
   /*
     AVSpeechSynthesizer *syn=[[AVSpeechSynthesizer alloc] init]; AVSpeechUtterance *utt=[AVSpeechUtterance speechUtteranceWithString:@"Say Hello"]; [utt setRate:0.15]; [syn speakUtterance:utt]; 
    */
    
    
}
