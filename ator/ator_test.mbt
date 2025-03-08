///|
test "from_array" {
  let xs = [1, 2, 3]
  let iter = @iter.from_array(xs)
  let ator = from_iter(iter)
  inspect!(ator.next(), content="Some(1)")
  inspect!(ator.next(), content="Some(2)")
  inspect!(ator.next(), content="Some(3)")
  inspect!(ator.next(), content="None")
}
