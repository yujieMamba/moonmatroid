# API 与错误语义

`Matroid` 是私有字段的不可变秩模型；构造器及变换闭包拥有其数组副本。每次查询产生新数组。返回结果记录允许调用者改动，因此重新使用证书前应调用验证器。

`MatroidError` 的三个分支：`InvalidInput` 为参数、维度或秩公理错误；`BudgetExceeded` 为明确预算不足；`InvalidCertificate` 为见证验证失败。验证器收到非法集合时也可能返回 `InvalidInput`。内部算法不变量若失效则抛错，不返回正常结果。

## 标签映射

`restrict_to([3,1])` 按原标签 `[1,3]` 建模，新 0 对应原 1。`relabel([3,2,1,0])` 按给定顺序重新命名。`delete` 与 `contract` 移除参数中标签，再对剩余标签升序重编号。`direct_sum` 的右侧标签加左侧 ground 大小。所有扩张的新标签为旧 n。

收缩使用 `r_(M/C)(X)=r_M(X∪C)-r_M(C)`，不要求 C 独立。对偶使用 `r*(X)=|X|+r(E-X)-r(E)`。自由扩张满足新元素在全集闭包里且不在任何真平坦里；秩为 0 时新元素为环。串联扩张定义为对偶的平行扩张再对偶。

## 选择与证书

`weighted_basis(weights, maximize=true)` 返回最优权重基，长度恰为完整秩。`maximize=false` 求最小权基；同权按 ID 升序处理。`max_weight_independent` 求允许空集的最大权独立集，忽略非正权。每个权是 Int32，总和用 Int64；最多 64 项不会溢出。

`Intersection` 的 `elements` 与 `certificate` 是互不要求相交的两个 ground 子集。`left_rank/right_rank` 分别是 U 和 E-U 的秩。验证器不信任这些数值，会重算；`oracle_calls/augmentations` 可更改但不是证据。

BFS 图源点是可在左侧扩张 I 的外元素；外→内弧代表右侧交换，内→外代表左侧交换；终点是可在右侧扩张 I 的外元素。选择最短增广路并做对称差。无路时令 R 为源点可达集合，U=E-R，给出 Edmonds 上界。实现不是带权增广路算法。

`union_partition(models)` 在 `(模型序号,原标签)` 复制 ground 上，将直和拟阵与“每个原标签至多选一次”的分区拟阵求交；选择被映射回独立块。`proof` 中 ID 是复制 ground ID，不能直接交给原模型。内部先验证求交证书，再验证分解覆盖；外部可对原模型调用 `verify_partition` 检查块的独立性、无重叠和精确覆盖。该函数仅检查分解可行性，单独使用不证明并集最优。

## 结构与枚举

`fundamental_circuit` 要求输入集独立、新元素不在其中且加入后依赖。`fundamental_cocircuit` 要求输入是基且 e 在基内。`components` 由一组基的基本回路构建连通等价关系，环和余环单独为分量；空拟阵 `is_connected=false`，单元素为 true。`simplify` 去环并为每个非环平行类保留最小原 ID，记录 `representatives/classes/removed_loops`。

枚举按位掩码升序，ID 数组内升序。`rank_distribution()[k][r]` 为大小 k、秩 r 的子集数量。Tutte 按 `sum_A (x-1)^(r(E)-r(A))*(y-1)^(|A|-r(A))` 展开，输出普通单项式非零系数，按 x 指数再 y 指数升序。空拟阵多项式为 1。`tutte_at` 独立用子集和求值，0^0 定义为 1。

秩表通过非负性、空集、单位单调增量和局部次模性验证；布尔格上的这些局部条件蕴含完整秩公理。格式解码经过相同验证。一般查询不是可消耗预算 API；图、匹配或嵌套变换的秩求值成本取决于具体模型。深层变换闭包会叠加计算成本，调用者应限制不受信任的变换层数。
