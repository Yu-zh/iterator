---
moonbit : true
---

# Yu-zh/iterator

This library implements both internal and external iterators.

* The package `@iter.T` is the internal iterator. It is similar to the `Iter`
  type of the MoonBit strandard library except that it can be transformed into
  an external iterator.

```moonbit
test {
  // First create an internal iterator
  let iter = [1, 2, 3] |> @iter.from_array
  // Then transform it into an external iterator
  let ator = iter |> @ator.from_iter
  // Finally, use the external iterator
  while ator.next() is Some(a) {
    println(a)
  }
}
```

* The package `@ator.T` is the external iterator. Note that the internal
  iterator is persistent whereas the external iterator is ephemeral.

```moonbit
test {
  // First create an external iterator
  let ator = [1, 2, 3] |> @ator.from_array
  // Find an element in the external iterator will consume elements 
  let first_even = ator.find(fn(x) { x % 2 == 0 })
  // The `find` operator is short-circuiting, so it will stop after finding
  // the result. The rest of the elements are still in the iterator.
  while ator.next() is Some(a) {
    println(a)
  }
}
```
