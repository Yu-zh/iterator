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

///|
test "ephemeral" {
  let xs = [1, 2, 3]
  let ator = from_array(xs)
  inspect!(ator.find(fn(x) { x == 2 }), content="Some(2)")
  inspect!(ator.next(), content="Some(3)")
}

///|
test "find & take & drop & concat" {
  let it1 = fn() { [(1, 'a'), (2, 'b'), (3, 'c')] |> from_array }
  let it2 = fn() { [(1, 'd'), (2, 'e'), (3, 'f')] |> from_array }
  let it3 = fn() { it1().drop(1).concat(it2().take(2)) }
  inspect!(it3().collect(), content="[(2, 'b'), (3, 'c'), (1, 'd'), (2, 'e')]")
  inspect!(it3().find(fn(x) { x.0 == 1 }), content="Some((1, 'd'))")
  inspect!(it3().find(fn(x) { x.0 == 2 }), content="Some((2, 'b'))")
  inspect!(it3().find(fn(x) { x.0 == 3 }), content="Some((3, 'c'))")
  inspect!(it3().find(fn(x) { x.0 == 4 }), content="None")
  let it4 = fn() { it1().take(2).concat(it2().drop(1)) }
  inspect!(it4().collect(), content="[(1, 'a'), (2, 'b'), (2, 'e'), (3, 'f')]")
  inspect!(it4().find(fn(x) { x.0 == 1 }), content="Some((1, 'a'))")
  inspect!(it4().find(fn(x) { x.0 == 2 }), content="Some((2, 'b'))")
  inspect!(it4().find(fn(x) { x.0 == 3 }), content="Some((3, 'f'))")
  inspect!(it4().find(fn(x) { x.0 == 4 }), content="None")
  let it5 = fn() { it2().take(1).concat(it1().drop(2)) }
  inspect!(it5().collect(), content="[(1, 'd'), (3, 'c')]")
  inspect!(it5().find(fn(x) { x.0 == 1 }), content="Some((1, 'd'))")
  inspect!(it5().find(fn(x) { x.0 == 2 }), content="None")
  inspect!(it5().find(fn(x) { x.0 == 3 }), content="Some((3, 'c'))")
  inspect!(it5().find(fn(x) { x.0 == 4 }), content="None")
  let it6 = fn() { it1().take(0).concat(it2().take(0)) }
  inspect!(it6().collect(), content="[]")
  inspect!(it6().find(fn(x) { x.0 == 1 }), content="None")
  inspect!(it6().find(fn(x) { x.0 == 2 }), content="None")
  inspect!(it6().find(fn(x) { x.0 == 3 }), content="None")
  inspect!(it6().find(fn(x) { x.0 == 4 }), content="None")
  let it7 = fn() { it1().drop(0).concat(it2().drop(0)) }
  inspect!(
    it7().collect(),
    content="[(1, 'a'), (2, 'b'), (3, 'c'), (1, 'd'), (2, 'e'), (3, 'f')]",
  )
  inspect!(it7().find(fn(x) { x.0 == 1 }), content="Some((1, 'a'))")
  inspect!(it7().find(fn(x) { x.0 == 2 }), content="Some((2, 'b'))")
  inspect!(it7().find(fn(x) { x.0 == 3 }), content="Some((3, 'c'))")
  inspect!(it7().find(fn(x) { x.0 == 4 }), content="None")
  let it8 = fn() { it2().take(4).concat(it1().take(4)) }
  inspect!(
    it8().collect(),
    content="[(1, 'd'), (2, 'e'), (3, 'f'), (1, 'a'), (2, 'b'), (3, 'c')]",
  )
  inspect!(it8().find(fn(x) { x.0 == 1 }), content="Some((1, 'd'))")
  inspect!(it8().find(fn(x) { x.0 == 2 }), content="Some((2, 'e'))")
  inspect!(it8().find(fn(x) { x.0 == 3 }), content="Some((3, 'f'))")
  inspect!(it8().find(fn(x) { x.0 == 4 }), content="None")
  let it9 = fn() { it1().drop(4).concat(it2().drop(4)) }
  inspect!(it9().collect(), content="[]")
  inspect!(it9().find(fn(x) { x.0 == 1 }), content="None")
  inspect!(it9().find(fn(x) { x.0 == 2 }), content="None")
  inspect!(it9().find(fn(x) { x.0 == 3 }), content="None")
  inspect!(it9().find(fn(x) { x.0 == 4 }), content="None")
}

///|
test "map & filter & flat_map" {
  let it1 = fn() { [1, 2, 3] |> from_array }
  let it2 = fn { (i : Int) => [(i, 'a'), (i, 'b'), (i, 'c')] |> from_array }
  let it3 = fn() { it1().flat_map(it2) }
  inspect!(
    it3().collect(),
    content="[(1, 'a'), (1, 'b'), (1, 'c'), (2, 'a'), (2, 'b'), (2, 'c'), (3, 'a'), (3, 'b'), (3, 'c')]",
  )
  let it4 = fn() { it3().drop(1).take(7) }
  inspect!(
    it4().collect(),
    content="[(1, 'b'), (1, 'c'), (2, 'a'), (2, 'b'), (2, 'c'), (3, 'a'), (3, 'b')]",
  )
  let it5 = fn() { it4().filter(fn(x) { x.0 == 2 }).map(fn(x) { x.1 }) }
  inspect!(it5().collect(), content="['a', 'b', 'c']")
  inspect!(it4().find(fn(x) { x.0 == 1 }), content="Some((1, 'b'))")
  inspect!(it4().find(fn(x) { x.0 == 2 }), content="Some((2, 'a'))")
  inspect!(it4().find(fn(x) { x.0 == 3 }), content="Some((3, 'a'))")
  inspect!(it4().find(fn(x) { x.0 == 4 }), content="None")
}
