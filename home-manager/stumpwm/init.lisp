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

;; Read some doc
(define-key *root-map* (kbd "d") "exec gv")
;; Browse somewhere
(define-key *root-map* (kbd "b") "colon1 exec firefox http://www.")
;; Ssh somewhere
(define-key *root-map* (kbd "C-s") "colon1 exec xterm -e ssh ")
;; Lock screen
(define-key *root-map* (kbd "C-l") "exec xlock")

;; Web jump (works for Google and Imdb)
(defmacro make-web-jump (name prefix)
  `(defcommand ,(intern name) (search) ((:rest ,(concatenate 'string name " search: ")))
    (substitute #\+ #\Space search)
    (run-shell-command (concatenate 'string ,prefix search))))

(make-web-jump "google" "firefox http://www.google.fr/search?q=")
(make-web-jump "imdb" "firefox http://www.imdb.com/find?q=")

;; C-t M-s is a terrble binding, but you get the idea.
(define-key *root-map* (kbd "M-s") "google")
(define-key *root-map* (kbd "i") "imdb")

;; Message window font
;;(set-font "-xos4-terminus-medium-r-normal--14-140-72-72-c-80-iso8859-15")

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

