///|
pub fn empty[A]() -> T[A] {
  fn { _ => IterEnd }
}

///|
pub fn each[A](self : T[A], f : (A) -> Unit) -> Unit {
  for a in self {
    f(a)
  }
}

///|
pub fn map[A, B](self : T[A], f : (A) -> B) -> T[B] {
  fn { yield_ => self.run!!(fn { a => yield_!!(f(a)) }) }
}

///|
pub fn filter[A](self : T[A], f : (A) -> Bool) -> T[A] {
  fn {
    yield_ =>
      self.run!!(fn { a => if f(a) { yield_!!(a) } else { IterContinue } })
  }
}

///|
pub fn flat_map[A, B](self : T[A], f : (A) -> T[B]) -> T[B] {
  fn { yield_ => self.run!!(fn { a => f(a).run!!(yield_) }) }
}

///|
pub fn concat[A](self : T[A], other : T[A]) -> T[A] {
  fn {
    yield_ =>
      if self.run!!(yield_) is IterEnd {
        IterEnd
      } else {
        other.run!!(yield_)
      }
  }
}

///|
pub fn take[A](self : T[A], n : Int) -> T[A] {
  fn {
    yield_ => {
      let mut i = 0
      let mut r = IterContinue
      self.run!!(fn {
        a =>
          if i < n {
            if yield_!!(a) is IterEnd {
              r = IterEnd
              IterEnd
            } else {
              i += 1
              IterContinue
            }
          } else {
            IterEnd
          }
      })
      |> ignore
      r
    }
  }
}

///|
pub fn drop[A](self : T[A], n : Int) -> T[A] {
  fn {
    yield_ => {
      let mut i = 0
      self.run!!(fn {
        a =>
          if i < n {
            i += 1
            IterContinue
          } else {
            yield_!!(a)
          }
      })
    }
  }
}

///|
pub fn find[A](self : T[A], f : (A) -> Bool) -> A? {
  let mut find_result = None
  reset(fn() {
    self.run!!(fn {
      a =>
        if f(a) {
          find_result = Some(a)
          IterEnd
        } else {
          IterContinue
        }
    })
  })
  |> ignore
  find_result
}
