const network_acala = 'acala';
const network_karura = 'karura';

const network_native_token = {network_acala: 'ACA', network_karura: 'KAR'};
//History  https://blockscout.karura-dev.aca-dev.network/api?module=account&action=txlist&address=0xfff2c1b954a91802dc97f65af37378329041aa7b

const network_node_list = {
  network_acala: [
    {
      'name': 'acala (via RadiumBlock)',
      'ss58': 2,
      'endpoint': 'https://acala-dev.aca-dev.network/eth/http',
      'chainId': '596',
      'networkType': 'ethereum',
    }
  ],
  network_karura: [
    {
      'name': 'karura (via RadiumBlock)',
      'ss58': 2,
      'endpoint': 'https://karura-dev.aca-dev.network/eth/http',
      'chainId': '597',
      'networkType': 'ethereum',
    }
  ]
};

const substrate_node_list = {
  network_acala: "wss://acala-dev.aca-dev.network/rpc/ws",
  network_karura: "wss://karura-dev.aca-dev.network/rpc/ws"
};

const substrate_ss58_list = {network_acala: 10, network_karura: 8};
