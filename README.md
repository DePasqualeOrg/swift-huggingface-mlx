# Swift Hugging Face MLX

This package allows [Swift Hugging Face](https://github.com/huggingface/swift-huggingface) to seamlessly integrate with [MLX Swift LM](https://github.com/ml-explore/mlx-swift-lm) by providing protocol conformance and convenience overloads.

Refer to the [Benchmarks](#Benchmarks) section to compare the performance of Swift Hugging Face and Swift HF API.

It provides two modules:

- `MLXLMHuggingFace` for LLM and VLM loading
- `MLXEmbeddersHuggingFace` for embedding model loading

## Setup

Add this package alongside MLX Swift LM in your `Package.swift`:

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

## Benchmarks

The benchmarks use tests from MLX Swift LM and can be run from this package in Xcode.

These results were observed on an M3 MacBook Pro.

| Benchmark | Swift HF API median | Swift Hugging Face median | Swift Hugging Face Performance |
| --- | ---: | ---: | --- |
| Download cache hit | 0.6 ms | 144.0 ms | 240.00x slower |
| LLM load | 77.9 ms | 317.0 ms | 4.07x slower |
| VLM load | 198.9 ms | 408.2 ms | 2.05x slower |
| Embedding load | 90.5 ms | 262.8 ms | 2.90x slower |
