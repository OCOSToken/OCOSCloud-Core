# 📈 OCOS Cloud Metrics & Monitoring

This document outlines the core metrics tracked across OCOS Cloud smart contracts, services, and nodes to maintain transparency, performance insights, and community trust.

---

## 🧱 Smart Contract Metrics

| Contract               | Metric                               | Description                                 |
|------------------------|--------------------------------------|---------------------------------------------|
| `ComputeBilling.sol`   | `totalUsageCount`                    | Number of compute sessions logged           |
|                        | `totalOCOSCharged`                   | Aggregate OCOS tokens billed                |
| `ComputeStaking.sol`   | `totalStaked`                        | Total OCOS tokens locked in staking         |
|                        | `activeStakers`                      | Number of active stakers                    |
| `NodeRewardVault.sol`  | `totalRewardsDistributed`            | Cumulative tokens sent to node operators    |
|                        | `claimRate`                          | Ratio of claimed vs allocated rewards       |
| `CloudDAO.sol`         | `proposalCount`                      | Total number of proposals submitted         |
|                        | `voteParticipationRate`              | Avg. % of token holders voting              |

---

## 🧠 Node Metrics

| Category      | Metric                     | Description                                |
|---------------|-----------------------------|--------------------------------------------|
| Compute       | `nodeComputeScore`          | Weighted performance score                 |
| Uptime        | `nodeAvailability`          | 30-day active availability                 |
| Rewards       | `nodeRewardMultiplier`      | Multiplier based on performance tier       |
| Benchmark     | `nodeBenchmarkValidity`     | ZK-proofed or manually submitted           |
| Jobs          | `jobsCompleted`             | Successful tasks processed by the node     |

---

## 📦 Vault Metrics

| Metric                 | Description                                  |
|------------------------|----------------------------------------------|
| `filesStoredCount`     | Number of CIDs added to `CloudVault.sol`     |
| `totalStorageUsedMB`   | Aggregated file size submitted by users      |
| `averageFileSizeMB`    | Mean file size per entry                     |
| `encryptedFileRatio`   | Percentage of encrypted vs public files      |

---

## 🌐 API Usage Metrics (Gateway)

| Endpoint                | Metric                       | Description                                |
|-------------------------|-------------------------------|--------------------------------------------|
| `/compute/start`        | `avgComputeStartLatency`     | Avg. time to respond to job initiation     |
| `/vault/store`          | `storageSuccessRate`         | Success ratio of file CID registration     |
| `/dao/proposal`         | `proposalCreationRate`       | Proposals per week                         |
| `/proof/submit`         | `zkProofSubmissionRate`      | Average ZK submissions per month           |

---

## 🧪 Monitoring Tools

- **On-chain Dashboards**: Dune, Tenderly, Blockscout
- **Off-chain Telemetry**: Grafana, Prometheus, Elastic
- **Real-time Logs**: WebSocket relays for live node and billing events

---

## 🛡 Alerts & Anomalies

- DAO vote anomalies (low turnout or vote spikes)
- Unexpected drop in compute availability
- Spike in unclaimed rewards or failed ZK verifications

---

> Metrics are the heartbeat of OCOS Cloud. Open visibility empowers community governance.

---
