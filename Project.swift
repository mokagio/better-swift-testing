import ProjectDescription
// import ProjectDescriptionHelpers

let appName = "BananaApp"

func makeBundleIdForName(_ name: String) -> String { "examples.mokagio.\(name)" }

let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UIMainStoryboardFile": ""
]

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
