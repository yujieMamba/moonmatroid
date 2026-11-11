///|
test "transversal assignments recover alternating paths and leave loops unmatched" {
  let graph = [[0, 1], [0], [1, 2], []]
  let pairs = transversal_assignment(3, graph, [0, 1, 2, 3])
  assert_eq(pairs.length(), 3)
  let seen = Array::make(4, false)
  for pair in pairs {
    assert_true(has(graph[pair.0], pair.1))
    assert_true(!seen[pair.0])
    seen[pair.0] = true
  }
  assert_eq(transversal_assignment(0, [[]], [0]), [])
}
