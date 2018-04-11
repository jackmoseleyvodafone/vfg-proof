# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

source 'git@github.com:CocoaPods/Specs.git'
source 'git@github.com:VodafoneDEAppFactory/vfg-ios-cocoapods.git'

target 'VFGProof' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for VFGProof
  
  pod 'VFGSplash', '0.0.1'

  target 'VFGProofTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'VFGProofUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  2
  post_install do |installer|
      
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
      
      puts 'Patching EncryptedStore.m.patch (Post install temporary fix):'
      %x(patch Pods/EncryptedCoreData/Incremental\\ Store/EncryptedStore.m < EncryptedStore.patch)
      
      puts 'Patching UASQLite.patch (Post install temporary fix):'
      %x(patch -b Pods/UrbanAirship-iOS-SDK/AirshipKit/AirshipKit/UASQLite.m < UASQLite.m.patch)
  end
end
