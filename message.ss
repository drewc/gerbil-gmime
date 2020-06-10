(import :drewc/gmime/foreign :drewc/gmime/internet-address :std/foreign)
(export new-message parse-message-file
        message-subject message-from message-to message-sender message-reply-to
        message-to message-cc message-bcc message-body message?)

(begin-gmime-ffi
    (g-mime-message-new GMIME_IS_MESSAGE
     parse-message-file message-subject
     message-from message-to message-sender message-reply-to message-to message-cc
     message-bcc message-body)
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
  (define GMIME_IS_MESSAGE (c-lambda (GObject*) bool "GMIME_IS_MESSAGE"))
  (define g-mime-message-new (c-lambda (bool) GMimeMessage* "g_mime_message_new"))
  (define parse-message-file (c-lambda (char-string) GMimeMessage* "parse_message_file"))
  (define message-subject
    (c-lambda (GMimeMessage*) char-string
      "___return((char*)g_mime_message_get_subject(___arg1));"))
  (define message-from (c-lambda (GMimeMessage*) InternetAddressList* "g_mime_message_get_from"))
  (define message-sender (c-lambda (GMimeMessage*) InternetAddressList* "g_mime_message_get_sender"))
  (define message-reply-to (c-lambda (GMimeMessage*) InternetAddressList* "g_mime_message_get_reply_to"))
  (define message-to (c-lambda (GMimeMessage*) InternetAddressList* "g_mime_message_get_to"))
  (define message-cc (c-lambda (GMimeMessage*) InternetAddressList* "g_mime_message_get_cc"))
  (define message-bcc (c-lambda (GMimeMessage*) InternetAddressList* "g_mime_message_get_bcc"))
  (define message-body (c-lambda (GMimeMessage*) GMimeObject* "g_mime_message_get_body")))

(def (message? thing) (and (##foreign? thing) (GMIME_IS_MESSAGE thing)))
(def (new-message (pretty-headers #f)) (g-mime-message-new pretty-headers))
