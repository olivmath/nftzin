import { useEffect, useState } from "react";
import { useAccount, useWriteContract } from "wagmi";
import { pinataUri } from "../services/convertURI.service";
import { NFTMetadata } from "../types/metadata";
import contractsMetadata from "../public/contractsMetadata";
import { Address } from "viem";

interface NFTCardProps {
  metadataUrl: string;
  tokenId: number;
}

const NFTCard: React.FC<NFTCardProps> = ({ metadataUrl, tokenId }) => {
  const [metadata, setMetadata] = useState<NFTMetadata | null>(null);
  const [recipientAddress, setRecipientAddress] = useState<Address>("0x");
  const { address } = useAccount();
  const { data: hash, writeContract } = useWriteContract();
  

  useEffect(() => {
    const fetchMetadata = async () => {
      const uri = pinataUri(metadataUrl);
      const response = await fetch(uri);
      const data = await response.json() as NFTMetadata;
      setMetadata(data);
    };
    fetchMetadata();
  }, [metadataUrl]);

  const handleTransferClick = () => {
    if (recipientAddress && address) {
      console.log([address, recipientAddress, tokenId])

      writeContract({
        address: contractsMetadata.vrum.address,
        abi: contractsMetadata.vrum.abi,
        functionName: "transferFrom",
        args: [address as Address, recipientAddress, BigInt(tokenId)],
      });
    } else {
      alert("Por favor, insira um endereço de destinatário válido.");
    }
  };

  return (
    <div style={{ margin: "10px", padding: "10px", border: "1px solid black" }}>
      {metadata ? (
        <>
          <img src={pinataUri(metadata.image)} alt={metadata.name} style={{ width: "100px" }} />
          <h3>{metadata.name}</h3>
          <p>{metadata.description}</p>
          <input
            type="text"
            placeholder="Endereço do destinatário"
            value={recipientAddress}
            onChange={(e) => setRecipientAddress(e.target.value as Address)}
          />
          <button onClick={handleTransferClick}>
            {hash ? "Transferindo..." : "Transferir NFT"}
          </button>
        </>
      ) : (
        <div>Loading...</div>
      )}
    </div>
  );
};

export default NFTCard;
