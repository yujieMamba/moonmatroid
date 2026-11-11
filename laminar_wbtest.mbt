///|
test "laminar nested quotas and crossing rejection" {
  let m = Matroid::laminar(5, [[0, 1, 2, 3], [0, 1], [2, 3]], [3, 1, 2])
  assert_eq(m.full_rank(), 4)
  assert_eq(m.rank([0, 1, 2, 3]), 3)
  assert_true(!m.independent([0, 1]))
  let crossing = try {
    Matroid::laminar(3, [[0, 1], [1, 2]], [1, 1]) |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(crossing)
  assert_eq(Matroid::laminar(0, [], []).full_rank(), 0)
}
