# C++ 中验证 Web3 钱包签名

## 概述

在 C++ 后端验证 Web3 钱包签名，需要：
1. 恢复签名中的公钥
2. 验证签名的有效性
3. 恢复钱包地址
4. 验证地址匹配

---

## 快速方案：使用现成工具库（推荐）

### 方案 1：使用 web3.cpp（最简单）

```bash
# 安装
git clone https://github.com/web3dev/web3.cpp.git
cd web3.cpp && cmake . && make install
```

**使用示例**：

```cpp
#include <web3/Web3.h>

using namespace dev::eth;

// 验证签名并恢复地址
bool verifySignature(const std::string& address,
                     const std::string& message,
                     const std::string& signature) {
    try {
        // 一行代码恢复地址
        Address recovered = dev::eth::recover(
            sha3(bytesConstRef(message)),
            SignatureStruct::fromHex(signature)
        );

        // 比较地址
        return recovered.hex() == address;
    } catch (...) {
        return false;
    }
}

int main() {
    std::string addr = "0x742d35Cc6634C0532925a3b844Bc1e4a48834d72";
    std::string msg = "Sign this message";
    std::string sig = "0x...";

    if (verifySignature(addr, msg, sig)) {
        std::cout << "✓ 签名有效" << std::endl;
    }
    return 0;
}
```

---

### 方案 2：使用 ethers.cpp（活跃维护）

```bash
# 安装
git clone https://github.com/ppoliani/ethers.cpp.git
cd ethers.cpp && mkdir build && cd build && cmake .. && make
```

**使用示例**：

```cpp
#include <ethers/ethers.hpp>

using namespace ethers;

class Web3Auth {
public:
    static bool verifyMessage(const std::string& address,
                             const std::string& message,
                             const std::string& signature) {
        try {
            // 创建签名对象
            Signature sig = Signature::fromHex(signature);

            // 恢复地址
            std::string recovered = sig.recoverAddress(message);

            // 比较（不区分大小写）
            return toChecksum(recovered) == toChecksum(address);

        } catch (const std::exception& e) {
            std::cerr << "Verification failed: " << e.what() << std::endl;
            return false;
        }
    }

private:
    static std::string toChecksum(const std::string& addr) {
        // 转换为 EIP-55 checksum 格式
        // ...
        return addr;
    }
};

int main() {
    std::string address = "0x742d35Cc6634C0532925a3b844Bc1e4a48834d72";
    std::string message = "Sign this message";
    std::string signature = "0x...";

    if (Web3Auth::verifyMessage(address, message, signature)) {
        std::cout << "✓ 钱包验证成功" << std::endl;
    }
    return 0;
}
```

---

### 方案 3：使用 EthWallet++（简洁易用）

```bash
# 安装
git clone https://github.com/CaplockCoder/EthWallet-Cpp.git
cd EthWallet-Cpp && mkdir build && cd build && cmake .. && make
```

**使用示例**：

```cpp
#include "EthWallet.h"

int main() {
    EthWallet wallet;

    // 直接验证签名
    bool isValid = wallet.verifySignature(
        address,      // "0x742d35..."
        message,      // "Sign this message"
        signature     // "0x..."
    );

    if (isValid) {
        // 获取签名者地址
        std::string signer = wallet.getSignerAddress(message, signature);
        std::cout << "签名者: " << signer << std::endl;
    }

    return 0;
}
```

---

### 方案 4：使用 libevm（轻量级）

```bash
# 安装
git clone https://github.com/chfast/evmc.git
cd evmc && mkdir build && cd build && cmake .. && make install
```

**使用示例**：

```cpp
#include <evmc/evmc.hpp>

// 验证签名
bool verifyWebMessage(const std::string& msg,
                      const std::string& sig,
                      const std::string& addr) {
    // Keccak256 哈希
    auto hash = keccak256(msg);
    
    // 恢复公钥
    auto pubkey = recoverPubkey(hash, sig);
    
    // 验证地址
    return getAddress(pubkey) == addr;
}
```

---

## 完整对比表

| 库名 | 难度 | 维护状态 | 文档 | 推荐度 |
|------|------|---------|------|--------|
| **web3.cpp** | ⭐ | 活跃 | 完整 | ⭐⭐⭐⭐⭐ |
| **ethers.cpp** | ⭐⭐ | 活跃 | 较好 | ⭐⭐⭐⭐ |
| **EthWallet++** | ⭐ | 维护中 | 简洁 | ⭐⭐⭐⭐ |
| **libevm** | ⭐⭐⭐ | 活跃 | 偏少 | ⭐⭐⭐ |
| 手动实现 | ⭐⭐⭐ | 自己维护 | 无 | ⭐ |

**推荐**：使用 **web3.cpp** 或 **ethers.cpp**

---

## 使用 Node.js 后端？更简单！

如果后端是 Node.js，直接用现成的库：

```javascript
// ethers.js (最流行)
const ethers = require('ethers');

async function verifySignature(address, message, signature) {
  const recovered = ethers.verifyMessage(message, signature);
  return recovered.toLowerCase() === address.toLowerCase();
}

// 或者使用 web3.js
const Web3 = require('web3');
const web3 = new Web3();

function verifySignature(address, message, signature) {
  const recovered = web3.eth.accounts.recover(message, signature);
  return recovered.toLowerCase() === address.toLowerCase();
}
```

---

## 依赖库安装（如果选择手动实现）

### 使用 OpenSSL 和 secp256k1

```bash
# macOS
brew install openssl secp256k1

# Ubuntu/Debian
sudo apt-get install libssl-dev libsecp256k1-dev

# CentOS
sudo yum install openssl-devel secp256k1-devel
```

### CMakeLists.txt 配置

```cmake
cmake_minimum_required(VERSION 3.10)
project(web3_verify)

set(CMAKE_CXX_STANDARD 17)

find_package(OpenSSL REQUIRED)
find_package(secp256k1 REQUIRED)

add_executable(verify_signature main.cpp)
target_link_libraries(verify_signature 
  PRIVATE 
    OpenSSL::Crypto 
    secp256k1
)
```

## C++ 实现（完整示例）

```cpp
#include <openssl/sha.h>
#include <openssl/keccak.h>
#include <secp256k1.h>
#include <secp256k1_recovery.h>
#include <string>
#include <vector>
#include <iomanip>
#include <sstream>
#include <cstring>

class Web3Verifier {
private:
    secp256k1_context* ctx;

public:
    Web3Verifier() {
        ctx = secp256k1_context_create(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY);
    }

    ~Web3Verifier() {
        secp256k1_context_destroy(ctx);
    }

    // 计算 Keccak256 哈希
    static std::string keccak256(const std::string& data) {
        unsigned char hash[32];
        EVP_MD_CTX* mdctx = EVP_MD_CTX_new();
        
        EVP_DigestInit_ex(mdctx, EVP_sha3_256(), nullptr);
        EVP_DigestUpdate(mdctx, data.data(), data.size());
        EVP_DigestFinal_ex(mdctx, hash, nullptr);
        EVP_MD_CTX_free(mdctx);

        std::stringstream ss;
        for (int i = 0; i < 32; i++) {
            ss << std::hex << std::setw(2) << std::setfill('0') << (int)hash[i];
        }
        return ss.str();
    }

    // 将十六进制字符串转换为字节
    static std::vector<unsigned char> hexToBytes(const std::string& hex) {
        std::vector<unsigned char> bytes;
        for (size_t i = 0; i < hex.length(); i += 2) {
            std::string byteString = hex.substr(i, 2);
            unsigned char byte = (unsigned char)strtol(byteString.c_str(), nullptr, 16);
            bytes.push_back(byte);
        }
        return bytes;
    }

    // 将字节转换为十六进制字符串
    static std::string bytesToHex(const std::vector<unsigned char>& bytes) {
        std::stringstream ss;
        for (unsigned char b : bytes) {
            ss << std::hex << std::setw(2) << std::setfill('0') << (int)b;
        }
        return ss.str();
    }

    // 生成消息的签名哈希（EIP-191 格式）
    std::string getMessageHash(const std::string& message) {
        // EIP-191 prefix: "\x19Ethereum Signed Message:\n{length}"
        std::string prefix = "\x19Ethereum Signed Message:\n";
        std::string msgLength = std::to_string(message.length());
        std::string fullMessage = prefix + msgLength + message;

        return keccak256(fullMessage);
    }

    // 验证签名并恢复地址
    bool verifySignature(const std::string& address,
                         const std::string& message,
                         const std::string& signature,
                         std::string& recoveredAddress) {
        try {
            // 1. 获取消息哈希
            std::string msgHash = getMessageHash(message);
            std::vector<unsigned char> msgHashBytes = hexToBytes(msgHash);

            // 2. 解析签名（v, r, s 格式）
            std::string sig = signature;
            if (sig.substr(0, 2) == "0x") {
                sig = sig.substr(2);
            }

            if (sig.length() != 130) { // 65 字节 = 130 hex 字符
                return false;
            }

            // 提取 v, r, s
            std::string vStr = sig.substr(128, 2);
            std::string rStr = sig.substr(0, 64);
            std::string sStr = sig.substr(64, 64);

            int v = stoi(vStr, nullptr, 16);
            if (v < 27 || v > 28) {
                return false;
            }

            // 3. 创建签名结构
            secp256k1_ecdsa_recoverable_signature sig_rec;
            std::vector<unsigned char> rBytes = hexToBytes(rStr);
            std::vector<unsigned char> sBytes = hexToBytes(sStr);

            secp256k1_ecdsa_recoverable_signature_parse_compact(
                ctx, sig_rec.data, rBytes.data(), v - 27
            );

            // 4. 恢复公钥
            secp256k1_pubkey pubkey;
            if (!secp256k1_ecdsa_recover(ctx, &pubkey, &sig_rec, msgHashBytes.data())) {
                return false;
            }

            // 5. 从公钥恢复地址
            unsigned char pubkeyBytes[65];
            size_t len = 65;
            secp256k1_ec_pubkey_serialize(
                ctx, pubkeyBytes, &len, &pubkey, SECP256K1_EC_UNCOMPRESSED
            );

            // 6. 计算 Keccak256(pubkey[1:]) 的最后 20 字节
            std::string pubkeyHex = bytesToHex(
                std::vector<unsigned char>(pubkeyBytes + 1, pubkeyBytes + 65)
            );
            std::string pubkeyHash = keccak256(pubkeyHex);
            recoveredAddress = "0x" + pubkeyHash.substr(pubkeyHash.length() - 40);

            // 7. 比较地址（忽略大小写）
            std::string lowerAddress = address;
            std::string lowerRecovered = recoveredAddress;

            for (auto& c : lowerAddress) {
                c = std::tolower(c);
            }
            for (auto& c : lowerRecovered) {
                c = std::tolower(c);
            }

            return lowerAddress == lowerRecovered;

        } catch (const std::exception& e) {
            std::cerr << "Verification error: " << e.what() << std::endl;
            return false;
        }
    }

    // 验证消息时效性（防重放攻击）
    bool verifyNonce(const std::string& message, uint64_t maxAgeMs = 5 * 60 * 1000) {
        // 从消息中提取 nonce（时间戳）
        size_t noncePos = message.rfind("Nonce: ");
        if (noncePos == std::string::npos) {
            return false;
        }

        try {
            std::string nonceStr = message.substr(noncePos + 7);
            uint64_t nonce = std::stoull(nonceStr);
            uint64_t now = std::chrono::system_clock::now().time_since_epoch().count() / 1000000;

            return (now - nonce) <= maxAgeMs;
        } catch (...) {
            return false;
        }
    }
};

// 使用示例
int main() {
    Web3Verifier verifier;

    // 从前端接收的数据
    std::string address = "0x742d35Cc6634C0532925a3b844Bc1e4a48834d72";
    std::string message = "Sign this message to authenticate with Blog UI\nNonce: 1704355200000";
    std::string signature = "0x..."; // 从前端接收

    std::string recoveredAddress;

    // 验证签名
    if (verifier.verifySignature(address, message, signature, recoveredAddress)) {
        std::cout << "✓ 签名有效" << std::endl;
        std::cout << "恢复地址: " << recoveredAddress << std::endl;

        // 验证 nonce 时效性
        if (verifier.verifyNonce(message)) {
            std::cout << "✓ Nonce 有效，未过期" << std::endl;
        } else {
            std::cout << "✗ Nonce 已过期" << std::endl;
            return 1;
        }
    } else {
        std::cout << "✗ 签名无效" << std::endl;
        return 1;
    }

    return 0;
}
```

## 在 REST API 中使用（使用 Poco 库）

```cpp
#include <Poco/Net/HTTPServer.h>
#include <Poco/Net/HTTPRequestHandler.h>
#include <Poco/JSON/Parser.h>
#include <Poco/JSON/Object.h>
#include <iostream>
#include "web3_verifier.h"

using namespace Poco;
using namespace Poco::Net;
using namespace Poco::JSON;

class Web3LoginHandler : public HTTPRequestHandler {
public:
    void handleRequest(HTTPServerRequest& request, HTTPServerResponse& response) override {
        try {
            // 解析 JSON 请求
            std::istream& is = request.stream();
            Parser parser;
            Object::Ptr obj = parser.parse(is).extract<Object::Ptr>();

            std::string address = obj->get("address").toString();
            std::string message = obj->get("message").toString();
            std::string signature = obj->get("signature").toString();

            // 验证签名
            Web3Verifier verifier;
            std::string recoveredAddress;

            if (!verifier.verifySignature(address, message, signature, recoveredAddress)) {
                response.setStatus(HTTPResponse::HTTP_UNAUTHORIZED);
                response.setContentType("application/json");
                response.send() << "{\"code\": 401, \"message\": \"Signature verification failed\"}";
                return;
            }

            // 验证 nonce
            if (!verifier.verifyNonce(message)) {
                response.setStatus(HTTPResponse::HTTP_UNAUTHORIZED);
                response.setContentType("application/json");
                response.send() << "{\"code\": 401, \"message\": \"Nonce expired\"}";
                return;
            }

            // 检查或创建用户
            // ... 数据库操作 ...

            // 生成 JWT token
            std::string token = generateJWT(address);

            // 返回成功响应
            response.setStatus(HTTPResponse::HTTP_OK);
            response.setContentType("application/json");
            
            Object::Ptr result = new Object();
            result->set("code", 0);
            result->set("message", "Login successful");
            
            Object::Ptr data = new Object();
            data->set("address", address);
            data->set("token", token);
            data->set("userId", getUserId(address));
            
            result->set("data", data);

            std::stringstream ss;
            result->stringify(ss);
            response.send() << ss.str();

        } catch (const std::exception& e) {
            response.setStatus(HTTPResponse::HTTP_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.send() << "{\"code\": 500, \"message\": \"" << e.what() << "\"}";
        }
    }

private:
    std::string generateJWT(const std::string& address) {
        // JWT 实现
        // ... 
        return "jwt_token_here";
    }

    std::string getUserId(const std::string& address) {
        // 数据库查询
        // ...
        return "user_id";
    }
};

int main(int argc, char** argv) {
    HTTPServer server(new HTTPRequestHandlerFactory<Web3LoginHandler>(), 3000);
    server.start();
    std::cout << "Server listening on port 3000..." << std::endl;
    // ... 
    return 0;
}
```

## 安全最佳实践

### 1. 防重放攻击

```cpp
// 存储已使用的签名
std::unordered_set<std::string> usedSignatures;

bool verifyAndStore(const std::string& signature) {
    if (usedSignatures.find(signature) != usedSignatures.end()) {
        return false; // 签名已使用过
    }
    usedSignatures.insert(signature);
    return true;
}

// 定期清理过期签名（配合 nonce 时间戳）
```

### 2. 速率限制

```cpp
#include <unordered_map>
#include <chrono>

class RateLimiter {
private:
    std::unordered_map<std::string, std::vector<uint64_t>> attempts;

public:
    bool isAllowed(const std::string& address, int maxAttempts = 5, uint64_t windowMs = 60000) {
        auto now = std::chrono::system_clock::now().time_since_epoch().count() / 1000000;
        auto& times = attempts[address];

        // 删除窗口外的请求
        times.erase(
            std::remove_if(times.begin(), times.end(),
                [now, windowMs](uint64_t t) { return (now - t) > windowMs; }),
            times.end()
        );

        if (times.size() >= maxAttempts) {
            return false;
        }

        times.push_back(now);
        return true;
    }
};
```

### 3. 日志记录

```cpp
void logVerification(const std::string& address, bool success, const std::string& reason = "") {
    std::ofstream log("web3_login.log", std::ios::app);
    auto now = std::chrono::system_clock::now();
    
    log << "[" << now.time_since_epoch().count() << "] "
        << "Address: " << address << " | "
        << "Status: " << (success ? "SUCCESS" : "FAILED") << " | "
        << "Reason: " << reason << std::endl;
}
```

## 编译和运行

```bash
# 编译
mkdir build
cd build
cmake ..
make

# 运行
./verify_signature
```

## 常见问题

**Q: 如何处理 Keccak256？**

A: 使用 OpenSSL 的 EVP 接口：
```cpp
EVP_sha3_256() // Keccak256
```

**Q: 如何处理不同的签名格式？**

A: 支持多种格式：
```cpp
// MetaMask: "0xabcd..."
// 无前缀: "abcd..."
std::string sig = signature;
if (sig.substr(0, 2) == "0x") {
    sig = sig.substr(2);
}
```

**Q: 如何验证链 ID？**

A: 在消息中包含链 ID 并验证：
```cpp
std::string message = "Sign for Ethereum (chainId: 1)\nNonce: ...";
```

---

这样就可以在 C++ 后端完整地验证 Web3 钱包签名了！
