# 三个端到端工作流

所有例子使用根模块公开 API。无凭据消费验收会安装精确版本后复制这些入口到新工程运行。

| 运行命令（可换后端） | 预期输出 |
| --- | --- |
| `moon run examples/quotas --target js` | `quota selection: [1, 2]`，`upper bound: 2` |
| `moon run examples/network --target js` | `quota forest: [0, 2, 3]`，`forest layers: [[0, 1, 3], [2, 4]]` |
| `moon run examples/features --target js` | `feature basis: [0, 2, 3]; weight=32`，下列快照与 `restored rank: 2` |

特征收缩快照：`MM1:4:0,1,1,1,1,2,2,2,1,2,2,2,2,2,2,2`。

申请选择直接演示两种配额相交中的交换需求；网络例子给出约束森林及全部 5 条边的双森林分层；特征例子在 GF(2) 上选择权重 32 的基，再收缩列 2 并进行精确序列化恢复。业务层应自行保存标签名称与重编号映射。
