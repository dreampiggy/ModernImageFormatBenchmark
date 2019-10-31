# ModernImageFormatBenchmark

A simple benchmark for modern image formats, including WebP/HEIF/BPG/FLIF/AVIF.

# Dependency

The test based on the [SDWebImage](https://github.com/SDWebImage/SDWebImage) all coder plugins. To provide a intuitive comparison between different modern image formats performance on decoding and encoding (Not on size).

See [All the coder list](https://github.com/SDWebImage/SDWebImage/wiki/Coder-Plugin-List).

# Codec versions

| Format         | codec         | version    |
|----------------|---------------|------------|
| WebP           | libwebp       | 1.0.3      |
| HEIF(Software) | libheif       | 1.5.1      |
|                | libx265       | 3.0        |
| AVIF           | libaom        | 1.0.1      |
|                | libavif       | 0.4.4      |
|                | libdav1d      | 0.4.4      |
|                | librav1e      | 0.1.0-beta |
| BPG            | libbpg        | 0.9.8      |
| FLIF           | libflif       | 0.3        |

Note: PNG, JPEG and HEIC using Apple's [ImageIO framework](https://developer.apple.com/documentation/imageio) for hardware acceleration.

# Performance result

Test Image: [Lenna - 512 x 512](https://en.wikipedia.org/wiki/Lenna)
Test Device: iPhone X (128GB), iOS 12.4

| Format         | decoding(ms)  | encoding(ms) |
|----------------|---------------|--------------|
| PNG            | 0.82          | 46.41        |
| JPEG           | 0.98          | 3.86         |
| WebP           | 35.33         | 788.98       |
| HEIF(Software) | 115.87        | 2667.97      |
| HEIC(Hardware) | 9.88          | 69.86        |
| AVIF           | 105.15        | 2942.21      |
| BPG            | 43.82         | 4389.27      |
| FLIF           | 562.00        | 8876.80      |

# Run

+ clone the repo
+ run pod install
+ open and build
+ deploy on real iOS device 