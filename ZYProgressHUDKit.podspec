Pod::Spec.new do |spec|
 
  spec.name = "ZYProgressHUDKit"
  spec.version = "1.0.0"
  spec.summary = "loding and message framework for Apple platforms"
  spec.homepage = "https://github.com/zyshaunavayne/ZYProgressHUDKit"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "zyshaunavayne" => "shaunavayne@vip.qq.com" }
  spec.platform = :ios, "11.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/zyshaunavayne/ZYProgressHUDKit.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "ZYProgressHUD/*.{h,m}"
  spec.resource_bundles = {'ZYProgressHUD_Resources' => ['ZYProgressHUDKit/ZYProgressHUDKit.bundle']}
  spec.dependency "lottie-ios"
  spec.frameworks = "Foundation","UIKit"
  spec.subspec "MBProgressHUD" do |ss|
    ss.source_files = "ZYProgressHUDKit/MBProgressHUD/**/*"
  end
  
end
