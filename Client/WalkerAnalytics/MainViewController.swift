//
//  MainViewController.swift
//  WalkerAnalytics
//
//  Created by Peterlee on 10/2/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet var scrollView:UIScrollView?
    var mode:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        mode = 2
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scrollView!.frame = view.frame
        scrollView!.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height*CGFloat(mode))
        scrollView!.delegate = self
        scrollView!.pagingEnabled = true
        scrollView!.scrollEnabled = false
        
        addViewController()
    }
    func addViewController(){
        var mainVC:ViewController = ViewController(nibName: "ViewController", bundle: nil)
        mainVC.view.frame = view.frame
        scrollView!.addSubview(mainVC.view)
        addChildViewController(mainVC)
    
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var height:CGFloat = scrollView.frame.size.height
        var page:Int = ( Int(Int(scrollView.contentOffset.y) + Int(0.5*height))/Int(height))
        page++
        // 1 2 3 ...
        if(page==2){
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
