///|
fn reset[A](f : async () -> A) -> A = "%async.run"

///|
// The iterator of the MoonBit core cannot be "interrupted". So here we use the
// control primitives provided by delimited continuations to implement the
// interruptable internal iterator so that it can be transformed into an
// external iterator.
type T[A] async (async (A) -> IterResult) -> IterResult

///|
pub async fn run[A](self : T[A], f : async (A) -> IterResult) -> IterResult {
  (self._)!!(f)
}

///|
pub fn new[A](f : async (async (A) -> IterResult) -> IterResult) -> T[A] {
  T(f)
}

///|
/// Transform the async iterator into the iterator of the MoonBit core.
pub fn iter[A](self : T[A]) -> Iter[A] {
  Iter::new(fn {
    yield_ => reset(fn() { (self._)!!(async fn(a) { yield_(a) }) })
  })
}
