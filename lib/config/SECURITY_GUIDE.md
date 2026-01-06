# Web3 安全配置指南

## Project ID 安全性说明

### ✅ 可以公开的信息（写在前端是安全的）

1. **WalletConnect Project ID**
   - 这是一个公开标识符，不是密钥
   - 用于标识你的应用和统计连接数据
   - 设计用途就是在客户端使用

2. **应用元数据**
   - 应用名称、描述、图标、URL
   - 这些信息会显示在钱包连接界面

3. **链 ID 和 RPC 节点**
   - 公开的区块链网络标识符
   - 公共 RPC 节点地址

### 🔒 不应该公开的信息（永远不要写在前端）

1. **私钥（Private Keys）**
   - 永远不要在代码中硬编码
   - 只存在用户的钱包中

2. **后端 API 密钥**
   - 数据库密码
   - 服务器密钥
   - JWT Secret

3. **付费 RPC 节点的 API Key**
   - Infura API Key
   - Alchemy API Key
   - 应该通过后端代理使用

## WalletConnect Cloud 安全设置

访问 https://cloud.walletconnect.com/ 配置：

### 1. 域名白名单

在项目设置中添加允许的域名：

```
允许的来源：
✓ https://yourdomain.com
✓ https://www.yourdomain.com
✓ http://localhost:8080  (开发环境)
```

### 2. 速率限制

```
连接请求限制：
- 每分钟最多 100 个连接
- 每小时最多 1000 个连接
```

### 3. 监控和告警

```
设置告警：
✓ 异常流量
✓ 大量失败连接
✓ 来自可疑来源的请求
```

## 环境变量配置（可选）

### 方式一：编译时注入

```bash
# 开发环境
flutter run --dart-define=WALLETCONNECT_PROJECT_ID=your_dev_project_id

# 生产环境
flutter build web --dart-define=WALLETCONNECT_PROJECT_ID=your_prod_project_id
```

### 方式二：配置文件

创建 `.env` 文件（不要提交到 Git）：

```env
WALLETCONNECT_PROJECT_ID=your_project_id_here
```

在 `.gitignore` 中添加：
```
.env
.env.local
.env.*.local
```

### 方式三：直接在配置文件中

如果你的项目是开源的，或者不在意 Project ID 公开，可以直接写在 `web3_config.dart` 中：

```dart
static const String walletConnectProjectId = 'your_actual_project_id';
```

## 最佳实践建议

### 1. 分离开发和生产环境

```dart
class Web3Config {
  static const bool isProduction = bool.fromEnvironment(
    'dart.vm.product',
    defaultValue: false,
  );

  static String get walletConnectProjectId {
    if (isProduction) {
      return 'prod_project_id';
    } else {
      return 'dev_project_id';
    }
  }
}
```

### 2. 使用测试网进行开发

开发时使用测试网（Sepolia, Mumbai 等）：
- 免费的测试币
- 不影响真实资产
- 可以随意测试

### 3. 实现错误处理

```dart
Future<void> _initWalletConnect() async {
  try {
    wcClient = await Web3App.createInstance(
      relayUrl: 'wss://relay.walletconnect.com',
      projectId: Web3Config.walletConnectProjectId,
      metadata: PairingMetadata(
        name: Web3Config.appName,
        description: Web3Config.appDescription,
        url: Web3Config.appUrl,
        icons: Web3Config.appIcons,
      ),
    );
  } on InvalidProjectIdException {
    print('错误：无效的 Project ID');
    SmartDialog.showToast('配置错误，请联系管理员');
  } catch (e) {
    print('WalletConnect initialization error: $e');
    SmartDialog.showToast('连接服务初始化失败');
  }
}
```

### 4. 后端验证签名

**关键：** 前端可以公开，但所有重要操作必须在后端验证！

```javascript
// 后端示例（Node.js）
const ethers = require('ethers');

function verifyWalletSignature(address, message, signature) {
  try {
    const recoveredAddress = ethers.verifyMessage(message, signature);
    return recoveredAddress.toLowerCase() === address.toLowerCase();
  } catch (error) {
    return false;
  }
}

// API 路由
app.post('/api/auth/web3-login', async (req, res) => {
  const { address, message, signature } = req.body;
  
  // 验证签名
  if (!verifyWalletSignature(address, message, signature)) {
    return res.status(401).json({ error: '签名验证失败' });
  }
  
  // 检查消息时效性
  const nonce = extractNonce(message);
  if (isExpired(nonce)) {
    return res.status(401).json({ error: '签名已过期' });
  }
  
  // 创建会话...
});
```

## 安全检查清单

- [ ] ✅ Project ID 写在配置文件中，方便管理
- [ ] ✅ 在 WalletConnect Cloud 配置域名白名单
- [ ] ✅ 设置合理的速率限制
- [ ] ✅ 开发和生产环境使用不同的 Project ID
- [ ] ❌ 私钥、API Secret 永远不写在前端
- [ ] ✅ 所有敏感操作在后端验证签名
- [ ] ✅ 实现签名的时效性检查
- [ ] ✅ 防止签名重放攻击
- [ ] ✅ 使用 HTTPS 传输数据
- [ ] ✅ 实现错误日志记录

## 常见安全问题

### Q: 别人拿到我的 Project ID 会怎样？

A: 他们只能：
- 使用你的 quota（免费版有限制）
- 可能被你的域名白名单拦截

不能：
- 访问用户的钱包
- 代表用户签名或转账
- 窃取任何私密信息

**解决方案：** 配置域名白名单

### Q: 开源项目怎么办？

A: 
1. 提供配置模板，让用户填入自己的 Project ID
2. 或者直接公开一个公共的 Project ID
3. 在文档中说明如何获取和配置

### Q: 需要加密 Project ID 吗？

A: **不需要**。加密后仍然可以被反编译出来，没有实际意义。Project ID 本身就是设计为可公开的。

### Q: 付费 API（如 Infura）怎么办？

A: 
1. **前端** - 使用免费的公共 RPC
2. **后端** - 使用付费 API 进行敏感操作
3. 或者后端做代理，限制使用

## 总结

✅ **WalletConnect Project ID 可以安全地写在前端代码中**

关键要记住：
1. Project ID 不是密钥，是公开标识符
2. 真正的安全在于钱包端的用户确认
3. 后端必须验证所有签名
4. 使用 WalletConnect Cloud 的安全功能
5. 永远不要在前端暴露私钥或后端密钥

---

📚 相关资源：
- [WalletConnect 安全最佳实践](https://docs.walletconnect.com/2.0/advanced/security)
- [Web3 安全指南](https://ethereum.org/zh/developers/docs/security/)
