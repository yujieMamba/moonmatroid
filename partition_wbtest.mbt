///|
test "partition capacities own their inputs and permit loops" {
  let groups = [0, 0, 1, 1, 2]
  let caps = [1, 2, 0]
  let m = Matroid::partition(groups, caps)
  groups[0] = 2
  caps[0] = 0
  assert_eq(m.rank([0, 1, 2, 3, 4]), 3)
  assert_true(m.independent([0, 2, 3]))
  assert_true(!m.independent([0, 1]))
  assert_eq(m.rank([4]), 0)
  let bad = try {
    Matroid::partition([1], [1]) |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(bad)
}
