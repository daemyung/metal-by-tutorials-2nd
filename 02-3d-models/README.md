# Chapter 2: 3D Models

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## Metal coordinate system

The book doesn't mention that The Metal NDC(Normalized Device Coordinate) system is the left-hand coordinate system.

![](https://upload.wikimedia.org/wikipedia/commons/b/b2/3D_Cartesian_Coodinate_Handedness.jpg)

To show the train, this book modified the model file itself. It's not bad but I believe that the model file should be remained to original. Instead of changing y position to -1, we can modify the vertex shader code like below and get the same result.

```
vertex float4 vertex_main(const VertexIn vertex_in [[ stage_in ]]) {
  float4 position = vertex_in.position;
  position.y -= 1.0;  // lower y position by -1
  return position;
}
```
