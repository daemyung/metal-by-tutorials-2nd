# Chapter 1: Hello, Metal!

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## The pipeline state

* When this book creates a pipeline state, they manually set the output pixel format like below.

```
pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
```

This is fine but the output pixel format of view isn't always `.bgra8Unorm`. It can be `.rgba8Unorm` or other formats. Thus we need to get this information from a view like below.

```
pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat;
```
