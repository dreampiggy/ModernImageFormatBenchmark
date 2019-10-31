# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

inhibit_all_warnings!
install! 'cocoapods', :generate_multiple_pod_projects => true

target 'ModernImageFormatBenchmark' do
    pod 'SDWebImage'
    pod 'SDWebImageWebPCoder'
    pod 'SDWebImageHEIFCoder', :subspecs => ['libde265', 'libx265']
    pod 'SDWebImageBPGCoder', :subspecs => ['libbpg', 'bpgenc']
    pod 'SDWebImageFLIFCoder'
    pod 'SDWebImageAVIFCoder'
    pod 'libavif', :subspecs => ['libdav1d', 'librav1e']
end