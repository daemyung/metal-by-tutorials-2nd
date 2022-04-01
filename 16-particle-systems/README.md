# Chapter 16: Particle Systems

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## Compute

A metal shader file isn't included in the bundle so we can't read shader so the runtime error is happened. But a metal shader is compiled and saved as the default library. In Renderer.swift, in initializeMetal(), replace:

```
guard let device = MTLCreateSystemDefaultDevice(),
      let commandQueue = device.makeCommandQueue(),
      let path = Bundle.main.path(forResource: "Shaders", ofType:"metal")
else { return nil }

let pipelineState: MTLComputePipelineState
do {
  let input = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
  let library = try device.makeLibrary(source: input, options: nil)
  guard let function = library.makeFunction(name: "compute")
  else { return nil }
  pipelineState = try device.makeComputePipelineState(function: function)
} catch {
  print(error.localizedDescription)
  return nil
}
```

With:

```
guard let device = MTLCreateSystemDefaultDevice(),
      let commandQueue = device.makeCommandQueue()
else { return nil }

let pipelineState: MTLComputePipelineState
do {
  let library = device.makeDefaultLibrary()!
  guard let function = library.makeFunction(name: "compute")
  else { return nil }
  pipelineState = try device.makeComputePipelineState(function: function)
} catch {
  print(error.localizedDescription)
  return nil
}
```
