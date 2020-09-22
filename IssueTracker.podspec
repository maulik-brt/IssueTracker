Pod::Spec.new do |s|
  s.name             = 'IssueTracker'
  s.version          = '0.1.1'
  s.summary          = 'IssueTracker lets a user select an test.'
 
  s.description      =  "A facebook like report a problem including media and markup images"
 
  s.homepage         = 'https://github.com/maulik-brt/IssueTracker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Maulik Vekariya' => 'maulik.vekariya@bluereeftech.com' }
  s.source           = { :git => 'https://github.com/maulik-brt/IssueTracker.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '12.0'
     #s.source_files = "IssueTracker/**/*.{swift,plist}"
     s.source_files = "IssueTracker/**/*.{swift}"

       s.framework  = "UIKit"

       s.dependency 'Alamofire'
       s.dependency 'iOSPhotoEditor'
       s.dependency 'IBAnimatable'
       s.dependency 'SVProgressHUD'
       s.dependency 'ReachabilitySwift'
       s.dependency 'IQKeyboardManagerSwift'
       s.dependency 'Toast-Swift'
     s.swift_versions = "5.0"
end
