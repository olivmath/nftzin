import { useEffect } from 'react';
import { useAccount } from 'wagmi';
import { useRouter } from 'next/router';
import type { NextPage } from 'next';

const ViewPage: NextPage = () => {
  const { isConnected } = useAccount();
  const router = useRouter();

  useEffect(() => {
    if (!isConnected) {
      router.push("/");
    }
  }, [isConnected, router]);

  return (
    <div
      style={{
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        height: "100vh",
      }}
    >
      <h1>Seu NFT aqui</h1>
    </div>
  );
};

export default ViewPage;
