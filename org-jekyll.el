;;; org-jekyll.el --- Custom Emacs plugin to operate with my OrgMode+Jekyll blog

;; Copyright (c) 2024 Eugene Andrienko


;; Author: Eugene Andrienko <evg.andrienko@gmail.com>
;; Version 0.0.1
;; Keywords: files local wp
;; Homepage: https://github.com/eugeneandrienko
;; Package-Requires: ((emacs "29.4")
;;                    (htmlize "20240915.1657")
;;                    (org "9.6.15")
;;                    (prodigy "20240929.1820")
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
;;; To use this plugin:
;;;
;;; 1) Load it in Emacs configuration file like this:
;;;
;;;        (use-package org-jekyll
;;;          :load-path "~/rsync/blog/"
;;;          :ensure nil
;;;          :demand t
;;;          :requires (org prodigy htmlize)
;;;          :after org)
;;;
;;; 2) Place to the root directory of the blog (see
;;; `org-jekyll-base-path' variable) file `.dir-locals.el' with the
;;; next content:
;;;
;;;        (("articles/"
;;;          . ((org-mode . ((eval . (org-jekyll-mode)))))))


;;; Code:

(require 'htmlize)
(require 'ox-publish)
(require 'prodigy)
(require 'transient)


(defgroup org-jekyll ()
  "Custom group for org-jekyll plugin."
  :group 'local)

(defgroup org-jekyll-paths nil
  "Custom group for filesystem paths related to org-jekyll plugin."
  :group 'org-jekyll)

;; Customizable options:

(defcustom org-jekyll-url
  "https://eugene-andrienko.com"
  "Blog URL."
  :type 'string
  :group 'org-jekyll)

(defcustom org-jekyll-base-path
  "~/rsync/blog"
  "Path to the base directory of my blog."
  :type 'directory
  :group 'org-jekyll-paths)

(defcustom org-jekyll-articles-path
  (concat org-jekyll-base-path "/articles")
  "Path to directory with original articles in Org format."
  :type 'directory
  :group 'org-jekyll-paths)

(defcustom org-jekyll-template-path
  (concat org-jekyll-articles-path "/_post_template.org")
  "Path to post template."
  :type '(file :must-match t)
  :group 'org-jekyll-paths)

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

;; OrgMode publication settings:

(set (make-local-variable 'org-publish-project-alist)
     `(("org-jekyll-org"
        :base-directory ,(concat org-jekyll-base-path "/_articles")
        :base-extension "org"
        :publishing-directory ,(concat org-jekyll-base-path "/_posts")
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
        :base-directory ,(concat org-jekyll-base-path "/_static")
         :base-extension "jpg\\|JPG\\|jpeg\\|png\\|gif\\|webm\\|webp\\|gpx\\|tar.bz2"
         :publishing-directory ,(concat org-jekyll-base-path "/assets/static")
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
modified, not original articles from `org-jekyll-articles-path'
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
             (concat org-jekyll-articles-path
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
                    (directory-files-recursively org-jekyll-articles-path "\\.org$" nil nil nil))))

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
              (string-match (concat org-jekyll-articles-path "/[[:alnum:]-/]+/\\([[:alnum:][:blank:]-_.]+\\)$") filename)
              (let
                  ((static-filename (match-string 1 filename)))
                (copy-file filename (concat static-directory "/" static-filename) t t t t))))
          (seq-filter (lambda (path)
                        (not (string-match
                              (concat org-jekyll-exclude-regex "\\|\\(article-[[:lower:]]+\\.org\\)")
                              path)))
                      (directory-files-recursively org-jekyll-articles-path "." nil nil nil)))))

;; Function which creates new blog post:

(defun org-jekyll--create-new-post ()
  "Ask user about new post properties and create new blog post."
  (interactive)
  (let* ((category (completing-read "Enter category: "
                                    (seq-filter
                                     (lambda (category) (string-match "^[[:lower:]]+$" category))
                                     (directory-files org-jekyll-articles-path nil
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
         (path org-jekyll-articles-path)
         (template org-jekyll-template-path)
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

;; Prodigy services to operate with Jekyll:

(defvar-local org-jekyll--build-service-name
    "Blog Build"
  "Name of service to build blog.")

(defvar-local org-jekyll--serve-service-name
    "Blog Serve"
  "Name of service to serve blog.")

(defvar-local org-jekyll--clean-service-name
    "Blog Clean"
  "Name of service to clean blog directory.")

(prodigy-define-status
  :id 'done
  :face 'prodigy-green-face)

(prodigy-define-tag
  :name 'jekyll
  :env '(("LANG" "en_US.UTF-8")
         ("LC_ALL" "en_US.UTF-8")))

(prodigy-define-service :name org-jekyll--build-service-name
  :command "bundle"
  :args '("exec" "jekyll" "build")
  :cwd org-jekyll-base-path
  :tags '(jekyll)
  :truncate-output 200
  :init (lambda () (progn
                (org-publish-project "org-jekyll" t nil)))
  :on-output (lambda (&rest args)
               (let ((output (plist-get args :output))
                     (service (plist-get args :service)))
                 (when (s-matches? "Configuration file" output)
                   (prodigy-set-status service 'ready))
                 (when (s-matches? "done in " output)
                   (progn
                     (message "%s" (propertize "Blog built" 'face '(:foreground "blue")))
                     (prodigy-set-status service 'done)))
                 (when (s-matches? "error" output)
                   (progn
                     (message "$s" (propertize "Blog build: error" 'face '(:foreground "red")))
                     (prodigy-set-status service 'failed)))
                 (when (s-matches? "exception" output)
                   (progn
                     (message "$s" (propertize "Blog build: exception" 'face '(:foreground "red")))
                     (prodigy-set-status service 'failed))))))

(prodigy-define-service :name org-jekyll--serve-service-name
  :command "bundle"
  :args '("exec" "jekyll" "serve")
  :url "http://127.0.0.1:8000"
  :cwd org-jekyll-base-path
  :tags '(jekyll)
  :truncate-output 100
  :on-output (lambda (&rest args)
               (let ((output (plist-get args :output))
                     (service (plist-get args :service)))
                 (when (s-matches? "Server running..." output)
                   (progn
                     (message "%s" (propertize "Blog served" 'face '(:foreground "blue")))
                     (prodigy-set-status service 'ready)))
                 (when (s-matches? "...done" output)
                   (prodigy-set-status service 'ready))
                 (when (s-matches? "error" output)
                   (progn
                     (message "%s" (propertize "Blog serve: error" 'face '(:foreground "red")))
                     (prodigy-set-status service 'failed)))
                 (when (s-matches? "exception" output)
                   (progn
                     (message "%s" (propertize "Blog serve: exception" 'face '(:foreground "red")))
                     (prodigy-set-status service 'failed))))))

(prodigy-define-service :name org-jekyll--clean-service-name
  :command "bundle"
  :args '("exec" "jekyll" "clean")
  :cwd org-jekyll-base-path
  :tags '(jekyll)
  :truncate-output 100
  :kill-process-buffer-on-stop t)

;; Transient sufficies:

(defun org-jekyll--suffix-build ()
  "Build the blog."
  (interactive)
  (let ((service (prodigy-find-service org-jekyll--build-service-name)))
    (prodigy-start-service service)))

(defun org-jekyll--suffix-serve-toggle ()
  "Serve blog or stop serving the blog."
  (interactive)
  (let ((service (prodigy-find-service org-jekyll--serve-service-name)))
    (if (prodigy-service-started-p service)
        (prodigy-stop-service service nil
          (lambda () (message "%s" (propertize "Blog serve: stopped" 'face '(:foreground "blue")))))
      (prodigy-start-service service))))

(defun org-jekyll--suffix-open-build-log ()
  "Open build log."
  (interactive)
  (let ((service (prodigy-find-service org-jekyll--build-service-name)))
    (prodigy-switch-to-process-buffer service)))

(defun org-jekyll--suffix-open-serve-log ()
  "Open serve log."
  (interactive)
  (let ((service (prodigy-find-service org-jekyll--serve-service-name)))
    (prodigy-switch-to-process-buffer service)))

(defun org-jekyll--suffix-clear ()
  "Clear blog files."
  (interactive)
  (mapc (lambda (x)
          (mapc (lambda (file)
                  (delete-file file nil))
                (mapcan (lambda (directory)
                          (directory-files-recursively (concat org-jekyll-base-path directory) (cdr x) nil nil nil))
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
  (prodigy-start-service (prodigy-find-service org-jekyll--clean-service-name))
  (message "%s" (propertize "Blog cleaned" 'face '(:foreground "blue"))))

(defun org-jekyll--suffix-open-blog ()
  "Open locally served blog."
  (interactive)
  (let* ((service (prodigy-find-service org-jekyll--serve-service-name))
         (url (prodigy-service-url service)))
    (browse-url url)))

(defun org-jekyll--suffix-create-post ()
  "Create new blog post."
  (interactive)
  (org-jekyll--create-new-post))

;; Transient keys description:

(transient-define-prefix org-jekyll-layout-descriptions ()
  "Transient layout with blog commands."
  [:description (lambda () (concat org-jekyll-url " control panel" "\n"))
                ["Development"
                 ("b" "Build blog" org-jekyll--suffix-build)
                 ("s" org-jekyll--suffix-serve-toggle
                  :description (lambda () (if (prodigy-service-started-p
                                          (prodigy-find-service "Blog Serve"))
                                         "Stop serving local blog"
                                       "Serve local blog")))
                 ("o" "Open served blog" org-jekyll--suffix-open-blog)
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
  (if org-jekyll-mode
      (progn
        (keymap-local-set "C-c b" #'org-jekyll-menu))
    (mapc #'kill-local-variable '(org-jekyll-url
                                  org-jekyll-paths-base-path
                                  org-jekyll-paths-articles-path
                                  org-jekyll-paths-template-path
                                  org-jekyll-exclude-regex
                                  org-jekyll-languages))
    (keymap-local-unset "C-c b")))

;;;###autoload
(defun org-jekyll-mode-hook ()
  "Hook to enable this mode only for articles."
  (if (string-match "^/.+/article-[[:lower:]]\\{2\\}\\.org" (buffer-file-name))
      (org-jekyll-mode 1)))

(provide 'org-jekyll)

;;; org-jekyll.el ends here
