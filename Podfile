source 'https://github.com/CocoaPods/Specs'

platform :ios, '9.0'

# ignore all warnings from all pods
inhibit_all_warnings!

# Add Application pods here

pod 'CocoaLumberjack', '~> 2.0'
pod 'RZImport', '~> 1.2'
pod 'RZVinyl', '~> 1.1'
pod 'RZCollectionList', '~> 0.7'
pod 'RZDataBinding', '~> 2.0'
pod 'RZUtils', '~> 2.5'
pod 'AFNetworking', '~> 2.5'
pod 'AsyncDisplayKit', :git => "https://github.com/bsmith11/AsyncDisplayKit", :commit => "e64965c1caea384be84d31e53a733f80bdf12d90"
pod 'pop', '~> 1.0'
pod 'KVOController', '~> 1.0'
pod 'DTCoreText', '~> 1.6'
pod 'PINRemoteImage', '~> 1.0'
pod 'SSPullToRefresh', '~> 1.2'
pod 'youtube-ios-player-helper', '~> 0.1'
pod 'BlockRSSParser', :git => "https://github.com/bsmith11/BlockRSSParser", :commit => "4938eaa1eb7c88d7a4d376f31e37b808ae957e15"
pod 'Parse', '~> 1.10'

target :unit_tests, :exclusive => true do
  link_with 'UnitTests'
  pod 'Specta'
  pod 'Expecta'
  pod 'OCMock'
  pod 'OHHTTPStubs'
end

plugin 'cocoapods-keys', {
    :project => "Stack",
    :keys => [
    "BloggerAPIKey"
    ]}

# Copy acknowledgements to the Settings.bundle

post_install do | installer |
  require 'fileutils'

  pods_acknowledgements_path = 'Pods/Target Support Files/Pods/Pods-Acknowledgements.plist'
  settings_bundle_path = Dir.glob("**/*Settings.bundle*").first

  if File.file?(pods_acknowledgements_path)
    puts 'Copying acknowledgements to Settings.bundle'
    FileUtils.cp_r(pods_acknowledgements_path, "#{settings_bundle_path}/Acknowledgements.plist", :remove_destination => true)
  end
end

