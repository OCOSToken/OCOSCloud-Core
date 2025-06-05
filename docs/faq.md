# ❓ OCOS Cloud – Frequently Asked Questions (FAQ)

This document answers the most common questions about OCOS Cloud’s infrastructure, token utility, smart contracts, governance, and deployment.

---

## 🌐 What is OCOS Cloud?
**OCOS Cloud** is a decentralized Web3-native infrastructure offering compute, storage, hosting, and governance modules—all powered by the OCOS token and secured via DAO protocols.

---

## 🪙 What is the utility of the OCOS token?
OCOS token is used for:
- Staking for compute/storage access
- Paying for resource usage (billing)
- Voting in the DAO
- Claiming node rewards

---

## 🔐 Who controls OCOS Cloud?
Initially, core contracts are managed by a multisig admin. Control is gradually transitioned to the DAO via `CloudDAO.sol`, where token holders vote on upgrades and policies.

---

## 🚀 How can I deploy OCOS Cloud contracts?
Refer to [`deployment-guide.md`](./deployment-guide.md). Use Hardhat and follow the environment setup for deploying on BSC or other EVM-compatible networks.

---

## ⚙️ How do I contribute?
Contributions are welcome! See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for details on submitting PRs, writing tests, or improving documentation.

---

## 🧪 Are the contracts audited?
All core smart contracts are scheduled for audit by **CertiK**, **Code4rena**, and community review rounds. Final audit reports will be published under `/audits/`.

---

## 💡 What is a Compute Node?
A compute node is a registered participant providing compute power (CPU/GPU). It earns OCOS rewards and can be registered via `CloudNodeRegistry.sol`.

---

## 🔄 Can users withdraw rewards?
Yes. Node operators and stakers can claim their rewards via `NodeRewardVault.sol` and `ComputeStaking.sol` after fulfilling time and activity conditions.

---

## 🧠 What are zkComputeProofs?
They are cryptographic proofs submitted by users/operators to prove that off-chain compute tasks were completed without revealing sensitive data. Verified via `zkComputeProof.sol`.

---

## 📩 Who do I contact for support?
- Dev email: **dev@ocos.io**
- Security: **security@ocos.io**
- Telegram: [@ocos_official](https://t.me/ocos_official)
- Docs: [https://ocos.io/cloud](https://ocos.io/cloud)

---

> Still have questions? Submit them via GitHub Discussions or email us directly.

---
