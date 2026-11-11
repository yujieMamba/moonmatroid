///|
/// Restriction to one representative per nonloop parallel class.
/// representatives[i] maps simplified ID i to the original ground.
pub(all) struct Simplification {
  matroid : Matroid
  representatives : Array[Int32]
  classes : Array[Array[Int32]]
  removed_loops : Array[Int32]
}

///|
/// Nonloop parallel classes in increasing representative order.
/// The rank-two test works for all supported representations, including minors.
pub fn Matroid::parallel_classes(self : Matroid) -> Array[Array[Int32]] {
  let classes : Array[Array[Int32]] = []
  for e = 0; e < self.size; e = e + 1 {
    if (self.evaluate)([e]) == 0 {
      continue
    }
    let mut placed = false
    for group in classes {
      if !placed && (self.evaluate)([group[0], e]) == 1 {
        group.push(e)
        placed = true
      }
    }
    if !placed {
      classes.push([e])
    }
  }
  classes
}

///|
pub fn Matroid::is_simple(self : Matroid) -> Bool {
  let classes = self.parallel_classes()
  if self.loops().length() > 0 {
    return false
  }
  for group in classes {
    if group.length() != 1 {
      return false
    }
  }
  true
}

///|
/// Mapping arrays are independent snapshots; modifying them leaves the model intact.
pub fn Matroid::simplify(self : Matroid) -> Simplification raise MatroidError {
  let classes = self.parallel_classes()
  let representatives = classes.map(group => group[0])
  {
    matroid: self.restrict_to(representatives),
    representatives,
    classes,
    removed_loops: self.loops(),
  }
}

///|
/// Connected components of the circuit equivalence relation.
/// Fundamental circuits of any basis generate this relation; no powerset walk.
/// A loop and a coloop are each singleton components.
pub fn Matroid::components(
  self : Matroid,
) -> Array[Array[Int32]] raise MatroidError {
  let base = self.basis(self.ground())
  let parents = all_elements(self.size)
  for e = 0; e < self.size; e = e + 1 {
    if !has(base, e) {
      let circuit = self.fundamental_circuit(base, e)
      for x in circuit {
        let a = root(parents, e)
        let b = root(parents, x)
        if a != b {
          parents[b] = a
        }
      }
    }
  }
  let result : Array[Array[Int32]] = []
  let roots = []
  for e = 0; e < self.size; e = e + 1 {
    let r = root(parents, e)
    let mut index = -1
    for i = 0; i < roots.length(); i = i + 1 {
      if roots[i] == r {
        index = i
      }
    }
    if index < 0 {
      roots.push(r)
      result.push([e])
    } else {
      result[index].push(e)
    }
  }
  result
}

///|
/// The empty matroid has zero components and is not connected by this API.
pub fn Matroid::is_connected(self : Matroid) -> Bool raise MatroidError {
  self.components().length() == 1
}

///|
/// Recover a structural decomposition, retaining the original labels per factor.
pub fn Matroid::component_factors(
  self : Matroid,
) -> Array[(Array[Int32], Matroid)] raise MatroidError {
  let result = []
  for group in self.components() {
    result.push((group.copy(), self.restrict_to(group)))
  }
  result
}
