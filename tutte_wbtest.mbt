///|
test "Tutte triangle polynomial and standard enumerative evaluations" {
  let triangle = Matroid::graphic(3, [(0, 1), (1, 2), (2, 0)])
  let terms = triangle.tutte()
  assert_eq(terms.length(), 3)
  assert_eq(
    (terms[0].x_degree, terms[0].y_degree, terms[0].coefficient),
    (0, 1, 1L),
  )
  assert_eq(
    (terms[1].x_degree, terms[1].y_degree, terms[1].coefficient),
    (1, 0, 1L),
  )
  assert_eq(
    (terms[2].x_degree, terms[2].y_degree, terms[2].coefficient),
    (2, 0, 1L),
  )
  assert_eq(triangle.tutte_at(1, 1), 3L)
  assert_eq(triangle.tutte_at(2, 1), 7L)
  assert_eq(triangle.tutte_at(2, 2), 8L)
  assert_eq(Matroid::zero(0).tutte_at(0, 0), 1L)
  assert_eq(Matroid::zero(3).tutte_at(1, 2), 8L)
  let bad = try {
    triangle.tutte_at(3, 1) |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(bad)
}
