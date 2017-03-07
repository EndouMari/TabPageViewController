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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let navigationHeight = topLayoutGuide.length 
        tableView.contentInset.top = navigationHeight + TabPageOption().tabHeight
    }
}


// MARK: - UITableViewDataSource

extension ListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = String((indexPath as NSIndexPath).row)
        return cell
    }
}
