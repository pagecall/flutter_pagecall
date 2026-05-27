// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "flutter_pagecall",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(name: "flutter-pagecall", targets: ["flutter_pagecall"])
  ],
  dependencies: [
    // Provided by the Flutter tool at build time (Flutter 3.41+).
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    // Native Pagecall iOS SDK. SPM builds the SDK from source, so this
    // must pin >= 0.0.32 (the first release with the `import UIKit` fix
    // in CallManager.swift). The CocoaPods pin in flutter_pagecall.podspec
    // can lag (0.0.31 compiles fine under CocoaPods) until 0.0.32 is on trunk.
    .package(url: "https://github.com/pagecall/pagecall-ios-sdk", exact: "0.0.32")
  ],
  targets: [
    .target(
      name: "flutter_pagecall",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(name: "PagecallCore", package: "pagecall-ios-sdk")
      ],
      path: "Sources/flutter_pagecall"
    )
  ]
)
