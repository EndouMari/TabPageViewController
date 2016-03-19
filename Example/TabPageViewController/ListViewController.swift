//
//  ListViewController.swift
//  TabPageViewController
//
//  Created by EndouMari on 2016/03/23.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import TabPageViewController

class ListViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()


        let navigationHeight = navigationController?.navigationBar.frame.maxY ?? 0.0
        tableView.contentInset.top = navigationHeight + TabPageOption.tabHeight
    }

}


// MARK: - UITableViewDataSource

extension ListViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
}
