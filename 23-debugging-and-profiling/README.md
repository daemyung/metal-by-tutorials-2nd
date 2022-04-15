# Chapter 23: Debugging & Profiling

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## GPU frame capture

Maybe you can't find Capture GPU Frame from the Action drop-down. Capture GPU Frame is renamed to **Capture GPU Workload**.

This book mentions that you can capture GPU frame programmatically but the code isn't given.

In Renderer.swift, in draw(in view:), add this at the top of this function:

```
let captureManager = MTLCaptureManager.shared()
let captureDescriptor = MTLCaptureDescriptor()
captureDescriptor.captureObject = Renderer.device
do {
    try captureManager.startCapture(with: captureDescriptor)
} catch {
    fatalError("error when trying to capture: \(error)")
}

```

Add this at the bottom of this function:

```
captureManager.stopCapture()
```

If you want to know more, you can get more detail at [here](https://developer.apple.com/documentation/metal/debugging_tools/capturing_gpu_command_data_programmatically).
