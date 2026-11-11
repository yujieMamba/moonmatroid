///|
test "strict rank snapshots roundtrip models and reject corrupt semantics" {
  let m = Matroid::uniform(3, 2)
  let text = m.encode()
  assert_eq(text, "MM1:3:0,1,1,2,1,2,2,2")
  let restored = decode_snapshot(text)
  assert_eq(restored.rank_snapshot(), m.rank_snapshot())
  for
    bad in [
      "", "MM2:0:0", "MM1:00:0", "MM1:1:0", "MM1:1:0,2", "MM1:1:0,01", "MM1:0:0\n",
      "MM1:0:-1", "MM1:0:０", "MM1:0:0:", "MM1:13:0", "MM1:2:0,0,0,1",
    ] {
    let rejected = try {
      decode_snapshot(bad) |> ignore
      false
    } catch {
      _ => true
    }
    assert_true(rejected)
  }
  assert_eq(decode_snapshot("MM1:0:0").ground_size(), 0)
}
