# 🌐 OCOS Cloud Frontend Interface

This README provides setup and deployment instructions for the OCOS Cloud Web UI — a decentralized dashboard for interacting with compute nodes, DAO proposals, storage vaults, and staking systems.

---

## 🧩 Features

- 🔌 Web3 Wallet login (MetaMask, WalletConnect)
- 📊 Compute session launcher with live logs
- 🗳 DAO proposal submission and voting interface
- 📁 IPFS-based file upload and vault manager
- 💰 OCOS token staking dashboard
- 🧠 zkCompute proof visualizer
- 🌑 Light/Dark theme toggle

---

## 📦 Tech Stack

- **Framework**: Next.js (React 18)
- **Wallet Provider**: wagmi + ethers.js
- **Design**: TailwindCSS + shadcn/ui
- **State Mgmt**: Zustand + Wagmi hooks
- **IPFS**: web3.storage
- **Charting**: Recharts

---

## 🚀 Getting Started

### 1. Clone the repo
```bash
git clone https://github.com/OCOSToken/OCOSCloud-Frontend.git
cd OCOSCloud-Frontend
```

### 2. Install dependencies
```bash
npm install
```

### 3. Configure environment
Create a `.env.local` file:
```env
NEXT_PUBLIC_API_BASE=https://api.ocos.io/v1
NEXT_PUBLIC_CHAIN_ID=56
NEXT_PUBLIC_RPC_URL=https://bsc-dataseed.binance.org/
NEXT_PUBLIC_WALLET_CONNECT_ID=<your_project_id>
```

### 4. Run the app
```bash
npm run dev
```

Visit `http://localhost:3000`

---

## 🛠 Directory Structure

```
/components     → UI elements (Navbar, Modal, Card)
/pages          → Route-based views (/vault, /dao, /compute)
/hooks          → Custom Web3 and state hooks
/lib            → Helper modules (IPFS, staking, billing)
/public         → Static assets (logos, icons)
/styles         → Global Tailwind configuration
```

---

## 🔒 Security Considerations

- Wallet interactions signed client-side only
- Contract addresses loaded via `.env`
- Snapshot-based DAO vote tracking
- Off-chain metrics displayed from verified telemetry endpoints

---

## 📬 Support
- Dev team: [dev@ocos.io](mailto:dev@ocos.io)
- Telegram: [@ocos_official](https://t.me/ocos_official)
- Docs: [https://ocos.io/cloud](https://ocos.io/cloud)

---

> OCOS Cloud UI is the gateway to your decentralized infrastructure.

---
