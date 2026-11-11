///|
fn mask_set(n : Int32, mask : Int32) -> Array[Int32] {
  let xs = []
  for e = 0; e < n; e = e + 1 {
    if (mask & (1 << e)) != 0 {
      xs.push(e)
    }
  }
  xs
}

///|
fn set_mask(xs : Array[Int32]) -> Int32 {
  let mut mask = 0
  for e in xs {
    mask = mask | (1 << e)
  }
  mask
}

///|
/// Fully checks local rank axioms; these imply all finite rank axioms.
/// Tables are limited to 12 elements (4096 rows).
pub fn Matroid::from_ranks(
  n : Int32,
  ranks : Array[Int32],
) -> Matroid raise MatroidError {
  if n < 0 || n > 12 {
    raise InvalidInput("rank table supports 0..12 elements")
  }
  let count = 1 << n
  if ranks.length() != count || ranks[0] != 0 {
    raise InvalidInput("rank table length or empty rank")
  }
  for mask = 0; mask < count; mask = mask + 1 {
    let r = ranks[mask]
    if r < 0 || r > mask_set(n, mask).length() {
      raise InvalidInput("rank outside cardinality bound")
    }
    for i = 0; i < n; i = i + 1 {
      if (mask & (1 << i)) == 0 {
        let one = mask | (1 << i)
        if ranks[one] < r || ranks[one] > r + 1 {
          raise InvalidInput("rank monotonicity or unit increment")
        }
        for j = i + 1; j < n; j = j + 1 {
          if (mask & (1 << j)) == 0 {
            let two = mask | (1 << j)
            if ranks[one] + ranks[two] < r + ranks[one | (1 << j)] {
              raise InvalidInput("rank violates diminishing returns")
            }
          }
        }
      }
    }
  }
  let owned = ranks.copy()
  { size: n, model: "rank-table", evaluate: xs => owned[set_mask(xs)], }
}

///|
pub fn Matroid::rank_snapshot(
  self : Matroid,
) -> Array[Int32] raise MatroidError {
  if self.size > 12 {
    raise InvalidInput("rank snapshot supports at most 12 elements")
  }
  Array::makei(1 << self.size, mask => {
    (self.evaluate)(mask_set(self.size, mask))
  })
}
