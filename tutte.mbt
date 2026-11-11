///|
/// A term c*x^x_degree*y^y_degree in the ordinary Tutte polynomial.
pub(all) struct TutteTerm {
  x_degree : Int32
  y_degree : Int32
  coefficient : Int64
}

///|
fn binomial(n : Int32, k : Int32) -> Int64 {
  let mut value = 1L
  for i = 1; i <= k; i = i + 1 {
    value = value * (n - i + 1).to_int64() / i.to_int64()
  }
  value
}

///|
/// Expand sum_A (x-1)^(r(E)-r(A)) (y-1)^(|A|-r(A)).
/// At n<=18 every coefficient and signed intermediate sum fits Int64.
pub fn Matroid::tutte(
  self : Matroid,
  max_subsets~ : Int32 = 262144,
) -> Array[TutteTerm] raise MatroidError {
  let count = enumeration_count(self, max_subsets)
  let r = self.full_rank()
  let coefficients = Array::makei(r + 1, _ => Array::make(self.size - r + 1, 0L))
  for mask = 0; mask < count; mask = mask + 1 {
    let xs = mask_set(self.size, mask)
    let rank = (self.evaluate)(xs)
    let a = r - rank
    let b = xs.length() - rank
    for i = 0; i <= a; i = i + 1 {
      for j = 0; j <= b; j = j + 1 {
        let c = binomial(a, i) * binomial(b, j)
        let signed = if (a + b - i - j) % 2 == 0 { c } else { -c }
        coefficients[i][j] = coefficients[i][j] + signed
      }
    }
  }
  let result = []
  for i = 0; i <= r; i = i + 1 {
    for j = 0; j <= self.size - r; j = j + 1 {
      if coefficients[i][j] != 0L {
        result.push({
          x_degree: i,
          y_degree: j,
          coefficient: coefficients[i][j],
        })
      }
    }
  }
  result
}

///|
fn small_power(base : Int64, exponent : Int32) -> Int64 {
  let mut result = 1L
  for i = 0; i < exponent; i = i + 1 {
    result = result * base
  }
  result
}

///|
/// Integer evaluation restricted to -2..2 so all n<=18 intermediates fit Int64.
pub fn Matroid::tutte_at(
  self : Matroid,
  x : Int32,
  y : Int32,
  max_subsets~ : Int32 = 262144,
) -> Int64 raise MatroidError {
  if x < -2 || x > 2 || y < -2 || y > 2 {
    raise InvalidInput("Tutte evaluation coordinates outside -2..2")
  }
  let count = enumeration_count(self, max_subsets)
  let r = self.full_rank()
  let mut total = 0L
  for mask = 0; mask < count; mask = mask + 1 {
    let xs = mask_set(self.size, mask)
    let rank = (self.evaluate)(xs)
    total = total +
      small_power((x - 1).to_int64(), r - rank) *
      small_power((y - 1).to_int64(), xs.length() - rank)
  }
  total
}
