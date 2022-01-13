# TabPageViewController

[![License](https://img.shields.io/cocoapods/l/TabPageViewController.svg?style=flat)](http://cocoapods.org/pods/TabPageViewController)
[![Language](https://img.shields.io/badge/language-swift-orange.svg?style=flat)](https://developer.apple.com/swift)
[![Version](https://img.shields.io/cocoapods/v/TabPageViewController.svg?style=flat)](http://cocoapods.org/pods/TabPageViewController)
[![Platform](https://img.shields.io/cocoapods/p/TabPageViewController.svg?style=flat)](http://cocoapods.org/pods/TabPageViewController)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/dt/TabPageViewController.svg)]()
[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/matteocrippa/awesome-swift#utility)



## Description

<img src="https://raw.githubusercontent.com/wiki/EndouMari/TabPageViewController/images/demo2.gif" width="300" align="right" hspace="20">


TabPageViewController is paging view controller and scroll tab view.

**Screenshot**

Infinity Mode

<img src="https://raw.githubusercontent.com/wiki/EndouMari/TabPageViewController/images/ScreenShot2.png" height="300">


Limited Mode

<img src="https://raw.githubusercontent.com/wiki/EndouMari/TabPageViewController/images/ScreenShot1.png" height="300">



<br clear="right">

## Customization

Use TabPageOption

* fontSize for tab item

`fontSize: CGFloat`

* currentColor for current tab item

`currentColor: UIColor`

* defaultColor for tab item
 
`defaultColor: UIColor`

* tabHeight for tab view

`tabHeight: CGFloat`

* tabMargin for tab item

`tabMargin: CGFloat`

* tabBackgroundColor for tab view

`tabBackgroundColor: UIColor`

* currentBarHeight for current bar view

`currentBarHeight: CGFloat`

* pageBackgoundColor for tab page viewcontroller 

`pageBackgoundColor: UIColor`

* isTranslucent for tab view and navigation bar 

`isTranslucent: Bool`

* hides tabbar on swipe

`hidesTabBarOnSwipe: Bool`

## Usage

`import TabPageViewController` to use TabPageViewController in your file.


### Example 

```swift
let tabPageViewController = TabPageViewController.create()
let vc1 = UIViewController()
let vc2 = UIViewController()

tabPageViewController.tabItems = [(vc1, "First"), (vc2, "Second")]

TabPageOption.currentColor = UIColor.redColor()

```

Infinity Mode 

```swift
let tabPageViewController = TabPageViewController.create()
tabPageViewController.isInfinity = true
```


## Requirements

iOS13+

## Installation

### Using CocoaPods

```ruby
use_frameworks!
pod "TabPageViewController"
```

### Using Carthage

```ruby
github "EndouMari/TabPageViewController"

```
### Manually
Copy all the files in `Pod/Classes` directory into your project.



## Author

EndouMari

## License

TabPageViewController is available under the MIT license. See the LICENSE file for more info.
