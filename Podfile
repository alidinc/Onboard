# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Onboard' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RemoteConfig
pod ‘Firebase’
pod ‘Firebase/Analytics’
pod ‘Firebase/RemoteConfig’
pod 'GoogleMLKit/SegmentationSelfie', '2.5.0'
pod 'SwiftLint'
pod 'R.swift'
pod 'FlagKit'
pod 'SnapKit', '~> 5.0.0'

# Core
  pod 'SevenAppsKit/UI', :path => './SevenAppsKit'
  pod 'SevenAppsKit/IAP', :path => './SevenAppsKit'
  pod 'SevenAppsKit/Firebase', :path => './SevenAppsKit'
  pod 'SevenAppsKit/POLYIAP', :path => './SevenAppsKit'
  pod 'SevenAppsKit/AnalyticsAmplitude', :path => './SevenAppsKit'
  pod 'SevenAppsKit/AnalyticsFirebase', :path => './SevenAppsKit'
  pod 'SevenAppsKit/AnalyticsAppsFlyer', :path => './SevenAppsKit'
  pod 'SevenAppsKit/AnalyticsPushwoosh', :path => './SevenAppsKit'
  pod 'SevenAppsKit/AnalyticsMixpanel', :path => './SevenAppsKit'
  pod 'SevenAppsKit/AnalyticsAdapty', :path => './SevenAppsKit'
  pod 'SevenAppsKit/AnalyticsFacebook', :path => './SevenAppsKit'


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            # Needed for building for simulator on M1 Macs
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end

end
