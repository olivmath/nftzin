import { ConnectButton } from '@rainbow-me/rainbowkit';
import { useAccount } from 'wagmi';
import { useEffect } from 'react';
import { useRouter } from 'next/router';
import type { NextPage } from 'next';

const Home: NextPage = () => {
  const { isConnected } = useAccount();
  const router = useRouter();

  useEffect(() => {
    if (isConnected) {
      router.push('/view');
    }
  }, [isConnected, router]);

  return (
    <>
      <div
        style={{
          fontSize: "240px",
          color: "#0e0e0e",
          fontWeight: "bold",
          marginTop: "120px",
          display: "flex",
          justifyContent: "center",
        }}
      >
        <main>NFTzin</main>
      </div>
    </>
  );
};

export default Home;
