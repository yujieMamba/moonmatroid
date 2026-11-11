///|
test "binary exact elimination and high bit boundary" {
  let m = Matroid::binary(3, [1UL, 2UL, 3UL, 4UL, 0UL])
  assert_eq(m.full_rank(), 3)
  assert_eq(m.rank([0, 1, 2]), 2)
  assert_eq(m.rank([4]), 0)
  assert_eq(Matroid::binary(64, [1UL << 63, 1UL]).full_rank(), 2)
  let bad = try {
    Matroid::binary(2, [4UL]) |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(bad)
}
