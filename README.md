# MoonMatroid

MoonMatroid 是纯 MoonBit 的有限拟阵建模与组合选择库。将“每组最多选几个”“边集不能成环”“二进制特征必须线性独立”等约束表示为秩函数，可以查询结构、做最优加权选择，或在两个约束系统间寻找最大共同独立集，并检查其最优性证书。

模块：`yujieMamba/moonmatroid@0.1.1`。许可证：MIT。运行时仅使用 MoonBit 核心类型，不依赖外部求解器或网络。

## 用途与完整工作流

| 使用者 | 输入与处理 | 输出和可运行例子 |
| --- | --- | --- |
| 排班、申请分配工具开发者 | 申请 ID、部门上限与时段上限；构造两个分区拟阵并求交 | 最大数量的可行申请、可独立检查的秩上界；`examples/quotas` |
| 网络设计与图算法开发者 | 端点和边类别；图拟阵与分区拟阵求交，再按两个森林分层 | 不成环且满足配额的边集、独立森林分解；`examples/network` |
| 二进制编码与特征分析开发者 | GF(2) 列向量、整数收益和待收缩特征 | 最优加权基、收缩后的精确模型、可恢复的秩快照；`examples/features` |

这些是可复用的程序接口与确定性示例，不是已部署的业务系统。一般线性规划、任意布尔约束或三个拟阵求交不在范围内。

## 安装与快速开始

开发和 CI 固定使用 **moonc v0.10.18+6c83a7f62**（高于验收要求的 0.10.16），对应 MoonBit 官方工具链。先按 [MoonBit 安装文档](https://docs.moonbitlang.com/en/latest/installation.html) 安装，再执行 `moon version --all` 和 `moonc -v`。支持 `js`、`wasm`、`wasm-gc` 和 Linux `native`；JS 示例需要 Node.js，Linux native 需要 C 编译器。Windows 本机验证范围另见验收记录。

在新的空目录创建消费者项目：

```sh
moon new selection-demo --user demo --name selection-demo
cd selection-demo
moon add yujieMamba/moonmatroid@0.1.1
```

将 `cmd/main/moon.pkg` 设置为：

```moonbit
import {
  "yujieMamba/moonmatroid" @matroid,
  "moonbitlang/core/debug",
}
pkgtype(kind: "executable")
```

将 `cmd/main/main.mbt` 设置为：

```moonbit
///|
fn main {
  let department = @matroid.Matroid::partition([0, 0, 1], [1, 1]) catch { _ => abort("department") }
  let slot = @matroid.Matroid::partition([0, 1, 0], [1, 1]) catch { _ => abort("slot") }
  let result = @matroid.intersect(department, slot) catch { _ => abort("intersection") }
  @matroid.verify_intersection(department, slot, result) catch { _ => abort("certificate") }
  println("quota selection: \{@debug.to_string(result.elements)}")
  println("upper bound: \{result.left_rank + result.right_rank}")
}
```

```sh
moon check --target js --deny-warn
moon run cmd/main --target js --deny-warn
```

预期输出：

```text
quota selection: [1, 2]
upper bound: 2
```

这组输入有意包含贪心陷阱：单独先选 0 会挡住 1、2；求交通过最短增广路交换，最终选择 1、2。示例用 `abort` 简化顶层错误处理；实际应用应捕获 `MatroidError` 并向调用方报告错误。

## 模型与 API

所有 ground ID 为 `0..ground_size-1`，一般上限 64。构造器复制输入，公开的 `Matroid` 字段不可由下游修改。集合输入会拒绝重复和越界 ID，再转为升序。`relabel` 保留传入排列；`restrict_to`、`delete`、`contract` 的新 ID 对应保留的原 ID 升序。

| 能力 | 入口 | 关键语义 |
| --- | --- | --- |
| 基础模型 | `Matroid::uniform/free/zero` | 固定秩上限、自由拟阵、全环拟阵 |
| 分区与层次配额 | `Matroid::partition/laminar` | 分组上限；层次集合必须嵌套或不相交 |
| 图与 GF(2) | `Matroid::graphic/binary` | 支持自环、平行边、不连通图；位向量精确消元 |
| 二部可匹配性 | `Matroid::transversal`、`transversal_assignment` | 选中的左端点是否能匹配；恢复最大匹配见证 |
| 外部有限模型 | `Matroid::from_ranks` | 至多 12 元；逐项检查所有局部秩公理，不信任外部函数 |
| 结构查询 | `rank/independent/nullity/closure/basis/is_basis/is_circuit/spans/is_flat` | 精确秩与闭包、基、回路 |
| 交换结构 | `fundamental_circuit/fundamental_cocircuit/loops/coloops/connectivity` | 明确前置条件；不合法请求抛错 |
| 变换 | `relabel/restrict_to/delete/contract/dual/truncate/direct_sum` | 依赖集也可收缩，使用标准秩公式 |
| 扩张与分解 | `add_loop/add_coloop/parallel_extension/free_extension/series_extension` | 新元素 ID 为旧 ground 大小 |
| 平行类和连通分量 | `parallel_classes/simplify/components/component_factors/is_simple/is_connected` | 简化保留原 ID 映射；环、余环各为单元素分量 |
| 加权优化 | `weighted_basis`、`max_weight_independent` | 整数权；基可含负权，后者忽略非正权；总权重 Int64 |
| 无权求交 | `intersect`、`verify_intersection` | 最大基数共同独立集；独立复算秩上界 |
| 并集分解 | `union_partition`、`verify_partition` | 复制 ground 上求交；输出互不重叠的各拟阵独立块 |
| 有界枚举与不变量 | `bases/circuits/flats/rank_distribution/tutte/tutte_at` | 完整枚举或报错，不返回伪装成完整的部分结果 |
| 交换格式 | `encode`、`decode_snapshot` | 版本化 ASCII 秩表，恢复时重新检查公理 |

完整类型和参数见根目录生成的 [pkg.generated.mbti](pkg.generated.mbti)，约束和证书含义见 [API 说明](docs/api.md)。

## 证书与资源边界

`intersect(M1,M2)` 返回独立集 `I` 与集合 `U`，满足：

```text
|I| = rank_M1(U) + rank_M2(E \ U)
```

右侧是任意共同独立集大小的上界。`verify_intersection` 重新检查两边独立性、集合合法性和上界相等，独立于搜索路径。`oracle_calls` 和 `augmentations` 只用于诊断，不参与证明。两模型必须使用相同 ground ID 语义；只有大小相同无法替调用者保证业务标签一致。

- 求交 `max_calls` 默认 1,000,000，允许 1..10,000,000；预算以秩调用次数计，不是时间或内存限额。超限抛出 `BudgetExceeded`。
- 并集要求 1..64 个模型且 `模型数 × 元素数 <= 64`；无权最大基数，不提供加权并集。
- 图端点、二部右侧顶点至多 256；GF(2) 行数至多 64；层次约束至多 128 项。
- 枚举与 Tutte 至多 18 元，`max_subsets` 上限 262,144，开始前检查完整子集数量；指数成本明确存在。`tutte_at` 仅接受 -2..2 整数坐标，保证 Int64 中间值有界。
- 秩快照至多 12 元。规范格式 `MM1:n:r0,r1,...`，无末尾换行，位掩码升序；只接受规范十进制数字，拒绝多余字段、前导零、空白、Unicode 数字和不满足公理的表，输入长度上限 16,384 个 UTF-16 单元（合法内容均为 ASCII）。
- 不提供加权拟阵求交、实数矩阵容差、无限 ground、任意用户回调、HOL 定理证明、通用 LP/SAT 或持久化服务。未做性能领先或任意规模可用的承诺。

## 从源码复现

```sh
git clone https://github.com/yujieMamba/moonmatroid.git
cd moonmatroid
moon info
moon fmt --check
moon check --target js --deny-warn
moon build --target js --deny-warn
moon test --target js --deny-warn
moon run examples/quotas --target js --deny-warn
moon run examples/network --target js --deny-warn
moon run examples/features --target js --deny-warn
```

将 `js` 换成 `wasm`、`wasm-gc` 或 Linux 的 `native` 即运行对应后端。示例输出保存在 [工作流说明](docs/examples.md)。CI 对四个后端分别执行检查、构建、测试和三个示例，并检查格式、公开接口与独立穷举样本可再生成性。

22 个命名测试块包含固定边界用例及独立 oracle：48 个模型 × 64 子集秩、144 个加权最优值、全部 16 个三元素拟阵的 256 对求交、128 对混合模型求交、24 对并集穷举、768 个对偶 Tutte 网格关系。它们是实测用例数量，不是代码覆盖率。没有宣称 100% 分支覆盖。

独立 oracle 仅使用 Python 3.8+ 标准库，采用可行子集、注入匹配和 XOR 闭包穷举生成答案，而非调用 MoonMatroid：

```sh
python tools/oracle.py
moon fmt
git diff --exit-code
```

详见 [测试方法](docs/testing.md)、[实测样本计数](docs/competition/oracle-metrics.json)、[验收映射](docs/competition/acceptance.md) 和 [语义查重](docs/competition/duplicate-check.md)。

## 来源、许可证与 AI 使用

本项目采用 [MIT](LICENSE)，为此次任务在独立仓库原创编写；没有移植、复制或嵌入 SageMath、HOL Light、moongraph 等项目代码或数据。SageMath 的有限拟阵概念与 API 用作成熟行为参考，具体边界、相关项目许可证及独立实现方法见 [参考与归属](NOTICE.md)。使用 MoonBit 官方标准工具链与标准库。开发中使用 AI 辅助设计、编码、生成独立测试、调试和文档；测试与来源披露不替代参赛者对成果的责任。
