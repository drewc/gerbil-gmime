(import :drewc/gmime/foreign :std/foreign)
(export object->string)
(begin-gmime-ffi (object->string)
 (define object->string (c-lambda (GMimeObject*) char-string "___return(g_mime_object_to_string(___arg1, NULL));")))
