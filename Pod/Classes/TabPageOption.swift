//
//  TabPageOption.swift
//  TabPageViewController
//
//  Created by EndouMari on 2016/02/24.
//  Copyright © 2016年 EndouMari. All rights reserved.
//

import UIKit

public struct TabPageOption {
    static var fontSize = UIFont.systemFontSize()
    static var currentColor = UIColor.blueColor()
    static var defaultColor = UIColor.blackColor()
    static var tabBarAlpha: CGFloat = 0.95
    static var tabHeight: CGFloat = 32.0
    static var tabMargin: CGFloat = 20.0
    static var tabBackgroundColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: TabPageOption.tabBarAlpha)
    static internal var tabBackgroundImage: UIImage {
        return convertImage()
    }

    static private func convertImage() -> UIImage {
        let rect : CGRect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContextRef? = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, TabPageOption.tabBackgroundColor.CGColor)
        CGContextFillRect(context, rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
