#!/usr/bin/env hy
; For IRC:
; (cut x -2)

(import os)
(if (os.path.isfile "./db")
  (os.remove "./db"))
(if-not (os.path.isdir "./db")
  (os.mkdir "./db"))

(import [log [Log]])
(Log.write "(◥▶ω◀◤)")
(Log.write "Hy there!")
(import [launcher [Launcher]])
(try
  (Launcher)
  (except [e KeyboardInterrupt]
    (print "\r" :end "")
    (Log.write "Exiting!")
    (for [bot Launcher.bots]
      (setv bot.running False))
    (exit)))