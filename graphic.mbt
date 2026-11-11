///|
fn root(parent : Array[Int32], start : Int32) -> Int32 {
  let mut x = start
  while parent[x] != x {
    x = parent[x]
  }
  x
}

///|
/// Edge IDs are stable, including loops and parallel edges. Vertices <=256.
pub fn Matroid::graphic(
  vertices : Int32,
  edges : Array[(Int32, Int32)],
) -> Matroid raise MatroidError {
  check_size(edges.length())
  if vertices < 0 || vertices > 256 {
    raise InvalidInput("vertices outside 0..256")
  }
  for edge in edges {
    let (u, v) = edge
    if u < 0 || v < 0 || u >= vertices || v >= vertices {
      raise InvalidInput("edge endpoint outside graph")
    }
  }
  let owned = edges.copy()
  {
    size: owned.length(),
    model: "graphic",
    evaluate: xs => {
      let parents = all_elements(vertices)
      let sizes = Array::make(vertices, 1)
      let mut rank = 0
      for e in xs {
        let (u, v) = owned[e]
        let a = root(parents, u)
        let b = root(parents, v)
        if a != b {
          if sizes[a] < sizes[b] {
            parents[a] = b
            sizes[b] = sizes[b] + sizes[a]
          } else {
            parents[b] = a
            sizes[a] = sizes[a] + sizes[b]
          }
          rank = rank + 1
        }
      }
      rank
    },
  }
}
