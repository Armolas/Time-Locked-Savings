
;; offspring-will
;; This smart contract allows parents to lock some funds for their child for a certain period before the child can have access to the fund.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Cons, Vars and Maps ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; deployer address
(define-constant deployer tx-sender)

;; contract address
(define-constant contract-address (as-contract tx-sender))

;; A year in blocks
(define-constant year-in-block (* u365 u144))

;; account opening fee
(define-constant account-opening-charge u5000000)

;; Minimun account opening deposit
(define-constant minimum-initial-deposit u5000000)

;; withdrawal fee
(define-constant withdrawal-fee u2)

;; emergency withdrawal fee
(define-constant emergency-withrawal-fee u10)

;; Total fees earned
(define-data-var total-fees-earned uint u0)

;; child account map
(define-map child-account {parent: principal, child-name: (string-ascii 24)}
    {
        child-wallet: principal,
        child-name: (string-ascii 24),
        unlock-height: uint,
        balance: uint,
        admins: (list 5 principal)
    }
)


;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Read Functions ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Reads the total balance on the contract
(define-read-only (get-contract-balance)
    (stx-get-balance contract-address)
)

;; Reads information about a child's account
(define-read-only (get-account (parent principal) (name (string-ascii 24)))
    (map-get? child-account {parent: parent, child-name: name})
)

;; Read all the total fees accumulated by the contract
(define-read-only (get-total-fees-earned)
    (var-get total-fees-earned)
)


