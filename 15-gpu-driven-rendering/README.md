# Chapter 15: GPU-Driven Rendering

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## The argument buffers

Many small buffers are created to set model information and copy into one large buffer. But we don't need any small buffers to upload model's information. We can set argument buffers for models directly to one large buffer. Also creating small buffers aren't the good practice.

In Renderer.swift, in initializeCommand(), change this:

```
var mBuffers: [MTLBuffer] = []
var mBuffersLength = 0
for model in models {
  let encoder = icbComputeFunction.makeArgumentEncoder(bufferIndex: Int(BufferIndexModels.rawValue))
  let mBuffer = Renderer.device.makeBuffer(length: encoder.encodedLength, options: [])!
  encoder.setArgumentBuffer(mBuffer, offset: 0)
  encoder.setBuffer(model.vertexBuffer, offset: 0, index: 0)
  encoder.setBuffer(model.submesh.indexBuffer.buffer, offset: 0, index: 1)
  encoder.setBuffer(model.texturesBuffer, offset: 0, index: 2)
  encoder.setRenderPipelineState(model.pipelineState, index: 3)
  mBuffers.append(mBuffer)
  mBuffersLength += mBuffer.length
}
modelsBuffer = Renderer.device.makeBuffer(length: mBuffersLength, options: [])
modelsBuffer.label = "Models Array Buffer"
var offset = 0
for mBuffer in mBuffers {
  var pointer = modelsBuffer.contents()
  pointer = pointer.advanced(by: offset)
  pointer.copyMemory(from: mBuffer.contents(), byteCount: mBuffer.length)
  offset += mBuffer.length
}
```

To:

```
let encoder = icbComputeFunction.makeArgumentEncoder(bufferIndex: Int(BufferIndexModels.rawValue))
let mBuffersLength = models.count * encoder.encodedLength
modelsBuffer = Renderer.device.makeBuffer(length: mBuffersLength, options: [])
modelsBuffer.label = "Models Array Buffer"
var offset = 0
for model in models {
  encoder.setArgumentBuffer(modelsBuffer, offset: offset)
  encoder.setBuffer(model.vertexBuffer, offset: 0, index: 0)
  encoder.setBuffer(model.submesh.indexBuffer.buffer, offset: 0, index: 1)
  encoder.setBuffer(model.texturesBuffer, offset: 0, index: 2)
  encoder.setRenderPipelineState(model.pipelineState, index: 3)
  offset += encoder.encodedLength
}
```

## Draw arguments

A MTLDrawIndexedPrimitivesIndirectArguments is created as local variable and sets values and copy to a buffer. Actually we don't need a local variable and can set values into a buffer directly.

In Renderer.swift, in initializeCommand(), change this in for loop:

```
var drawArgument = MTLDrawIndexedPrimitivesIndirectArguments()
drawArgument.indexCount = UInt32(model.submesh.indexCount)
drawArgument.instanceCount = 1
drawArgument.indexStart = UInt32(model.submesh.indexBuffer.offset)
drawArgument.baseVertex = 0
drawArgument.baseInstance = UInt32(modelIndex)
drawPointer.pointee = drawArgument
```

To:

```
drawPointer.pointee.indexCount = UInt32(model.submesh.indexCount)
drawPointer.pointee.instanceCount = 1
drawPointer.pointee.indexStart = UInt32(model.submesh.indexBuffer.offset)
drawPointer.pointee.baseVertex = 0
drawPointer.pointee.baseInstance = UInt32(modelIndex)
```
