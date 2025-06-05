// OCOS Cloud: API route to fetch node heartbeats from NodeSentinel smart contract

import type { NextApiRequest, NextApiResponse } from 'next';
import { ethers } from 'ethers';
import NodeSentinelABI from '../../../abis/NodeSentinel.json';

const NODE_SENTINEL_ADDRESS = process.env.NODE_SENTINEL_ADDRESS || '';
const RPC_URL = process.env.NEXT_PUBLIC_RPC_URL || 'https://bsc-dataseed.binance.org/';

const provider = new ethers.providers.JsonRpcProvider(RPC_URL);
const contract = new ethers.Contract(NODE_SENTINEL_ADDRESS, NodeSentinelABI, provider);

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const {
    query: { nodeId },
    method,
  } = req;

  if (method !== 'GET') return res.status(405).end('Method Not Allowed');
  if (!nodeId || isNaN(Number(nodeId))) return res.status(400).json({ error: 'Invalid node ID' });

  try {
    const count = 10;
    const heartbeats = await contract.getRecentHeartbeats(Number(nodeId), count);

    const formatted = heartbeats.map((hb: any) => ({
      timestamp: Number(hb.timestamp),
      latencyMs: Number(hb.latencyMs),
      anomalyDetected: Boolean(hb.anomalyDetected),
      anomalyScore: Number(hb.anomalyScore),
    }));

    res.status(200).json(formatted);
  } catch (err) {
    console.error('API Error:', err);
    res.status(500).json({ error: 'Failed to fetch heartbeats' });
  }
}
