///|
/// U certifies |I|=r_left(U)+r_right(E\U). Calls counts actual rank evaluations.
pub(all) struct Intersection {
  elements : Array[Int32]
  certificate : Array[Int32]
  left_rank : Int32
  right_rank : Int32
  oracle_calls : Int32
  augmentations : Int32
}

///|
priv struct RankBudget {
  mut used : Int32
  limit : Int32
}

///|
fn budget_rank(
  m : Matroid,
  xs : Array[Int32],
  budget : RankBudget,
) -> Int32 raise MatroidError {
  if budget.used >= budget.limit {
    raise BudgetExceeded("rank evaluation budget exhausted")
  }
  budget.used = budget.used + 1
  (m.evaluate)(xs)
}

///|
/// Shortest augmenting paths for maximum cardinality common independence.
/// Two matroids must share identical ground IDs. Weighted intersection is not offered.
pub fn intersect(
  left : Matroid,
  right : Matroid,
  max_calls~ : Int32 = 1000000,
) -> Intersection raise MatroidError {
  if left.size != right.size {
    raise InvalidInput("intersection requires equal ground sizes")
  }
  if max_calls < 1 || max_calls > 10000000 {
    raise InvalidInput("rank budget outside 1..10000000")
  }
  let n = left.size
  let budget = { used: 0, limit: max_calls, }
  let mut chosen : Array[Int32] = []
  let mut augmentations = 0
  while true {
    let outside = complement(n, chosen)
    let parent = Array::make(n, -2)
    let queue = []
    // Sources extend I in M1. M2-exchanges lead outside -> inside;
    // M1-exchanges lead inside -> outside. BFS shortest paths are essential.
    for e in outside {
      if budget_rank(left, with_element(chosen, e), budget) ==
        chosen.length() + 1 {
        parent[e] = -1
        queue.push(e)
      }
    }
    let mut cursor = 0
    let mut sink = -1
    while cursor < queue.length() && sink < 0 {
      let e = queue[cursor]
      cursor = cursor + 1
      if !has(chosen, e) {
        if budget_rank(right, with_element(chosen, e), budget) ==
          chosen.length() + 1 {
          sink = e
        } else {
          for x in chosen {
            if parent[x] == -2 &&
              budget_rank(right, with_element(without(chosen, x), e), budget) ==
              chosen.length() {
              parent[x] = e
              queue.push(x)
            }
          }
        }
      } else {
        for x in outside {
          if parent[x] == -2 &&
            budget_rank(left, with_element(without(chosen, e), x), budget) ==
            chosen.length() {
            parent[x] = e
            queue.push(x)
          }
        }
      }
    }
    if sink < 0 {
      // Reachable set R gives U=E\R: r1(U)+r2(R)=|I|.
      let u = []
      for e = 0; e < n; e = e + 1 {
        if parent[e] == -2 {
          u.push(e)
        }
      }
      let a = budget_rank(left, u, budget)
      let b = budget_rank(right, complement(n, u), budget)
      if a + b != chosen.length() {
        raise InvalidInput("internal intersection certificate invariant")
      }
      return {
        elements: chosen,
        certificate: u,
        left_rank: a,
        right_rank: b,
        oracle_calls: budget.used,
        augmentations,
      }
    }
    let toggles = Array::make(n, false)
    let mut at = sink
    while at >= 0 {
      toggles[at] = true
      at = parent[at]
    }
    let next = []
    for e = 0; e < n; e = e + 1 {
      if has(chosen, e) != toggles[e] {
        next.push(e)
      }
    }
    if next.length() != chosen.length() + 1 ||
      budget_rank(left, next, budget) != next.length() ||
      budget_rank(right, next, budget) != next.length() {
      raise InvalidInput("internal augmenting path invariant")
    }
    chosen = next
    augmentations = augmentations + 1
  } nobreak {
    raise InvalidInput("unreachable loop termination")
  }
}
