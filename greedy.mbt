///|
/// Owned result arrays; mutating them cannot mutate the input model.
pub(all) struct Selection {
  elements : Array[Int32]
  weight : Int64
  rank : Int32
}

///|
fn checked_weight_sum(weights : Array[Int32], chosen : Array[Int32]) -> Int64 {
  // <=64 signed 32-bit weights cannot overflow signed 64-bit accumulation.
  let mut sum = 0L
  for e in chosen {
    sum = sum + weights[e].to_int64()
  }
  sum
}

///|
fn weight_order(weights : Array[Int32], maximize : Bool) -> Array[Int32] {
  let order = all_elements(weights.length())
  // Stable insertion sort, ties retain increasing element IDs.
  for i = 1; i < order.length(); i = i + 1 {
    let e = order[i]
    let mut j = i
    while j > 0 {
      let before = order[j - 1]
      let better = if maximize {
        weights[e] > weights[before]
      } else {
        weights[e] < weights[before]
      }
      if !better {
        break
      }
      order[j] = before
      j = j - 1
    }
    order[j] = e
  }
  order
}

///|
/// Optimal-weight basis, even when all weights are negative.
pub fn Matroid::weighted_basis(
  self : Matroid,
  weights : Array[Int32],
  maximize~ : Bool = true,
) -> Selection raise MatroidError {
  if weights.length() != self.size {
    raise InvalidInput("one integer weight per element required")
  }
  let chosen = []
  for e in weight_order(weights, maximize) {
    let candidate = with_element(chosen, e)
    if (self.evaluate)(candidate) == candidate.length() {
      chosen.push(e)
    }
  }
  {
    elements: checked_set(self.size, chosen),
    weight: checked_weight_sum(weights, chosen),
    rank: chosen.length(),
  }
}

///|
/// Maximum weight independent set; nonpositive weights are omitted.
pub fn Matroid::max_weight_independent(
  self : Matroid,
  weights : Array[Int32],
) -> Selection raise MatroidError {
  if weights.length() != self.size {
    raise InvalidInput("one integer weight per element required")
  }
  let chosen = []
  for e in weight_order(weights, true) {
    if weights[e] > 0 {
      let candidate = with_element(chosen, e)
      if (self.evaluate)(candidate) == candidate.length() {
        chosen.push(e)
      }
    }
  }
  {
    elements: checked_set(self.size, chosen),
    weight: checked_weight_sum(weights, chosen),
    rank: chosen.length(),
  }
}
