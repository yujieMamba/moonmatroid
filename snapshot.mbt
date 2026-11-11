///|
/// Versioned, canonical ASCII snapshot: MM1:n:r0,r1,...\n (no final newline).
/// Rank rows are in bitmask order and revalidated on decoding, not trusted.
pub fn Matroid::encode(self : Matroid) -> String raise MatroidError {
  let ranks = self.rank_snapshot()
  let mut out = "MM1:\{self.size}:"
  for i = 0; i < ranks.length(); i = i + 1 {
    if i > 0 {
      out = out + ","
    }
    out = out + "\{ranks[i]}"
  }
  out
}

///|
fn parse_snapshot_number(text : String) -> Int32 raise MatroidError {
  let chars = text.to_array()
  if chars.length() == 0 || chars.length() > 2 {
    raise InvalidInput("snapshot integer width")
  }
  if chars.length() > 1 && chars[0] == '0' {
    raise InvalidInput("snapshot leading zero")
  }
  let mut value = 0
  for c in chars {
    let digit = match c {
      '0' => 0
      '1' => 1
      '2' => 2
      '3' => 3
      '4' => 4
      '5' => 5
      '6' => 6
      '7' => 7
      '8' => 8
      '9' => 9
      _ => raise InvalidInput("snapshot nondecimal integer")
    }
    value = value * 10 + digit
  }
  value
}

///|
/// Strict decode: 16KiB cap, canonical decimals, exact row count, all rank axioms.
pub fn decode_snapshot(text : String) -> Matroid raise MatroidError {
  if text.length() > 16384 {
    raise InvalidInput("snapshot exceeds 16KiB")
  }
  let parts = text.split(":").to_array()
  if parts.length() != 3 || parts[0].to_owned() != "MM1" {
    raise InvalidInput("snapshot header")
  }
  let n = parse_snapshot_number(parts[1].to_owned())
  if n > 12 {
    raise InvalidInput("snapshot supports at most 12 elements")
  }
  let rows = parts[2].to_owned().split(",").to_array()
  if rows.length() != 1 << n {
    raise InvalidInput("snapshot row count")
  }
  let ranks = []
  for row in rows {
    ranks.push(parse_snapshot_number(row.to_owned()))
  }
  Matroid::from_ranks(n, ranks)
}
