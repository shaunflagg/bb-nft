import AllCodeNFTContract from 0xf8d6e0586b0a20c7

transaction {
  let receiverRef: &{AllCodeNFTContract.NFTReceiver}
  let minterRef: &AllCodeNFTContract.NFTMinter

  prepare(acct: AuthAccount) {
      self.receiverRef = acct.getCapability<&{AllCodeNFTContract.NFTReceiver}>(/public/NFTReceiver)
          .borrow()
          ?? panic("Could not borrow receiver reference")

      self.minterRef = acct.borrow<&AllCodeNFTContract.NFTMinter>(from: /storage/NFTMinter)
          ?? panic("could not borrow minter reference")
  }

  execute {
      let metadata : {String : String} = {
          "name": "AllCode Logo",
          "street_address": "Fillmore Street",
          "phone_number": "415-890-6431",
          "email": "joel@allcode.com",
          "uri": "ipfs://QmVH5T7MFVU52hTfQdWvu73iFPEF3jizuGfyVLccTmBCX2"
      }
      let newNFT <- self.minterRef.mintNFT()

      self.receiverRef.deposit(token: <-newNFT, metadata: metadata)

      log("NFT Minted and deposited to Account 2's Collection")
  }
}
