///|
/// The returned ground is reindexed by the supplied ordered labels.
pub fn Matroid::relabel(
  self : Matroid,
  order : Array[Int32],
) -> Matroid raise MatroidError {
  checked_set(self.size, order) |> ignore
  if order.length() != self.size {
    raise InvalidInput("relabel requires a complete permutation")
  }
  let labels = order.copy()
  {
    size: self.size,
    model: "relabel",
    evaluate: xs => (self.evaluate)(xs.map(e => labels[e])),
  }
}

///|
/// Retained labels are ascending; new index i denotes retained[i].
pub fn Matroid::restrict_to(
  self : Matroid,
  retained : Array[Int32],
) -> Matroid raise MatroidError {
  let labels = checked_set(self.size, retained)
  {
    size: labels.length(),
    model: "restriction",
    evaluate: xs => (self.evaluate)(xs.map(e => labels[e])),
  }
}

///|
pub fn Matroid::delete(
  self : Matroid,
  removed : Array[Int32],
) -> Matroid raise MatroidError {
  let xs = checked_set(self.size, removed)
  self.restrict_to(complement(self.size, xs))
}

///|
/// Contracts even dependent sets using r(X union C)-r(C).
pub fn Matroid::contract(
  self : Matroid,
  contracted : Array[Int32],
) -> Matroid raise MatroidError {
  let fixed = checked_set(self.size, contracted)
  let labels = complement(self.size, fixed)
  let offset = (self.evaluate)(fixed)
  {
    size: labels.length(),
    model: "contraction",
    evaluate: xs => {
      let expanded = fixed.copy()
      for e in xs {
        expanded.push(labels[e])
      }
      (self.evaluate)(expanded) - offset
    },
  }
}

///|
pub fn Matroid::dual(self : Matroid) -> Matroid {
  let full = self.full_rank()
  {
    size: self.size,
    model: "dual",
    evaluate: xs => {
      xs.length() + (self.evaluate)(complement(self.size, xs)) - full
    },
  }
}

///|
pub fn Matroid::truncate(
  self : Matroid,
  rank : Int32,
) -> Matroid raise MatroidError {
  if rank < 0 || rank > self.full_rank() {
    raise InvalidInput("truncation rank outside 0..r(E)")
  }
  {
    size: self.size,
    model: "truncation",
    evaluate: xs => (self.evaluate)(xs).min(rank),
  }
}
