///|
type T[A] async (async (A) -> IterResult) -> IterResult

///|
pub async fn run[A](self : T[A], f : async (A) -> IterResult) -> IterResult {
  (self._)!!(f)
}

///|
pub fn new[A](f : async (async (A) -> IterResult) -> IterResult) -> T[A] {
  T(f)
}
