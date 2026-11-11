///|
test "simplification maps parallel classes and components preserve direct sums" {
  let m = Matroid::binary(3, [0UL, 1UL, 1UL, 2UL, 3UL, 4UL])
  let simplified = m.simplify()
  assert_eq(simplified.removed_loops, [0])
  assert_eq(simplified.classes, [[1, 2], [3], [4], [5]])
  assert_eq(simplified.representatives, [1, 3, 4, 5])
  assert_true(simplified.matroid.is_simple())
  assert_eq(m.components(), [[0], [1, 2, 3, 4], [5]])
  let mut sum_rank = 0
  for factor in m.component_factors() {
    sum_rank = sum_rank + factor.1.full_rank()
  }
  assert_eq(sum_rank, m.full_rank())
  assert_true(Matroid::uniform(4, 2).is_connected())
  assert_true(!Matroid::free(0).is_connected())
  simplified.representatives[0] = 63
  assert_eq(simplified.matroid.full_rank(), 3)
}
