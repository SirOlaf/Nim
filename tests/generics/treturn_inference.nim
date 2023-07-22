
block:
  type
    MyOption[T, Z] = object
      x: T
      y: Z

  proc none[T, Z](): MyOption[T, Z] =
    when T is int:
      result.x = 22
    when Z is float:
      result.y = 12.0

  proc myGenericProc[T, Z](): MyOption[T, Z] =
    none() # implied by return type

  let a = myGenericProc[int, float]()
  doAssert a.x == 22
  doAssert a.y == 12.0

  let b: MyOption[int, float] = none() # implied by type of b
  doAssert b.x == 22
  doAssert b.y == 12.0

# Simple template based result with inferred type for errors
block:
  type
    ResultKind {.pure.} = enum
      Ok
      Err

    Result[T] = object
      case kind: ResultKind
      of Ok:
        data: T
      of Err:
        errmsg: cstring

  template err[T](msg: static cstring): Result[T] =
    Result[T](kind : ResultKind.Err, errmsg : msg)

  proc testproc(): Result[int] =
    err("Inferred error!") # implied by proc return
  let r = testproc()
  doAssert r.kind == ResultKind.Err
  doAssert r.errmsg == "Inferred error!"