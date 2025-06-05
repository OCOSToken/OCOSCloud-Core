// 🌐 OCOS Cloud: pages/node/[id].tsx
// Dynamic page to display node-specific health and diagnostics data

import { useRouter } from 'next/router';
import Head from 'next/head';
import dynamic from 'next/dynamic';

const NodeHealth = dynamic(() => import('../../components/NodeHealth'), { ssr: false });

export default function NodePage() {
  const router = useRouter();
  const { id } = router.query;

  const nodeId = parseInt(id as string);

  if (isNaN(nodeId)) return <div className="p-6 text-red-500">Invalid node ID</div>;

  return (
    <>
      <Head>
        <title>Node #{nodeId} | OCOS Cloud</title>
      </Head>
      <main className="min-h-screen p-6 bg-gray-50 dark:bg-zinc-950">
        <div className="max-w-5xl mx-auto">
          <h1 className="text-2xl font-bold mb-6">OCOS Node #{nodeId}</h1>
          <NodeHealth nodeId={nodeId} />
        </div>
      </main>
    </>
  );
}
