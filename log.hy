(import time)

(defclass Log []
  (defn write [&optional [msg "Moo"]]
    "Prepends timestamp to given string and prints it"
    (setv x (time.strftime "[%Y.%m.%d|%H:%M:%S] "))
    (setv y (str msg))
    (setv z (+ x y))
    (print z)))