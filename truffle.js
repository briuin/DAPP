module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      gas: 500000,
      network_id: "*" // Match any network id
    },
    ganache: {
      host: "localhost",
      port: 7545,
      gas: 90000000,
      network_id: "5788" // Match any network id
    }
  }
};
