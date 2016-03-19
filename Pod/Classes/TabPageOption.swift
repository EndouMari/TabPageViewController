//
//  TabPageOption.swift
//  TabPageViewController
//
//  Created by EndouMari on 2016/02/24.
//  Copyright © 2016年 EndouMari. All rights reserved.
//

import UIKit

public struct TabPageOption {
    public static var fontSize = UIFont.systemFontSize()
    public static var currentColor = UIColor(red: 105/255, green: 182/255, blue: 245/255, alpha: 1.0)
    public static var defaultColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    public static var tabBarAlpha: CGFloat = 0.95
    public static var tabHeight: CGFloat = 32.0
    public static var tabMargin: CGFloat = 20.0
    public static var tabBackgroundColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: TabPageOption.tabBarAlpha)
    public static var pageBackgoundColor: UIColor = UIColor.whiteColor()
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
