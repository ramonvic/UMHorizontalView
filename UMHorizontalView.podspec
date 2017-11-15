Pod::Spec.new do |s|

  s.name                 = "UMHorizontalView"
  s.version              = "1.0.0"
  s.platform             = :ios, '9.0'
  s.summary              = "This is an iOS control for presenting any UIView in an UIAlertController like manner"
  s.description          = "This framework allows you to present just any view as an action sheet. In addition, it allows you to add actions arround the presented view which behave like a button and can be tapped by the user. The result looks very much like an UIActionSheet or UIAlertController with a special UIView and some UIActions attached."
  
  s.homepage             = "https://github.com/ramonvic/UMHorizontalView"
  
  s.license              = { :type => "MIT", :file => "LICENSE.md" }
  s.author               = { "Ramon Vicente" => "ramonvic@me.com" }
  
  s.source               = { :git => "https://github.com/ramonvic/UMHorizontalView.git", :tag => "1.0.0" }
  s.source_files         = 'Sources/**/*.{swift}'
  
  s.requires_arc         = true
end