///|
test "graphic handles cycles loops parallel edges and disconnected vertices" {
  let m = Matroid::graphic(5, [(0, 1), (1, 2), (2, 0), (0, 1), (3, 3)])
  assert_eq(m.full_rank(), 2)
  assert_eq(m.rank([0, 1, 2]), 2)
  assert_eq(m.rank([0, 3]), 1)
  assert_eq(m.rank([4]), 0)
  assert_eq(Matroid::graphic(0, []).full_rank(), 0)
  let bad = try {
    Matroid::graphic(1, [(0, 1)]) |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(bad)
}
