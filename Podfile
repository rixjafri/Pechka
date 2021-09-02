# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Pechka' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

# Pods for Pechka
  pod 'Alamofire', '~> 4.7'
  pod 'SVProgressHUD'
  pod 'LocationPicker'
  pod 'GooglePlaces'
  pod 'GooglePlacePicker'
  pod 'GoogleMaps'
  pod 'IQKeyboardManagerSwift', '6.0.4'
  pod 'NVActivityIndicatorView','4.4.0'
  pod 'SVProgressHUD'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'LGSideMenuController'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'GoogleSignIn'
  pod 'FloatRatingView'
  pod 'MultiSlider'
  pod 'ObjectMapper'
  pod 'SDWebImage', '~> 4.0'
  pod 'SDWebImage/WebP'
  pod 'Firebase/Messaging'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Analytics'
  pod 'ChameleonFramework'
  
 




  post_install do |installer_representation|
       installer_representation.pods_project.targets.each do |target|
           target.build_configurations.each do |config|
               config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
           end
       end
   end

  target 'PechkaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PechkaUITests' do
    # Pods for testing
  end

end
