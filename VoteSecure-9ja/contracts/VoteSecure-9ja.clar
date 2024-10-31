
;; VoteSecure-9ja
;; Nigeria Decentralized Voting System (VoteSecure-9ja)

;; data variables
(define-data-var proposals (map uint {title: (string-ascii 50), yes-votes: uint, no-votes: uint}) {})
(define-data-var voters (map principal bool) {})
(define-data-var vote-status (map {voter: principal, proposal-id: uint} bool) {})

;; constants
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_VOTED (err u101))
(define-constant ERR_INVALID_PROPOSAL (err u102))

;; Register a voter by their unique principal address
(define-public (register-voter (voter principal))
  (begin
    (asserts! (is-eq tx-sender voter) ERR_UNAUTHORIZED)
    (map-insert voters voter true)
    (ok true)
  )
)

;; Remove a voter from the system
(define-public (remove-voter (voter principal))
  (begin
    (asserts! (is-eq tx-sender voter) ERR_UNAUTHORIZED)
    (map-delete voters voter)
    (ok true)
  )
)

;; Create a new proposal
(define-public (create-proposal (id uint) (title (string-ascii 50)))
  (begin
    (map-insert proposals id {title: title, yes-votes: u0, no-votes: u0})
    (ok id)
  )
)

;; Cast a vote on a proposal
(define-public (vote (proposal-id uint) (in-favor bool))
  (let (
        (is-registered-voter (map-get? voters tx-sender))
        (has-voted (map-get? vote-status {voter: tx-sender, proposal-id: proposal-id}))
        (proposal (map-get? proposals proposal-id))
      )
    (begin
      (asserts! is-registered-voter ERR_UNAUTHORIZED)
      (asserts! (is-none has-voted) ERR_ALREADY_VOTED)
      (asserts! (is-some proposal) ERR_INVALID_PROPOSAL)

      ;; Update votes based on vote type
      (if in-favor
        (map-set proposals proposal-id {title: (get title (unwrap! proposal ERR_INVALID_PROPOSAL)), yes-votes: (+ (get yes-votes (unwrap! proposal ERR_INVALID_PROPOSAL)) u1), no-votes: (get no-votes (unwrap! proposal ERR_INVALID_PROPOSAL))})
        (map-set proposals proposal-id {title: (get title (unwrap! proposal ERR_INVALID_PROPOSAL)), yes-votes: (get yes-votes (unwrap! proposal ERR_INVALID_PROPOSAL)), no-votes: (+ (get no-votes (unwrap! proposal ERR_INVALID_PROPOSAL)) u1)}))

      ;; Mark voter as having voted
      (map-insert vote-status {voter: tx-sender, proposal-id: proposal-id} true)

      (ok true)
    )
  )
)

;; Retrieve proposal details
(define-read-only (get-proposal (proposal-id uint))
  (map-get proposals proposal-id)
)

;; Check if a voter has voted on a proposal
(define-read-only (has-voted (voter principal) (proposal-id uint))
  (match (map-get vote-status {voter: voter, proposal-id: proposal-id})
    vote-status-flag vote-status-flag ;; If a value exists, return it (true)
    false ;; Default to false if no value is found
  )
)

;; Retrieve vote counts for a proposal
(define-read-only (count-votes (proposal-id uint))
  (let ((proposal (map-get? proposals proposal-id)))
    (if (is-some proposal)
      (ok {yes-votes: (get yes-votes (unwrap! proposal ERR_INVALID_PROPOSAL)), no-votes: (get no-votes (unwrap! proposal ERR_INVALID_PROPOSAL))})
      ERR_INVALID_PROPOSAL
    )
  )
)