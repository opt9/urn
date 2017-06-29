(import base (defmacro defun with for when if and or let*
              get-idx gensym =))
(import binders (let))
(import list (for-each push-cdr! any map traverse reduce))
(import type (symbol? list? function? table?))
(import table (.> getmetatable))
(import lua/os (clock))

(import base (print pretty))

(defun slot? (symb)
  "Test whether SYMB is a slot. For this, it must be a symbol, whose
   contents are `<>`."
  (and (symbol? symb) (= (get-idx symb "contents") "<>")))

(defmacro cut (&func)
  "Partially apply a function FUNC, where each `<>` is replaced by an
   argument to a function. Values are evaluated every time the resulting
   function is called.

   ### Example
   ```
   > (define double (cut * <> 2))
   > (double 3)
   6
   ```"
  (let [(args '())
        (call '())]
    (for-each item func
      (if (slot? item)
        (with (symb (gensym))
          (push-cdr! args symb)
          (push-cdr! call symb))
        (push-cdr! call item)))
    `(lambda ,args ,call)))

(defmacro cute (&func)
  "Partially apply a function FUNC, where each `<>` is replaced by an
   argument to a function. Values are evaluated when this function is
   defined.

   ### Example
   ```
   > (define double (cute * <> 2))
   > (double 3)
   6
   ```"
  (let ((args '())
        (vals '())
        (call '()))
    (for-each item func
      (with (symb (gensym))
        (push-cdr! call symb)
        (if (slot? item)
          (push-cdr! args symb)
          (push-cdr! vals `(,symb ,item)))))
    `(let ,vals (lambda ,args ,call))))

(defmacro -> (x &funcs)
  "Chain a series of method calls together. If the list contains `<>`
   then the value is placed there, otherwise the expression is invoked
   with the previous entry as an argument.

   ### Example
   ```
   > (-> '(1 2 3)
       (map succ <>)
       (map (cut * <> 2) <>))
   (4 6 8)
   ```"
  (with (res x)
    (for-each form funcs
      (let* [(symb (gensym))
             (body (if (and (list? form) (any slot? form))
                     (map (lambda (x) (if (slot? x) symb x)) form)
                     `(,form ,symb)))]
        (set! res `((lambda (,symb) ,body) ,res))))
    res))

(defun invokable? (x)
  "Test if the expression X makes sense as something that can be applied
   to a set of arguments.

   ### Example
   ```
   > (invokable? invokable?)
   true
   > (invokable? nil)
   false
   > (invokable? (setmetatable {} { :__call (lambda (x) (print! \"hello\")) }))
   true
   ```"
  (or (function? x)
      (and (table? x)
           (table? (getmetatable x))
           (invokable? (.> (getmetatable x) :__call)))))

(defun compose (f g)
  "Return the pointwise composition of functions F and G.

   ### Example:
   ```cl
   > ((compose (cut + <> 2) (cut * <> 2))
   .  2)
   out = 6
   ```"
  (if (and (invokable? f)
           (invokable? g))
    (lambda (x) (f (g x)))
    nil))

(defun comp (&fs)
  "Return the pointwise composition of all functions in FS.

   ### Example:
   ```cl
   > ((comp succ (cut + <> 2) (cut * <> 2))
   .  2)
   out = 7
   ```"
  (reduce compose (lambda (x) x) fs))
