///|
pub fn from_array[A](xs : Array[A]) -> T[A] {
  new(async fn(yield_) {
    for v in xs {
      guard yield_!!(v) is IterContinue else { break IterEnd }

    } else {
      IterContinue
    }
  })
}

///|
pub fn collect[A](self : T[A]) -> Array[A] {
  let xs = []
  for x in self {
    xs.push(x)
  }
  xs
}
