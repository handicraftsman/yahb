(import [log [Log]])
(import ctypes)

(defn try-get [dict index]
  (setv x None)
  (try
    (setv x (get dict index))
    (except [e KeyError] (setv x None))
    (except [e IndexError] (setv x None)))
  x)

(defn try-2d-get [dict c1 c2]
  (setv o None)
  (setv x (try-get dict c1))
  (if (= x None)
    (setv o None)
  (do 
    (setv y (try-get x c2))
    (if (= x None)
      (setv o None)
      (setv o y))))
  o)

(defn dict-exists [dict index]
  (!= (dict.get index) None))

(defn -cfa-base-callback- [dict index]
  (raise (IndexError (+ "Dict: cannot find index `" index "` in dict `" dict "`"))))

(defn check-for-all! [dict indices &optional [cback -cfa-base-callback-] [dname "unnamed"]]
  (for [el indices] 
    (unless (dict-exists dict el) 
      ;(Log.write (+ "Err: `" (str el) "` item does not exist"))
      (cback (str dname) (str el))
      (exit 1))))