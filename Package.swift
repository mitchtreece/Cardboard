// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Cardboard",
    platforms: [.iOS(.v13)],
    products: [

        .library(
            name: "Cardboard", 
            targets: ["Cardboard"]
        )

    ],
    dependencies: [

        .package(
            name: "SnapKit",
            url: "https://github.com/SnapKit/SnapKit",
            .upToNextMajor(from: .init(5, 6, 0))
        )

    ],
    targets: [

        .target(
            name: "Cardboard",
            dependencies: [

                .product(
                    name: "SnapKit", 
                    package: "SnapKit"
                )

            ],
            path: "Sources/Core"
        )

    ],
    swiftLanguageVersions: [.v5]
)
