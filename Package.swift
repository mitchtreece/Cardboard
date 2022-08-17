// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    
    name: "Cardboard",
    
    platforms: [
        
        .iOS(.v13)
        
    ],
    
    products: [

        .library(
            name: "Cardboard",
            targets: ["Cardboard"]
        )

    ],
    
    targets: [

        .target(name: "Cardboard")

    ]
    
)