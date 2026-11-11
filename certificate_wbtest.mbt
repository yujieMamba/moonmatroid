///|
test "certificates reject feasible but nonmaximum selections and false bounds" {
  let a = Matroid::uniform(4, 2)
  let b = Matroid::partition([0, 0, 1, 1], [1, 1])
  let good = intersect(a, b)
  verify_intersection(a, b, good)
  let false_bound = { ..good, left_rank: 0, }
  let bad = try {
    verify_intersection(a, b, false_bound)
    false
  } catch {
    _ => true
  }
  assert_true(bad)
  let suboptimal = { ..good, elements: [0], }
  let not_max = try {
    verify_intersection(a, b, suboptimal)
    false
  } catch {
    _ => true
  }
  assert_true(not_max)
  verify_partition([a, b], [[0, 1], [2]], [0, 1, 2])
  let overlap = try {
    verify_partition([a, b], [[0], [0]], [0])
    false
  } catch {
    _ => true
  }
  assert_true(overlap)
}
