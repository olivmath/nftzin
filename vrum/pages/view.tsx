import contractsMetadata from "../public/contractsMetadata";
import { useAccount, useReadContract } from "wagmi";
import { useEffect, useState } from "react";
import { useRouter } from "next/router";
import type { NextPage } from "next";
import { Address } from "viem";
import NFTCard from "../components/NFTCard";

const ViewPage: NextPage = () => {
  const { isConnected, address } = useAccount();
  const router = useRouter();
  const [nftUris, setNftUris] = useState<string[]>([]);

  // Verificar saldo do usuário
  const { data: uris } = useReadContract({
    address: contractsMetadata.vrum.address,
    abi: contractsMetadata.vrum.abi,
    functionName: "getMyURIs",
    args: [address as Address],
  });

  useEffect(() => {
    if (uris) {
      console.log(uris);
      setNftUris(uris as string[]);
    }
  }, [uris]);

  useEffect(() => {
    if (!isConnected) {
      router.push("/");
    }
  }, [isConnected, router]);

  return (
    <div>
      <h1>Seu NFT aqui</h1>
      <div
        style={{ display: "flex", flexWrap: "wrap", justifyContent: "center" }}
      >
        {nftUris.map((uri, index) => (
          <NFTCard key={index} metadataUrl={uri} />
        ))}
      </div>
    </div>
  );
};

export default ViewPage;
