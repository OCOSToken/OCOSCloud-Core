# 🚀 OCOS Cloud Smart Contracts Deployment Guide

This guide provides a step-by-step walkthrough for deploying the OCOS Cloud smart contracts to the BNB Smart Chain (BSC) or Ethereum-compatible networks.

---

## 📦 Prerequisites

- Node.js >= 16.x
- Hardhat >= 2.17
- Git
- Metamask / Private key with BNB or ETH
- OCOS token contract address (pre-deployed)

### 📁 Recommended Directory Structure:
```
contracts/
├── OcosCloudHost.sol
├── CloudNodeRegistry.sol
├── ComputeStaking.sol
├── CloudVault.sol
├── CloudDAO.sol
├── ComputeBilling.sol
├── NodeRewardVault.sol
├── zkComputeProof.sol
scripts/
├── deployAll.js
hardhat.config.js
.env
```

---

## 🔧 Step 1: Setup Project

```bash
git clone https://github.com/OCOSToken/OCOSCloud-Core.git
cd OCOSCloud-Core
npm install --save-dev hardhat dotenv @nomiclabs/hardhat-ethers ethers
```

Create `.env` file:
```ini
PRIVATE_KEY=your_wallet_private_key
BSC_RPC_URL=https://bsc-dataseed.binance.org/
OCOS_TOKEN_ADDRESS=0xYourOcosTokenAddress
```

---

## ⚙️ Step 2: Configure Hardhat

In `hardhat.config.js`:
```javascript
require("dotenv").config();
require("@nomiclabs/hardhat-ethers");

module.exports = {
  networks: {
    bsc: {
      url: process.env.BSC_RPC_URL,
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  solidity: "0.8.20"
};
```

---

## 🚀 Step 3: Deploy Script (scripts/deployAll.js)

```javascript
async function main() {
  const [deployer] = await ethers.getSigners();
  const token = process.env.OCOS_TOKEN_ADDRESS;

  const Host = await ethers.getContractFactory("OcosCloudHost");
  const host = await Host.deploy(token);
  console.log("OcosCloudHost:", host.address);

  const Registry = await ethers.getContractFactory("CloudNodeRegistry");
  const registry = await Registry.deploy();
  console.log("CloudNodeRegistry:", registry.address);

  const Staking = await ethers.getContractFactory("ComputeStaking");
  const staking = await Staking.deploy(token);
  console.log("ComputeStaking:", staking.address);

  const Vault = await ethers.getContractFactory("CloudVault");
  const vault = await Vault.deploy(token);
  console.log("CloudVault:", vault.address);

  const DAO = await ethers.getContractFactory("CloudDAO");
  const dao = await DAO.deploy(token);
  console.log("CloudDAO:", dao.address);

  const Billing = await ethers.getContractFactory("ComputeBilling");
  const billing = await Billing.deploy(token);
  console.log("ComputeBilling:", billing.address);

  const Rewards = await ethers.getContractFactory("NodeRewardVault");
  const rewards = await Rewards.deploy(token);
  console.log("NodeRewardVault:", rewards.address);

  const ZKP = await ethers.getContractFactory("zkComputeProof");
  const zkp = await ZKP.deploy();
  console.log("zkComputeProof:", zkp.address);
}

main().catch(console.error);
```

---

## 🚨 Step 4: Run Deployment

```bash
npx hardhat run scripts/deployAll.js --network bsc
```

---

## 📄 Post-Deployment Checklist

- ✅ Verify contracts on BscScan using Hardhat plugins or manual interface
- ✅ Save contract addresses in a `.json` file
- ✅ Grant roles / set DAO ownerships where applicable
- ✅ Fund Vault contracts and allocate initial rewards

---

## 🔒 Security Recommendations

- Use multisig or Gnosis Safe for admin keys
- Integrate CertiK audit reports post-deployment
- Rotate token allowances securely
- Monitor events for unexpected behavior

---

## 🧠 References

- [OCOS Token Repo](https://github.com/OCOSToken/OCOSUK)
- [OCOS Cloud Architecture](./architecture.md)
- [Hardhat Documentation](https://hardhat.org/)
- [BscScan Verification](https://bscscan.com/verifyContract)

---

> For questions, reach out at dev@ocos.io or open a GitHub issue.

---
