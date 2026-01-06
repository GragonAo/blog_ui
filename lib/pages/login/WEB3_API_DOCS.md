# Web3 钱包登录 - 后端 API 文档

## 概述
本文档描述了 Web3 钱包登录所需的后端 API 接口。

## API 端点

### 1. Web3 登录
**端点:** `POST /api/auth/web3-login`

**描述:** 验证用户的钱包签名并创建会话

**请求体:**
```json
{
  "address": "0x1234567890123456789012345678901234567890",
  "message": "Sign this message to authenticate with Blog UI\nNonce: 1704355200000",
  "signature": "0xabcdef..."
}
```

**字段说明:**
- `address` (string, 必需): 以太坊钱包地址
- `message` (string, 必需): 用户签名的原始消息
- `signature` (string, 必需): 用户的签名

**成功响应:**
```json
{
  "code": 0,
  "message": "登录成功",
  "data": {
    "userId": "123",
    "address": "0x1234567890123456789012345678901234567890",
    "username": "User_1234",
    "avatar": "https://...",
    "token": "jwt_token_here",
    "createdAt": "2026-01-04T00:00:00Z"
  }
}
```

**错误响应:**
```json
{
  "code": 400,
  "message": "签名验证失败"
}
```

---

## 后端实现指南

### 签名验证流程

1. **接收参数**
   - 获取钱包地址、消息和签名

2. **验证签名**
   使用 Web3 库验证签名是否有效：

   ```javascript
   // Node.js 示例
   const ethers = require('ethers');
   
   function verifySignature(address, message, signature) {
     try {
       const recoveredAddress = ethers.verifyMessage(message, signature);
       return recoveredAddress.toLowerCase() === address.toLowerCase();
     } catch (error) {
       return false;
     }
   }
   ```

   ```python
   # Python 示例
   from eth_account.messages import encode_defunct
   from web3.auto import w3
   
   def verify_signature(address, message, signature):
       try:
           message_hash = encode_defunct(text=message)
           recovered_address = w3.eth.account.recover_message(
               message_hash, 
               signature=signature
           )
           return recovered_address.lower() == address.lower()
       except Exception as e:
           return False
   ```

3. **检查 Nonce 时效性**
   - 提取消息中的 nonce（时间戳）
   - 验证时间戳在合理范围内（如 5 分钟内）
   - 防止重放攻击

4. **用户处理**
   - 如果是新地址，创建新用户账户
   - 如果是已有地址，返回现有用户信息

5. **生成会话**
   - 创建 JWT token 或 session
   - 返回用户信息和认证令牌

---

## 安全建议

### 1. Nonce 验证
```javascript
// 检查时间戳有效性
const nonce = extractNonceFromMessage(message);
const now = Date.now();
const maxAge = 5 * 60 * 1000; // 5分钟

if (Math.abs(now - parseInt(nonce)) > maxAge) {
  throw new Error('Nonce expired');
}
```

### 2. 防止重放攻击
- 将已使用的签名存储在缓存中（Redis）
- 设置过期时间
- 拒绝重复使用的签名

```javascript
// 伪代码
if (await redis.exists(`used_signature:${signature}`)) {
  throw new Error('Signature already used');
}

await redis.setex(`used_signature:${signature}`, 600, '1');
```

### 3. 链验证（可选）
如果需要验证用户的链，可以要求在消息中包含 chainId：

```
Sign this message to authenticate with Blog UI
Chain: Ethereum Mainnet (1)
Nonce: 1704355200000
```

---

## 数据库模型

### User 表
```sql
CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  wallet_address VARCHAR(42) UNIQUE NOT NULL,
  username VARCHAR(50),
  avatar VARCHAR(255),
  bio TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_wallet_address (wallet_address)
);
```

### Session 表（可选）
```sql
CREATE TABLE sessions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  token VARCHAR(255) UNIQUE NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  INDEX idx_token (token),
  INDEX idx_user_id (user_id)
);
```

---

## 测试用例

### 1. 正常登录流程
```bash
curl -X POST http://localhost:3000/api/auth/web3-login \
  -H "Content-Type: application/json" \
  -d '{
    "address": "0x...",
    "message": "Sign this message to authenticate with Blog UI\nNonce: 1704355200000",
    "signature": "0x..."
  }'
```

### 2. 无效签名
```bash
# 应返回 400 错误
curl -X POST http://localhost:3000/api/auth/web3-login \
  -H "Content-Type: application/json" \
  -d '{
    "address": "0x...",
    "message": "...",
    "signature": "invalid_signature"
  }'
```

### 3. 过期的 Nonce
```bash
# 应返回 400 错误
curl -X POST http://localhost:3000/api/auth/web3-login \
  -H "Content-Type: application/json" \
  -d '{
    "address": "0x...",
    "message": "Sign this message to authenticate with Blog UI\nNonce: 1600000000000",
    "signature": "0x..."
  }'
```

---

## 前端集成说明

### 获取 WalletConnect Project ID
1. 访问 https://cloud.walletconnect.com/
2. 注册账号
3. 创建新项目
4. 复制 Project ID
5. 在 `lib/pages/login/controller.dart` 中替换 `YOUR_PROJECT_ID`

### 更新后端 API 地址
在 `lib/http/constants.dart` 中配置正确的后端 API 地址：

```dart
class HttpString {
  static const String apiBaseUrl = 'https://your-api-domain.com';
  // ...
}
```

---

## 常见问题

**Q: 为什么需要签名？**
A: 签名证明用户拥有该钱包的私钥，无需密码即可安全认证。

**Q: 如何处理用户首次登录？**
A: 自动创建新用户账户，可以让用户后续设置用户名和头像。

**Q: 支持哪些钱包？**
A: 
- Web 端：MetaMask, Coinbase Wallet, Brave Wallet 等浏览器钱包
- 移动端：通过 WalletConnect 支持 Trust Wallet, Rainbow, MetaMask Mobile 等

**Q: 如何处理多个设备登录？**
A: 使用 JWT token，允许同一账户在多个设备上同时登录。

**Q: 如何实现退出登录？**
A: 前端清除本地存储的 token，后端可选择性地将 token 加入黑名单。
