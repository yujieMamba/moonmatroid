///|
test "greedy basis differs from optional independent selection for negatives" {
  let m = Matroid::partition([0, 0, 1, 1], [1, 1])
  let weights = [7, 7, -1, -3]
  let basis = m.weighted_basis(weights)
  assert_eq(basis.elements, [0, 2])
  assert_eq(basis.weight, 6L)
  assert_eq(m.max_weight_independent(weights).elements, [0])
  assert_eq(m.weighted_basis(weights, maximize=false).elements, [0, 3])
  assert_eq(
    Matroid::free(2).weighted_basis([2147483647, 2147483647]).weight,
    4294967294L,
  )
}
