///|
test "uniform rank and defensive set validation" {
  let m = Matroid::uniform(4, 2)
  assert_eq(m.ground_size(), 4)
  assert_eq(m.rank([3, 0, 1]), 2)
  assert_true(m.independent([3, 1]))
  assert_eq(m.nullity([0, 1, 2]), 1)
  assert_eq(Matroid::zero(0).full_rank(), 0)
  let duplicate = try {
    m.rank([1, 1]) |> ignore
    false
  } catch {
    _ => true
  }
  let outside = try {
    m.rank([4]) |> ignore
    false
  } catch {
    _ => true
  }
  let size = try {
    Matroid::free(65) |> ignore
    false
  } catch {
    _ => true
  }
  assert_true(duplicate && outside && size)
}
