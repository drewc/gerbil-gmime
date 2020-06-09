(import :drewc/gmime/foreign :std/foreign)
(export new-message parse-message-file message-subject)

(begin-gmime-ffi
 (new-message parse-message-file message-subject)
 (c-declare #<<END-C
static GMimeMessage *
parse_message_stream (GMimeStream *stream)
{
  GMimeMessage *message;
  GMimeParser *parser;

 /* create a new parser object to parse the stream */
  parser = g_mime_parser_new_with_stream (stream);

  /* parse the message from the stream */
  message = g_mime_parser_construct_message (parser, NULL);

  /* free the parser */
  g_object_unref (parser);
  return message;
}
static GMimeMessage *
parse_message_file (char *filename)
{
  GMimeStream *stream;
  GMimeMessage *message;

  stream = g_mime_stream_file_open (filename, "r", NULL);

  /* parse the message from the stream */
  message = parse_message_stream(stream);

  g_object_unref (stream);

  return message;
}
END-C
)
 (define-c-GObject GMimeMessage)
 (define new-message (c-lambda () GMimeMessage*  "___return(g_mime_message_new(FALSE));"))
 (define parse-message-file (c-lambda (char-string) GMimeMessage* "parse_message_file"))
 (define message-subject
   (c-lambda (GMimeMessage*)
       char-string "___return((char*)g_mime_message_get_subject(___arg1));")))
