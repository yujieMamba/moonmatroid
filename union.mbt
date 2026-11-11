///|
/// Maximum-cardinality union selection and its disjoint independent blocks.
pub(all) struct UnionSelection {
  elements : Array[Int32]
  groups : Array[Array[Int32]]
  proof : Intersection
}

///|
/// Reduce matroid union to intersection on (block, original-element) copies.
/// The copied ground is bounded by 64; no exponential enumeration is used.
pub fn union_partition(
  models : Array[Matroid],
  max_calls~ : Int32 = 1000000,
) -> UnionSelection raise MatroidError {
  if models.length() == 0 || models.length() > 64 {
    raise InvalidInput("union requires 1..64 models")
  }
  let n = models[0].size
  if n * models.length() > 64 {
    raise InvalidInput("union copied ground exceeds 64")
  }
  let mut combined = Matroid::zero(0)
  for m in models {
    if m.size != n {
      raise InvalidInput("union ground mismatch")
    }
    combined = combined.direct_sum(m)
  }
  let copies = n * models.length()
  let labels = Array::makei(copies, e => e % n)
  let once = Matroid::partition(labels, Array::make(n, 1))
  let proof = intersect(combined, once, max_calls~)
  verify_intersection(combined, once, proof)
  let groups : Array[Array[Int32]] = Array::makei(models.length(), _ => [])
  let selected = []
  for e in proof.elements {
    groups[e / n].push(e % n)
    selected.push(e % n)
  }
  let elements = checked_set(n, selected)
  verify_partition(models, groups, elements)
  { elements, groups, proof, }
}
