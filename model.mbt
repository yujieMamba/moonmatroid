///|
pub suberror MatroidError {
  InvalidInput(String)
  BudgetExceeded(String)
}

///|
/// A finite, exactly evaluated matroid. Constructors own their inputs.
pub struct Matroid {
  size : Int32
  model : String
  evaluate : (Array[Int32]) -> Int32
}

///|
fn check_size(n : Int32) -> Unit raise MatroidError {
  if n < 0 || n > 64 {
    raise InvalidInput("ground size must be in 0..64")
  }
}

///|
fn checked_set(
  n : Int32,
  input : Array[Int32],
) -> Array[Int32] raise MatroidError {
  let seen = Array::make(n, false)
  for e in input {
    if e < 0 || e >= n {
      raise InvalidInput("element outside ground set")
    }
    if seen[e] {
      raise InvalidInput("duplicate element")
    }
    seen[e] = true
  }
  let result = []
  for e = 0; e < n; e = e + 1 {
    if seen[e] {
      result.push(e)
    }
  }
  result
}

///|
fn all_elements(n : Int32) -> Array[Int32] {
  Array::makei(n, i => i)
}

///|
pub fn Matroid::ground_size(self : Matroid) -> Int32 {
  self.size
}

///|
pub fn Matroid::kind(self : Matroid) -> String {
  self.model
}

///|
pub fn Matroid::ground(self : Matroid) -> Array[Int32] {
  all_elements(self.size)
}

///|
pub fn Matroid::rank(
  self : Matroid,
  subset : Array[Int32],
) -> Int32 raise MatroidError {
  (self.evaluate)(checked_set(self.size, subset))
}

///|
pub fn Matroid::full_rank(self : Matroid) -> Int32 {
  (self.evaluate)(all_elements(self.size))
}

///|
pub fn Matroid::independent(
  self : Matroid,
  subset : Array[Int32],
) -> Bool raise MatroidError {
  self.rank(subset) == subset.length()
}

///|
pub fn Matroid::nullity(
  self : Matroid,
  subset : Array[Int32],
) -> Int32 raise MatroidError {
  subset.length() - self.rank(subset)
}

///|
pub fn Matroid::uniform(n : Int32, rank : Int32) -> Matroid raise MatroidError {
  check_size(n)
  if rank < 0 || rank > n {
    raise InvalidInput("uniform rank outside 0..n")
  }
  { size: n, model: "uniform", evaluate: xs => xs.length().min(rank), }
}

///|
pub fn Matroid::free(n : Int32) -> Matroid raise MatroidError {
  Matroid::uniform(n, n)
}

///|
pub fn Matroid::zero(n : Int32) -> Matroid raise MatroidError {
  Matroid::uniform(n, 0)
}
