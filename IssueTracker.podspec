Pod::Spec.new do |s|
  s.name             = 'IssueTracker'
  s.version          = '1.0.10'
  s.summary          = 'IssueTracker lets a user select an test.'
 
  s.description      =  "A facebook like report a problem including media and markup images"
 
  s.homepage         = 'https://github.com/maulik-brt/IssueTracker.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Maulik Vekariya' => 'maulik.vekariya@bluereeftech.com' }
  s.source           = { :git => 'https://github.com/maulik-brt/IssueTracker.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '11.0'
     
       s.framework  = "UIKit"
       s.dependency 'iOSPhotoEditor'
       s.dependency 'IBAnimatable'
       s.dependency 'SVProgressHUD'
       s.dependency 'ReachabilitySwift'
       s.dependency 'IQKeyboardManagerSwift'
       s.dependency 'Toast-Swift'

s.source_files = "IssueTracker/**/*.{swift}"
s.resources = "IssueTracker/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
     s.swift_versions = "5.0"
end
