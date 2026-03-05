# Swift Hugging Face MLX

This package allows [Swift Hugging Face](https://github.com/huggingface/swift-huggingface) to seamlessly integrate with [MLX Swift LM](https://github.com/ml-explore/mlx-swift-lm) by providing protocol conformance and convenience overloads.

It provides two modules:

- `MLXLMHuggingFace` for LLM and VLM loading
- `MLXEmbeddersHuggingFace` for embedding model loading

## Setup

Add this package alongside mlx-swift-lm in your `Package.swift`:

```swift
.package(url: "https://github.com/DePasqualeOrg/swift-huggingface-mlx/", from: "0.1.0"),
```

And add the modules you need to your target's dependencies:

```swift
.product(name: "MLXLMHuggingFace", package: "swift-huggingface-mlx"),
// and/or
.product(name: "MLXEmbeddersHuggingFace", package: "swift-huggingface-mlx"),
```

## Usage

`MLXLMHuggingFace` provides convenience overloads with `HubClient.default` as the default downloader, so you can omit the `from:` parameter:

```swift
import MLXLLM
import MLXLMHuggingFace
import MLXLMTransformers

// HubClient.default is used automatically
let model = try await loadModel(
    using: TransformersLoader(),
    id: "mlx-community/Qwen3-4B-4bit"
)
```

With a custom Hub client:

```swift
import MLXLLM
import MLXLMHuggingFace
import MLXLMTransformers

let hub = HubClient(token: "hf_...")
let container = try await loadModelContainer(
    from: hub,
    using: TransformersLoader(),
    id: "mlx-community/Qwen3-4B-4bit"
)
```

You can also pass `HubClient.default` explicitly to the core API:

```swift
let container = try await loadModelContainer(
    from: HubClient.default,
    using: TransformersLoader(),
    id: "mlx-community/Qwen3-4B-4bit"
)
```

## Re-exports

Both modules re-export `HuggingFace`, so you get access to `HubClient` and other Hugging Face types without an additional import.

## Testing

Benchmarks for download cache hit performance and model loading are included.
