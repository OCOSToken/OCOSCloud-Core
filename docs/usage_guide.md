# 🚀 OCOS Cloud Usage Guide

This guide provides a comprehensive walkthrough on how to use OCOS Cloud as a developer, node operator, or DAO participant. OCOS Cloud offers decentralized compute, storage, and hosting services powered by the OCOS token and governed via on-chain DAO mechanisms.

---

## 👤 User Types

| Role             | Description                                                   |
|------------------|---------------------------------------------------------------|
| End User         | Uses services like AI API, NFT storage, or dApp hosting.     |
| Developer        | Builds and deploys apps using OCOS Cloud SDK and dashboard.  |
| Node Operator    | Provides compute/storage nodes and earns OCOS rewards.       |
| DAO Member       | Participates in governance using OCOS token for voting.      |

---

## 🛠 Developer Quickstart

### 1. Connect Wallet
Visit [https://cloud.ocos.io](https://cloud.ocos.io) and connect your wallet via MetaMask or WalletConnect.

### 2. Select Service
Choose from the available modules:
- **Compute Engine** (AI/ML tasks, simulation)
- **Storage Vault** (IPFS/NFT backup)
- **DApp Hosting** (IPFS + custom DNS)
- **AI API** (text-to-image, voice synthesis, etc.)

### 3. Upload Files or Models
You can deploy:
- Smart contract source files
- Frontend build folders (`dist/`, `build/`)
- AI models or datasets

Upload is done via the UI or CLI SDK:
```bash
npx ocos-cloud-cli upload ./build --target ipfs
```

### 4. Pay with OCOS Tokens
Resources are paid in OCOS tokens:
- Pay-as-you-go (per GB/hour)
- Monthly staking for flat-rate usage

```bash
npx ocos-cloud-cli stake --compute 100 --storage 50
```

### 5. Monitor Logs & Usage
All services generate:
- Realtime logs (compute time, resource usage)
- IPFS hashes and history
- Node health and job history

---

## ⚙️ Node Operator Guide

### 1. Register Your Node
Run registration from CLI:
```bash
npx ocos-cloud-cli register-node --type compute --gpu yes
```

### 2. Set Resource Limits
Define your available CPU/GPU/Storage:
```bash
npx ocos-cloud-cli configure --cpu 8 --gpu 1 --ram 32 --disk 100
```

### 3. Monitor Jobs
All node jobs are visible in your dashboard, including:
- Assigned tasks
- Execution time
- Earned OCOS tokens

### 4. Withdraw Earnings
Node rewards accumulate per job and can be withdrawn directly to your wallet.
```bash
npx ocos-cloud-cli withdraw
```

---

## 🗳 DAO Governance Guide

### 1. Delegate or Vote
Use OCOS tokens to vote on proposals:
```bash
npx ocos-cloud-cli vote --proposal 12 --option yes
```

### 2. Submit a Proposal
To propose changes or upgrades:
```bash
npx ocos-cloud-cli submit-proposal --title "Add zkCompute support" --description "Proposing integration of zkCompute module."
```

### 3. Track Governance Logs
Visit the DAO portal or use SDK:
```bash
npx ocos-cloud-cli list-proposals
```

---

## 📦 Available SDK Commands (CLI)

| Command                     | Description                                |
|-----------------------------|--------------------------------------------|
| `upload`                    | Upload app/models/files to storage         |
| `stake`                     | Stake OCOS for quota allocation            |
| `deploy`                    | Deploy dApps or containers                 |
| `monitor`                   | View live logs and usage metrics           |
| `vote`, `submit-proposal`  | DAO voting operations                      |
| `register-node`            | Setup a compute or storage node            |
| `withdraw`                 | Claim node rewards                         |

---

## 🔗 Resources

- [OCOS Cloud Dashboard](https://cloud.ocos.io)
- [Official OCOS Docs](https://ocos.io/cloud)
- [GitHub Source Code](https://github.com/OCOSToken/OCOSUK)
- [Telegram Support](https://t.me/OCOS_Official)

---

> "OCOS Cloud empowers developers, decentralizes hosting, and rewards contributors in a fully trustless infrastructure."

---
