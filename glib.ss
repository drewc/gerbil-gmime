(import (for-syntax :std/foreign)  :std/foreign (for-syntax :std/stxutil))
(export begin-glib-ffi)
(defsyntax (begin-glib-ffi stx)
  (def (prelude-macros)
    '(
      (define-macro (define-c-GObject name)
        (let* ((str (symbol->string name))
               (ptr (string->symbol (string-append str "*"))))
        `(begin (c-define-type ,name ,str)
                (c-define-type ,ptr (pointer ,str (,ptr) "gobj_free")))))
      ))
  (syntax-case stx ()
    ((_ exports body ...)
     (with-syntax (((macros ...) (prelude-macros)))
       #'(begin-ffi
          exports
          macros ...
          (c-declare "void gobj_free(void *ptr);")
          (c-declare #<<END-C
#include <glib.h>
END-C
)
         body ...
         (c-declare #<<END-C
#ifndef ___HAVE_GOBJ_FREE
#define ___HAVE_GOBJ_FREE
___SCMOBJ gobj_free (void *ptr)
{
 g_object_unref (ptr);
 return ___FIX (___NO_ERR);
}
#endif
END-C
))))))
