///|
pub fn from_array[A](xs : Array[A]) -> T[A] {
  let mut i = 0
  fn() {
    if i < xs.length() {
      let res = Some(xs[i])
      i += 1
      res
    } else {
      None
    }
  }
}

///|
pub fn collect[A](self : T[A]) -> Array[A] {
  let xs = []
  while self.next() is Some(a) {
    xs.push(a)
  }
  xs
}
