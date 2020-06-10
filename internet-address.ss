(import :drewc/gmime/foreign :std/foreign)
(export internet-address-list-get-address
        internet-address-list-length
        internet-address-list->list
        internet-address-list->string)

(begin-gmime-ffi
 (InternetAddress
  InternetAddress*
  InternetAddressList InternetAddressList*
  internet-address-list-length
  internet-address-list-get-address
  internet-address-list->string)

 (define-c-GObject InternetAddress)
 (define-c-GObject InternetAddressList)

 (define internet-address-list-length
   (c-lambda (InternetAddressList*) int "internet_address_list_length"))
 (define internet-address-list-get-address
   (c-lambda (InternetAddressList* int) InternetAddress* "internet_address_list_get_address"))

 ;; char *
 ;; internet_address_list_to_string (InternetAddressList *list,
 ;;                                  GMimeFormatOptions *options,
 ;;                                  gboolean encode);

 (define internet-address-list->string
   (c-lambda (InternetAddressList*) char-string
     "___return(internet_address_list_to_string (___arg1, NULL, TRUE));")))

(def (internet-address-list->list IAL)
  (let IAL->list ((n (1- (internet-address-list-length IAL))))
    (if (< n 0) '()
        (cons (internet-address-list-get-address IAL n)
              (IAL->list (- n 1))))))
