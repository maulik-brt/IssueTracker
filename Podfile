platform :ios, '11.0'

target 'IssueTracker' do
  
  pod 'IBAnimatable'
  pod 'SVProgressHUD'
  pod 'ReachabilitySwift'
  pod 'IQKeyboardManagerSwift'
  pod 'iOSPhotoEditor'
  pod 'Toast-Swift'

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
end
