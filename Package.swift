// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Cardboard",
    platforms: [.iOS(.v13)],
    swiftLanguageVersions: [.v5],
    dependencies: [],
    products: [

        .library(
            name: "Cardboard", 
            targets: ["Core"]
        )

    ],
    targets: [

        .target(
            name: "Core",
            path: "Sources/Core",
            dependencies: [

                .package(
                    name: "SnapKit",
                    url: "https://github.com/SnapKit/SnapKit",
                    .upToNextMajor(from: .init(5, 0, 0))
                )

            ]
        )

    ]
)
