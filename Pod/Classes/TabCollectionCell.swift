//
//  TabCollectionCell.swift
//  TabPageViewController
//
//  Created by EndouMari on 2016/02/24.
//  Copyright © 2016年 EndouMari. All rights reserved.
//

import UIKit

class TabCollectionCell: UICollectionViewCell {

    var tabItemButtonPressedBlock: (Void -> Void)?
    var item: String = "" {
        didSet {
            itemLabel.text = item
            itemLabel.invalidateIntrinsicContentSize()
            invalidateIntrinsicContentSize()
        }
    }
    var isCurrent: Bool = false {
        didSet {
            currentBarView.hidden = !isCurrent
            if isCurrent {
                highlightTitle()
            } else {
                unHighlightTitle()
            }
            layoutIfNeeded()
        }
    }

    @IBOutlet private weak var itemLabel: UILabel!
    @IBOutlet private weak var currentBarView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        currentBarView.hidden = true
        currentBarView.backgroundColor = TabPageOption.currentColor
    }

    override func sizeThatFits(size: CGSize) -> CGSize {
        if item.characters.count == 0 {
            return CGSizeZero
        }

        return intrinsicContentSize()
    }

    class func cellIdentifier() -> String {
        return "TabCollectionCell"
    }
}


// MARK: - View

extension TabCollectionCell {
    override func intrinsicContentSize() -> CGSize {
        var width = itemLabel.intrinsicContentSize().width
        width += TabPageOption.tabMargin * 2
        let size = CGSizeMake(width, TabPageOption.tabHeight)
        return size
    }

    func hideCurrentBarView() {
        currentBarView.hidden = true
    }

    func showCurrentBarView() {
        currentBarView.hidden = false
    }

    func highlightTitle() {
        itemLabel.textColor = TabPageOption.currentColor
        itemLabel.font = UIFont.boldSystemFontOfSize(TabPageOption.fontSize)
    }

    func unHighlightTitle() {
        itemLabel.textColor = TabPageOption.defaultColor
        itemLabel.font = UIFont.systemFontOfSize(TabPageOption.fontSize)
    }
}


// MARK: - IBAction

extension TabCollectionCell {
    @IBAction private func tabItemTouchUpInside(button: UIButton) {
        tabItemButtonPressedBlock?()
    }
}
