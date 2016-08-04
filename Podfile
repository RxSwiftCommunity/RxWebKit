platform :ios, '8.0'
use_frameworks!

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

target 'RxWebKit' do
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift.git', :branch =>
  'swift-3.0'
  pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift.git', :branch =>
  'swift-3.0'
end

target 'Example' do
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift.git', :branch =>
  'swift-3.0'
  pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift.git', :branch =>
  'swift-3.0'
end
