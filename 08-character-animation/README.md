# Chapter 8: Character Animation

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## Animation using physics

* Newton's second law is used to simulate physics. However below code uses Newton's second law incorrectly.

```
let gravity: Float = 9.8 // meter / sec2
let mass: Float = 0.05
let acceleration = gravity / mass
```

Newton's second law is `F = ma`. `F` is Newton(`N`) and `N`'s unit is `kg·m/s2`. From `let acceleration = gravity / mass`, we can know `a = m/F` so `gravity` is force. 

```
let force: Float = 9.8 // kg * meter / sec2
let mass: Float = 0.05
let acceleration = force / mass
```

Thus upper code is more proper to express Newton's second law.

## Interpolation

* There is a typo at `func update(deltaTime: Float)`. `ball.position.y += ball.size.y` should be `ball.position.y += ball.size.y / 2`. Because `ball.size.y` is the height of this ball so only the half height should be added.

## Joint matrix palette

* Calculating the flattened joint matrix palette is wrong as I think. Because the pose of parent couldn't be calculated when the pose of child is calculated and the parent also can have parent. So we need to get the parent transform recursively.

```
func updatePose(animationClip: AnimationClip,
                at time: Float) {
  // ...
  var poses = [float4x4](repeatElement(.identity(),
                                       count: jointPaths.count))

  // 1. Get the local joint matrix palette.
  for (jointIndex, jointPath) in jointPaths.enumerated() {
    poses[jointIndex] =
      animationClip.getPose(at: time * animationClip.speed,
                            jointPath: jointPath)
        ?? restTransforms[jointIndex]
  }
  
  // 2. Declare a nested function to get parent's transform recursively.
  func getFlattenPose(jointIndex: Int) -> float4x4 {
    guard let parentIndex = parentIndices[jointIndex] else {
      return poses[jointIndex]
    }
    return getFlattenPose(jointIndex: parentIndex) * poses[jointIndex]
  }
  
  // 3. Allocate an array for flattened joint matrix palette.
  var flattenedPoses = [float4x4](repeatElement(.identity(),
                                       count: jointPaths.count))
  for (jointIndex, _) in jointPaths.enumerated() {
    // 4. Calculate a flattened joint matrix recursively.
    flattenedPoses[jointIndex] = getFlattenPose(jointIndex: jointIndex)
    palettePointer.pointee =
      flattenedPoses[jointIndex] * bindTransforms[jointIndex].inverse
    palettePointer = palettePointer.advanced(by: 1)
  }
}
```

## Vertex function constants

* Add below code for tangent and bitangent at `Shaders.metal`.

```
// ...
float4 tangent = float4(vertexIn.tangent, 0);
float4 bitangent = float4(vertexIn.bitangent, 0);

if (hasSkeleton) {
  float4 weights = vertexIn.weights;
  ushort4 joints = vertexIn.joints;
  // ...
  tangent =
    weights.x * (jointMatrices[joints.x] * tangent) +
    weights.y * (jointMatrices[joints.y] * tangent) +
    weights.z * (jointMatrices[joints.z] * tangent) +
    weights.w * (jointMatrices[joints.w] * tangent);
  bitangent =
    weights.x * (jointMatrices[joints.x] * bitangent) +
    weights.y * (jointMatrices[joints.y] * bitangent) +
    weights.z * (jointMatrices[joints.z] * bitangent) +
    weights.w * (jointMatrices[joints.w] * bitangent);
}

VertexOut out {
  // ...
  .worldTangent = uniforms.normalMatrix * tangent.xyz,
  .worldBitangent = uniforms.normalMatrix * bitangent.xyz,
};
```
