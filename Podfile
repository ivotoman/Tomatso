source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'
use_frameworks!

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
               end
          end
   end
end

def library
    pod 'KissXML'
    pod 'ICSMainFramework', :path => "./Library/ICSMainFramework/"
    pod 'MMWormhole'
    pod 'KeychainAccess'
end

def tunnel
    pod 'MMWormhole'
end

def socket
    pod 'CocoaAsyncSocket'
end

def model
  pod 'RealmSwift', '~> 4.4.1'
end

target "Potatso" do
    pod 'Aspects', :path => "./Library/Aspects/"
    pod 'Cartography'
    pod 'AsyncSwift'
    pod 'SwiftColor'
    pod 'Appirater'
    pod 'Eureka'
    pod 'MBProgressHUD'
    pod 'CallbackURLKit', :path => "./Library/CallbackURLKit"
    pod 'ICDMaterialActivityIndicatorView'
    pod 'Reveal-iOS-SDK', '~> 1.6.2', :configurations => ['Debug']
    pod 'ICSPullToRefresh'
    pod 'ISO8601DateFormatter'
    pod 'Alamofire'
    pod 'ObjectMapper', '~> 3.4'
    pod 'CocoaLumberjack/Swift'
    pod 'PSOperations'
    tunnel
    library
    socket
    model
end

target "PacketTunnel" do
    tunnel
    socket
end

target "PacketProcessor" do
    socket
end

target "TodayWidget" do
    pod 'Cartography'
    pod 'SwiftColor'
    library
    socket
    model
end

target "PotatsoLibrary" do
    library
    model
    # YAML-Framework 0.0.3 is not available in cocoapods so we install it from local using git submodule
    pod 'YAML-Framework', :path => "./Library/YAML-Framework"
end

target "PotatsoModel" do
    model
end

target "PotatsoLibraryTests" do
    library
end

