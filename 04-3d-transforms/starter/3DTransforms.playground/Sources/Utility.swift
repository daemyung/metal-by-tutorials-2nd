import MetalKit

public typealias float3 = SIMD3<Float>
public typealias float4 = SIMD4<Float>

public var device: MTLDevice!
public let commandQueue = device.makeCommandQueue()!
public let library = device.makeDefaultLibrary()!
public let pipelineState = createPipelineState(library: library)

public var lightGrayColor: float4 = [0.9, 0.9, 0.9, 1]
public var redColor: float4 = [1, 0, 0, 1]

public func setupMetal() {
  
}

public func createPipelineState(library: MTLLibrary) -> MTLRenderPipelineState {
  let descriptor = MTLRenderPipelineDescriptor()
  descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
  descriptor.vertexFunction = library.makeFunction(name: "vertex_main")
  descriptor.fragmentFunction = library.makeFunction(name: "fragment_main")
  let pipelineState = try! device.makeRenderPipelineState(descriptor: descriptor)
  return pipelineState
}

