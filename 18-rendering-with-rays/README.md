# Chapter 18: Rendering with Rays

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## Signed distance functions

There is a runtime error in because Shaders.metal files isn't included in the bundle. But we have the default library.

In Renderer.swift, in initializeMetal(), replace this:

```
guard let path = Bundle.main.path(forResource: "Shaders", ofType: "metal") else { fatalError() }
let input = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
let library = try device.makeLibrary(source: input, options: nil)
```

With:

```
let library = device.makeDefaultLibrary()!
```

## The raymarching algorithm

There is a runtime error in because Shaders.metal files isn't included in the bundle. But we have the default library.

In Renderer.swift, in initializeMetal(), replace this:

```
guard let path = Bundle.main.path(forResource: "Shaders", ofType: "metal") else { fatalError() }
let input = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
let library = try device.makeLibrary(source: input, options: nil)
```

With:

```
let library = device.makeDefaultLibrary()!
```

## Creating random noise

There is a runtime error in because Shaders.metal files isn't included in the bundle. But we have the default library.

In Renderer.swift, in initializeMetal(), remove this:

```
let path = Bundle.main.path(forResource: "Shaders", ofType: "metal")
```

Replace this:

```
let input = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
let library = try device!.makeLibrary(source: input, options: nil)
```

With:

```
let library = device.makeDefaultLibrary()!
```

## Marching clouds

There is a runtime error in because Shaders.metal files isn't included in the bundle. But we have the default library.

In Renderer.swift, in initializeMetal(), replace this:

```
guard let path = Bundle.main.path(forResource: "Shaders", ofType: "metal") else { fatalError() }
let input = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
let library = try device.makeLibrary(source: input, options: nil)
```

With:

```
let library = device.makeDefaultLibrary()!
```
