var FEPToken = artifacts.require("./FEPToken.sol");

module.exports = function(deployer) {
  deployer.deploy(FEPToken, { gas: 900000000 });
};
