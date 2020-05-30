(module
    (import "wasi_unstable" "fd_write" (func $__wasi_fd_write (param i32 i32 i32 i32) (result i32)))
    (memory (export "memory") 1)
    ;; "0123456789FizzBuzz"(18bytes) + padding[0x00 0x00](2bytes)
    ;; + buf address[0x00 0x00 0x00 0x00] (4bytes = i32) + buf length[0x01 0x00 0x00 0x00](4bytes = i32)
    (data (i32.const 0) "0123456789FizzBuzz\00\00")
    (func $fizzbuzz (param $arg i32)
        (if
            ;; mod 15
            (i32.eqz
                (i32.rem_u (get_local $arg) (i32.const 15))
            )
            (then
                ;; FizzBuzz
                (i32.store (i32.const 20) (i32.const 10))
                (i32.store (i32.const 24) (i32.const 8))
            )
            (else
                (if
                    ;; mod 5
                    (i32.eqz
                        (i32.rem_u (get_local $arg) (i32.const 5))
                    )
                    (then
                        ;; Buzz
                        (i32.store (i32.const 20) (i32.const 14))
                        (i32.store (i32.const 24) (i32.const 4))
                    )
                    (else
                        (if
                            ;; mod 3
                            (i32.eqz
                                (i32.rem_u (get_local $arg) (i32.const 3))
                            )
                            (then
                                ;; Fizz
                                (i32.store (i32.const 20) (i32.const 10))
                                (i32.store (i32.const 24) (i32.const 4))
                            )
                            (else
                                (if
                                    ;; tens place
                                    (i32.ge_u (get_local $arg) (i32.const 10))
                                    (then
                                        (i32.store (i32.const 20) (i32.div_u (get_local $arg) (i32.const 10)))
                                        (i32.store (i32.const 24) (i32.const 1))
                                        (drop
                                            (call $__wasi_fd_write (i32.const 1) (i32.const 20) (i32.const 1) (i32.const 28))
                                        )
                                    )
                                )
                                ;;　ones place
                                (i32.store (i32.const 20) (i32.rem_u (get_local $arg) (i32.const 10)))
                                (i32.store (i32.const 24) (i32.const 1))
                            )
                        )
                    )
                )
            )
        )
        (drop
            (call $__wasi_fd_write (i32.const 1) (i32.const 20) (i32.const 1) (i32.const 28))
        )
        ;; \0
        (i32.store (i32.const 20) (i32.const 19))
        (i32.store (i32.const 24) (i32.const 1))
        (drop
            (call $__wasi_fd_write (i32.const 1) (i32.const 20) (i32.const 1) (i32.const 28))
        )
    )
    (func $main
        (local $c i32)
        (local $n i32)
        (set_local $c (i32.const 1))
        (set_local $n (i32.const 31)) ;; upto $n
        (block
            (loop
                ;; $c from 1 upto $n
                (call $fizzbuzz (get_local $c))
                (br_if 1 (i32.eq (get_local $n) (get_local $c)))
                (set_local $c (i32.add (get_local $c) (i32.const 1)))
                (br 0)
            )
        )
    )
    (export "fizzbuzz" (func $fizzbuzz))
    (export "_start" (func $main))
)
