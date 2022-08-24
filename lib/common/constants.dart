const network_acala = 'acala';
const network_karura = 'karura';
const network_ethereum = 'ethereum';

const network_native_token = {
  network_acala: 'ACA',
  network_karura: 'KAR',
  network_ethereum: 'ETH'
};

//history api base network
const network_url_api = {
  network_acala: 'https://blockscout.acala-dev.aca-dev.network',
  network_karura: 'https://blockscout.karura-dev.aca-dev.network',
  network_ethereum: 'https://api.etherscan.io'
};

const network_url_scan = {
  network_acala: {
    'name': 'Blockscout',
    'url': 'https://blockscout.acala-dev.aca-dev.network'
  },
  network_karura: {
    'name': 'Blockscout',
    'url': 'https://blockscout.karura-dev.aca-dev.network'
  },
  network_ethereum: {'name': 'Etherscan', 'url': 'https://etherscan.io'}
};

const network_node_list = {
  network_ethereum: [
    {
      'name': 'ethereum',
      'ss58': 2,
      'endpoint':
          'https://mainnet.infura.io/v3/069fb89d9e594d68b3e2dff06a1592b4',
      'chainId': '597',
      'networkType': 'ethereum',
    },
    // {
    //   'name': 'Ethereum (dev node)',
    //   'ss58': 2,
    //   'endpoint': 'https://ropsten.infura.io/v3/069fb89d9e594d68b3e2dff06a1592b4',
    //   'chainId': '597',
    //   'networkType': 'ethereum',
    // }
  ],
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
