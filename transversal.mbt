///|
fn augment_matching(
  e : Int32,
  adjacency : Array[Array[Int32]],
  matched : Array[Int32],
  seen : Array[Bool],
) -> Bool {
  for r in adjacency[e] {
    if !seen[r] {
      seen[r] = true
      if matched[r] < 0 ||
        augment_matching(matched[r], adjacency, matched, seen) {
        matched[r] = e
        return true
      }
    }
  }
  false
}

///|
/// Ground elements are left vertices; a set is independent iff matchable.
pub fn Matroid::transversal(
  rights : Int32,
  neighbors : Array[Array[Int32]],
) -> Matroid raise MatroidError {
  check_size(neighbors.length())
  if rights < 0 || rights > 256 {
    raise InvalidInput("right vertices outside 0..256")
  }
  let owned = []
  for row in neighbors {
    owned.push(checked_set(rights, row))
  }
  {
    size: owned.length(),
    model: "transversal",
    evaluate: xs => {
      let matched = Array::make(rights, -1)
      let mut rank = 0
      for e in xs {
        if augment_matching(e, owned, matched, Array::make(rights, false)) {
          rank = rank + 1
        }
      }
      rank
    },
  }
}
