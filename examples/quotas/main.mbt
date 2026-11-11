///|
fn main {
  // IDs are applications; department and time-slot quotas are independent.
  let department = @matroid.Matroid::partition([0, 0, 1], [1, 1]) catch {
    _ => abort("department")
  }
  let slot = @matroid.Matroid::partition([0, 1, 0], [1, 1]) catch {
    _ => abort("slot")
  }
  let result = @matroid.intersect(department, slot) catch {
    _ => abort("intersection")
  }
  @matroid.verify_intersection(department, slot, result) catch {
    _ => abort("certificate")
  }
  println("quota selection: \{@debug.to_string(result.elements)}")
  println("upper bound: \{result.left_rank + result.right_rank}")
}
