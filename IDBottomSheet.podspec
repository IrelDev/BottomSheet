Pod::Spec.new do |s|
  s.name         = "IDBottomSheet"
  s.version      = "2.1.0"
  s.summary      = "Bottom sheet popover built with Swift & UIKit."
  s.homepage     = "https://github.com/IrelDev/BottomSheet"
  s.swift_version= '5.0'

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Kirill Pustovalov"
  s.platform     = :ios, "11.0"
  s.source       = { :git => "https://github.com/IrelDev/BottomSheet.git", :tag => "#{s.version}" }
  s.source_files = "Sources/**/*.swift"
end
