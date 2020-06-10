(import (for-syntax :drewc/gmime/glib) :std/foreign :drewc/gmime/glib)
(export begin-gmime-ffi g-mime-init)

(defsyntax (begin-gmime-ffi stx)
  (syntax-case stx ()
    ((_ exports body ...)
     #'(begin-glib-ffi exports
        (c-declare #<<END-C
#include <gmime/gmime.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

END-C
)
        (define-c-GObject GMimeObject #f)
        (define-c-GObject GMimePartIter)
        (define-c-GObject GMimeMessage)
        (define-c-GObject InternetAddressList)

        body ...))))

(begin-gmime-ffi
 (g-mime-init)
 (c-initialize "g_mime_init();")
 (define gmime-major-version (c-lambda () int "___return(gmime_major_version);"))
 (define g-mime-init (c-lambda () void "g_mime_init")))
