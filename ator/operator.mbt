///|
pub fn zip[A, B](self : T[A], other : T[B]) -> T[(A, B)] {
  fn() {
    if self.next() is Some(a) && other.next() is Some(b) {
      Some((a, b))
    } else {
      None
    }
  }
}

///|
pub fn empty[A]() -> T[A] {
  fn() { None }
}

///|
pub fn each[A](self : T[A], f : (A) -> Unit) -> Unit {
  while self.next() is Some(a) {
    f(a)
  }
}

///|
pub fn map[A, B](self : T[A], f : (A) -> B) -> T[B] {
  fn() { if self.next() is Some(a) { Some(f(a)) } else { None } }
}

///|
pub fn filter[A](self : T[A], f : (A) -> Bool) -> T[A] {
  fn ator() {
    if self.next() is Some(a) {
      if f(a) {
        Some(a)
      } else {
        ator()
      }
    } else {
      None
    }
  }

  ator
}

///|
pub fn flat_map[A, B](self : T[A], f : (A) -> T[B]) -> T[B] {
  let mut inner : T[B]? = None
  fn() {
    for {
      if inner is Some(inner_iter) {
        if inner_iter.next() is Some(a) {
          break Some(a)
        } else {
          inner = None
        }
      } else if self.next() is Some(a) {
        inner = Some(f(a))
      } else {
        break None
      }
    }
  }
}

///|
pub fn concat[A](self : T[A], other : T[A]) -> T[A] {
  let mut left = Some(self)
  fn() {
    if left is Some(left_iter) {
      if left_iter.next() is Some(a) {
        Some(a)
      } else {
        left = None
        other.next()
      }
    } else {
      other.next()
    }
  }
}

///|
pub fn take[A](self : T[A], n : Int) -> T[A] {
  let mut count = 0
  fn() {
    if count < n && self.next() is (Some(_) as res) {
      count += 1
      res
    } else {
      None
    }
  }
}

///|
pub fn drop[A](self : T[A], n : Int) -> T[A] {
  let mut count = 0
  while count < n && self.next() is Some(_) {
    count += 1
  }
  self
}

///|
pub fn find[A](self : T[A], f : (A) -> Bool) -> A? {
  while self.next() is Some(a) {
    if f(a) {
      return Some(a)
    }
  }
  None
}
