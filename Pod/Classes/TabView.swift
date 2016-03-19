//
//  TabView.swift
//  TabPageViewController
//
//  Created by EndouMari on 2016/02/24.
//  Copyright © 2016年 EndouMari. All rights reserved.
//

import UIKit

internal class TabView: UIView {

    var isInfinity: Bool = false
    var pageItemPressedBlock: ((index: Int, direction: UIPageViewControllerNavigationDirection) -> Void)?
    var pageTabItems: [String] = [] {
        didSet {
            pageTabItemsCount = pageTabItems.count
            beforeIndex = pageTabItems.count
        }
    }

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

    init(isInfinity: Bool) {
       super.init(frame: CGRectZero)
        self.isInfinity = isInfinity
        NSBundle(forClass: TabView.self).loadNibNamed("TabView", owner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = TabPageOption.tabBackgroundColor

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

        currentBarView.backgroundColor = TabPageOption.currentColor
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
                constant: TabPageOption.tabHeight - currentBarView.frame.height)

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
     isInfinityTabPageViewControllerでスワイプしている時にに呼ばれる、collectionViewのcontentOffsetを動かす処理

     - parameter index: CurrentにしたいIndex
     - parameter contentOffsetX: isInfinityTabPageViewControllerのscrollViewのcontentOffset.x
     */
    func scrollCurrentBarView(index: Int, contentOffsetX: CGFloat) {
        var nextIndex = isInfinity ? index + pageTabItemsCount : index
        if isInfinity && index == 0 && (beforeIndex - pageTabItemsCount) == pageTabItemsCount - 1 {
            // pageTabItemsの最後のアイテムから一番目のアイテムに遷移するときのindexを計算
            nextIndex = pageTabItemsCount * 2
        } else if isInfinity && (index == pageTabItemsCount - 1) && (beforeIndex - pageTabItemsCount) == 0 {
            // pageTabItemsの一番目のアイテムから最後のアイテムに遷移するときのindexを計算
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
     スワイプでページを切り替えるときに現在のCurrentのCellを中央に移動させる処理
     */
    func scrollToHorizontalCenter() {
        let indexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
        collectionViewContentOffsetX = collectionView.contentOffset.x
    }

    /**
     Currentの更新処理でisInfinityTabPageViewControllerでページの遷移完了後に呼ばれる

     - parameter index: CurrentにしたいIndex
     */
    func updateCurrentIndex(index: Int) {
        deselectVisibleCells()

        currentIndex = isInfinity ? index + pageTabItemsCount : index

        let indexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
        moveCurrentBarView(indexPath, animated: !isInfinity)
    }

    /**
     isInfinityTabCollectionCellをタップした時にCurrentを更新する処理

     - parameter index: CurrentにしたいIndexを渡す
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
        moveCurrentBarView(indexPath, animated: true)
    }

    /**
     collectionViewをCurrentのIndexPathに移動させる処理

     - parameter indexPath: CurrentにしたいIndexPathを渡す
     - parameter animated: isInfinityTabCollectionCellをタップして移動させるときはtrue
     */
    private func moveCurrentBarView(indexPath: NSIndexPath, animated: Bool) {
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: animated)
        layoutIfNeeded()
        collectionViewContentOffsetX = 0.0
        currentBarViewWidth = 0.0
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TabCollectionCell {
            currentBarView.hidden = false
            cell.isCurrent = true
            cell.hideCurrentBarView()
            currentBarViewWidthConstraint.constant = cell.frame.width
            if !isInfinity {
                currentBarViewLeftConstraint?.constant = cell.frame.origin.x
            }
            UIView.animateWithDuration(0.2) {
                self.layoutIfNeeded()
                if !self.isInfinity {
                    self.updateCollectionViewUserInteractionEnabled(true)
                }
            }
        }
        beforeIndex = currentIndex
    }

    /**
     collectionViewのタッチイベント制御

     - parameter userInteractionEnabled: collectionViewに渡すuserInteractionEnabled
     */
    func updateCollectionViewUserInteractionEnabled(userInteractionEnabled: Bool) {
        collectionView.userInteractionEnabled = userInteractionEnabled
    }

    /**
     表示中のすべてのセルを未選択状態にする
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
                // スクロールのアニメーションが終わるまでタッチイベントを受け付けない
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
        // アニメーションが完了したのでタッチイベントを受け付ける
        updateCollectionViewUserInteractionEnabled(true)

        guard isInfinity else {
            return
        }

        let indexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
        if shouldScrollToItem {
            // 違和感がないように動かしたあと、contentOffsetをcurrentIndexのところに調整する
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

        let size = cellForSize.sizeThatFits(CGSizeMake(collectionView.bounds.width, TabPageOption.tabHeight))
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
