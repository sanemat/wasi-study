(module
    ;;(import "wasi_unstable" "fd_write" (func $__wasi_fd_write (param i32 i32 i32 i32) (result i32)))
    (func $fizzbuzz (param $arg i32) (result i32)
        get_local $arg
    )
    (func $main
    )
    (export "fizzbuzz" (func $fizzbuzz))
    (export "_start" (func $main))
)
(assert_return (invoke "fizzbuzz" (i32.const 0)) (i32.const 0))
