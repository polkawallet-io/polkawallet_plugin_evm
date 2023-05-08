const network_acala = 'acala';
const network_karura = 'karura';
const network_ethereum = 'ethereum';
const network_goerli = 'goerli';

const ethTokenDetailPageRoute = '/eth/token/detail';

const network_native_token = {
  network_acala: 'ACA',
  network_karura: 'KAR',
  network_goerli: 'ETH',
  network_ethereum: 'ETH'
};

const block_explorer_url = {
  network_acala: {
    'name': 'Blockscout',
    'url': 'https://blockscout.acala-dev.aca-dev.network',
    'api': 'https://blockscout.acala-dev.aca-dev.network',
  },
  network_karura: {
    'name': 'Blockscout',
    'url': 'https://blockscout.karura-dev.aca-dev.network',
    'api': 'https://blockscout.karura-dev.aca-dev.network',
  },
  network_ethereum: {
    'name': 'Etherscan',
    'url': 'https://etherscan.io',
    'api': 'https://api.etherscan.io'
  }
};

const network_node_list = {
  // network_ethereum: [
  //   {
  //     'name': 'ethereum',
  //     'ss58': 2,
  //     'endpoint':
  //         'https://mainnet.infura.io/v3/069fb89d9e594d68b3e2dff06a1592b4',
  //     'chainId': '1',
  //     'networkType': 'ethereum',
  //   }
  // ],
  network_goerli: [
    {
      'name': 'Goerli Testnet',
      'ss58': 2,
      'endpoint':
          'https://goerli.infura.io/v3/069fb89d9e594d68b3e2dff06a1592b4',
      'chainId': '5',
      'networkType': 'ethereum',
    }
  ],
  // network_acala: [
  //   {
  //     'name': 'acala EVM (dev)',
  //     'ss58': 2,
  //     'endpoint': 'https://eth-rpc-acala-testnet.aca-staging.network',
  //     'chainId': '597',
  //     'networkType': 'ethereum',
  //   }
  // ],
  // network_karura: [
  //   {
  //     'name': 'karura EVM (dev)',
  //     'ss58': 2,
  //     'endpoint': 'https://eth-rpc-karura-testnet.aca-staging.network',
  //     'chainId': '596',
  //     'networkType': 'ethereum',
  //   }
  // ]
};

const substrate_node_list = {
  network_acala: "wss://acala-dev.aca-dev.network/rpc/ws",
  network_karura: "wss://karura-dev.aca-dev.network/rpc/ws"
};

const substrate_ss58_list = {network_acala: 10, network_karura: 8};
