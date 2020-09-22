platform :ios, '12.0'

target 'IssueTracker' do
  
pod 'IBAnimatable'
    pod 'Alamofire', '~> 5.2'
    pod 'ReachabilitySwift'
    pod 'IQKeyboardManagerSwift'
    pod 'Toast-Swift'
    pod 'iOSPhotoEditor'

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end
end