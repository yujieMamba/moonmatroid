///|
fn without(xs : Array[Int32], e : Int32) -> Array[Int32] {
  let result = []
  for x in xs {
    if x != e {
      result.push(x)
    }
  }
  result
}

///|
fn with_element(xs : Array[Int32], e : Int32) -> Array[Int32] {
  let result = xs.copy()
  if !has(result, e) {
    result.push(e)
  }
  result
}

///|
fn complement(n : Int32, xs : Array[Int32]) -> Array[Int32] {
  let result = []
  for e = 0; e < n; e = e + 1 {
    if !has(xs, e) {
      result.push(e)
    }
  }
  result
}

///|
pub fn Matroid::closure(
  self : Matroid,
  subset : Array[Int32],
) -> Array[Int32] raise MatroidError {
  let xs = checked_set(self.size, subset)
  let r = (self.evaluate)(xs)
  let result = []
  for e = 0; e < self.size; e = e + 1 {
    if (self.evaluate)(with_element(xs, e)) == r {
      result.push(e)
    }
  }
  result
}

///|
pub fn Matroid::basis(
  self : Matroid,
  subset : Array[Int32],
) -> Array[Int32] raise MatroidError {
  let xs = checked_set(self.size, subset)
  let result = []
  for e in xs {
    let next = with_element(result, e)
    if (self.evaluate)(next) == next.length() {
      result.push(e)
    }
  }
  result
}

///|
pub fn Matroid::is_basis(
  self : Matroid,
  subset : Array[Int32],
) -> Bool raise MatroidError {
  self.independent(subset) && subset.length() == self.full_rank()
}

///|
pub fn Matroid::is_circuit(
  self : Matroid,
  subset : Array[Int32],
) -> Bool raise MatroidError {
  let xs = checked_set(self.size, subset)
  if xs.length() == 0 || (self.evaluate)(xs) == xs.length() {
    return false
  }
  for e in xs {
    let next = without(xs, e)
    if (self.evaluate)(next) != next.length() {
      return false
    }
  }
  true
}

///|
pub fn Matroid::fundamental_circuit(
  self : Matroid,
  independent : Array[Int32],
  e : Int32,
) -> Array[Int32] raise MatroidError {
  let xs = checked_set(self.size, independent)
  if e < 0 || e >= self.size || has(xs, e) {
    raise InvalidInput("new element must be outside independent set")
  }
  if (self.evaluate)(xs) != xs.length() {
    raise InvalidInput("base set must be independent")
  }
  let extended = with_element(xs, e)
  if (self.evaluate)(extended) == extended.length() {
    raise InvalidInput("extension is independent, no circuit")
  }
  let result = [e]
  for x in xs {
    let candidate = with_element(without(xs, x), e)
    if (self.evaluate)(candidate) == xs.length() {
      result.push(x)
    }
  }
  checked_set(self.size, result)
}

///|
pub fn Matroid::loops(self : Matroid) -> Array[Int32] {
  let result = []
  for e = 0; e < self.size; e = e + 1 {
    if (self.evaluate)([e]) == 0 {
      result.push(e)
    }
  }
  result
}

///|
pub fn Matroid::coloops(self : Matroid) -> Array[Int32] {
  let result = []
  let full = all_elements(self.size)
  let rank = (self.evaluate)(full)
  for e in full {
    if (self.evaluate)(without(full, e)) < rank {
      result.push(e)
    }
  }
  result
}

///|
pub fn Matroid::spans(
  self : Matroid,
  subset : Array[Int32],
) -> Bool raise MatroidError {
  self.rank(subset) == self.full_rank()
}

///|
pub fn Matroid::is_flat(
  self : Matroid,
  subset : Array[Int32],
) -> Bool raise MatroidError {
  let xs = checked_set(self.size, subset)
  self.closure(xs).length() == xs.length()
}

///|
pub fn Matroid::fundamental_cocircuit(
  self : Matroid,
  basis : Array[Int32],
  e : Int32,
) -> Array[Int32] raise MatroidError {
  let xs = checked_set(self.size, basis)
  if !self.is_basis(xs) || !has(xs, e) {
    raise InvalidInput("requires a basis and one of its elements")
  }
  let result = [e]
  let reduced = without(xs, e)
  for x in complement(self.size, xs) {
    let candidate = with_element(reduced, x)
    if (self.evaluate)(candidate) == xs.length() {
      result.push(x)
    }
  }
  checked_set(self.size, result)
}
