# 🌐 OCOS Cloud API Reference

This document provides a reference for interacting with the OCOS Cloud smart contract infrastructure via RESTful endpoints and SDK wrappers. These APIs abstract on-chain functions into user-friendly Web3 gateway interfaces.

---

## 📎 Base URL
```
https://api.ocos.io/v1
```

Authentication: via WalletConnect or JWT (for off-chain authorized endpoints)

---

## ⚙️ Endpoints Overview

| Method | Endpoint                          | Description                                  |
|--------|-----------------------------------|----------------------------------------------|
| POST   | `/compute/start`                  | Starts a compute session                     |
| POST   | `/compute/end`                    | Ends compute session and returns cost        |
| GET    | `/compute/logs/:address`          | Returns all usage logs for a user            |
| POST   | `/staking/stake`                  | Stakes OCOS tokens for compute quota         |
| POST   | `/staking/unstake`                | Unstakes after lock period                   |
| POST   | `/vault/store`                    | Upload metadata of file + CID                |
| GET    | `/vault/files/:address`           | Returns stored files                         |
| POST   | `/dao/proposal`                   | Create new DAO proposal                      |
| POST   | `/dao/vote`                       | Vote on a proposal                           |
| GET    | `/dao/proposals`                  | List all active proposals                    |
| GET    | `/proof/:taskId`                  | Fetch zk-proof submission data               |
| POST   | `/proof/submit`                   | Submit new zk-proof                          |

---

## 🧠 Example Usage

### Start Compute Session
```bash
POST /compute/start
Content-Type: application/json
Authorization: Bearer <jwt>

{
  "user": "0xabc...",
  "nodeId": 12
}
```
Returns:
```json
{
  "logId": 1053,
  "startTime": 1717600000
}
```

### Submit zk-Proof
```bash
POST /proof/submit
Content-Type: application/json

{
  "taskId": 100,
  "proofHash": "ipfs://Qm...",
  "publicSignals": "[123,456,789]"
}
```

---

## 🧰 SDK Wrappers

OCOS provides a JS SDK:
```bash
npm install @ocos-cloud/sdk
```

Basic usage:
```javascript
import { startCompute, storeFile, voteProposal } from '@ocos-cloud/sdk';

await startCompute({ user: wallet.address, nodeId: 42 });
await storeFile({ cid: "Qm...", size: 12, encrypted: true });
await voteProposal({ proposalId: 4, support: true });
```

---

## 🧪 Rate Limiting & Access

| Access Type    | Auth Required | Rate Limit       |
|----------------|----------------|------------------|
| Public Read    | ❌             | 100 req/min      |
| Write/Stake    | ✅ (JWT or Wallet) | 10 req/min   |
| Admin Actions  | ✅ (Multisig/Role) | 5 req/min    |

---

## 🛡 Notes

- All write endpoints require transaction confirmation via Web3
- zk-Proofs are stored off-chain, references anchored on-chain
- Errors returned as HTTP 400+ with message field

---

## 📬 Support
- Email: support@ocos.io
- Telegram: [@ocos_official](https://t.me/ocos_official)
- Docs: [https://ocos.io/cloud](https://ocos.io/cloud)

---
