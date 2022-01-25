#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint plugin_screeb.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'plugin_screeb'
  s.version          = '0.0.3'
  s.summary          = 'Screeb flutter plugin'
  s.description      = <<-DESC
Screeb plugin for Flutter, simplify use of Screeb in Flutter apps
                       DESC
  s.homepage         = 'https://screeb.app'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.dependency 'Screeb', '~> 0.9'
  s.preserve_paths = 'Screeb.xcframework'
    s.xcconfig = { 'OTHER_LDFLAGS' => '-framework Screeb' }
    s.vendored_frameworks = 'Screeb.xcframework'
end
