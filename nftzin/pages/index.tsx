import { ConnectButton } from '@rainbow-me/rainbowkit';
import type { NextPage } from 'next';
import Link from 'next/link';

const Home: NextPage = () => {
  return (
    <>
      <div
        style={{
          display: "flex",
          justifyContent: "flex-end",
          padding: 12,
        }}
      >
        <ConnectButton />
      </div>
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
        <Link href="/view">
          <main>NFTzin</main>
        </Link>
      </div>
    </>
  );
};

export default Home;
