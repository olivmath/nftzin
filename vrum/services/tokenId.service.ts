export function extractTokenId(ipfsUri: string): number {
    // INPUT ipfs://Qmcjsq941CGGcFFKq8VJxVjbbMKH9QCsx8JfgpGJnGzxK1/3.json
    // OUTPUT 3
    return parseInt(ipfsUri.split('/').slice(-1)[0].split('.json')[0])
}
