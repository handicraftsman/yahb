(import [log [Log]])
(import [utils [try-get]])
(import [reactor [Reactor]])
(import socket threading)

(defclass Bot []
  (setv sock None)
  (setv running False)
  (setv conf {})

  (defn --init-- [self conf]
    (setv self.conf conf.data)
    (Log.write (+ "Hy bot!: " (try-get self.conf "name")))
    
    (setv self.sock (socket.socket socket.AF_INET socket.SOCK_STREAM))
    (self.connect)
    (let [x (threading.Thread :target (fn [] (self.-reader-)))] 
      (setv self.running True)
      (x.start)))

  (defn connect [self]
    (self.sock.connect (tuple [
      (try-get self.conf "host")
      (try-get self.conf "port")
    ]))
    (self.introduce))

  (defn introduce [self]
    (if (try-get self.conf "pass")
      (self.write (+ "PASS " (try-get self.conf "pass"))))
    (self.write (+ "USER " (try-get self.conf "user") " 0 * :" (try-get self.conf "rnam")))
    (self.write (+ "NICK " (try-get self.conf "nick"))))

  (defn -reader- [self]
    (while self.running
      (setv x (self.read))
      (if (= (x.strip) "")
        (continue))
      (Log.write (+ (try-get self.conf "name") ":< " x))
      (setv t (apply threading.Thread [] {:target (fn [] (apply Reactor [self x] {}))}))
      (t.start)))

  (defn read [self]
    (setv b 512)
    (setv on True)
    (setv c "")
    (while (and on (!= b 0))
      (setv x (self.sock.recv 1))
      (+= c (x.decode "UTF-8"))
      (-= b 1)
      (if (= "\r\n" (cut c -2))
        (do
          (if (= "" (cut c -2))
            (continue))
          (setv on False)
          (setv c (cut c 0 -2)))))
    c)

  (defn write [self msg]
    (Log.write (+ (try-get self.conf "name") ":> " msg))
    (self.sock.send (bytearray (+ (str msg) "\n") "UTF-8"))))