(module
    (memory 1)
    (export "memory" (memory 0))
    ;; fib(0) = 0, fib(1) = 1, fib(n) = fib(n-2) + fib(n-1)
    (func $fib (param $arg i32) (result i32)
        (if (result i32)
            (i32.eqz
                (get_local $arg)
            )
            (then
                (i32.const 0)
            )
            (else
                (if (result i32)
                    (i32.eq
                        (i32.const 1)
                        (get_local $arg)
                    )
                    (then
                        (i32.const 1)
                    )
                    (else
                        ;; fib(n) = fib(n-2) + fib(n-1)
                        (i32.add
                            (call $fib
                                (i32.sub
                                    (get_local $arg)
                                    (i32.const 2)
                                )
                            )
                            (call $fib
                                (i32.sub
                                    (get_local $arg)
                                    (i32.const 1)
                                )
                            )
                        )
                    )
                )
            )
        ))
    ;; fibmemoize(0) = 0, fibmemoize(1) = 1, fibmemoize(n) = fibmemoize(n-2) + fibmemoize(n-1)
    (func $fibmemoize (param $arg i32) (result i32)
        (if (result i32)
            (i32.eqz
                (get_local $arg)
            )
            (then
                (i32.store (i32.const 0) (i32.const 0))
                (i32.load (i32.const 0))
            )
            (else
                (if (result i32)
                    (i32.eq
                        (i32.const 1)
                        (get_local $arg)
                    )
                    (then
                        (i32.store (i32.const 4) (i32.const 1))
                        (i32.load (i32.const 4))
                    )
                    (else
                        ;; fibmemoize(n) = fibmemoize(n-2) + fibmemoize(n-1)
                        (if (result i32)
                            (i32.eqz
                                (i32.load (i32.mul (i32.const 4) (get_local $arg)))
                            )
                            (then
                                (i32.store (i32.mul (i32.const 4) (get_local $arg)) (i32.add
                                                                                                                        (call $fibmemoize
                                                                                                                            (i32.sub
                                                                                                                                (get_local $arg)
                                                                                                                                (i32.const 2)
                                                                                                                            )
                                                                                                                        )
                                                                                                                        (call $fibmemoize
                                                                                                                            (i32.sub
                                                                                                                                (get_local $arg)
                                                                                                                                (i32.const 1)
                                                                                                                            )
                                                                                                                        )
                                                                                                                    ))
                                (i32.load (i32.mul (i32.const 4) (get_local $arg)))
                            )
                            (else
                                (i32.load (i32.mul (i32.const 4) (get_local $arg)))
                            )
                        )
                    )
                )
            )
        ))
    (export "fib" (func $fib))
    (export "fibmemoize" (func $fibmemoize))
)
(assert_return (invoke "fib" (i32.const 0)) (i32.const 0))
(assert_return (invoke "fib" (i32.const 1)) (i32.const 1))
(assert_return (invoke "fib" (i32.const 2)) (i32.const 1))
(assert_return (invoke "fib" (i32.const 3)) (i32.const 2))
(assert_return (invoke "fib" (i32.const 4)) (i32.const 3))
(assert_return (invoke "fib" (i32.const 5)) (i32.const 5))
(assert_return (invoke "fib" (i32.const 6)) (i32.const 8))
;;(assert_return (invoke "fib" (i32.const 45)) (i32.const 1134903170))
(assert_return (invoke "fibmemoize" (i32.const 0)) (i32.const 0))
(assert_return (invoke "fibmemoize" (i32.const 1)) (i32.const 1))
(assert_return (invoke "fibmemoize" (i32.const 2)) (i32.const 1))
(assert_return (invoke "fibmemoize" (i32.const 3)) (i32.const 2))
(assert_return (invoke "fibmemoize" (i32.const 4)) (i32.const 3))
(assert_return (invoke "fibmemoize" (i32.const 5)) (i32.const 5))
(assert_return (invoke "fibmemoize" (i32.const 6)) (i32.const 8))
(assert_return (invoke "fibmemoize" (i32.const 45)) (i32.const 1134903170))
