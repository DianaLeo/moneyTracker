//
//  PopupViewController.swift
//  moneyTracker
//
//  Created by User on 28/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    var btn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.superview?.frame = CGRectMake(40, 100, 200, 200)
        self.view.backgroundColor = UIColor.clearColor()
//        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
//        self.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        btn = UIButton(frame: CGRect(x: 50, y: 200, width: 100, height: 100))
        btn.backgroundColor = UIColor.magentaColor()
        btn.addTarget(self, action: "btnTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)

        // Do any additional setup after loading the view.
    }

    func btnTouch(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
