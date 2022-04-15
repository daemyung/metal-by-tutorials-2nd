# Chapter 24: Performance Optimization

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## CPU-GPU synchronization

For the triple buffering, currentUniformIndex is used to point a current uniform data. However this logic is totally wrong because uniform data which is sent to GPU is invalid. Let's print uniform data and see what's wrong.

In Scene.swift, in update(deltaTime:), add this code before currentUniformIndex is updated:

```
print("Update: \(uniforms[currentUniformIndex].viewMatrix)")
```

In Renderer.swift, in draw(in view:), add this line after declaring uniforms:

```
print("Draw: \(uniforms.viewMatrix)")
```

Build and run. You will see logs like below:

```
Update: simd_float4x4([[0.99999994, 0.0, 0.0, 0.0], [0.0, 0.99999994, 0.0, 0.0], [0.0, 0.0, 0.99999994, 0.0], [0.0, -0.99999994, 0.99999994, 0.99999994]])
Draw: simd_float4x4([[0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0]])
```

We've updated uniform data in update(deltaTime:) but sent uniform data to GPU is the garbage. To fix this, we need to keep the uniform index for rendering.

In Scene.swift, add this property:

```
var renderUniformIndex = 0
```

In Scene.swift, in update(deltaTime:), add this code before currentUniformIndex is updated:

```
renderUniformIndex = currentUniformIndex
```

In Renderer.swift, in draw(in view:), replace this code:

```
let uniforms = scene.uniforms[scene.currentUniformIndex]
```

With:

```
let uniforms = scene.uniforms[scene.renderUniformIndex]
```

Build and run. Now we send valid uniform data to GPU:

```
Update: simd_float4x4([[0.99999994, 0.0, 0.0, 0.0], [0.0, 0.99999994, 0.0, 0.0], [0.0, 0.0, 0.99999994, 0.0], [0.0, -0.99999994, 0.99999994, 0.99999994]])
Draw: simd_float4x4([[0.99999994, 0.0, 0.0, 0.0], [0.0, 0.99999994, 0.0, 0.0], [0.0, 0.0, 0.99999994, 0.0], [0.0, -0.99999994, 0.99999994, 0.99999994]])
```
