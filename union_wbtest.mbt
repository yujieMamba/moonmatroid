///|
test "union separates parallel edges into forests with verified cover" {
  let forest = Matroid::graphic(3, [(0, 1), (1, 2), (2, 0), (0, 1), (1, 2)])
  let result = union_partition([forest, forest])
  assert_eq(result.elements.length(), 4)
  verify_partition([forest, forest], result.groups, result.elements)
  let empty = union_partition([Matroid::zero(0), Matroid::free(0)])
  assert_eq(empty.elements, [])
  let over = try {
    union_partition([Matroid::free(40), Matroid::free(40)]) |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(over)
  let mismatch = try {
    union_partition([Matroid::free(2), Matroid::free(3)]) |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(mismatch)
}
