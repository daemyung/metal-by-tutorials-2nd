# Chapter 9: The Scene Graph

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## The scene graph

* You can also remove the light when you cleanup your code. In `Scene.swift`, add this:

```
var lighting = Lighting()
```

In `Renderer.swift`, in `func draw(in view: MTKView)`, replace:

```
var lights = lighting.lights
```

With:

```
var lights = scene.lighting.lights
```

* If you remove a camera in 'Renderer', you need to update `override func scrollWheel(with event: NSEvent)` in `ViewControllerExtension.swift`, replace:

```
override func scrollWheel(with event: NSEvent) {
  renderer?.camera.zoom(delta: Float(event.deltaY))
}
```

With:

```
override func scrollWheel(with event: NSEvent) {
  renderer?.scene?.camera.zoom(delta: Float(event.deltaY))
}
```
