// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-huggingface-mlx",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "MLXLMHuggingFace", targets: ["MLXLMHuggingFace"]),
        .library(name: "MLXEmbeddersHuggingFace", targets: ["MLXEmbeddersHuggingFace"]),
    ],
    dependencies: [
        // TODO: Change to ml-explore/mlx-swift-lm before PR #118 is merged
        .package(url: "https://github.com/DePasqualeOrg/mlx-swift-lm.git", branch: "swift-tokenizers"),
        .package(url: "https://github.com/huggingface/swift-huggingface.git", from: "0.8.1"),
    ],
    targets: [
        .target(
            name: "MLXLMHuggingFace",
            dependencies: [
                .product(name: "MLXLMCommon", package: "mlx-swift-lm"),
                .product(name: "HuggingFace", package: "swift-huggingface"),
            ]
        ),
        .target(
            name: "MLXEmbeddersHuggingFace",
            dependencies: [
                .product(name: "MLXEmbedders", package: "mlx-swift-lm"),
                "MLXLMHuggingFace",
                .product(name: "HuggingFace", package: "swift-huggingface"),
            ]
        ),
        .testTarget(
            name: "Benchmarks",
            dependencies: [
                "MLXLMHuggingFace",
                .product(name: "BenchmarkHelpers", package: "mlx-swift-lm"),
            ]
        ),
    ]
)
