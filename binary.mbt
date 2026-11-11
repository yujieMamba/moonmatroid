///|
/// Columns are UInt64 bit vectors over GF(2), low bits are row indices.
pub fn Matroid::binary(
  rows : Int32,
  columns : Array[UInt64],
) -> Matroid raise MatroidError {
  check_size(columns.length())
  if rows < 0 || rows > 64 {
    raise InvalidInput("binary rows outside 0..64")
  }
  for c in columns {
    if rows < 64 && c >> rows != 0UL {
      raise InvalidInput("binary column exceeds row count")
    }
  }
  let owned = columns.copy()
  {
    size: owned.length(),
    model: "binary",
    evaluate: xs => {
      let pivots = Array::make(rows, 0UL)
      let mut rank = 0
      for e in xs {
        let mut vector = owned[e]
        for row = rows - 1; row >= 0; row = row - 1 {
          if (vector & (1UL << row)) != 0UL {
            if pivots[row] == 0UL {
              pivots[row] = vector
              rank = rank + 1
              break
            } else {
              vector = vector ^ pivots[row]
            }
          }
        }
      }
      rank
    },
  }
}
