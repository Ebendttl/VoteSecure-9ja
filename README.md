Nigeria Decentralized Voting System
===================================

This smart contract, written in Clarity, enables a decentralized voting system tailored for use in Nigeria. It supports secure proposal creation, voter registration, vote tracking, and vote tallying, allowing a transparent and tamper-proof election or voting process on the Stacks blockchain.

Overview
--------

This solution is designed to improve the democratic voting experience by making elections verifiable, secure, and accessible to registered voters. Only registered voters can participate in voting, and each voter is allowed to cast a single vote per proposal.

Key Features
------------

-   **Transparent Proposal Management**: New proposals can be created and viewed by all participants.
-   **Controlled Voter Registration**: Only registered Nigerian voters can participate in the voting process.
-   **Secure Voting**: Each registered voter is permitted one vote per proposal, which is publicly counted.
-   **Tamper-Proof Counting**: Votes are publicly counted and verifiable, ensuring transparency.

Prerequisites
-------------

-   Stacks blockchain access and tools (e.g., Clarinet)
-   Clarity-compatible wallet for authorized calls

Contract Functions
------------------

### 1\. **Voter Registration**

-   **register-voter**: Registers a Nigerian voter by their principal address.

    -   **Parameters**: `voter (principal)` - The voter's principal address.
    -   **Returns**: `ok true` if registered successfully, or `ERR_UNAUTHORIZED` if unauthorized.
-   **remove-voter**: Deregisters a voter.

    -   **Parameters**: `voter (principal)` - The voter's principal address.
    -   **Returns**: `ok true` if successful, or `ERR_UNAUTHORIZED` if unauthorized.

### 2\. **Proposal Management**

-   **create-proposal**: Creates a proposal to be voted on.

    -   **Parameters**: `id (uint)`, `title (string-ascii 50)` - Proposal ID and title.
    -   **Returns**: `ok id` if successfully created.
-   **get-proposal** (Read-only): Retrieves proposal details by ID.

    -   **Parameters**: `proposal-id (uint)` - The ID of the proposal.
    -   **Returns**: Proposal details including title, yes-votes, and no-votes.

### 3\. **Voting**

-   **vote**: Allows registered voters to cast a Yes or No vote on a proposal.
    -   **Parameters**: `proposal-id (uint)`, `in-favor (bool)` - Proposal ID and vote choice.
    -   **Returns**: `ok true` if successful, `ERR_UNAUTHORIZED` if not registered, `ERR_ALREADY_VOTED` if already voted, or `ERR_INVALID_PROPOSAL` if the proposal does not exist.

### 4\. **Vote Counting**

-   **count-votes** (Read-only): Displays the count of Yes and No votes for a proposal.
    -   **Parameters**: `proposal-id (uint)` - Proposal ID.
    -   **Returns**: `{yes-votes: uint, no-votes: uint}` or `ERR_INVALID_PROPOSAL` if invalid.

Error Codes
-----------

-   **ERR_UNAUTHORIZED (u100)**: Returned if a non-registered user attempts an action.
-   **ERR_ALREADY_VOTED (u101)**: Returned if a voter attempts to vote more than once on a proposal.
-   **ERR_INVALID_PROPOSAL (u102)**: Returned if an invalid proposal ID is specified.

Deployment & Usage
------------------

1.  Deploy the contract on the Stacks blockchain using a Clarity-compatible environment.
2.  Register eligible Nigerian voters using `register-voter`.
3.  Create proposals with `create-proposal` for voting.
4.  Voters can use the `vote` function to cast votes.
5.  Use `count-votes` to tally and review the final vote counts.

Example Usage
-------------

1.  **Register a voter**:

    arduino

    Copy code

    `(register-voter 'ST1ABCDEFGHIJKLMN) `

2.  **Create a proposal**:

    lua

    Copy code

    `(create-proposal u1 "Fund Community Development Projects")`

3.  **Vote on a proposal**:

    arduino

    Copy code

    `(vote u1 true) ;; Voting "Yes"
    (vote u1 false) ;; Voting "No"`

4.  **Count votes for a proposal**:

    scss

    Copy code

    `(count-votes u1)`
