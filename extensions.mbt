///|
/// Disjoint concatenation; right element j becomes left.size+j.
pub fn Matroid::direct_sum(
  self : Matroid,
  right : Matroid,
) -> Matroid raise MatroidError {
  check_size(self.size + right.size)
  {
    size: self.size + right.size,
    model: "direct-sum",
    evaluate: xs => {
      let a = []
      let b = []
      for e in xs {
        if e < self.size {
          a.push(e)
        } else {
          b.push(e - self.size)
        }
      }
      (self.evaluate)(a) + (right.evaluate)(b)
    },
  }
}

///|
pub fn Matroid::add_loop(self : Matroid) -> Matroid raise MatroidError {
  self.direct_sum(Matroid::zero(1))
}

///|
pub fn Matroid::add_coloop(self : Matroid) -> Matroid raise MatroidError {
  self.direct_sum(Matroid::free(1))
}

///|
/// Adds a parallel copy at element n. A copy of a loop is a loop.
pub fn Matroid::parallel_extension(
  self : Matroid,
  element : Int32,
) -> Matroid raise MatroidError {
  if element < 0 || element >= self.size {
    raise InvalidInput("parallel source outside ground")
  }
  check_size(self.size + 1)
  {
    size: self.size + 1,
    model: "parallel-extension",
    evaluate: xs => {
      let mapped = []
      for e in xs {
        let label = if e == self.size { element } else { e }
        if !has(mapped, label) {
          mapped.push(label)
        }
      }
      (self.evaluate)(mapped)
    },
  }
}

///|
/// Free extension at n lies in full closure but in no proper flat.
pub fn Matroid::free_extension(self : Matroid) -> Matroid raise MatroidError {
  check_size(self.size + 1)
  let full = self.full_rank()
  {
    size: self.size + 1,
    model: "free-extension",
    evaluate: xs => {
      let base = without(xs, self.size)
      let r = (self.evaluate)(base)
      if has(xs, self.size) {
        (r + 1).min(full)
      } else {
        r
      }
    },
  }
}

///|
/// Series extension is dual to a parallel extension.
pub fn Matroid::series_extension(
  self : Matroid,
  element : Int32,
) -> Matroid raise MatroidError {
  self.dual().parallel_extension(element).dual()
}

///|
/// Connectivity across an explicit bipartition, lambda(A)=r(A)+r(E-A)-r(E).
pub fn Matroid::connectivity(
  self : Matroid,
  subset : Array[Int32],
) -> Int32 raise MatroidError {
  let xs = checked_set(self.size, subset)
  (self.evaluate)(xs) +
  (self.evaluate)(complement(self.size, xs)) -
  self.full_rank()
}
