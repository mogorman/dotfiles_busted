;; -*-lisp-*-
;;
;; Here is a sample .stumpwmrc file

(in-package :stumpwm)

;;"Define mode line background color."
(setf *mode-line-background-color* "#1EB5C4")

;;"Define mode line foreground color."
(setf *mode-line-foreground-color* "#3b456a")

;;"Define mode line border color."
(setf *mode-line-border-color* "#242A35")


(set-focus-color  "#20E0D6")
(set-unfocus-color "#3b456a")

(set-module-dir "~/.stumpwm.d/modules")

(toggle-mode-line (current-screen) (current-head))

(load-module "stumptray")
(stumptray:stumptray)

;; change the prefix key to something else
(set-prefix-key (kbd "C-t"))


(setf *mouse-focus-policy* :click) ;; :click, :ignore, :sloppy

(defun group-rename (group name)
  (setf (group-name group) name))


(defcommand fullscreen-with-modeline () ()
  "fake version of fullscreen that retains border and mode-line"
  (let ((group-file (format nil "/tmp/stumpwm-group-~a" (group-name (current-group)))))
    (if (null (cdr (head-frames (current-group) (current-head))))
        (restore-from-file group-file)
        (progn
          (dump-group-to-file group-file)
          (only)))))

(defcommand firefox () ()
  "Start firefox unless it is already running, in which case focus it."
  (run-or-raise "firefox" '(:instance "firefox")))

(defcommand chrome () ()
  "Start google-chome-stable unless it is already running, in which case focus it."
  (run-or-raise "google-chome-stable" '(:instance "google-chrome-stable")))

(defgeneric modeline-window-list (group))

(defmethod modeline-window-list (group)
  (stumpwm::group-windows group))

(defmethod modeline-window-list ((group stumpwm::tile-group))
  (stumpwm::frame-windows group (stumpwm::tile-group-current-frame group)))

(defun fmt-modeline-window-list (ml)
  "Using *window-format*, return a 1 line list of the windows for the current group, space separated."
  (format nil "~{~a~^ ~}"
          (mapcar (lambda (w)
                    (let ((str (stumpwm::format-expand *window-formatters* *window-format* w)))
                      (if (eq w (stumpwm::current-window))
                          (stumpwm::fmt-highlight str)
                          str)))
                  (stumpwm::sort1 (modeline-window-list (stumpwm::mode-line-current-group ml))
                         #'< :key #'stumpwm::window-number))))

(push '(#\m fmt-modeline-window-list) *screen-mode-line-formatters*)

(setf *screen-mode-line-format*
      (list
       ;;       "䷹ "
;;       " 兌 "
       "[^B%n^b] "
;;       '(:eval (run-shell-command "date '+%-I:%M %b %-d'|tr -d [:cntrl:]" t))
        '(:eval (run-shell-command "date '+%-I:%M'|tr -d [:cntrl:]" t))
       "|"
       ;;    "%B"
    ;;   '(:eval (run-shell-command "/home/mog/.bin/battery.sh|tr -d [:cntrl:]" t))
       "|"
;       '(:eval (run-shell-command "ping -c 1 -W 1 8.8.8.8 2>/dev/null >/dev/null && printf '' || printf '^1^R^BDown^b^r^n|'" t))
     ;; '(:eval (run-shell-command "acpi|cut -f2 -d','|tr -d ' '|tr -d [:cntrl:]" t))
       ;; "^B^[^3*"
       ;; '(:eval (run-shell-command "/sbin/iwconfig wlan0 | grep ESSID| cut -f2 -d'\"' |tr -d [:cntrl:]" t))
       ;; ":"
       ;; '(:eval (run-shell-command "/sbin/ifconfig wlan0|grep \"inet addr\"| cut -f2 -d':'|cut -f1 -d' '| cut -f4 -d'.'|tr -d [:cntrl:]" t))
       ;; "^]^b"
       ;; "|^B^[^3*"
       ;; '(:eval (run-shell-command "upower -i /org/freedesktop/UPower/devices/battery_BAT1|grep \"time to \"|awk '{ print $4  substr($5, 0, 1)}' | tr -d [:cntrl:]" t))
       ;; "^]^b"
;;       "%b"
       ;; "|"
       ;; '(:eval (run-shell-command "/home/mog/.bin/pa-vol.sh get_num|tr -d [:cntrl:]" t))
       " %W"
))

;;(setf *mode-line-pad-y* 3)

(setf *window-format* "%n:%0s%t")
(setf *mode-line-position* :top)
(setf *mode-line-border-width* 1)
(setf *mode-line-pad-x* 2)
(setf *mode-line-pad-y* 1)



(set-font "-*-terminus-*-r-*-*-12-*-*-*-*-*-*-*")


(group-rename (current-group) "1")
;; prompt the user for an interactive command. The first arg is an
;; optional initial contents.
(defcommand colon1 (&optional (initial "")) (:rest)
  (let ((cmd (read-one-line (current-screen) ": " :initial-input initial)))
    (when cmd
      (eval-command cmd t))))

(define-key *root-map* (kbd "l") "exec /usr/bin/env xscreensaver-command -lock")
(define-key *root-map* (kbd "f") "fullscreen-with-modeline")

(define-key *root-map* (kbd "RET") "exec /usr/bin/env roxterm")
(define-key *root-map* (kbd "C-RET") "exec /usr/bin/env roxterm")

(define-key *root-map* (kbd "c") "chrome")
(define-key *root-map* (kbd "C-c") "chrome")


;;; Define window placement policy...

;; Clear rules
(clear-window-placement-rules)

;; Last rule to match takes precedence!
;; TIP: if the argument to :title or :role begins with an ellipsis, a substring
;; match is performed.
;; TIP: if the :create flag is set then a missing group will be created and
;; restored from *data-dir*/create file.
;; TIP: if the :restore flag is set then group dump is restored even for an
;; existing group using *data-dir*/restore file.
(define-frame-preference "Default"
  ;; frame raise lock (lock AND raise == jumpto)
  (0 t nil :class "Konqueror" :role "...konqueror-mainwindow")
  (1 t nil :class "XTerm"))

(define-frame-preference "Ardour"
  (0 t   t   :instance "ardour_editor" :type :normal)
  (0 t   t   :title "Ardour - Session Control")
  (0 nil nil :class "XTerm")
  (1 t   nil :type :normal)
  (1 t   t   :instance "ardour_mixer")
  (2 t   t   :instance "jvmetro")
  (1 t   t   :instance "qjackctl")
  (3 t   t   :instance "qjackctl" :role "qjackctlMainForm"))

(define-frame-preference "Shareland"
  (0 t   nil :class "XTerm")
  (1 nil t   :class "aMule"))

(define-frame-preference "Emacs"
  (1 t t :restore "emacs-editing-dump" :title "...xdvi")
  (0 t t :create "emacs-dump" :class "Emacs"))

(define-key *root-map* (kbd "~") "exec")
(define-key *root-map* (kbd "C-r") "exec")
(define-key *root-map* (kbd "!") "gmove 1")
(define-key *root-map* (kbd "@") "gmove F")
(define-key *root-map* (kbd "#") "gmove 3")
(define-key *root-map* (kbd "$") "gmove 4")
(define-key *root-map* (kbd "%") "gmove 5")
(define-key *root-map* (kbd "^") "gmove 6")
(define-key *root-map* (kbd "&") "gmove 7")
(define-key *root-map* (kbd "*") "gmove 8")
(define-key *root-map* (kbd "(") "gmove 9")


(define-key *root-map* (kbd "1") "gselect 1")
(define-key *root-map* (kbd "2") "gselect F")
(define-key *root-map* (kbd "3") "gselect 3")
(define-key *root-map* (kbd "4") "gselect 4")
(define-key *root-map* (kbd "5") "gselect 5")
(define-key *root-map* (kbd "6") "gselcet 6")
(define-key *root-map* (kbd "7") "gselect 7")
(define-key *root-map* (kbd "8") "gselect 8")
(define-key *root-map* (kbd "9") "gselect 9")

(undefine-key *root-map* (kbd "F1"))
(undefine-key *root-map* (kbd "F2"))
(undefine-key *root-map* (kbd "F3"))
(undefine-key *root-map* (kbd "F4"))
(undefine-key *root-map* (kbd "F5"))
(undefine-key *root-map* (kbd "F6"))
(undefine-key *root-map* (kbd "F7"))
(undefine-key *root-map* (kbd "F8"))
(undefine-key *root-map* (kbd "F9"))
(undefine-key *root-map* (kbd "F10"))
(undefine-key *root-map* (kbd "F11"))
(undefine-key *root-map* (kbd "F12"))

(gnewbg-float "F")
(gnewbg "3")
(gnewbg "4")
(gnewbg "5")
(gnewbg "6")
(gnewbg "7")
(gnewbg "8")
(gnewbg "9")
