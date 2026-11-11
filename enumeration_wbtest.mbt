///|
test "enumeration is complete and fails before exceeding budget" {
  let u = Matroid::uniform(4, 2)
  assert_eq(u.bases().length(), 6)
  assert_eq(u.circuits().length(), 4)
  assert_eq(u.flats(), [[], [0], [1], [2], [3], [0, 1, 2, 3]])
  let d = u.rank_distribution()
  assert_eq(d[2][2], 6L)
  assert_eq(d[3][2], 4L)
  let low = try {
    u.bases(max_subsets=15) |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(low)
  assert_eq(Matroid::zero(0).bases(), [[]])
  assert_eq(Matroid::zero(0).circuits(), [])
  let big = try {
    Matroid::free(19).flats() |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(big)
}
