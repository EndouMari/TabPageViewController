//
//  LimitedTabPageViewController.swift
//  TabPageViewController
//
//  Created by Tomoya Hayakawa on 2017/08/05.
//
//

import UIKit
import TabPageViewController

class LimitedTabPageViewController: TabPageViewController {

    override init() {
        super.init()
//        let vc1 = UIViewController()
//        vc1.view.backgroundColor = UIColor.white
//        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListViewController")
        let tabItems = [
            LazyTabItem(title: "First") {
                let vc1 = UIViewController()
                vc1.view.backgroundColor = UIColor.white
                return vc1
            },
            LazyTabItem(title: "First") {
                UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListViewController")
            }
        ]
        self.tabItems = tabItems
        option.tabWidth = view.frame.width / CGFloat(tabItems.count)
        option.hidesTopViewOnSwipeType = .all
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
