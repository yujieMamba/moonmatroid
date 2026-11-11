///|
/// Verify primal feasibility and an Edmonds upper bound independently of BFS.
/// Call counters are diagnostics; they do not participate in the proof.
pub fn verify_intersection(
  left : Matroid,
  right : Matroid,
  result : Intersection,
) -> Unit raise MatroidError {
  if left.size != right.size {
    raise InvalidCertificate("ground mismatch")
  }
  let chosen = checked_set(left.size, result.elements)
  let u = checked_set(left.size, result.certificate)
  if (left.evaluate)(chosen) != chosen.length() ||
    (right.evaluate)(chosen) != chosen.length() {
    raise InvalidCertificate("selection is not common independent")
  }
  let a = (left.evaluate)(u)
  let b = (right.evaluate)(complement(left.size, u))
  if a != result.left_rank || b != result.right_rank || a + b != chosen.length() {
    raise InvalidCertificate("rank upper bound does not equal selection size")
  }
}

///|
/// Check an element-to-block decomposition, including exact coverage and disjointness.
pub fn verify_partition(
  models : Array[Matroid],
  groups : Array[Array[Int32]],
  covered : Array[Int32],
) -> Unit raise MatroidError {
  if models.length() != groups.length() {
    raise InvalidCertificate("block count mismatch")
  }
  if models.length() == 0 {
    if covered.length() != 0 {
      raise InvalidCertificate("no models for nonempty cover")
    }
    return
  }
  let n = models[0].size
  let expected = checked_set(n, covered)
  let seen = Array::make(n, false)
  for i = 0; i < models.length(); i = i + 1 {
    if models[i].size != n {
      raise InvalidCertificate("ground mismatch")
    }
    let xs = checked_set(n, groups[i])
    if (models[i].evaluate)(xs) != xs.length() {
      raise InvalidCertificate("dependent block")
    }
    for e in xs {
      if seen[e] {
        raise InvalidCertificate("blocks overlap")
      }
      seen[e] = true
    }
  }
  for e = 0; e < n; e = e + 1 {
    if seen[e] != has(expected, e) {
      raise InvalidCertificate("cover differs from claimed set")
    }
  }
}
