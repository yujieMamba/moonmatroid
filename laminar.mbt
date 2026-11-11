///|
fn has(xs : Array[Int32], e : Int32) -> Bool {
  for x in xs {
    if x == e {
      return true
    }
  }
  false
}

///|
/// Sets must be nested or disjoint; missing root is equivalent to capacity n.
pub fn Matroid::laminar(
  n : Int32,
  sets : Array[Array[Int32]],
  capacities : Array[Int32],
) -> Matroid raise MatroidError {
  check_size(n)
  if sets.length() != capacities.length() || sets.length() > 128 {
    raise InvalidInput("laminar set/capacity count mismatch or limit")
  }
  let owned = []
  for i = 0; i < sets.length(); i = i + 1 {
    let s = checked_set(n, sets[i])
    if capacities[i] < 0 || capacities[i] > 64 {
      raise InvalidInput("invalid laminar capacity")
    }
    owned.push(s)
  }
  for i = 0; i < owned.length(); i = i + 1 {
    for j = i + 1; j < owned.length(); j = j + 1 {
      let mut overlap = 0
      for e in owned[i] {
        if has(owned[j], e) {
          overlap = overlap + 1
        }
      }
      if overlap > 0 &&
        overlap != owned[i].length() &&
        overlap != owned[j].length() {
        raise InvalidInput("crossing sets do not define a laminar family")
      }
      if overlap == owned[i].length() && overlap == owned[j].length() {
        raise InvalidInput("duplicate laminar set")
      }
    }
  }
  let caps = capacities.copy()
  {
    size: n,
    model: "laminar",
    evaluate: xs => {
      let counts = Array::make(caps.length(), 0)
      let mut rank = 0
      for e in xs {
        let mut fits = true
        for i = 0; i < owned.length(); i = i + 1 {
          if has(owned[i], e) && counts[i] >= caps[i] {
            fits = false
          }
        }
        if fits {
          rank = rank + 1
          for i = 0; i < owned.length(); i = i + 1 {
            if has(owned[i], e) {
              counts[i] = counts[i] + 1
            }
          }
        }
      }
      rank
    },
  }
}
