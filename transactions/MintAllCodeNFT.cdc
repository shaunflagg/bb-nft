import BbNFTContract from 0xf8d6e0586b0a20c7

transaction {
  let receiverRef: &{BbNFTContract.NFTReceiver}
  let minterRef: &BbNFTContract.NFTMinter

  prepare(acct: AuthAccount) {
      self.receiverRef = acct.getCapability<&{BbNFTContract.NFTReceiver}>(/public/NFTReceiver)
          .borrow()
          ?? panic("Could not borrow receiver reference")

      self.minterRef = acct.borrow<&BbNFTContract.NFTMinter>(from: /storage/NFTMinter)
          ?? panic("could not borrow minter reference")
  }

  execute {
      let metadata : {String : String} = {
          "name": "Shaun Flagg",
          "street_address": "Techwood",
          "phone_number": "770-000-0000",
          "email": "sflagg@warnermedia.com",
          "uri": "ipfs://QmcP2JQtX8aBvFPE7Mr2WsCgiLNRyBQmYWFcjgDheiXGwJ"
      }
      let newNFT <- self.minterRef.mintNFT()

      self.receiverRef.deposit(token: <-newNFT, metadata: metadata)

      log("NFT Minted and deposited to Account 2's Collection")
  }
}
