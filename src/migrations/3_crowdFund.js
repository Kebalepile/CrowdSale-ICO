const CrowdFund = artifacts.require('CrowdFund');

module.exports = (deployer) => {
	const startTime = 2003526559,
		endTime = 2003526600,
		tokenPriceInWei = 2000000000000000,
		fundTargetInEther = 700;
	deployer.deploy(CrowdFund, startTime, endTime, tokenPriceInWei, fundTargetInEther);
};
