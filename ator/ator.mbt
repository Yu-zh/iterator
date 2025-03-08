///|
typealias Iter[A] = @iter.T[A]

///|
type T[A] () -> A?

///|
pub fn next[A](self : T[A]) -> A? {
  (self._)()
}

///|
async fn shift[T](cb : ((T) -> Unit) -> Unit) -> T = "%async.suspend"

///|
fn reset(f : async () -> Unit) -> Unit = "%async.run"

///|
pub fn from_iter[A](iter : Iter[A]) -> T[A] {
  let mut k = fn() { () }
  let mut v = None
  reset(fn() {
    iter.run!!(fn(a) {
      v = Some(a)
      shift!!(fn(next_k) { k = fn() { next_k(IterContinue) } })
    })
    |> ignore
    v = None
    k = fn() { () }
  })
  fn() {
    if v is (Some(_) as res) {
      k()
      res
    } else {
      None
    }
  }
}
