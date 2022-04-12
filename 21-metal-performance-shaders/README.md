# Chapter 21: Metal Performance Shaders

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## 3. Secondary rays

In Renderer, in draw(in:), the code for secondary rays is like this:

```
for _ in 0..<3 {
  // MARK: generate intersections between rays and model triangles
  intersector.intersectionDataType = .distancePrimitiveIndexCoordinates
  intersector.encodeIntersection(commandBuffer: commandBuffer,
                                 intersectionType: .nearest,
                                 rayBuffer: rayBuffer, rayBufferOffset: 0,
                                 intersectionBuffer: intersectionBuffer, intersectionBufferOffset: 0,
                                 rayCount: width * height,
                                 accelerationStructure: accelerationStructure)
  
  // MARK: shading
  computeEncoder = commandBuffer.makeComputeCommandEncoder()
  computeEncoder?.label = "Shading"
  computeEncoder?.setBuffer(uniformBuffer, offset: uniformBufferOffset, index: 0)
  computeEncoder?.setBuffer(rayBuffer, offset: 0, index: 1)
  computeEncoder?.setBuffer(shadowRayBuffer, offset: 0, index: 2)
  computeEncoder?.setBuffer(intersectionBuffer, offset: 0, index: 3)
  computeEncoder?.setBuffer(vertexColorBuffer, offset: 0, index: 4)
  computeEncoder?.setBuffer(vertexNormalBuffer, offset: 0, index: 5)
  computeEncoder?.setBuffer(randomBuffer, offset: randomBufferOffset, index: 6)
  computeEncoder?.setTexture(renderTarget, index: 0)
  computeEncoder?.setComputePipelineState(shadePipelineState!)
  computeEncoder?.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadsPerGroup)
  computeEncoder?.endEncoding()
  
  // MARK: shadows
  intersector.label = "Shadow Intersector"
  intersector.intersectionDataType = .distance
  intersector.encodeIntersection(commandBuffer: commandBuffer,
                                 intersectionType: .any,
                                 rayBuffer: shadowRayBuffer, rayBufferOffset: 0,
                                 intersectionBuffer: intersectionBuffer, intersectionBufferOffset: 0,
                                 rayCount: width * height,
                                 accelerationStructure: accelerationStructure)
  
  computeEncoder = commandBuffer.makeComputeCommandEncoder()
  computeEncoder?.label = "Shadows"
  computeEncoder?.setBuffer(uniformBuffer, offset: uniformBufferOffset, index: 0)
  computeEncoder?.setBuffer(shadowRayBuffer, offset: 0, index: 1)
  computeEncoder?.setBuffer(intersectionBuffer, offset: 0, index: 2)
  computeEncoder?.setTexture(renderTarget, index: 0)
  computeEncoder?.setComputePipelineState(shadowPipelineState)
  computeEncoder?.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadsPerGroup)
  computeEncoder?.endEncoding()
}
```