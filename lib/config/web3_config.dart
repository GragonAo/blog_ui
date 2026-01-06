/// Web3 配置
class Web3Config {
  // WalletConnect Project ID (可以公开，不是密钥)
  // 从 https://cloud.walletconnect.com/ 获取
  static const String walletConnectProjectId = String.fromEnvironment(
    'WALLETCONNECT_PROJECT_ID',
    defaultValue: 'c0fb8df3-a39b-4d41-aced-77d3cad3d16e', // 开发环境默认值
  );

  // 应用元数据
  static const String appName = 'Blog UI';
  static const String appDescription = 'Web3 Blog Platform';
  static const String appUrl = 'https://yourdomain.com';
  static const List<String> appIcons = ['https://yourdomain.com/icon.png'];

  // 支持的链
  static const Map<String, String> supportedChains = {
    'eip155:1': 'Ethereum Mainnet',
    'eip155:11155111': 'Sepolia Testnet',
    'eip155:137': 'Polygon',
    'eip155:56': 'BSC',
  };

  // RPC 节点 (可选，用于查询链上数据)
  static const Map<String, String> rpcUrls = {
    'eip155:1': 'https://eth.llamarpc.com',
    'eip155:11155111': 'https://sepolia.infura.io/v3/YOUR_INFURA_KEY',
    'eip155:137': 'https://polygon-rpc.com',
    'eip155:56': 'https://bsc-dataseed.binance.org',
  };

  // 区块浏览器
  static const Map<String, String> blockExplorers = {
    'eip155:1': 'https://etherscan.io',
    'eip155:11155111': 'https://sepolia.etherscan.io',
    'eip155:137': 'https://polygonscan.com',
    'eip155:56': 'https://bscscan.com',
  };
}
