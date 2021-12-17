# Chapter 6: Textures

As I read this book, I summarize what I think is wrong. If you think my comments are wrong then please let me know. We can dicuss more and update your opinion.

## sRGB color space

* Actually we can't do math on non-linear space because `1 + 1 != 2` in non-linear space. Let's explain a reason in detail.

![](./gamma-correction-gamma-curves.png)

Data in the reality are in linear space and those are encoded non-linear space because the limitation of memory.
It made sRGB color format that compromised between how cathode ray tube monitors worked and what colors the human eye sees.
Let's think about that you are calculating `0.5 + 0.5` and the result must be `1.0`. However `0.5` is in non-linear space
so it is `0.729` in linear space. So `0.5 + 0.5` in non-linear space equals to `0.729 + 0.729` so the result is `1.458` not `1.0`.
Thus when you do the math, you must check values are in linear space.

* If texture's format is sRGB then OpenGL, Vulkan and DirectX convert from non-linear space to linear space automatically
when you fetch a texel with a sampler. However Metal don't do that. This book give a code how to convert from non-linear space to linear space.
But the code is not compiled when you copy. Try this code `baseColor = pow(baseColor, 1.0 / 2.2);`. You can do the gamma correction by yourself.
