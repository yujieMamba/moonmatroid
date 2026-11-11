///|
fn main {
  let forest = @matroid.Matroid::graphic(4, [
    (0, 1),
    (1, 2),
    (2, 0),
    (2, 3),
    (0, 3),
  ]) catch {
    _ => abort("graph")
  }
  let quota = @matroid.Matroid::partition([0, 0, 1, 1, 1], [1, 2]) catch {
    _ => abort("quota")
  }
  let result = @matroid.intersect(forest, quota) catch {
    _ => abort("intersection")
  }
  @matroid.verify_intersection(forest, quota, result) catch {
    _ => abort("proof")
  }
  println("quota forest: \{@debug.to_string(result.elements)}")
  let layers = @matroid.union_partition([forest, forest]) catch {
    _ => abort("union")
  }
  @matroid.verify_partition([forest, forest], layers.groups, layers.elements) catch {
    _ => abort("cover")
  }
  println("forest layers: \{@debug.to_string(layers.groups)}")
}
