import { ConnectButton } from '@rainbow-me/rainbowkit';
import type { NextPage } from 'next';

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
