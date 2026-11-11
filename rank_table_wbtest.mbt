///|
test "validated rank table roundtrip and nonmatroid rejection" {
  let original = Matroid::graphic(3, [(0, 1), (1, 2), (2, 0)])
  let table = original.rank_snapshot()
  let restored = Matroid::from_ranks(3, table)
  table[7] = 0
  assert_eq(restored.full_rank(), 2)
  let bad = try {
    Matroid::from_ranks(2, [0, 0, 0, 1]) |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(bad)
  assert_eq(Matroid::from_ranks(0, [0]).full_rank(), 0)
}
