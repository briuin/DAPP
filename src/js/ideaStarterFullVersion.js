import contract from 'truffle-contract'
import IdeaStarterContract from '@contracts/IdeaStarter.json'

const IdeaStarter = {

  contract: null,

  instance: null,

  init: function () {
    let self = this

    return new Promise(function (resolve, reject) {
      self.contract = contract(IdeaStarterContract)
      self.contract.setProvider(window.web3.currentProvider)

      self.contract.deployed().then(instance => {
        self.instance = instance
        resolve()
      }).catch(err => {
        reject(err)
      })
    })
  },

  getOwner: function(){
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.owner.call(
        {from: window.web3.eth.accounts[0]}
      ).then(owner => {
        resolve(owner)
      }).catch(err => {
        reject(err)
      })
    })
  },

  backIdea: function(id, owner, amount) {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.backIdea(
        id,
        owner,
        {from: window.web3.eth.accounts[0], value: window.web3.toWei(amount, "ether")}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  getIdea: function (id) {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.getIdea.call(
        id,
        {from: window.web3.eth.accounts[0]}
      ).then(idea => {
        var ideaObj = {
          id: id,
          owner: idea[0],
          name: idea[1],
          description: idea[2],
          goal: window.web3.fromWei(idea[3], "ether").toNumber(),
          funded: window.web3.fromWei(idea[4], "ether").toNumber(),
          backersCount: idea[5].toNumber(),
          url: idea[6]
        }
        resolve(ideaObj)
      }).catch(err => {
        reject(err)
      })
    })
  },

  getIdeasCount: function () {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.totalIdeas.call(
        {from: window.web3.eth.accounts[0]}
      ).then(count => {
        resolve(count.toNumber())
      }).catch(err => {
        reject(err)
      })
    })
  },

  addIdea: function (name, description, luckyNumber, url) {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.addIdea(
        name,
        description,
        luckyNumber,
        url,
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  getTokenHolderCount: function () {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.getTokenHolderCount.call(
        {from: window.web3.eth.accounts[0]}
      ).then(count => {
        resolve(count.toNumber())
      }).catch(err => {
        reject(err)
      })
    })
  },

  getTokenBalanceByIndex: function (id) {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.getTokenBalanceByIndex.call(
        id,
        {from: window.web3.eth.accounts[0]}
      ).then(tokenHolder => {
        var holderObj = {
          address: tokenHolder[0],
          amount: tokenHolder[1].toNumber()
        }
        resolve(holderObj)
      }).catch(err => {
        reject(err)
      })
    })
  },

  setTokenAddress: function (address) {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.setTokenAddress(
        address,
        {from: window.web3.eth.accounts[0]}
      ).then(tx=> {
        resolve(tx)
      }).catch(err=> {
        reject(err)
      })
    })
  }
}

export default IdeaStarter
