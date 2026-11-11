///|
/// Group labels index capacities; absent groups and zero capacities are valid.
pub fn Matroid::partition(
  groups : Array[Int32],
  capacities : Array[Int32],
) -> Matroid raise MatroidError {
  check_size(groups.length())
  if capacities.length() > 64 {
    raise InvalidInput("too many groups")
  }
  for c in capacities {
    if c < 0 || c > 64 {
      raise InvalidInput("invalid capacity")
    }
  }
  for g in groups {
    if g < 0 || g >= capacities.length() {
      raise InvalidInput("unknown group")
    }
  }
  let labels = groups.copy()
  let caps = capacities.copy()
  {
    size: labels.length(),
    model: "partition",
    evaluate: xs => {
      let counts = Array::make(caps.length(), 0)
      for e in xs {
        counts[labels[e]] = counts[labels[e]] + 1
      }
      let mut rank = 0
      for g = 0; g < caps.length(); g = g + 1 {
        rank = rank + counts[g].min(caps[g])
      }
      rank
    },
  }
}
