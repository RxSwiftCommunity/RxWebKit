platform :ios, '8.0'
use_frameworks!

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end

target 'RxWebKit' do
  pod 'RxSwift',    '~> 4.0.0'
  pod 'RxCocoa',    '~> 4.0.0'
end

target 'Example' do
  pod 'RxSwift',    '~> 4.0.0'
  pod 'RxCocoa',    '~> 4.0.0'
end
