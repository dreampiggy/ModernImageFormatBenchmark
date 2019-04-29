# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

inhibit_all_warnings!
#use_frameworks!
target 'ModernImageFormatBenchmark' do
    pod 'SDWebImage'
    pod 'SDWebImageWebPCoder', '~> 0.1'
    pod 'SDWebImageHEIFCoder', '~> 0.3', :subspecs => ['libde265', 'libx265']
    pod 'SDWebImageBPGCoder', '~> 0.5', :subspecs => ['libbpg', 'bpgenc']
    pod 'SDWebImageFLIFCoder', '~> 0.2'
    pod 'SDWebImageAVIFCoder', '~> 0.2'
end