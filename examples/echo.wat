(module
 (import "wasi_unstable" "fd_write" (func $__wasi_fd_write (param i32 i32 i32 i32) (result i32)))
 (import "wasi_unstable" "fd_read" (func $__wasi_fd_read (param i32 i32 i32 i32) (result i32)))
 (import "wasi_unstable" "proc_exit" (func $__wasi_proc_exit (param i32)))
 (memory (export "memory") 1)
 (global $a (mut i32) (i32.const 0))
 (global $pc (mut i32) (i32.const 0))
 (func $f0
  (loop
   (if
    (i32.eq (get_global $pc) (i32.const 0))
    (then
     (i32.store (i32.const 0) (i32.const 0))
     (drop (call $__wasi_fd_read (i32.const 0) (i32.const 4) (i32.const 1) (i32.const 12)))
     (set_global $a (i32.load (i32.const 0)))
    ) ;; then
   ) ;; if
   (if
    (i32.eq (get_global $pc) (i32.const 1))
    (then
     (i32.store (i32.const 0) (get_global $a))
     (drop (call $__wasi_fd_write (i32.const 1) (i32.const 4) (i32.const 1) (i32.const 12)))
     (i32.store (i32.const 0) (i32.const 0))
     (set_global $pc (i32.const 0))
     (br 1)
    ) ;; then
   ) ;; if
   (set_global $pc (i32.add (get_global $pc) (i32.const 1)))
   (br 0)
  ) ;; loop
 )
 (func $main
  (i32.store (i32.const 0) (i32.const 0)) ;; buffer
  (i32.store (i32.const 4) (i32.const 0)) ;; buf address
  (i32.store (i32.const 8) (i32.const 1)) ;; buf length
  (loop
   (call $f0)
   (br 0)
  ) ;; loop
 ) ;; func main
 (export "_start" (func $main))
) ;; module
