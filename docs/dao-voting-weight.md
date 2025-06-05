# 🗳️ OCOS Cloud DAO Voting Weight Calculation

This document defines how voting power is calculated for participants in the OCOS Cloud DAO based on their token holdings, delegation status, and role within the network.

---

## 🎯 Principles

1. **1 OCOS = 1 Vote** (baseline)
2. **Voting weight is determined at snapshot block height**
3. **Staked tokens are included in vote weight**
4. **Delegated tokens transfer voting power, not ownership**

---

## 🧮 Weight Calculation Formula

```text
votingWeight = OCOS_wallet + OCOS_staked + OCOS_delegatedIn - OCOS_delegatedOut
```

Where:
- `OCOS_wallet`: tokens in wallet balance
- `OCOS_staked`: tokens locked in `ComputeStaking.sol`
- `OCOS_delegatedIn`: tokens delegated to this address
- `OCOS_delegatedOut`: tokens delegated by this address to others

---

## ⏳ Snapshot Mechanism

- Snapshot block is recorded at the moment of proposal creation
- All votes during the proposal period reference this block’s token balances
- Prevents flash-loan manipulation

---

## 🤝 Delegation System

- Token holders may delegate votes using `delegate(address)` function
- Delegation can be changed or revoked any time before proposal ends
- Delegation does not move funds — only assigns vote rights

---

## 📊 Minimum Requirements

| Metric                 | Value               |
|------------------------|---------------------|
| Min Proposal Threshold | 50,000 OCOS         |
| Min Voting Quorum      | 2% of circulating   |
| Min Participation Rate | 10% of proposal voters must act |

---

## 🔐 DAO Voting Smart Contract

- `CloudDAO.sol` handles proposal registry, voting power checks, and finalization
- Interfaces with token, staking, and delegation modules
- All logic is auditable and verifiable on-chain

---

## 📬 Resources
- Delegation Functions: [`delegate()`](../contracts/CloudDAO.sol)
- Snapshot Tooling: `snapshot.js` (WIP)
- Governance Dashboard: [Coming Q3 2025]

---

> Power in OCOS Cloud comes not from control — but from contribution.

---
