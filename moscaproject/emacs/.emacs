(setq load-path (cons "~/emacs" load-path))


;; mouse focus of windows
(setq mouse-autoselect-window t)

;; font size: 100 = 10pt
(set-face-attribute 'default nil :height 100)

;; does this work?
(setq x-select-enable-clipboard t)

;;copy on mouse select
(setq mouse-drag-copy-region t)


(define-key esc-map "g" 'goto-line)
(define-key esc-map "r" 'query-replace)

(add-hook 'mh-show-mode-hook 'goto-address)
;;(setq goto-address-highlight-keymap
;;  (let ((m (make-sparse-keymap)))
;;    (define-key esc-map "m"  'goto-address-at-mouse)
;;    m))

;(pc-selection-mode)

;;
;; VRML Mode
;;

(autoload 'vrml-mode "vrml-mode" "VRML mode." t)
(add-hook 'vrml-mode-hook 'turn-on-font-lock)

;;
;; Python mode
;;

(autoload 'python-mode "python-mode" "Python editing mode." t)
(add-hook 'python-mode-hook 'turn-on-font-lock)

(setq auto-mode-alist   (append '(("\\.wrl\\'" . vrml-mode)
			 ("\\.py$" . python-mode) 
			 ) auto-mode-alist))


(global-font-lock-mode 1)

(show-paren-mode)
;;(require 'sclang)


(add-to-list 'load-path "/usr/bin/sclang")


(global-set-key (kbd "<C-return>") 'sclang-eval-region-or-line)

(global-set-key (kbd "C-.") 'sclang-main-stop)

;; (global-set-key (kbd "C-b") 'sclang-server-boot)
	


(require 'sclang)


;; freeze windows!

(defadvice pop-to-buffer (before cancel-other-window first)
  (ad-set-arg 1 nil))

(ad-activate 'pop-to-buffer)

;; Toggle window dedication
(defun toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not"
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p window 
                                 (not (window-dedicated-p window))))
       "Window '%s' is dedicated"
     "Window '%s' is normal")
   (current-buffer)))

;; Press [pause] key in each window you want to "freeze"
(global-set-key [pause] 'toggle-window-dedicated)


;; ;;;;;;;;;;;;;;;;;;;;;

(defun count-lines-region (start end)
  "Print number of lines and characters in the region."
  (interactive "r")
  (message "Region has %d lines, %d characters"
       (count-lines start end) (- end start)))

(defun call-for-help! (start end)
  (interactive "r")
  (message "HelpBrowser.openHelpFor(\"%s\")"
       (setq myStr (buffer-substring start end)) ))

(defun call-for-help! (start end)
  (interactive "r")
  (message "HelpBrowser.openHelpFor(\"%s\")"
       (setq myStr (buffer-substring start end)) ))

(add-hook 'sclang-mode-hook
	  '(lambda nil
             (define-key sclang-mode-map (kbd "<f12>")
               '(lambda () (interactive)(sclang-eval-expression "a.value")))))



;;(global-set-key (kbd "<f12>") 'call-for-help!)
;;(global-set-key (kbd "<f11>") ('sclang-eval-expression "a.play"))


(custom-set-variables
'(sclang-auto-scroll-post-buffer t)
'(sclang-eval-line-forward nil)
;;'(sclang-help-path (quote ("/Applications/SuperCollider/Help")))
;;'(sclang-runtime-directory "~/.sclang/")
)
