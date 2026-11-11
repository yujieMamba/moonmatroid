# 语义查重与选题决策

日期：2026-11-11（Asia/Shanghai）。先检索、读源码、检查全局项目注册表并原子预留，再在独立目录实现 MoonMatroid。本记录将当次实际证据整理为可审阅说明；原始响应和失败探测保存在本地工程证据目录，不作为唯一性的保证。

遵循已安装 `osc2026-guide` 的 Project Research Guide：MoonCakes → 包详情 → README/API/源码/测试 → GitHub/MoonBit/官方列表 → 保留/已交付项目语义指纹 → 反向检索。比赛助手是检索指南，不是官方判定。官方列表读取 [awesome-moonbit](https://github.com/moonbitlang/awesome-moonbit)。

## 需求依据与候选

不虚构参赛者既有经验、采访或用户数量。有限拟阵是 [SageMath 成熟模型](https://github.com/sagemath/sage/blob/develop/src/sage/matroids/matroid.pyx) 已覆盖的问题：相同秩接口可表达图独立性、配额和精确线性独立；交集最优性可通过秩上界独立复算。这里的实际价值是避免三个下游各自手写模型、增广路径、重编号和校验逻辑。

三类可复用用户分别是分配/排班工具、网络组合设计工具、二进制编码/特征分析工具。输入—处理—输出对应根 README 和三个可运行例子。项目仅提供有界程序库，不声称用户已采用。

评分每项 1–5，列依次为生态广度、用户多样性、复用、低重合风险、算法深度、客观验证、可完成性、可维护性。成熟直接替代是硬淘汰，分数不能抵消。

| 候选领域 | 八项评分 | 总分 | 决策及源码证据 |
| --- | --- | --- | --- |
| 生存分析 Kaplan–Meier | 4/4/4/1/4/5/4/4 | 30 | 淘汰；`Lyl66655/moon-survival@0.2.4` 已有 KM 实现和测试，仓库当前跳转到 [WmmmQa/moon-survival](https://github.com/WmmmQa/moon-survival/blob/master/src/kaplan_meier.mbt) |
| CommonMark 文档处理 | 5/5/5/1/5/5/3/3 | 32 | 淘汰；`moonbit-community/cmark@0.4.13` 的 [公开 API](https://github.com/moonbit-community/cmark.mbt/blob/main/src/cmark/pkg.generated.mbti)、README 与源码树构成成熟直接替代 |
| LZW 压缩 | 4/4/5/1/4/5/4/4 | 31 | 淘汰；`bikallem/compress@0.3.4` 已有 [LZW 编码](https://github.com/bikallem/compress/blob/main/lzw/compress.mbt) 与测试 |
| 湿空气热力学 | 4/4/4/1/4/5/4/4 | 30 | 淘汰；`liying-han/moonbit-energybalance@0.2.3` 的 [psychrometrics.mbt](https://github.com/liying-han/moonbit-energybalance/blob/main/psychrometrics.mbt) 已提供相同行为 |
| 可执行有限拟阵和约束选择 | 4/4/5/4/5/5/4/4 | 35 | 通过有界查重，自动选择；与现有定理包、图匹配、矩阵库区别见下 |

最低完整核心：六类精确表示、验证秩表、查询/对偶/删除/收缩、整数加权贪心、无权求交与上界证书、并集分解、有预算枚举、不变量、严格交换格式、三个消费者流程。客观完成标准：独立穷举秩/最优值相同、伪造证书拒绝、四后端 CI、精确发布版新消费者。明确不做加权求交、任意 LP/SAT、浮点误差模型和形式化定理证明。

## 检索范围与实际限制

`moon search KEYWORD --limit 100 --json` 的扩词包括：matroid、拟阵、graphic matroid、partition matroid、matroid intersection、matroid union、rank oracle、greedy basis、common independent、independent set、exchange graph、transversal、matching、linear independence、spanning forest、circuit、SageMath、Tutte、parallel classes。其它候选包括 survival、markdown、commonmark、lzw、psychrolib、psychrometric、HVAC、humidity、wet bulb、dew point、moist air、ASHRAE、thermodynamic 及中文词。详细响应保存于本地；matching、transversal 和 markdown 等宽泛搜索达到 100 条上限，不能视为全量穷尽。

使用 `moon view` 核验精确包版本、仓库和许可证；成功读取 HOL Light、moongraph 的 MoonCakes 页面。GitHub 搜索带 `language:MoonBit` 或 `moonbit`，每页 100；记录 `total_count` 与 `incomplete_results`。初检仓库 matroid/MoonBit 为 0；反查 `matroid_intersection`、`partition_matroid`、`common_independent` 代码为 0。临发布复核中代码搜索 `matroid language:MoonBit` 有 63 个匹配，全部来自同一个 HOL Light 仓库；`matroid_intersection`、`common_independent`、`union_partition` 仍为 0。这不包含未索引、私有或未来项目。

发布复核 `Tutte` 在 MoonCakes 命中 `walkzzz/moon-geometry@0.251.0` 的 harmonic/Tutte **网格参数化**；读取其 [mesh_param 接口](https://github.com/walkzzz/moon-geometry/blob/main/mesh/mesh_param/pkg.generated.mbti)，输入网格输出 UV/畸变，非拟阵 Tutte 多项式。GitHub 相同词的 13 项是词形/其它领域匹配，不作为直接替代证据。

原始 raw GitHub 与 Sage 文档地址一度连接失败，改用同一已绑定身份的 GitHub contents API 成功读取。早期猜测的 `bobzhang/hol_light` 仓库和测试文件名 404，随后按 MoonCakes 元数据纠正为 `bobzhang/hol-light.mbt` 和 `matroids_ref_test.mbt`。这些失败未被算作“无同类”。没有修改全局登录、系统代理或共享网络设置。

## 实际相邻项目能力矩阵

| 对象 / 版本 | 用户任务和输入输出 | 实际源码或测试 | 归类与独立建设理由 |
| --- | --- | --- | --- |
| `bobzhang/hol_light@0.1.0`，BSD-2-Clause | 定理证明；定义/定理返回内核 `Thm`，加载和回放理论 | [matroids.mbt](https://github.com/bobzhang/hol-light.mbt/blob/main/library/matroids/matroids.mbt)、[回放测试](https://github.com/bobzhang/hol-light.mbt/blob/main/library/matroids/matroids_ref_test.mbt)、公开接口 | 同主题、核心任务不同；不接收有限图/配额实例输出组合最优解。把纯求解库塞入证明内核会引入无关依赖与许可/架构负担 |
| `moonbitstack/moongraph@0.1.1`，Apache-2.0 | 通用图存储、图匹配/指派，输入图输出匹配 | [matching.mbt](https://github.com/moonbitstack/moongraph/blob/master/src/matching/matching.mbt)、[测试](https://github.com/moonbitstack/moongraph/blob/master/src/matching/matching_wbtest.mbt) 与 README | 高度相邻；图匹配本身不作为新颖点。本库核心是不同秩模型相交、秩上界和 minors，需 GF(2)/配额/表模型，适合独立薄接口而非依赖图存储框架 |
| `manabeai/ac-library-mbt@0.1.0`，CC0-1.0 | 竞赛基础算法：DSU、最大/最小流等 | [仓库](https://github.com/manabeai/ac-library-mbt) 的完整源码树、README | 方向相邻；未看到通用拟阵模型/求交，底层技巧不构成相同任务 |
| `Luna-Flow/linear-algebra@0.5.2`，Apache-2.0 | 矩阵/向量与后端封装 | [arithmetic API](https://github.com/Luna-Flow/linear-algebra/blob/main/src/arithmetic/pkg.generated.mbti)、container API、完整源码树 | 同方向不同功能；不把矩阵基础操作当作原创点。本库使用位向量精确秩与组合选择，无实数矩阵后端 |
| `hutingyu-nuist/moonzdd` | 集族决策图压缩与集族运算 | [公开接口](https://github.com/hutingyu-nuist/moonzdd/blob/main/pkg.generated.mbti) 和源码树 | 集族相邻；不复制 ZDD，不做集族压缩；使用多项式秩调用的增广路处理两个独立性模型 |
| 注册表 MoonIncidence / MoonChoice 等保留、已完成条目 | FCA/关联、偏序、选择/经济学等指纹 | 搜索 capability 后读取完整条目 | 语义不同；不做概念格、偏序 Möbius、消费选择或记录审计 |

维护状态取本次公开版本与实际源码，不从星标数量推断正确性。HOL、moongraph、线代和 ACL 的精确版本均在本次查询中存在。没有复制其源码，独立实现优先于对现有不同架构强加不相关内核；未来适配协作不排斥。

## 结论

在上述日期、公开索引、可访问源码和已读注册表指纹范围内，未发现成熟的直接替代。该结论有检索上限和索引延迟限制，不能证明绝对唯一。预留锁使用注册表同目录排他锁、锁内重读、原子替换；最终完成状态只在两端发布和新消费者验证后登记。
