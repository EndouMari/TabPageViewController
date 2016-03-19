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
        let tc = TabPageViewController.create()
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.whiteColor()
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ListViewController")
        tc.tabItems = [(vc1, "First"), (vc2, "Second")]
        navigationController?.pushViewController(tc, animated: true)
    }

    @IBAction func InfinityButton(button: UIButton) {
        let tc = TabPageViewController.create()
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor(red: 251/255, green: 252/255, blue: 149/255, alpha: 1.0)
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor(red: 252/255, green: 150/255, blue: 149/255, alpha: 1.0)
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor(red: 149/255, green: 218/255, blue: 252/255, alpha: 1.0)
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor(red: 149/255, green: 252/255, blue: 197/255, alpha: 1.0)
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor(red: 252/255, green: 182/255, blue: 106/255, alpha: 1.0)
        tc.tabItems = [(vc1, "月曜日"), (vc2, "火曜日"), (vc3, "水曜日"), (vc4, "木曜日"), (vc5, "金曜日")]
        tc.isInfinity = true
        navigationController?.pushViewController(tc, animated: true)
    }
}

