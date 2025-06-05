# 🛡 OCOS Cloud Access Control Policy

This document outlines the access control model used within OCOS Cloud smart contracts and infrastructure to ensure secure, modular, and role-based permissioning across the decentralized cloud ecosystem.

---

## 👤 Roles & Permissions

| Role         | Description                                        | Permissions                                                                 |
|--------------|----------------------------------------------------|-----------------------------------------------------------------------------|
| `Admin`      | Initial contract deployer or DAO multisig          | Contract upgrades, configuration, token withdrawal                         |
| `Operator`   | Registered node host (compute/storage)             | Register/update node, claim rewards, execute jobs                          |
| `User`       | Any OCOS token holder                              | Stake, use compute/storage, vote in DAO, store files                       |
| `DAO`        | Governance body (CloudDAO contract)                | Vote on upgrades, funding decisions, access revocation                     |

---

## 🧱 Access Design Patterns

### 1. **Ownable Admin Logic**
Most core contracts use `admin` or `owner` modifiers to restrict sensitive operations:
```solidity
modifier onlyAdmin() {
    require(msg.sender == admin, "Not authorized");
    _;
}
```

### 2. **Decentralized Governance Escalation**
DAO can override or reassign roles using `CloudDAO` decisions. Admin ownership can be passed via smart contract proposal.

### 3. **Node Isolation**
Each compute/storage node operates independently, and access to logs/jobs is scoped per node ID.

### 4. **User Staking Access**
Access to compute sessions or file storage is granted only after staking OCOS tokens (recorded in `ComputeStaking.sol`).

### 5. **Proof Submission Scope**
Only submitter can post or modify their ZK proof before it’s verified. Once verified, it becomes immutable.

---

## 🔄 Ownership Transfer Flow

1. Admin calls `transferAdmin(newAdmin)` on relevant contracts
2. DAO vote can approve ownership transfer proposal
3. New admin address becomes the role bearer

---

## 🔐 Security Notes

- Admin roles should use multisig or Gnosis Safe
- DAO votes should require quorum and expiration
- Node operators must not have access to billing logic
- zkProofs cannot be edited post-verification

---

## 🧠 References

- [`CloudDAO.sol`](../contracts/CloudDAO.sol)
- [`ComputeStaking.sol`](../contracts/ComputeStaking.sol)
- [`NodeRewardVault.sol`](../contracts/NodeRewardVault.sol)
- [`zkComputeProof.sol`](../contracts/zkComputeProof.sol)

---

> OCOS Cloud enforces least-privilege access and community-driven governance across all protocol layers.

---
