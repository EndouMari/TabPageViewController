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

    @IBAction func LimitedButton(_ button: UIButton) {
        let tc = TabPageViewController.create()
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.white
        vc1.title = "First"
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListViewController")
        vc2.title = "Second"
        tc.tabItems = [vc1, vc2]
        var option = TabPageOption()
        option.tabWidth = view.frame.width / CGFloat(tc.tabItems.count)
        option.hidesTopViewOnSwipeType = .all
        tc.option = option
        navigationController?.pushViewController(tc, animated: true)
    }

    @IBAction func InfinityButton(_ button: UIButton) {
        let tc = TabPageViewController.create()
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor(red: 251/255, green: 252/255, blue: 149/255, alpha: 1.0)
        vc1.title = "Mon."
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor(red: 252/255, green: 150/255, blue: 149/255, alpha: 1.0)
        vc2.title = "Tue."
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor(red: 149/255, green: 218/255, blue: 252/255, alpha: 1.0)
        vc3.title = "Wed."
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor(red: 149/255, green: 252/255, blue: 197/255, alpha: 1.0)
        vc4.title = "Thu."
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor(red: 252/255, green: 182/255, blue: 106/255, alpha: 1.0)
        vc5.title = "Fri."
        tc.tabItems = [vc1, vc2, vc3, vc4, vc5]
        tc.isInfinity = true
        let nc = UINavigationController()
        nc.viewControllers = [tc]
        var option = TabPageOption()
        option.currentColor = UIColor(red: 246/255, green: 175/255, blue: 32/255, alpha: 1.0)
        option.tabMargin = 30.0
        tc.option = option
        navigationController?.pushViewController(tc, animated: true)
    }
}
