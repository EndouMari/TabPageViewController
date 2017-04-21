#
# Be sure to run `pod lib lint TabPageViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TabPageViewController"
  s.version          = "0.2.7"
  s.summary          = "Custom UIPageViewController"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "UIPageViewController and Tab"

  s.homepage         = "https://github.com/EndouMari/TabPageViewController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "EndouMari" => "endo@vasily.jp" }
  s.source           = { :git => "https://github.com/EndouMari/TabPageViewController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Sources/*.swift'
  s.resource = 'Sources/*.{xib,storyboard}'

  #s.public_header_files = 'Sources/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
