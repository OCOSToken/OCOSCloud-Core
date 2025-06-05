// 🌐 OCOS Cloud: NodeHealth.tsx
// React component to display live node heartbeat and anomaly score

import React, { useEffect, useState } from 'react';
import { useAccount } from 'wagmi';
import axios from 'axios';

interface Heartbeat {
  timestamp: number;
  latencyMs: number;
  anomalyDetected: boolean;
  anomalyScore: number;
}

const formatTime = (unix: number) => new Date(unix * 1000).toLocaleString();

export default function NodeHealth({ nodeId }: { nodeId: number }) {
  const [heartbeats, setHeartbeats] = useState<Heartbeat[]>([]);
  const { address } = useAccount();

  useEffect(() => {
    const fetchHeartbeats = async () => {
      try {
        const res = await axios.get(`/api/nodes/${nodeId}/health`);
        setHeartbeats(res.data);
      } catch (err) {
        console.error("Error fetching heartbeats", err);
      }
    };

    fetchHeartbeats();
    const interval = setInterval(fetchHeartbeats, 60_000);
    return () => clearInterval(interval);
  }, [nodeId]);

  return (
    <div className="rounded-xl border p-4 shadow-md bg-white dark:bg-zinc-900">
      <h3 className="text-lg font-semibold mb-4">Node Health: #{nodeId}</h3>
      <div className="overflow-x-auto">
        <table className="table-auto w-full text-sm">
          <thead>
            <tr className="text-left border-b">
              <th>Timestamp</th>
              <th>Latency (ms)</th>
              <th>Anomaly</th>
              <th>Score</th>
            </tr>
          </thead>
          <tbody>
            {heartbeats.slice(-10).reverse().map((h, i) => (
              <tr key={i} className="border-b">
                <td>{formatTime(h.timestamp)}</td>
                <td>{h.latencyMs}</td>
                <td className={h.anomalyDetected ? 'text-red-500' : 'text-green-600'}>
                  {h.anomalyDetected ? 'Yes' : 'No'}
                </td>
                <td>{(h.anomalyScore / 1000).toFixed(3)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
