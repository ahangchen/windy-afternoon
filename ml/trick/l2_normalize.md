# L2 Norm与L2 normalize

## L2 Norm

L2 Norm是向量一个L2模，是一个实数，也称L2范数，二范数

$$norm(x) = \sqrt{x_1^2+x_2^2+...+x_n^2 }$$

## L2 Normalize

L2归一化，是对单个向量的各个元素做归一化的手段，使得向量x变换后的结果x'的L2 norm为1

$$1 = norm(x')=\frac{\sqrt{x_1^2+x_2^2+...+x_n^2 }}{norm(x)}$$ $$=\sqrt{\frac{x_1^2+x_2^2+...+x_n^2}{norm(x)^2}}$$ $$=\sqrt{(\frac{x_1}{norm(x)})_2+(\frac{x_2}{norm(x)})_2+...+(\frac{x_n}{norm(x)})_2}$$ $$=\sqrt{x_1^2'+x_2^2'+...+x_n^2'}$$

即： $$x'_i =\frac{x_i}{norm(x)}$$

