///|
test "sum extensions preserve loops coloops and parallel semantics" {
  let m = Matroid::uniform(3, 2)
  assert_eq(m.add_loop().loops(), [3])
  assert_eq(m.add_coloop().coloops(), [3])
  assert_true(m.parallel_extension(0).is_circuit([0, 3]))
  assert_eq(
    m.free_extension().rank_snapshot(),
    Matroid::uniform(4, 2).rank_snapshot(),
  )
  assert_eq(
    m.series_extension(0).dual().rank_snapshot(),
    m.dual().parallel_extension(0).rank_snapshot(),
  )
  let s = Matroid::free(1).direct_sum(Matroid::uniform(3, 1))
  assert_eq(s.connectivity([0]), 0)
  assert_eq(s.full_rank(), 2)
}
