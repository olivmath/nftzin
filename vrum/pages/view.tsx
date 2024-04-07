import contractsMetadata from "../public/contractsMetadata";
import { useAccount, useReadContract } from "wagmi";
import { useEffect, useState } from "react";
import { useRouter } from "next/router";
import type { NextPage } from "next";
import { Address } from "viem";
import NFTCard from "../components/NFTCard";
import { extractTokenId } from "../services/tokenId.service";
import ClaimNFT from "../components/ClaimNFT";

const ViewPage: NextPage = () => {
  const { isConnected, address } = useAccount();
  const router = useRouter();
  const [nftUris, setNftUris] = useState<string[]>([]);

  // Verificar saldo do usuário
  const { data: uris, isLoading, isError } = useReadContract({
    address: contractsMetadata.vrum.address,
    abi: contractsMetadata.vrum.abi,
    functionName: "getMyURIs",
    args: [address as Address],
  });

  useEffect(() => {
    if (!isConnected) {
      router.push("/");
    } else if (!isLoading && !isError && uris && uris.length > 0) {
      setNftUris(uris as string[]);
    }
  }, [isConnected, isLoading, isError, uris, router]);
  return (
    <div>
      <div
        style={{ display: "flex", flexWrap: "wrap", justifyContent: "center" }}
      >
        {!isLoading && !isError && nftUris.length > 0 ? (
          nftUris.map((uri, index) => (
            <NFTCard
              key={index}
              metadataUrl={uri}
              tokenId={extractTokenId(uri)}
            />
          ))
        ) : (
          <ClaimNFT />
        )}
      </div>
    </div>
  );
};

export default ViewPage;
