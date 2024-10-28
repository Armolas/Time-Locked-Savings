# Time-Locked Savings Smart Contract

This contract allows parents to create locked fund accounts for their children on the Stacks blockchain using the Clarity language. Parents can specify a time period during which the funds will remain locked, preventing access by the child until the account reaches its maturity date. The contract also supports emergency withdrawals and account management.

## Table of Contents

- [Overview](#overview)
- [Constants and Variables](#constants-and-variables)
- [Data Structures](#data-structures)
- [Functions](#functions)
    - [Read Functions](#read-functions)
    - [Write Functions](#write-functions)
    - [Admin Functions](#admin-functions)
    - [Private Functions](#private-functions)
- [Error Handling](#error-handling)
- [License](#license)

## Overview

The Offspring-Will smart contract allows parents to deposit funds for their child under certain conditions, with funds unlocking after a specified time (in years). Key features include:

- Account creation with a minimum deposit.
- Periodic funding of accounts.
- Withdrawal by the child after maturity.
- Emergency withdrawals by parent or admin.
- Admin management for each account.

## Constants and Variables

- **deployer**: The contract deployer's address.
- **contract-address**: The contract's address.
- **year-in-block**: Number of blocks equivalent to a year.
- **account-opening-charge**: The fee for creating an account.
- **minimum-initial-deposit**: The minimum deposit required to create an account.
- **withdrawal-fee**: Fee percentage applied when a child withdraws after maturity.
- **emergency-withdrawal-fee**: Fee for emergency withdrawals.
- **total-fees-earned**: Tracks total fees collected by the contract.

## Data Structures

- **child-account**: Map storing information about each child account, structured as follows:
    - **parent**: Address of the parent who created the account.
    - **child-name**: Name of the child.
    - **child-wallet**: Child's wallet address.
    - **unlock-height**: Block height when funds are accessible.
    - **balance**: Current balance of the account.
    - **admins**: List of admins for the account.

## Functions

### Read Functions

#### `get-contract-balance`

Reads the total STX balance held in the contract.

```clarity
(define-read-only (get-contract-balance) (stx-get-balance contract-address))
```

#### `get-account`

Fetches details of a child account using the parent's address and child’s name.

```clarity
(define-read-only (get-account (parent principal) (name (string-ascii 24))))
```

#### `get-total-fees-earned`

Returns the total accumulated fees from account operations.

```clarity
(define-read-only (get-total-fees-earned) (var-get total-fees-earned))
```

### Write Functions

#### `create-account`

Creates a new child account with specified deposit and lock period.

- **Parameters**: `child-name`, `child-wallet`, `lock-period-in-years`, `amount`
- **Returns**: Success status or error if creation fails.

```clarity
(define-public (create-account (child-name (string-ascii 24)) (child-wallet principal) (lock-period-in-years uint) (amount uint)))
```

#### `fund-child-account`

Allows parents to add additional funds to an existing child account.

- **Parameters**: `parent`, `child-name`, `amount`

```clarity
(define-public (fund-child-account (parent principal) (child-name (string-ascii 24)) (amount uint)))
```

#### `child-withdraw`

Permits the child to withdraw funds after the account reaches maturity.

- **Parameters**: `parent`, `child-name`
- **Returns**: Funds are transferred if the conditions are met, else an error.

```clarity
(define-public (child-withdraw (parent principal) (child-name (string-ascii 24))))
```

#### `emergency-withdraw`

Allows parents or assigned admins to withdraw funds in case of an emergency.

- **Parameters**: `parent`, `child-name`

```clarity
(define-public (emergency-withdraw (parent principal) (child-name (string-ascii 24))))
```

#### `withdraw-earnings`

Allows the deployer to withdraw the contract's accumulated earnings from fees.

- **Returns**: Success or failure status.

```clarity
(define-public (withdraw-earnings))
```

### Admin Functions

#### `add-child-admin`

Enables a parent to add an admin to the child account.

- **Parameters**: `parent`, `child-name`, `admin`

```clarity
(define-public (add-child-admin (parent principal) (child-name (string-ascii 24)) (admin principal)))
```

#### `remove-child-admin`

Enables a parent to remove an existing admin from the child account.

- **Parameters**: `parent`, `child-name`, `admin`

```clarity
(define-public (remove-child-admin (parent principal) (child-name (string-ascii 24)) (admin principal)))
```

### Private Functions

#### `remove-admin`

Helper function for `remove-child-admin`, to filter and remove the specified admin.

- **Parameters**: `list-admin`, `admin-tracker`

```clarity
(define-private (remove-admin (list-admin principal) (admin-tracker {compare-to: principal, new-admin-list: (list 5 principal)}))
```

## Error Handling

Each function has built-in error handling:

- **Insufficient balance**: Raised if the parent does not have enough STX to cover charges.
- **Unauthorized access**: Prevents unauthorized users from accessing restricted functions.
- **Account maturity check**: Ensures withdrawals are only permitted after the account’s unlock period.

## License

This project is licensed under the MIT License.