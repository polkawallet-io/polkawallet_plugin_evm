const network_acala = 'acala';
const network_karura = 'karura';
const network_ethereum = 'ethereum';
const network_goerli = 'goerli';
const network_mandala = 'mandala';
const network_acala_dev = 'acala-dev';
const network_karura_dev = 'karura-dev';

const ethTokenDetailPageRoute = '/eth/token/detail';

const network_native_token = {
  network_mandala: 'ACA',
  network_acala_dev: 'ACA',
  network_karura_dev: 'KAR',
  network_acala: 'ACA',
  network_karura: 'KAR',
  network_goerli: 'ETH',
  network_ethereum: 'ETH'
};

const block_explorer_url = {
  network_acala: {
    'name': 'Blockscout',
    'url': 'https://blockscout.acala.network',
    'api': 'https://blockscout.acala.network',
  },
  network_karura: {
    'name': 'Blockscout',
    'url': 'https://blockscout.karura.network',
    'api': 'https://blockscout.karura.network',
  },
  network_mandala: {
    'name': 'Blockscout',
    'url': 'https://blockscout.mandala.aca-staging.network',
    'api': 'https://blockscout.mandala.aca-staging.network',
  },
  network_acala_dev: {
    'name': 'Blockscout',
    'url': 'https://blockscout.acala-dev.aca-dev.network',
    'api': 'https://blockscout.acala-dev.aca-dev.network',
  },
  network_karura_dev: {
    'name': 'Blockscout',
    'url': 'https://blockscout.karura-dev.aca-dev.network',
    'api': 'https://blockscout.karura-dev.aca-dev.network',
  },
  network_ethereum: {
    'name': 'Etherscan',
    'url': 'https://etherscan.io',
    'api': 'https://api.etherscan.io'
  },
  network_goerli: {
    'name': 'Etherscan',
    'url': 'https://goerli.etherscan.io',
    'api': 'https://api-goerli.etherscan.io'
  }
};

const network_node_list = {
  network_ethereum: [
    {
      'name': 'ethereum',
      'ss58': 2,
      'endpoint':
          'https://mainnet.infura.io/v3/069fb89d9e594d68b3e2dff06a1592b4',
      'chainId': '1',
      'networkType': 'ethereum',
    }
  ],
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
  // network_mandala: [
  //   {
  //     'name': 'mandala EVM',
  //     'ss58': 2,
  //     'endpoint': 'https://eth-rpc-tc9.aca-staging.network',
  //     'chainId': '595',
  //     'networkType': 'ethereum',
  //   }
  // ],
  network_acala: [
    {
      'name': 'acala EVM',
      'ss58': 2,
      'endpoint': 'https://eth-rpc-acala.aca-api.network',
      'chainId': '787',
      'networkType': 'ethereum',
    }
  ],
  network_karura: [
    {
      'name': 'karura EVM',
      'ss58': 2,
      'endpoint': 'https://eth-rpc-karura.aca-api.network',
      'chainId': '686',
      'networkType': 'ethereum',
    }
  ],
  // network_acala_dev: [
  //   {
  //     'name': 'acala EVM (dev)',
  //     'ss58': 2,
  //     'endpoint': 'https://eth-rpc-acala-testnet.aca-staging.network',
  //     'chainId': '597',
  //     'networkType': 'ethereum',
  //   }
  // ],
  // network_karura_dev: [
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
  network_mandala: "wss://eth-rpc-tc9.aca-staging.network",
  network_acala_dev: "wss://acala-dev.aca-dev.network/rpc/ws",
  network_karura_dev: "wss://karura-dev.aca-dev.network/rpc/ws",
  network_acala: "wss://acala-polkadot.api.onfinality.io/public-ws",
  network_karura: "wss://karura.api.onfinality.io/public-ws"
};

const substrate_ss58_list = {
  network_mandala: 42,
  network_acala_dev: 10,
  network_karura_dev: 8,
  network_acala: 10,
  network_karura: 8
};
