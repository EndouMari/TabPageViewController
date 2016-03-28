//
//  TabPageOption.swift
//  TabPageViewController
//
//  Created by EndouMari on 2016/02/24.
//  Copyright © 2016年 EndouMari. All rights reserved.
//

import UIKit

public struct TabPageOption {

    public init() {}

    public var fontSize = UIFont.systemFontSize()
    public var currentColor = UIColor(red: 105/255, green: 182/255, blue: 245/255, alpha: 1.0)
    public var defaultColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    public var tabBarAlpha: CGFloat = 0.95
    public var tabHeight: CGFloat = 32.0
    public var tabMargin: CGFloat = 20.0
    public var tabWidth: CGFloat?
    public var tabBackgroundColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95)
    public var pageBackgoundColor: UIColor = UIColor.whiteColor()
     internal var tabBackgroundImage: UIImage {
        return convertImage()
    }

    private func convertImage() -> UIImage {
        let rect : CGRect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContextRef? = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, tabBackgroundColor.CGColor)
        CGContextFillRect(context, rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
