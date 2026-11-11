///|
test "closure circuits flats and fundamental exchange" {
  let m = Matroid::binary(3, [1UL, 2UL, 3UL, 4UL, 0UL])
  assert_eq(m.closure([0, 1]), [0, 1, 2, 4])
  assert_eq(m.loops(), [4])
  assert_eq(m.coloops(), [3])
  assert_eq(m.basis(m.ground()), [0, 1, 3])
  assert_eq(m.fundamental_circuit([0, 1, 3], 2), [0, 1, 2])
  assert_eq(m.fundamental_circuit([0, 1, 3], 4), [4])
  assert_eq(m.fundamental_cocircuit([0, 1, 3], 3), [3])
  assert_true(m.is_circuit([0, 1, 2]))
  assert_true(!m.is_circuit([0, 1, 2, 4]))
  assert_true(m.is_flat([0, 1, 2, 4]))
  assert_true(m.spans([0, 1, 3]))
}
