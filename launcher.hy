(import [log [Log]])
(import [botrc [confs]])
(import [bot [Bot]])
(import [utils [try-get]])
(import
  threading 
  time)

(defclass Launcher []
  (setv bots {})
  (setv threads {})

  "Bot Launcher"
  (defn --init-- [self]
    (Log.write "Hy launcher!")
    (setv self.conf confs)
    (for [conf confs]
      (if (try-get conf.data "enabled") (do 
        (setv thr 
          (threading.Thread 
            :target self.launch-bot
            :args  (tuple [conf])))
        (setv (. self threads [(try-get conf.data "name")]) thr)
        (thr.start))))
    (while True (time.sleep 60)))

  (defn launch-bot [self conf] 
    (setv n (try-get conf.data "name"))
    (setv (. self bots [n]) (Bot conf))))