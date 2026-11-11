///|
test "duality minors and relabeling preserve exact ranks" {
  let m = Matroid::binary(3, [1UL, 2UL, 3UL, 4UL, 0UL])
  assert_eq(m.dual().dual().rank_snapshot(), m.rank_snapshot())
  assert_eq(m.contract([0, 1, 2]).rank_snapshot(), [0, 1, 0, 1])
  assert_eq(m.delete([4]).ground_size(), 4)
  assert_eq(m.restrict_to([3, 1]).rank_snapshot(), [0, 1, 1, 2])
  assert_eq(m.relabel([4, 3, 2, 1, 0]).loops(), [0])
  assert_eq(m.truncate(1).full_rank(), 1)
  assert_eq(
    m.delete([0, 2]).dual().rank_snapshot(),
    m.dual().contract([0, 2]).rank_snapshot(),
  )
}
