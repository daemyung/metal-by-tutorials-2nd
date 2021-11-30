# Chapter 4: The Rendering Pipeline

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## Matrices on the GPU

* Vertices are translated by the matrix now. Also you can notice that an original buffer and transformed buffer have same vertices information. So we just need one buffer. We can change the source code like below.

```
var matrix = matrix_identity_float4x4
let originalBuffer = device.makeBuffer(bytes: &vertices, length: MemoryLayout<float3>.stride * vertices.count, options: [])
renderEncoder.setVertexBuffer(originalBuffer, offset: 0, index: 0)
renderEncoder.setVertexBytes(&matrix, length: MemoryLayout<float4x4>.stride, index: 1)
renderEncoder.setFragmentBytes(&lightGrayColor, length: MemoryLayout<float4>.stride, index: 0)
renderEncoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: vertices.count)
renderEncoder.setVertexBytes(&matrix, length: MemoryLayout<float4x4>.stride, index: 1)
// var transformedBuffer = device.makeBuffer(bytes: &vertices, length: MemoryLayout<float3>.stride * vertices.count, options: [])
// renderEncoder.setVertexBuffer(transformedBuffer, offset: 0, index: 0)
matrix.columns.3 = [0.3, -0.4, 0, 1]
renderEncoder.setVertexBytes(&matrix, length: MemoryLayout<float4x4>.stride, index: 1)
renderEncoder.setFragmentBytes(&redColor, length: MemoryLayout<float4>.stride, index: 0)
renderEncoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: vertices.count)
```

## Rotation

* This book mentioned that each vertex rotates around the world origin. I think it's wrong and it's better that each vertex rotate the object origin. The object origin is the center of the object.