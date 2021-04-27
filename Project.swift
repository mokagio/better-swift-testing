import ProjectDescription

let appName = "BananaApp"

func makeBundleIdForName(_ name: String) -> String { "examples.mokagio.\(name)" }

// Extracted the InfoPlist settings that differentiated between a UIKit and
// SwiftUI lifecycle app to make it easier to swiftch between the two.
let swiftUILifecycle: [String: InfoPlist.Value] = [
    "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": true,
    ],
    "UILaunchScreen": [:]
]

let uikitLifecycle: [String: InfoPlist.Value] = [
    "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
        "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication": [
                [
                    "UISceneConfigurationName": "Default Configuration",
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                ]
            ]
        ]
    ],
    "UILaunchStoryboardName": "LaunchScreen"
]

let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "CFBundlePackageType": "$(PRODUCT_BUNDLE_PACKAGE_TYPE)",
    "UIApplicationSupportsIndirectInputEvents": true
].merging(uikitLifecycle) { (x, _) in x }

let project = Project(
    name: appName,
    organizationName: "mokagio",
    targets: [
        Target(
            name: "BananaApp",
            platform: .iOS,
            product: .app,
            bundleId: makeBundleIdForName(appName),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["./Sources/**"]
        ),
        Target(
            name: "\(appName)Tests",
            platform: .iOS,
            product: .unitTests,
            bundleId: makeBundleIdForName("\(appName)Tests"),
            infoPlist: .default,
            sources: ["./Tests/**"],
            dependencies: [
                .target(name: "\(appName)")
            ]
        )
    ]
)
