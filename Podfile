# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'catan' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for catan
  pod 'LBTAComponents', '~> 0.1.9'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'TRON', '~> 2.0.0'
  pod 'KeychainAccess'
  
  plugin 'cocoapods-keys', {
      :project => "xyz.parti.catan",
      :keys => [
        "serviceClientId",
        "serviceClientSecret"
      ]}
end
