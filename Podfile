platform :ios, '13.0'

  # Comment the next line if you don't want to use dynamic frameworks
use_frameworks!
inhibit_all_warnings!

target 'RIBsReactorKit' do

  # Pods for RIBsReactorKit

  # Architecture
  pod 'RIBs', :path => './'
  pod 'ReactorKit'

  # DI
  pod 'NeedleFoundation'

  # Rx
  pod 'RxSwift', '~> 6.0.0'
  pod 'RxCocoa', '~> 6.0.0'

  # Network
  pod 'Alamofire'
  pod 'Moya/RxSwift' 
  pod 'RxReachability'

  # UI
  pod 'SnapKit' 
  pod 'SkeletonView' 
  pod 'RxDataSources' 
  pod 'RxViewController'

  # Image
  pod 'Kingfisher'

  # ETC
  pod 'EPLogger' 

  target 'RIBsReactorKitTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Nimble'
    pod 'RxBlocking'
    pod 'RxTest' 
  end

  target 'RIBsReactorKitUITests' do
    # Pods for testing
  end

end
