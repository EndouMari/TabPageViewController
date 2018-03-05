//
//  TabItem.swift
//  TabPageViewController
//
//  Created by Yohta Watanave on 2018/03/05.
//  Copyright © 2018年 Yohta Watanave. All rights reserved.
//

import UIKit

public protocol TabItemProtocol {
    var viewController: UIViewController { get }
    var cacheViewController: UIViewController? { get }
    var title: String { get }
}

public struct TabItem: TabItemProtocol {
    public let viewController: UIViewController
    public let title: String
    public let cacheViewController: UIViewController?
    
    public init(viewController: UIViewController, title: String) {
        self.viewController = viewController
        self.title = title
        self.cacheViewController = viewController
    }
    
    public init(tuple: (UIViewController, String)) {
        self.init(viewController: tuple.0, title: tuple.1)
    }
}

public class LazyTabItem: TabItemProtocol {
    public let title: String
    public let createViewControllerBlock: ()->UIViewController
    private(set) public weak var cacheViewController: UIViewController?
    
    init(title: String, createViewController: @escaping ()->UIViewController) {
        self.title = title
        self.createViewControllerBlock = createViewController
    }
    
    public var viewController: UIViewController {
        let viewController = createViewControllerBlock()
        cacheViewController = viewController
        return viewController
    }
}
