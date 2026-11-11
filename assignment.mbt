///|
/// Recover an actual maximum matching for the selected transversal elements.
/// Pairs are (left element ID, right vertex ID), ordered by right ID.
/// Unmatched elements are omitted; returned length equals the transversal rank.
pub fn transversal_assignment(
  rights : Int32,
  neighbors : Array[Array[Int32]],
  subset : Array[Int32],
) -> Array[(Int32, Int32)] raise MatroidError {
  let m = Matroid::transversal(rights, neighbors)
  let selected = checked_set(m.size, subset)
  let owned = neighbors.map(row => row.copy())
  let matched = Array::make(rights, -1)
  for e in selected {
    augment_matching(e, owned, matched, Array::make(rights, false)) |> ignore
  }
  let pairs = []
  for r = 0; r < rights; r = r + 1 {
    if matched[r] >= 0 {
      pairs.push((matched[r], r))
    }
  }
  if pairs.length() != (m.evaluate)(selected) {
    raise InvalidCertificate("transversal witness rank mismatch")
  }
  pairs
}
