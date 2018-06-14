//
//  test.swift
//  Coin
//
//  Created by haiqingzheng on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

import Foundation
import BigInt
import web3swift

public class EthCrypto: NSObject
{
    static public func generateMnemonics() -> String? {
        var str : String!
        do{
        try str = BIP39.generateMnemonics(bitsOfEntropy: 128);
        }
        catch {}
        return str
    }
//    static public var paths: [String:EthereumAddress] = [String:EthereumAddress]()
    
    static public func isValidMnemonice(_ mnemonics: String) -> String? {
        var _ : String!
        var seed : Data!
        seed = BIP39.mnemonicsToEntropy(mnemonics)
        
        if seed != nil {
            return "1"
        } else {
            return "0"
        }
//        seed = BIP39.mnemonicsToEntropy(mnemonics)
//        guard let prefixNode = HDNode(seed: seed)?.derive(path: HDNode.defaultPathMetamaskPrefix, derivePrivateKey: true) else {return nil}
//
//        var newIndex = UInt32(0)
//        for (p, _) in paths {
//            guard let idx = UInt32(p.components(separatedBy: "/").last!) else {continue}
//            if idx >= newIndex {
//                newIndex = idx + 1
//            }
//        }
//
//        let newNode = prefixNode.derive(index: newIndex, derivePrivateKey: true, hardened: false)
//        privateKeyStr = newNode?.privateKey?.toHexString();
        
//        return seed;
    }
    static public var paths: [String:EthereumAddress] = [String:EthereumAddress]()
    
    static public func getPrivateKey(_ mnemonics: String) -> String? {
        var privateKeyStr : String!
        var seed : Data!
        seed = BIP39.seedFromMmemonics(mnemonics);
//        seed = BIP39.mnemonicsToEntropy(mnemonics)
        guard let prefixNode = HDNode(seed: seed)?.derive(path: HDNode.defaultPathMetamaskPrefix, derivePrivateKey: true) else {return nil}
        
        var newIndex = UInt32(0)
        for (p, _) in paths {
            guard let idx = UInt32(p.components(separatedBy: "/").last!) else {continue}
            if idx >= newIndex {
                newIndex = idx + 1
            }
        }
        
        let newNode = prefixNode.derive(index: newIndex, derivePrivateKey: true, hardened: false)
        privateKeyStr = newNode?.privateKey?.toHexString();
        
        return privateKeyStr;
    }
    
    static public func getAddress(privateKey: String) -> String? {
        var address : String!
        var publicKey : Data!
       
        publicKey = Web3Utils.privateToPublic(Data.fromHex(privateKey)!)
        address = Web3Utils.publicToAddressString(publicKey);
        return address;
    }
    
    static public func gasPriceResult(privateKey: String) -> String? {
        var address : String!
        var publicKey : Data!
        
        publicKey = Web3Utils.privateToPublic(Data.fromHex(privateKey)!)
        address = Web3Utils.publicToAddressString(publicKey);
        return address;
    }
    
    //获取矿工燃料费用单价
    static public func getGasPrice() -> String? {
        
        //rinkey测试环境，上线需要修改
        let web3 = Web3.InfuraRinkebyWeb3();
        let gasPriceResult = web3.eth.getGasPrice();
        if case .failure(_) = gasPriceResult {
            return (nil)
        }
        return String.init(gasPriceResult.value!);
        
        //gasPrice
        //gasLimit默认21000
        //默认矿工费用=21000*gasPrice
        
    }
    
    //发送ETH交易（签名并广播）
    static public func sendTransaction(mnemonic: String, to: String, amount: String, gasPrice: String, gasLimit: String) -> String? {
        
        var txHash : String!
//        txHash = "";
        do{
           
            let keystore = try! BIP32Keystore(mnemonics: mnemonic, password: "BANKEXFOUNDATION", mnemonicsPassword: "")
            
            let web3Rinkeby = Web3.InfuraRinkebyWeb3()
            let keystoreManager = KeystoreManager.init([keystore!])
            web3Rinkeby.addKeystoreManager(keystoreManager)
            
            var options = Web3Options.defaultOptions()
            options.gasLimit = BigUInt(21000)
            options.from = keystore?.addresses?.first!
            let am = BigUInt.init(amount)
            options.value = am
            let toaddress = EthereumAddress(to)
           
           
            let intermediateSend = web3Rinkeby.contract(Web3.Utils.coldWalletABI, at: toaddress, abiVersion: 2)!.method(options: options)!
            let sendResult = intermediateSend.send(password: "BANKEXFOUNDATION")
            switch sendResult {
            case .success(let r):
                print("Sucess",r.values.first as Any)
                txHash=r.values.first as Any as! String
                //todo 返回交易hash
            case .failure(let err):
                print("Eroor",err)
            }
            if txHash != nil {
               txHash =  "1"
            } else {
              txHash = "0"
            }
            
        }
        
        return txHash;
    
    }
    
//    public struct Web3s {
//
//        public static func new(_ providerURL: URL) -> web3? {
//            guard let provider = Web3HttpProvider(providerURL) else {return nil}
//            return web3(provider: provider)
//        }
//    }
//    var web3: web3
//    public var options: Web3Options {
//        return self.web3.options
//    }
    
//    var ethInstance: web3.Eth?
//    public var eth: web3.Eth {
//        if (self.ethInstance != nil) {
//            return self.ethInstance!
//        }
////        self.ethInstance = web3.Eth(provider : Web3Operation as! Web3Provider, web3: we)
//        return self.ethInstance!
//    }
//    var myTV = Web3()
    
    
//    transaction.gasPrice = gasPriceResult.value!
//    options.gasPrice = gasPriceResult.value!
//    guard let gasEstimate = self.estimateGas(transaction, options: options) else {return (nil, nil)}
//    transaction.gasLimit = gasEstimate
//    options.gasLimit = gasEstimate
//    print(transaction)
//    return (transaction, options)

    
    

}
