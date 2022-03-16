# Chapter 10: Fragment Post-Processing

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## The runtime error

A metal shader file isn't included in the bundle so we can't read shader so the runtime error is happened. But a metal shader is compiled and saved as the default library. Replace code in `buildPipelineState()`:

```
guard let path = Bundle.main.path(forResource: "Shaders", ofType: "metal") else { return }
let source = try String(contentsOfFile: path, encoding: .utf8)
let library = try device.makeLibrary(source: source, options: nil)
```

to this code:

```
guard let library = device.makeDefaultLibrary() else {
  fatalError("Can't make default library")
}
```

## Antialiasing

This book says that MSAA(Multisample Antialiasing) is more expeensive to compute. But it's not true in modern GPUs. Nowadays most of GPUs supports 4X MSAA almost free so don't worry about using MSAA.
