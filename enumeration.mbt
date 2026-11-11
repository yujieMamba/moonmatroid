///|
fn enumeration_count(
  m : Matroid,
  max_subsets : Int32,
) -> Int32 raise MatroidError {
  if m.size > 18 {
    raise InvalidInput("enumeration supports at most 18 elements")
  }
  if max_subsets < 1 || max_subsets > 262144 {
    raise InvalidInput("subset budget outside 1..262144")
  }
  let count = 1 << m.size
  if count > max_subsets {
    raise BudgetExceeded("complete subset enumeration exceeds budget")
  }
  count
}

///|
/// Complete enumeration in ascending bitmask order, or an explicit budget error.
/// The budget is charged before traversal; a partial answer is never returned.
pub fn Matroid::bases(
  self : Matroid,
  max_subsets~ : Int32 = 262144,
) -> Array[Array[Int32]] raise MatroidError {
  let count = enumeration_count(self, max_subsets)
  let r = self.full_rank()
  let result = []
  for mask = 0; mask < count; mask = mask + 1 {
    let xs = mask_set(self.size, mask)
    if xs.length() == r && (self.evaluate)(xs) == r {
      result.push(xs)
    }
  }
  result
}

///|
pub fn Matroid::circuits(
  self : Matroid,
  max_subsets~ : Int32 = 262144,
) -> Array[Array[Int32]] raise MatroidError {
  let count = enumeration_count(self, max_subsets)
  let result = []
  for mask = 1; mask < count; mask = mask + 1 {
    let xs = mask_set(self.size, mask)
    if self.is_circuit(xs) {
      result.push(xs)
    }
  }
  result
}

///|
pub fn Matroid::flats(
  self : Matroid,
  max_subsets~ : Int32 = 262144,
) -> Array[Array[Int32]] raise MatroidError {
  let count = enumeration_count(self, max_subsets)
  let result = []
  for mask = 0; mask < count; mask = mask + 1 {
    let xs = mask_set(self.size, mask)
    if self.is_flat(xs) {
      result.push(xs)
    }
  }
  result
}

///|
/// Entry [cardinality][rank] counts all subsets with those invariants.
pub fn Matroid::rank_distribution(
  self : Matroid,
  max_subsets~ : Int32 = 262144,
) -> Array[Array[Int64]] raise MatroidError {
  let count = enumeration_count(self, max_subsets)
  let result = Array::makei(self.size + 1, _ => {
    Array::make(self.full_rank() + 1, 0L)
  })
  for mask = 0; mask < count; mask = mask + 1 {
    let xs = mask_set(self.size, mask)
    let r = (self.evaluate)(xs)
    result[xs.length()][r] = result[xs.length()][r] + 1L
  }
  result
}
