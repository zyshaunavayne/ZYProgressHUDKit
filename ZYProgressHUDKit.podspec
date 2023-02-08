Pod::Spec.new do |spec|
 
  spec.name = "ZYProgressHUDKit"
  spec.version = "1.0.0"
  spec.summary = "loding and message framework for Apple platforms"
  spec.homepage = "https://github.com/zyshaunavayne/ZYProgressHUDKit"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "zyshaunavayne" => "shaunavayne@vip.qq.com" }
  spec.platform = :ios, "12.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/zyshaunavayne/ZYProgressHUDKit.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "ZYProgressHUD/*.{h,m}"
  spec.resource_bundles = {'ZYProgressHUD_Resources' => ['ZYProgressHUDKit/ZYProgressHUDKit.bundle']}
  spec.dependency "lottie-ios", '> 3.5'

  spec.subspec "MBProgressHUD" do |ss|
    ss.source_files = "ZYProgressHUDKit/MBProgressHUD/**/*"
  end
  
end
