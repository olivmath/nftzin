export function pinataUri(ipfsUri: string): string {
    // Define o base URL do gateway do Pinata
    const pinataBaseUrl = "https://black-cheerful-newt-43.mypinata.cloud/ipfs/";

    // Extrai o CID e o caminho do arquivo da URI do IPFS
    const [, cidAndPath] = ipfsUri.split("ipfs://");

    // Monta e retorna a URL completa
    return `${pinataBaseUrl}${cidAndPath}`;
}
