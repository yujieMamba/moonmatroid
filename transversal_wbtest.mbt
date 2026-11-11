///|
test "transversal matching needs reassignment and handles empty neighbors" {
  let rows = [[0, 1], [0], [1, 2], []]
  let m = Matroid::transversal(3, rows)
  rows[0].clear()
  assert_eq(m.full_rank(), 3)
  assert_true(m.independent([0, 1, 2]))
  assert_eq(m.rank([3]), 0)
  let duplicate = try {
    Matroid::transversal(2, [[0, 0]]) |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(duplicate)
}
