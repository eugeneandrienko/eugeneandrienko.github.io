;;; org-jekyll.el --- Custom Emacs plugin to operate with my OrgMode+Jekyll blog

;; Copyright (c) 2024 Eugene Andrienko


;; Author: Eugene Andrienko <evg.andrienko@gmail.com>
;; Version 0.0.1
;; Keywords: files local wp
;; Homepage: https://github.com/eugeneandrienko
;; Package-Requires: ((emacs "29.4")
;;                    (htmlize "20240915.1657")
;;                    (org "9.6.15")
;;                    (transient "0.6.0"))

;; This file is not part of GNU Emacs.

;;; Commentary:

;;; There is a special plugin for Emacs, designed to convert articles
;;; stored as OrgMode files to HTML pages for Jekyll static blog.
;;;
;;; Articles written as Org Mode files. These files lies in ./articles
;;; catalog with the structure described below.
;;;
;;; Every subcatalog in ./articles is a separate category. For
;;; example, we have next categories in this repository: arms,
;;; cycling, it, leatherwork, photo.
;;;
;;; In every category-catalog there are set of catalogs — one catalog
;;; per article. These article-catalogs should have name in next
;;; format:
;;;
;;; YYYY-MM-DD-article-name: Catalog for published article. These
;;; articles can be previewed when serving local blog via this
;;; plugin. Its also can be published in the blog.
;;;
;;; draft-article-name: Catalog for draft article. These articles will
;;; not be published.
;;;
;;; hidden-article-name: Catalog for hidden article. There are
;;; finished articles but they will not be published for some reasons.
;;;
;;; Inside every catalog there should be set of images and other
;;; static files, related to article. And one or more article-LANG.org
;;; files with article itself. `LANG' is two-letter language code for
;;; language used in corresponding file with article. For example:
;;; `ru' or `en'.
;;;
;;; To use this plugin load it in Emacs configuration file like this:
;;;
;;;    (use-package org-jekyll
;;;      :load-path "~/rsync/blog/"
;;;      :ensure nil
;;;      :commands org-jekyll-init
;;;      :hook (org-mode . org-jekyll-init))


;;; Code:

(require 'htmlize)
(require 'ox-publish)
(require 'transient)


(defgroup org-jekyll ()
  "Emacs mode to write on OrgMode for Jekyll blog."
  :group 'local
  :prefix "org-jekyll-"
  :link '(url-link :tag "Source code" "https://github.com/eugeneandrienko/eugeneandrienko.github.io"))

(defgroup org-jekyll-paths nil
  "Paths for emacs mode to write on OrgMode for Jekyll blog."
  :group 'org-jekyll
  :prefix "org-jekyll-paths-")

;; Customizable options:

(defcustom org-jekyll-url
  "https://eugene-andrienko.com"
  "Blog URL."
  :type 'string
  :group 'org-jekyll)

(defcustom org-jekyll-exclude-regex
  "\\(_post_template\\.org\\)\\|\\(\\.project\\)"
  "Regex to exclude unwanted files."
  :type 'regexp
  :group 'org-jekyll)

(defcustom org-jekyll-languages
  '("ru" "en")
  "Blog languages."
  :type 'sexp
  :group 'org-jekyll)

(defcustom org-jekyll-paths-base-path
  "~/rsync/blog"
  "Path to the base directory of my blog."
  :type 'directory
  :group 'org-jekyll-paths)

(defcustom org-jekyll-paths-articles-path
  (concat org-jekyll-paths-base-path "/articles")
  "Path to directory with original articles in Org format."
  :type 'directory
  :group 'org-jekyll-paths)

(defcustom org-jekyll-paths-template-path
  (concat org-jekyll-paths-articles-path "/_post_template.org")
  "Path to post template."
  :type '(file :must-match t)
  :group 'org-jekyll-paths)

;; OrgMode publication settings:

(set (make-local-variable 'org-publish-project-alist)
     `(("org-jekyll-org"
        :base-directory ,(concat org-jekyll-paths-base-path "/_articles")
        :base-extension "org"
        :publishing-directory ,(concat org-jekyll-paths-base-path "/_posts")
        :preparation-function org-jekyll--prepare-articles
        :completion-function org-jekyll--complete-articles
        :publishing-function org-html-publish-to-html
        :html-extension "html"
        :headline-levels 5
        :html-toplevel-hlevel 2
        :html-html5-fancy t
        :html-table-attributes (:border "2" :cellspacing "0" :cellpadding "6" :frame "void")
        :section-numbers nil
        :html-inline-images t
        :htmlized-source t
        :with-toc nil
        :with-sub-superscript nil
        :body-only t
        :exclude ,org-jekyll-exclude-regex
        :recursive t)
       ("org-jekyll-static"
        :base-directory ,(concat org-jekyll-paths-base-path "/_static")
        :base-extension "jpg\\|JPG\\|jpeg\\|png\\|gif\\|webm\\|webp\\|gpx\\|tar.bz2"
        :publishing-directory ,(concat org-jekyll-paths-base-path "/assets/static")
        :publishing-function org-publish-attachment
        :preparation-function org-jekyll--prepare-static
        :exclude ,org-jekyll-exclude-regex
        :recursive t)
       ("org-jekyll" :components ("org-jekyll-org" "org-jekyll-static"))))

;; OrgMode publication functions:

(defun org-jekyll--prepare-article (article)
  "Prepare article's text for Jekyll.

Modify OrgMode file before publish it. ARTICLE is a path to
OrgMode file with article. Files, stored in `_articles/' will be
modified, not original articles from `org-jekyll-paths-articles-path'
path."
  (with-temp-buffer
    (insert-file-contents article)
    (goto-char (point-min))
    (while (search-forward "[file:" nil t)
      (replace-match "[file://assets/static/" t t))
    (write-file article)))

(defun org-jekyll--prepare-articles (property-list)
  "Copy articles to `_articles/' catalog before publishing. Rename
article file from `article-LANG.org' to
`YYYY-MM-DD-short-url.org'.

PROPERTY-LIST is a list of properties from
`org-publish-project-alist'."
  (mapc (lambda (article)
          (progn
            (string-match
             (concat org-jekyll-paths-articles-path
                     "/\\(\\w+\\)/\\([0-9-]+\\)-\\([[:alnum:]-]+\\)/article-\\([[:lower:]]\\{2\\}\\)\\.org$")
             article)
            (let*
                ((article-category (match-string 1 article))
                 (article-date (match-string 2 article))
                 (article-slug (match-string 3 article))
                 (article-lang (match-string 4 article))
                 (article-new-catalog (concat
                                       (plist-get property-list ':base-directory)
                                       "/"
                                       article-lang))
                 (article-processed (concat article-new-catalog "/" article-date "-" article-slug ".org")))
              (make-directory article-new-catalog t)
              (copy-file article article-processed t t t t)
              (org-jekyll--prepare-article article-processed))))
        (seq-filter (lambda (path)
                      (and
                       (not (string-match org-jekyll-exclude-regex path))
                       (not (string-match "\\(draft-\\)\\|\\(hidden-\\)" path))))
                    (directory-files-recursively org-jekyll-paths-articles-path "\\.org$" nil nil nil))))

(defun org-jekyll--complete-articles (property-list)
  "Change published html-files via regular expressions.

Fix links to attached files. Remove \"Footnotes:\" section from
generated file. Remove autogenerated Org ids from html tags.

PROPERTY-LIST is a list of properties from
`org-publish-project-alist'."
  (let*
      ((publishing-directory (plist-get property-list ':publishing-directory)))
    (mapc (lambda (html)
            (with-temp-buffer
              (insert-file-contents html)
              (mapc (lambda (x)
                      (progn
                        (goto-char (point-min))
                        (while (re-search-forward (car x) nil t)
                          (replace-match (cdr x) t nil))))
                    '(("file://" . "/")
                      ("<p><span class=\"figure-number\">[[:alnum:] :]+</span>\\(.+\\)</p>" . "<p style=\"text-align: center\"><i>\\1</i></p>")
                      ("<h2 class=\"footnotes\">Footnotes: </h2>" . "")
                      (" id=\"org[[:xdigit:]]\\{7\\}\"" . "")
                      (" id=\"outline-container-org[[:xdigit:]]\\{7\\}\"" . "")
                      (" id=\"text-org[[:xdigit:]]\\{7\\}\"" . "")))
              (write-file html)))
          (directory-files-recursively publishing-directory "\\.html$" nil nil nil))))

(defun org-jekyll--prepare-static (property-list)
  "Copy static files to `/_static' directory.

PROPERTY-LIST is a list of properties from
`org-publish-project-alist'."
  (let
      ((static-directory (plist-get property-list `:base-directory)))
    (make-directory static-directory t)
    (mapc (lambda (filename)
            (progn
              (string-match (concat org-jekyll-paths-articles-path "/[[:alnum:]-/]+/\\([[:alnum:][:blank:]-_.]+\\)$") filename)
              (let
                  ((static-filename (match-string 1 filename)))
                (copy-file filename (concat static-directory "/" static-filename) t t t t))))
          (seq-filter (lambda (path)
                        (not (string-match
                              (concat org-jekyll-exclude-regex "\\|\\(article-[[:lower:]]+\\.org\\)")
                              path)))
                      (directory-files-recursively org-jekyll-paths-articles-path "." nil nil nil)))))

;; Function which creates new blog post:

(defun org-jekyll--create-new-post ()
  "Ask user about new post properties and create new blog post."
  (interactive)
  (let* ((category (completing-read "Enter category: "
                                    (seq-filter
                                     (lambda (category) (string-match "^[[:lower:]]+$" category))
                                     (directory-files org-jekyll-paths-articles-path nil
                                                      directory-files-no-dot-files-regexp
                                                      nil nil))
                                    nil t))
         (name (read-string "Enter title: "))
         (summary (read-string "Enter summary: "))
         (tags (read-string "Enter tags (space separated): "))
         (permalink (read-string "Enter permalink: "))
         (date (format-time-string "%Y-%m-%d"))
         (language (completing-read "Enter post language: " org-jekyll-languages nil t))
         (use-banner (y-or-n-p "Use banner?"))
         (banner (if use-banner
                     (read-file-name "Path to banner image: " nil nil t nil nil)
                   nil))
         (path org-jekyll-paths-articles-path)
         (template org-jekyll-paths-template-path)
         (additional (concat (if use-banner
                                 (concat "banner:\n"
                                         "  image: /assets/static/" (file-name-nondirectory banner) "\n"
                                         "  opacity: 0.6\n")
                               "")
                             (concat "summary: " summary "\n")
                             (concat "tags: " tags)))
         (dirname (concat path "/" category "/" date "-" permalink))
         (filename (concat dirname "/" "article-" language ".org")))
    (make-directory dirname t)
    (if use-banner
        (copy-file banner (concat dirname "/" (file-name-nondirectory banner))))
    (with-temp-buffer
      (insert-file-contents template)
      (mapc
       (lambda (x) (progn
                (goto-char (point-min))
                (while (search-forward (car x) nil t)
                  (replace-match (cdr x) t t))))
       `(("{%NAME%}" . ,name)
         ("{%CATEGORY%}" . ,category)
         ("{%DATE%}" . ,date)
         ("{%LANG%}" . ,language)
         ("{%ADDITIONAL%}" . ,additional)))
      (write-file filename))
    (with-current-buffer (find-file filename)
      (goto-char (point-max)))))

;; Transient sufficies:

(defun org-jekyll--suffix-build ()
  "Build the blog."
  (interactive)
  (cd (expand-file-name org-jekyll-paths-base-path))
  (org-publish-project "org-jekyll" t nil)
  (make-process
   :name "jekyll-build"
   :buffer "jekyll-build"
   :command '("bundle" "exec" "jekyll" "build")
   :delete-exited-processes t
   :sentinel (lambda (process state)
               (cond
                ((and (eq (process-status process) 'exit)
                      (zerop (process-exit-status process)))
                 (message "%s" (propertize "Blog built" 'face '(:foreground "blue"))))
                ((eq (process-status process) 'run)
                 (accept-process-output process))
                (t (error (concat "Jekyll Build: " state)))))))

(defun org-jekyll--suffix-serve-toggle ()
  "Serve blog or stop serving the blog."
  (interactive)
  (if (eq (process-status "jekyll-serve") ' run)
      (interrupt-process "jekyll-serve")
    (cd (expand-file-name org-jekyll-paths-base-path))
    (make-process
     :name "jekyll-serve"
     :buffer "jekyll-serve"
     :command '("bundle" "exec" "jekyll" "serve")
     :delete-exited-processes t
     :sentinel (lambda (process state)
                 (cond
                  ((and (eq (process-status process) 'exit)
                        (zerop (process-exit-status process)))
                   (message "%s" (propertize "Blog serve: stopped" 'face '(:foreground "blue"))))
                  ((eq (process-status process) 'run)
                   (accept-process-output process))
                  (t (error (concat "Jekyll Serve: " state))))))))

(defun org-jekyll--suffix-open-build-log ()
  "Open build log."
  (interactive)
  (switch-to-buffer "jekyll-build" t))

(defun org-jekyll--suffix-open-serve-log ()
  "Open serve log."
  (interactive)
  (switch-to-buffer "jekyll-serve" t))

(defun org-jekyll--suffix-clear ()
  "Clear blog files."
  (interactive)
  (cd (expand-file-name org-jekyll-paths-base-path))
  (mapc (lambda (x)
          (mapc (lambda (file)
                  (delete-file file nil))
                (mapcan (lambda (directory)
                          (directory-files-recursively (concat org-jekyll-paths-base-path directory) (cdr x) nil nil nil))
                        (car x))))
        `((("/_posts/en" "/_posts/ru") . "\\.html$")
          (("/assets/static" "/_static") . ,(concat "\\.png\\|\\.jpg$\\|\\.jpeg$"
                                                    "\\|"
                                                    "\\.JPG$\\|\\.svg$\\|\\.webm$"
                                                    "\\|"
                                                    "\\.webp$\\|\\.html$\\|\\.tar.bz2$"
                                                    "\\|"
                                                    "\\.org$\\|\\.gif$\\|\\.gpx$"))
          (("/_articles") . "\\.org$")))
  (make-process
   :name "jekyll-clean"
   :buffer "jekyll-clean"
   :command '("bundle" "exec" "jekyll" "clean")
   :delete-exited-processes t
   :sentinel (lambda (process state)
               (cond
                ((and (eq (process-status process) 'exit)
                      (zerop (process-exit-status process)))
                 (message "%s" (propertize "Blog cleaned" 'face '(:foreground "blue"))))
                ((eq (process-status process) 'run)
                 (accept-process-output process))
                (t (error (concat "Jekyll Clean: " state)))))))

(defun org-jekyll--suffix-open-blog ()
  "Open locally served blog."
  (interactive)
  (browse-url "http://127.0.0.1:8000/"))

(defun org-jekyll--suffix-open-remote-blog ()
  "Open remote blog."
  (interactive)
  (browse-url org-jekyll-url))

(defun org-jekyll--suffix-create-post ()
  "Create new blog post."
  (interactive)
  (cd (expand-file-name org-jekyll-paths-base-path))
  (org-jekyll--create-new-post))

;; Transient keys description:

(transient-define-prefix org-jekyll-layout-descriptions ()
  "Transient layout with blog commands."
  [:description (lambda () (concat org-jekyll-url " control panel" "\n"))
                ["Development"
                 ("b" "Build blog" org-jekyll--suffix-build)
                 ("s" org-jekyll--suffix-serve-toggle
                  :description (lambda () (if (eq (process-status "jekyll-serve") 'run)
                                         "Stop serving local blog"
                                       "Serve local blog")))
                 ("o" "Open served blog" org-jekyll--suffix-open-blog)
                 ("O" "Open blog in Web" org-jekyll--suffix-open-remote-blog)
                 ("B" "Open build log" org-jekyll--suffix-open-build-log)
                 ("l" "Open serve log" org-jekyll--suffix-open-serve-log)
                 ("C" "Clear blog directory" org-jekyll--suffix-clear)]
                ["Actions"
                 ("n" "New blog post" org-jekyll--suffix-create-post)]])

;; Function to call main menu:

;;;###autoload
(defun org-jekyll-menu ()
  "Open blog control center."
  (interactive)
  (org-jekyll-layout-descriptions))

;; Minor mode:

;;;###autoload
(define-minor-mode org-jekyll-mode
  "Enable transient menu to operate with blog-related OrgMode files."
  :lighter " oj"
  :global nil
  :init-value nil
  :keymap (list (cons (kbd "C-c b") #'org-jekyll-menu)))

;;;###autoload
(defun org-jekyll-init ()
  (if (and buffer-file-name
           (string-match "^/.+/article-[[:lower:]]\\{2\\}\\.org" (buffer-file-name)))
      (org-jekyll-mode 1)))


(provide 'org-jekyll)

;;; org-jekyll.el ends here
