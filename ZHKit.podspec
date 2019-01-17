#
#  Be sure to run `pod spec lint ZHKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZHKit"
  s.version      = "1.0.2"
  s.summary      = "开发常用工具和系统类扩展"

  s.homepage     = "https://github.com/leezhihua/ZHKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "leezhihua" => "leezhihua@yeah.net" }
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  
  
  s.frameworks = "UIKit", "Foundation", "QuartzCore"
  
  s.source       = { :git => "https://github.com/leezhihua/ZHKit.git", :tag => "#{s.version}" }
  s.source_files  = "Pod/Classes/ZHKit.h"

  
  s.subspec 'Foundation' do |ss|
      ss.source_files = 'Pod/Classes/Foundation/*','Pod/Classes/Foundation/PinYin4Objc/*'
  end

  s.subspec 'UIKit' do |ss|
      ss.source_files = 'Pod/Classes/UIKit/*.{h,m}'
  end

end
