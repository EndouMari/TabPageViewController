//
//  ViewController.swift
//  TabPageViewController
//
//  Created by EndouMari on 03/19/2016.
//  Copyright (c) 2016 EndouMari. All rights reserved.
//

import UIKit
import TabPageViewController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LimitedButton(button: UIButton) {
        let tc = TabPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.cyanColor()
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.magentaColor()
        tc.tabItems = [(vc1, "未読"), (vc2, "既読")]
        navigationController?.pushViewController(tc, animated: true)
    }

    @IBAction func InfinityButton(button: UIButton) {
        let tc = TabPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.yellowColor()
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.redColor()
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.blueColor()
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.greenColor()
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor.orangeColor()
        tc.tabItems = [(vc1, "月曜日"), (vc2, "火曜日"), (vc3, "水曜日"), (vc4, "木曜日"), (vc5, "金曜日")]
        tc.isInfinity = true
        navigationController?.pushViewController(tc, animated: true)
    }
}

