// swift-tools-version:5.3

import PackageDescription

/// Because some code is shared between `ComposableEnvironment` and `GlobalEnvironment`, and in
/// order to expose only the minimum API surface, the package is split in several targets.
///
/// The third product called `ComposableDependencies` can be used in case you want to define
/// dependencies in an environment-agnostic way. Such dependencies can then be imported and used by
/// `ComposableEnvironment` or `GlobalEnvironment`.
///
/// Targets with names starting with a underscore are used for implementation only and their types
/// exported on a case by case basis. They should not be imported as a whole without prefixing the
/// import with the `@_implementationOnly` keyword.

let package = Package(
  name: "swift-composable-environment",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "ComposableDependencies",
      targets: ["ComposableDependencies"]
    ),
    .library(
      name: "ComposableEnvironment",
      targets: ["ComposableEnvironment"]
    ),
    .library(
      name: "GlobalEnvironment",
      targets: ["GlobalEnvironment"]
    ),
  ],
  targets: [
    .target(name: "_Dependencies"),
    .target(
      name: "_DependencyAliases",
      dependencies: [
        .target(name: "ComposableDependencies")
      ]
    ),
    .testTarget(
      name: "DependencyAliasesTests",
      dependencies: [
        .target(name: "_DependencyAliases")
      ]
    ),
    
    .target(
      name: "ComposableDependencies",
      dependencies: [
        .target(name: "_Dependencies")
      ]
    ),
    
    .target(
      name: "ComposableEnvironment",
      dependencies: [
        .target(name: "ComposableDependencies"),
        .target(name: "_Dependencies"),
        .target(name: "_DependencyAliases"),
      ]
    ),
    .testTarget(
      name: "ComposableEnvironmentTests",
      dependencies: [
        .target(name: "ComposableEnvironment")
      ]
    ),
    
    .target(
      name: "GlobalEnvironment",
      dependencies: [
        .target(name: "ComposableDependencies"),
        .target(name: "_Dependencies"),
        .target(name: "_DependencyAliases"),
      ]
    ),
    .testTarget(
      name: "GlobalEnvironmentTests",
      dependencies: [
        .target(name: "GlobalEnvironment")
      ]
    ),
  ]
)
