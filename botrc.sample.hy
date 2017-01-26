;; |----------------------|
;; | Internal Definitions |
;; |----------------------|
(import [log [Log]])
(import [utils [check-for-all! try-get]])

(setv confs [])

(defclass Conf []
  "Config Class"
  (setv data {})

  (defn --init-- [self &kwargs kwargs]
    "Init Function"
    (setv self.data kwargs)
    (check-for-all! self.data ["name"] :dname "base-config")
    (if (= "global" (try-get self.data "name")) (do
      (check-for-all! self.data ["cmdchar"] :dname "global-config"))
    (do 
      (check-for-all! self.data ["host" "nick"] :dname (+ (try-get self.data "name") "-server-config"))
      (for [el [
        ["enabled" True]
        ["port" 6667]
        ["user" (get self.data "nick")]
        ["rnam" "Yet Another Hy Bot"]
      ]] (self.data.setdefault (get el 0) (get el 1)))
    ))
    (global confs)
    (setv confs (+ confs [self]))
    (Log.write (+ "Hy conf!: " (str self.data)))))

(defclass ConfError [BaseException]
  "Config-Error")

;; |-------------|
;; | User Config |
;; |-------------|

(apply Conf [] {
  :name "global"

  :cmdchar ";"
})


(apply Conf [] {
  :enabled True

  :name `localhost

  :host `127.0.0.1
  :port `6667

  :user `yahb
  :nick `yahb
  :rnam "Bot in Hy"

  :autojoin ["#yahb"]
})

;; |--------|
;; | Checks |
;; |--------|
(do 
  (setv x False)
  (for [c confs]
    (if (= "global" (try-get c.data "name"))
      (setv x True)))
  (if (= False x)
(raise (ConfError "No global section!"))))