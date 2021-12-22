
;; xyz-token
;; <add a description here>
(define-constant ERR-UNAUTHORIZED u1)
(define-constant ERR-ZERO-VALUE u11)
;; constants
;;
(define-fungible-token xyz-token)
(define-constant contract-owner tx-sender)

;; data maps and vars
;;
(define-data-var token-uri (optional (string-utf8 256)) none)
(define-data-var total-supply uint u0)

;; private functions
;;

(define-private (get-balance-of (owner principal))
    (ft-get-balance xyz-token owner)
)

;; public functions
;;

(define-read-only (get-name)
    (ok "Hirevibes"))

(define-read-only (get-symbol)
    (ok "VIBES"))

(define-read-only (get-decimals)
    (ok u0))

(define-read-only (get-total-supply)
    (ok (ft-get-supply xyz-token)))

(define-read-only (get-balance (owner principal))
    (ok (get-balance-of owner)))

(define-read-only (get-token-uri)
    (ok (var-get token-uri)))

(define-read-only (get-contract-owner)
    (ok contract-owner)
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
    (begin
        (asserts! ( > amount u0) (err ERR-ZERO-VALUE))
        (asserts! (is-eq sender tx-sender) (err ERR-UNAUTHORIZED))
        (asserts! (> (get-balance-of sender) u0) (err ERR-ZERO-VALUE))
        (try! (ft-transfer? xyz-token amount sender recipient))
        (print memo)
        (ok true)
    )
)


(define-private (mint (amount uint) (recipient principal))
    (begin 
        (asserts! ( > amount u0) (err ERR-ZERO-VALUE))
        (var-set total-supply (+ (var-get total-supply) amount))
        (ft-mint? xyz-token amount recipient)
    )
)

(mint u1000000 tx-sender)