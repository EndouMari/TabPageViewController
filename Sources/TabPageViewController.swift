//
//  TabPageViewController.swift
//  TabPageViewController
//
//  Created by EndouMari on 2016/02/24.
//  Copyright © 2016年 EndouMari. All rights reserved.
//

import UIKit

open class TabPageViewController: UIPageViewController {
    open var isInfinity: Bool = false
    open var option: TabPageOption = TabPageOption()
    open var tabItems: [(viewController: UIViewController, title: String)] = []

    var currentIndex: Int? {
        guard let viewController = viewControllers?.first else {
            return nil
        }
        return tabItems.map{ $0.viewController }.index(of: viewController)
    }
    fileprivate var beforeIndex: Int = 0
    fileprivate var tabItemsCount: Int {
        return tabItems.count
    }
    fileprivate var defaultContentOffsetX: CGFloat {
        return self.view.bounds.width
    }
    fileprivate var shouldScrollCurrentBar: Bool = true
    lazy fileprivate var tabView: TabView = self.configuredTabView()
    fileprivate var statusView: UIView?
    fileprivate var statusViewHeightConstraint: NSLayoutConstraint?
    fileprivate var tabBarTopConstraint: NSLayoutConstraint?

    public init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
        setupScrollView()
        updateNavigationBar()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if tabView.superview == nil {
            tabView = configuredTabView()
        }

        if let currentIndex = currentIndex , isInfinity {
            tabView.updateCurrentIndex(currentIndex, shouldScroll: true)
        }
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateNavigationBar()
        tabView.layouted = true
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
}


// MARK: - Public Interface

public extension TabPageViewController {

    public func displayControllerWithIndex(_ index: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {

        beforeIndex = index
        shouldScrollCurrentBar = false
        let nextViewControllers: [UIViewController] = [tabItems[index].viewController]

        let completion: ((Bool) -> Void) = { [weak self] _ in
            self?.shouldScrollCurrentBar = true
            self?.beforeIndex = index
        }

        setViewControllers(
            nextViewControllers,
            direction: direction,
            animated: animated,
            completion: completion)

        guard isViewLoaded else { return }
        tabView.updateCurrentIndex(index, shouldScroll: true)
    }
}


// MARK: - View

extension TabPageViewController {

    fileprivate func setupPageViewController() {
        dataSource = self
        delegate = self
        automaticallyAdjustsScrollViewInsets = false

        setViewControllers([tabItems[beforeIndex].viewController],
                           direction: .forward,
                           animated: false,
                           completion: nil)
    }

    fileprivate func setupScrollView() {
        // Disable PageViewController's ScrollView bounce
        let scrollView = view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.scrollsToTop = false
        scrollView?.delegate = self
        scrollView?.backgroundColor = option.pageBackgoundColor
    }

    /**
     Update NavigationBar
     */

    fileprivate func updateNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(option.tabBackgroundImage, for: .default)
            navigationBar.isTranslucent = option.isTranslucent
        }
    }

    fileprivate func configuredTabView() -> TabView {
        let tabView = TabView(isInfinity: isInfinity, option: option)
        view.addSubview(tabView)

        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabBarTopConstraint = tabView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            tabView.heightAnchor.constraint(equalToConstant: option.tabHeight),
            tabBarTopConstraint!,
            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])

        tabView.pageTabItems = tabItems.map({ $0.title})
        tabView.updateCurrentIndex(beforeIndex, shouldScroll: true)

        tabView.pageItemPressedBlock = { [weak self] (index: Int, direction: UIPageViewControllerNavigationDirection) in
            self?.displayControllerWithIndex(index, direction: direction, animated: true)
        }

        return tabView
    }

    private func setupStatusView() {
        let statusView = UIView()
        statusView.backgroundColor = option.tabBackgroundColor
        view.addSubview(statusView)

        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusViewHeightConstraint = statusView.heightAnchor.constraint(equalToConstant: topLayoutGuide.length)
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: view.topAnchor),
            statusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusViewHeightConstraint!
            ])

        self.statusView = statusView
    }

    public func updateNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        guard let navigationController = navigationController else { return }

        switch option.hidesTopViewOnSwipeType {
        case .tabBar:
            updateTabBarOrigin(hidden: hidden)
        case .navigationBar:
            if hidden {
                navigationController.setNavigationBarHidden(true, animated: true)
            } else {
                showNavigationBar()
            }
        case .all:
            updateTabBarOrigin(hidden: hidden)
            if hidden {
                navigationController.setNavigationBarHidden(true, animated: true)
            } else {
                showNavigationBar()
            }
        default:
            break
        }
        if statusView == nil {
            setupStatusView()
        }

        statusViewHeightConstraint!.constant = topLayoutGuide.length
    }

    public func showNavigationBar() {
        guard let navigationController = navigationController else { return }
        guard navigationController.isNavigationBarHidden  else { return }
        guard let tabBarTopConstraint = tabBarTopConstraint else { return }

        if option.hidesTopViewOnSwipeType != .none {
            tabBarTopConstraint.constant = 0.0
            UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration)) {
                self.view.layoutIfNeeded()
            }
        }

        navigationController.setNavigationBarHidden(false, animated: true)
        
    }

    private func updateTabBarOrigin(hidden: Bool) {
        guard let tabBarTopConstraint = tabBarTopConstraint else { return }

        tabBarTopConstraint.constant = hidden ? -(20.0 + option.tabHeight) : 0.0
        UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration)) {
            self.view.layoutIfNeeded()
        }
    }
}


// MARK: - UIPageViewControllerDataSource

extension TabPageViewController: UIPageViewControllerDataSource {

    fileprivate func nextViewController(_ viewController: UIViewController, isAfter: Bool) -> UIViewController? {

        guard var index = tabItems.map({$0.viewController}).index(of: viewController) else {
            return nil
        }

        if isAfter {
            index += 1
        } else {
            index -= 1
        }

        if isInfinity {
            if index < 0 {
                index = tabItems.count - 1
            } else if index == tabItems.count {
                index = 0
            }
        }

        if index >= 0 && index < tabItems.count {
            return tabItems[index].viewController
        }
        return nil
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, isAfter: true)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, isAfter: false)
    }
}


// MARK: - UIPageViewControllerDelegate

extension TabPageViewController: UIPageViewControllerDelegate {

    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        shouldScrollCurrentBar = true
        tabView.scrollToHorizontalCenter()

        // Order to prevent the the hit repeatedly during animation
        tabView.updateCollectionViewUserInteractionEnabled(false)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentIndex = currentIndex , currentIndex < tabItemsCount {
            tabView.updateCurrentIndex(currentIndex, shouldScroll: false)
            beforeIndex = currentIndex
        }

        tabView.updateCollectionViewUserInteractionEnabled(true)
    }
}


// MARK: - UIScrollViewDelegate

extension TabPageViewController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == defaultContentOffsetX || !shouldScrollCurrentBar {
            return
        }

        // (0..<tabItemsCount)
        var index: Int
        if scrollView.contentOffset.x > defaultContentOffsetX {
            index = beforeIndex + 1
        } else {
            index = beforeIndex - 1
        }
        
        if index == tabItemsCount {
            index = 0
        } else if index < 0 {
            index = tabItemsCount - 1
        }

        let scrollOffsetX = scrollView.contentOffset.x - view.frame.width
        tabView.scrollCurrentBarView(index, contentOffsetX: scrollOffsetX)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tabView.updateCurrentIndex(beforeIndex, shouldScroll: true)
    }
}
