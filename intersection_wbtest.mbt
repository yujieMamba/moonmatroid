///|
test "intersection escapes greedy traps via exchange paths" {
  // Greedy picks edge 0 (a,x), blocking both 1(a,y) and 2(b,x).
  let a = Matroid::partition([0, 0, 1], [1, 1])
  let b = Matroid::partition([0, 1, 0], [1, 1])
  let result = intersect(a, b)
  assert_eq(result.elements, [1, 2])
  assert_eq(result.augmentations, 2)
  assert_eq(result.left_rank + result.right_rank, 2)
  assert_true(a.independent(result.elements) && b.independent(result.elements))
  let low = try {
    intersect(a, b, max_calls=1) |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(low)
  let empty = intersect(Matroid::free(0), Matroid::zero(0))
  assert_eq(empty.elements, [])
}
