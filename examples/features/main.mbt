///|
fn main {
  let features = @matroid.Matroid::binary(3, [1UL, 2UL, 3UL, 4UL, 5UL]) catch {
    _ => abort("binary")
  }
  let selected = features.weighted_basis([9, 8, 20, 3, 1]) catch {
    _ => abort("weights")
  }
  println(
    "feature basis: \{@debug.to_string(selected.elements)}; weight=\{selected.weight}",
  )
  let remaining = features.contract([2]) catch { _ => abort("minor") }
  let snapshot = remaining.encode() catch { _ => abort("encode") }
  let restored = @matroid.decode_snapshot(snapshot) catch {
    _ => abort("decode")
  }
  println("contracted snapshot: \{snapshot}")
  println("restored rank: \{restored.full_rank()}")
}
