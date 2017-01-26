(import re)
(import [utils [try-get]])

(defclass Reactor []
  "Reactor for messages. Uses regexes"

  (setv bot None)
  (setv msg None)
  (setv ran False)

  (defn --init-- [self bot msg]
    (setv self.bot bot)
    (setv self.msg msg)
    (self.react))

  (defn react [self]
    ; Ping
    (self.case "PING (.+)" (fn [match]
      (self.bot.write (+ "PONG " (try-get match 1)))))

    ; Code-Cases
    (self.case-code "001" (fn [match]
      (print 1)
      (if (!= None (try-get self.bot.data "autojoin"))
        (for [chan (try-get self.bot.data "autojoin")]
          (self.bot.write ("JOIN " + chan)))))))

  (defn case [self pattern callable]
    (if-not self.ran (do
      (setv p (re.compile pattern))
      (setv m (p.match self.msg))
      (if (!= m None)
        (callable m))
      (setv self.ran True)
      m)))

  (defn case-code [self code callable]
    (setv  pattern (+ ":(.+?) " (str code) " " (try-get self.bot.conf "nick") " (.+)"))
    (print (self.case pattern callable))))