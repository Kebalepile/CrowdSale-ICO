const SimpleCoin = artifacts.require("SimpleCoin");

module.exports = function (deployer) {
  deployer.deploy(SimpleCoin,BigInt(5000000000000000000));
  // 2003526559, 2003526600, 2000000000000000, 15000
};
