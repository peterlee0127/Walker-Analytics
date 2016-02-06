//
//  SettingViewController.swift
//  WalkerAnalytics
//
//  Created by Peterlee on 11/26/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startStairs() {
        let speak:SpeakerManager = SpeakerManager.sharedInstance
        speak.say("前方有樓梯，請小心行走")
    }
    @IBAction func endStairs() {
        let speak:SpeakerManager = SpeakerManager.sharedInstance
        speak.say("即將離開樓梯區域")
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    } //This is swift code
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
