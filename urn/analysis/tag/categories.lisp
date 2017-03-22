(import urn/analysis/nodes ())
(import urn/analysis/pass ())

(defun cat (category &args)
  "Create a CATEGORY data set, using ARGS as additional parameters to [[struct]]."
  :hidden
  (struct
    :category category
    (unpack args 1 (# args))))

(defun part-all (xs i e f)
  "An implementation of [[all]] which just goes between I and E."
  (cond
    [(> i e) true]
    [(f (nth xs i)) (part-all xs (+ i 1) e f)]
    [true false]))

(defun visit-node (lookup node stmt)
  "Marks a specific NODE with a category.

   STMT marks whether this node is in a \"statement\" context. This is any node
   for which we are capable of generating a statement: namely any
   block (assignments, returns, simple calls) or the condition inside a `cond`."
  :hidden
  (with (cat (case (type node)
          ["string" (cat "const")]
          ["number" (cat "const")]
          ["key"    (cat "const")]
          ["symbol" (cat "const")]
          ["list"
           (with (head (car node))
             (case (type head)
               ["symbol"
                (let* [(func (.> head :var))
                       (funct (.> func :tag))]
                  (cond
                    ;; Handle all special forms
                    [(= func (.> builtins :lambda))
                     (visit-nodes lookup node 3 true)
                     (cat "lambda")]
                    [(= func (.> builtins :cond))
                     ;; Visit all conditions inside the node. It maybe seem
                     ;; weird that we consider the condition as a statement, but
                     ;; we have enough flexibility at codegen time to allow it to
                     ;; be.
                     (for i 2 (# node) 1
                       (with (case (nth node i))
                         (visit-node lookup (car case) true)
                         (visit-nodes lookup case 2 true)))

                     ;; And attempt to find the best condition
                     (cond
                       [(and
                          ;; If we have two conditions
                          (= (# node) 3)
                          ;; If the first condition is of the form `[A false]`
                          (with (sub (nth node 2))
                            (and (= (# sub) 2) (builtin-var? (nth sub 2) :false)))
                          (with (sub (nth node 3))
                            (and (= (# sub) 2) (builtin-var? (nth sub 1) :true) (builtin-var? (nth sub 2) :true))))
                        (cat "not" :stmt (.> lookup (car (nth node 2)) :stmt))]

                       [(and
                          ;; If we have two conditions
                          (= (# node) 3)
                          ;; If the first condition is of the form `[A <expr>]`
                          ;; The second one is of the form `[true A]`
                          (let* [(first (nth node 2))
                                 (second (nth node 3))]
                            (and
                              (= (# first) 2) (= (# second) 2)
                              (symbol? (car first)) (! (.> lookup (nth first 2) :stmt))
                              (builtin-var? (car second) :true) (eq? (car first) (nth second 2)))))
                        (cat "and")]

                       [(and
                          ;; If we have at least two conditions.
                          (>= (# node) 3)
                          ;; Each condition follows the form `[x x]`.
                          (part-all node 2 (pred (# node))
                            (lambda (branch)
                              (and (= (# branch) 2) (symbol? (car branch)) (eq? (car branch) (nth branch 2)))))
                          ;; Apart from the last one, which is `[true <expr>]`.
                          (with (branch (last node))
                            (and (= (# branch) 2) (builtin-var? (car branch) :true) (! (.> lookup (nth branch 2) :stmt)))))
                        (cat "or")]

                       [true (cat "cond" :stmt true)])]
                    [(= func (.> builtins :set!))
                     (visit-node lookup (nth node 3) true)
                     (cat "set!")]
                    [(= func (.> builtins :quote)) (cat "quote")]
                    [(= func (.> builtins :syntax-quote))
                     (visit-quote lookup (nth node 2) 1)
                     (cat "syntax-quote")]
                    [(= func (.> builtins :unquote)) (fail! "unquote should never appear")]
                    [(= func (.> builtins :unquote-splice)) (fail! "unquote should never appear")]
                    [(= func (.> builtins :define))
                     (visit-node lookup (nth node (# node)) true)
                     (cat "define")]
                    [(= func (.> builtins :define-macro))
                     (visit-node lookup (nth node (# node)) true)
                     (cat "define")]
                    [(= func (.> builtins :define-native)) (cat "define-native")]
                    [(= func (.> builtins :import)) (cat "import")]

                    ;; Handle things like `("foo")`
                    [(= func (.> builtin-vars :true))
                     (visit-nodes lookup node 1 false)
                     (cat "call-literal")]
                    [(= func (.> builtin-vars :false))
                     (visit-nodes lookup node 1 false)
                     (cat "call-literal")]
                    [(= func (.> builtin-vars :nil))
                     (visit-nodes lookup node 1 false)
                     (cat "call-literal")]

                    ;; Default invocation
                    [true
                     (visit-nodes lookup node 1 false)
                     (cat "call-symbol")]))]
               ["list"
                (cond
                  ;; We detect structures of the form ((lambda (x) (set-idx! x A B)) (empty-struct)) and
                  ;; compile them to tables.
                  ;; Ideally, this would be implemented in a "compiler" plugin as it assumes empty-struct
                  ;; and set-idx! do what they do in the standard library.
                  [(and
                     (= (# node) 2) (builtin? (car head) :lambda) (= (# (nth head 2)) 1)
                     (with (val (nth node 2))
                       (and (list? arg) (= (# val) 1) (eq? (car val) 'empty-struct)))
                     (with (arg (car (nth head 2)))
                       (and
                         (! (.> arg :isVariadic)) (eq? arg (last head))
                         ;; We check that all body nodes are of the form (set-idx! x A B)
                         ;; A future enhancement would be to ensure B is an expression: otherwise we're just
                         ;; postponing the inevitable lambda creation.
                         (part-all head 3 (pred (# head)) (lambda (node)
                                                            (and
                                                              (list? node) (= (# node) 4)
                                                              (eq? (car node) 'set-idx!)
                                                              (eq? (nth node 2) arg)))))))
                   (visit-nodes lookup (car node) 3 false)
                   (cat "make-struct")]

                  [(and
                     ;; Attempt to determine expressions of the form ((lambda (x) x) Y)
                     ;; where Y is an expression.
                     (= (# node) 2) (builtin? (car head) :lambda)
                     (= (# head) 3) (= (# (nth head 2)) 1)
                     (symbol? (nth head 3)) (= (.> (nth head 3) :var) (.> (car (nth head 2)) :var)))

                   ;; We now need to visit the child node.
                   (with (child-cat (visit-node lookup (nth node 2) stmt))
                     (if (.> child-cat :stmt)
                       (progn
                         (visit-node lookup head true)
                         ;; If we got a statement out of it, then we either need to emit
                         ;; our fancy let bindings or just a normal call.
                         (if stmt
                           (cat "call-lambda" :stmt true)
                           (cat "call")))
                       (cat "wrap-value")))]

                  [(and stmt (builtin? (car head) :lambda))
                   ;; Visit the lambda body
                   (visit-nodes lookup (car node) 3 true)

                   ;; And visit the argument values
                   ;; Yay: My favourite bit of code, zipping over arguments
                   ;; No seriously: I need to write an abstraction layer at some point for this.
                   (let* [(lam (car node))
                          (args (nth lam 2))
                          (offset 1)]
                     (for i 1 (# args) 1
                       (with (arg (nth args i))
                         (if (.> arg :var :isVariadic)
                           (with (count (- (# node) (# args)))
                             (when (< count 0) (set! count 0))
                             (for j 1 count 1
                               (visit-node lookup (nth node (+ i j)) false))
                             (set! offset count))
                           (when-with (val (nth node (+ i offset)))
                             (visit-node lookup val true)))))
                     (for i (+ (# args) (+ offset 1)) (# node) 1
                       (visit-node lookup (nth node i) true))

                     (cat "call-lambda" :stmt true))]
                  [(or (builtin? (car head) :quote) (builtin? (car head) :syntax-quote))
                   (visit-nodes lookup node 1 false)
                   (cat "call-literal")]
                  [true
                    (visit-nodes lookup node 1 false)
                    (cat "call")])]

               ;; We're probably calling a constant here.
               [true
                (visit-nodes lookup node 1 false)
                (cat "call-literal")]))]))
    (.<! lookup node cat)
    cat))

(defun visit-nodes (lookup nodes start stmt)
  "Marks all NODES with a category."
  :hidden
  (for i start (# nodes) 1
    (visit-node lookup (nth nodes i) stmt)))

(defun visit-quote (lookup node level)
  "Marks all unquoted NODES with a category."
  (if (= level 0)
    (visit-node lookup node false)
    (when (list? node)
      (case (car node)
        [unquote (visit-quote lookup (nth node 2) (pred level))]
        [unquote-splice (visit-quote lookup (nth node 2) (pred level))]
        [syntax-quote (visit-quote lookup (nth node 2) (succ level))]
        [_ (for-each child node (visit-quote lookup child level))]))))

(defpass categorise-nodes (state nodes lookup)
  "Categorise a group of NODES, annotating their appropriate node type."
  :cat '("categorise")
  (visit-nodes lookup nodes 1 true))

(defpass categorise-node (state node lookup stmt)
  "Categorise a NODE, annotating it's appropriate node type."
  :cat '("categorise")
  (visit-node lookup node stmt))