//
//  TabView.swift
//  TabPageViewController
//
//  Created by EndouMari on 2016/02/24.
//  Copyright © 2016年 EndouMari. All rights reserved.
//

import UIKit

internal class TabView: UIView {

    var pageItemPressedBlock: ((index: Int, direction: UIPageViewControllerNavigationDirection) -> Void)?
    var pageTabItems: [String] = [] {
        didSet {
            pageTabItemsCount = pageTabItems.count
            beforeIndex = pageTabItems.count
        }
    }

    private var isInfinity: Bool = false
    private var option: TabPageOption = TabPageOption()
    private var beforeIndex: Int = 0
    private var currentIndex: Int = 0
    private var pageTabItemsCount: Int = 0
    private var shouldScrollToItem: Bool = false
    private var pageTabItemsWidth: CGFloat = 0.0
    private var collectionViewContentOffsetX: CGFloat = 0.0
    private var currentBarViewWidth: CGFloat = 0.0
    private var cellForSize: TabCollectionCell!
    private var cachedCellSizes: [NSIndexPath: CGSize] = [:]
    private var currentBarViewLeftConstraint: NSLayoutConstraint?

    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var currentBarView: UIView!
    @IBOutlet private weak var currentBarViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomBarViewHeightConstraint: NSLayoutConstraint!

    init(isInfinity: Bool, option: TabPageOption) {
       super.init(frame: CGRectZero)
        self.option = option
        self.isInfinity = isInfinity
        NSBundle(forClass: TabView.self).loadNibNamed("TabView", owner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = option.tabBackgroundColor

        let top = NSLayoutConstraint(item: contentView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0.0)

        let left = NSLayoutConstraint(item: contentView,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Leading,
            multiplier: 1.0,
            constant: 0.0)

        let bottom = NSLayoutConstraint (item: self,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0.0)

        let right = NSLayoutConstraint(item: self,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: 0.0)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([top, left, bottom, right])

        let bundle = NSBundle(forClass: TabView.self)
        let nib = UINib(nibName: TabCollectionCell.cellIdentifier(), bundle: bundle)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: TabCollectionCell.cellIdentifier())
        cellForSize = nib.instantiateWithOwner(nil, options: nil).first as! TabCollectionCell

        collectionView.scrollsToTop = false

        currentBarView.backgroundColor = option.currentColor
        if !isInfinity {
            currentBarView.removeFromSuperview()
            collectionView.addSubview(currentBarView)
            currentBarView.translatesAutoresizingMaskIntoConstraints = false
            let top = NSLayoutConstraint(item: currentBarView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: collectionView,
                attribute: .Top,
                multiplier: 1.0,
                constant: option.tabHeight - currentBarView.frame.height)

            let left = NSLayoutConstraint(item: currentBarView,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: collectionView,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 0.0)
            currentBarViewLeftConstraint = left
            collectionView.addConstraints([top, left])
        }

        bottomBarViewHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
    }

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// MARK: - View

extension TabView {

    /**
     Called when you swipe in isInfinityTabPageViewController, moves the contentOffset of collectionView

     - parameter index: Next Index
     - parameter contentOffsetX: contentOffset.x of scrollView of isInfinityTabPageViewController
     */
    func scrollCurrentBarView(index: Int, contentOffsetX: CGFloat) {
        var nextIndex = isInfinity ? index + pageTabItemsCount : index
        if isInfinity && index == 0 && (beforeIndex - pageTabItemsCount) == pageTabItemsCount - 1 {
            // Calculate the index at the time of transition to the first item from the last item of pageTabItems
            nextIndex = pageTabItemsCount * 2
        } else if isInfinity && (index == pageTabItemsCount - 1) && (beforeIndex - pageTabItemsCount) == 0 {
            // Calculate the index at the time of transition from the first item of pageTabItems to the last item
            nextIndex = pageTabItemsCount - 1
        }

        if collectionViewContentOffsetX == 0.0 {
            collectionViewContentOffsetX = collectionView.contentOffset.x
        }

        let currentIndexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
        let nextIndexPath = NSIndexPath(forItem: nextIndex, inSection: 0)
        if let currentCell = collectionView.cellForItemAtIndexPath(currentIndexPath) as? TabCollectionCell, nextCell = collectionView.cellForItemAtIndexPath(nextIndexPath) as? TabCollectionCell {
            nextCell.hideCurrentBarView()
            currentCell.hideCurrentBarView()
            currentBarView.hidden = false

            if currentBarViewWidth == 0.0 {
                currentBarViewWidth = currentCell.frame.width
            }

            let distance = (currentCell.frame.width / 2.0) + (nextCell.frame.width / 2.0)
            let scrollRate = contentOffsetX / frame.width

            if fabs(scrollRate) > 0.6 {
                nextCell.highlightTitle()
                currentCell.unHighlightTitle()
            } else {
                nextCell.unHighlightTitle()
                currentCell.highlightTitle()
            }

            let width = fabs(scrollRate) * (nextCell.frame.width - currentCell.frame.width)
            if isInfinity {
                let scroll = scrollRate * distance
                collectionView.contentOffset.x = collectionViewContentOffsetX + scroll
            } else {
                if scrollRate > 0 {
                currentBarViewLeftConstraint?.constant = currentCell.frame.minX + scrollRate * currentCell.frame.width
                } else {
                    currentBarViewLeftConstraint?.constant = currentCell.frame.minX + nextCell.frame.width * scrollRate
                }
            }
            currentBarViewWidthConstraint.constant = currentBarViewWidth + width
        }
    }

    /**
     Center the current cell after page swipe
     */
    func scrollToHorizontalCenter() {
        let indexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
        collectionViewContentOffsetX = collectionView.contentOffset.x
    }

    /**
     Called in after the transition is complete pages in isInfinityTabPageViewController in the process of updating the current

     - parameter index: Next Index
     */
    func updateCurrentIndex(index: Int, shouldScroll: Bool) {
        deselectVisibleCells()

        currentIndex = isInfinity ? index + pageTabItemsCount : index

        let indexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
        moveCurrentBarView(indexPath, animated: !isInfinity, shouldScroll: shouldScroll)
    }

    /**
     Make the tapped cell the current if isInfinity is true

     - parameter index: Next IndexPath√
     */
    private func updateCurrentIndexForTap(index: Int) {
        deselectVisibleCells()

        if isInfinity && (index < pageTabItemsCount) || (index >= pageTabItemsCount * 2) {
            currentIndex = (index < pageTabItemsCount) ? index + pageTabItemsCount : index - pageTabItemsCount
            shouldScrollToItem = true
        } else {
            currentIndex = index
        }
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        moveCurrentBarView(indexPath, animated: true, shouldScroll: true)
    }

    /**
     Move the collectionView to IndexPath of Current

     - parameter indexPath: Next IndexPath
     - parameter animated: true when you tap to move the isInfinityTabCollectionCell
     - parameter shouldScroll:
     */
    private func moveCurrentBarView(indexPath: NSIndexPath, animated: Bool, shouldScroll: Bool) {
        if shouldScroll {
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: animated)
            layoutIfNeeded()
            collectionViewContentOffsetX = 0.0
            currentBarViewWidth = 0.0
        }
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TabCollectionCell {
            currentBarView.hidden = false
            if animated && shouldScroll {
                cell.isCurrent = true
            }
            cell.hideCurrentBarView()
            currentBarViewWidthConstraint.constant = cell.frame.width
            if !isInfinity {
                currentBarViewLeftConstraint?.constant = cell.frame.origin.x
            }
            UIView.animateWithDuration(0.2, animations: {
                self.layoutIfNeeded()
                }, completion: { _ in
                    if !animated && shouldScroll {
                        cell.isCurrent = true
                    }
                    if !self.isInfinity {
                        self.updateCollectionViewUserInteractionEnabled(true)
                    }
            })
        }
        beforeIndex = currentIndex
    }

    /**
     Touch event control of collectionView

     - parameter userInteractionEnabled: collectionViewに渡すuserInteractionEnabled
     */
    func updateCollectionViewUserInteractionEnabled(userInteractionEnabled: Bool) {
        collectionView.userInteractionEnabled = userInteractionEnabled
    }

    /**
     Update all of the cells in the display to the unselected state
     */
    private func deselectVisibleCells() {
        collectionView
            .visibleCells()
            .flatMap { $0 as? TabCollectionCell }
            .forEach { $0.isCurrent = false }
    }
}


// MARK: - UICollectionViewDataSource

extension TabView: UICollectionViewDataSource {

    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isInfinity ? pageTabItemsCount * 3 : pageTabItemsCount
    }

    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TabCollectionCell.cellIdentifier(), forIndexPath: indexPath) as! TabCollectionCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }

    private func configureCell(cell: TabCollectionCell, indexPath: NSIndexPath) {
        let fixedIndex = isInfinity ? indexPath.item % pageTabItemsCount : indexPath.item
        cell.item = pageTabItems[fixedIndex]
        cell.option = option
        cell.isCurrent = fixedIndex == (currentIndex % pageTabItemsCount)
        cell.tabItemButtonPressedBlock = { [weak self, weak cell] in
            var direction: UIPageViewControllerNavigationDirection = .Forward
            if let pageTabItemsCount = self?.pageTabItemsCount, currentIndex = self?.currentIndex {
                if self?.isInfinity == true {
                    if (indexPath.item < pageTabItemsCount) || (indexPath.item < currentIndex) {
                        direction = .Reverse
                    }
                } else {
                    if indexPath.item < currentIndex {
                        direction = .Reverse
                    }
                }
            }
            self?.pageItemPressedBlock?(index: fixedIndex, direction: direction)

            if cell?.isCurrent == false {
                // Not accept touch events to scroll the animation is finished
                self?.updateCollectionViewUserInteractionEnabled(false)
            }
            self?.updateCurrentIndexForTap(indexPath.item)
        }
    }
}


// MARK: - UIScrollViewDelegate

extension TabView: UICollectionViewDelegate {

    internal func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.dragging {
            currentBarView.hidden = true
            let indexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TabCollectionCell {
                cell.showCurrentBarView()
            }
        }

        guard isInfinity else {
            return
        }

        if pageTabItemsWidth == 0.0 {
            pageTabItemsWidth = floor(scrollView.contentSize.width / 3.0)
        }

        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x > pageTabItemsWidth * 2.0) {
            scrollView.contentOffset.x = pageTabItemsWidth
        }

    }

    internal func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        // Accept the touch event because animation is complete
        updateCollectionViewUserInteractionEnabled(true)

        guard isInfinity else {
            return
        }

        let indexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
        if shouldScrollToItem {
            // After the moved so as not to sense of incongruity, to adjust the contentOffset at the currentIndex
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
            shouldScrollToItem = false
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension TabView: UICollectionViewDelegateFlowLayout {

    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        if let size = cachedCellSizes[indexPath] {
            return size
        }

        configureCell(cellForSize, indexPath: indexPath)

        let size = cellForSize.sizeThatFits(CGSizeMake(collectionView.bounds.width, option.tabHeight))
        cachedCellSizes[indexPath] = size

        return size
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
}
