# 参考、归属和许可

MoonMatroid 为原创实现，项目代码为 MIT（2026 yujieMamba）。没有 vendor 文件、第三方运行时依赖或复制的上游测试数据。MoonBit 工具链及核心标准库由其各自许可约束。

- [SageMath Matroid 基类](https://github.com/sagemath/sage/blob/develop/src/sage/matroids/matroid.pyx)：GPL 系列许可；仅阅读有限拟阵、秩、对偶、收缩等行为边界，未复制或翻译其实现和测试。MoonMatroid 不宣称 Sage 兼容或涵盖其全部功能。
- [HOL Light MoonBit](https://github.com/bobzhang/hol-light.mbt)，MoonCakes `bobzhang/hol_light@0.1.0`：BSD-2-Clause；查重时阅读定理 API、加载和回放测试，无代码复用。本库不输出内核定理。
- [moongraph](https://github.com/moonbitstack/moongraph)，`moonbitstack/moongraph@0.1.1`：Apache-2.0；查重时阅读匹配算法与测试，无代码复用。
- [ac-library-mbt](https://github.com/manabeai/ac-library-mbt)，`manabeai/ac-library-mbt@0.1.0`：公开包标注 CC0-1.0；用于算法边界比较，无代码复用。
- [linear-algebra](https://github.com/Luna-Flow/linear-algebra)，`Luna-Flow/linear-algebra@0.5.2`：Apache-2.0；用于线性代数方向比较，无代码复用。

独立测试样本由本仓库 `tools/oracle.py` 的标准库穷举生成（MIT）。数学公式与标准算法行为不是来自对某一许可代码的移植。AI 参与设计、实现、调试、文档及测试生成；不据此声明形式化证明或官方验收。
