platform :ios, '8.0'
use_frameworks!

$rx_version = '~> 4.0.0-rc.0'

def rx
 pod 'RxSwift', $rx_version
 pod 'RxCocoa', $rx_version
end

target 'RxWebKit' do
  rx
end

target 'RxWebKit-iOS' do
  rx
end

target 'Example' do
  pod 'RxWebKit', :path => '.'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
