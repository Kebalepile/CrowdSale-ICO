const CrowdFund = artifacts.require('CrowdFund');
const web3 = require('web3');
contract('CrowdFund', function (accounts) {
	let Contract,
		ownerPK = accounts[0];
	before('contract instance', async () => {
		Contract = await CrowdFund.deployed();
	});

	context('Reading Contract owner public address', () => {
		it('should have owner', async () => {
			const address = await Contract.owner();

			assert.equal(address, ownerPK);
		});
	});

	context('Invest Ether in CrowFund', () => {
		it('should emit LogInvestment event', async () => {
			for (let i = 0; i < accounts.length; i++) {
				const address = accounts[i];
				const amount = web3.utils.toWei('70', 'ether');
				const { logs } = await Contract.invest({ from: address, value: amount });
				Contract.adjustPriceLevel({ from: ownerPK });
				const { investor, value } = logs[0].args;

				assert.equal(logs[0].event, 'LogInvestment', 'expected event not emited');
				assert.equal(investor.toUpperCase(), address.toUpperCase(), 'public address do not match');
				assert.equal(amount, value, 'amount of wei is not the same');
				assert.equal(logs[0].type, 'mined', 'transaction is not mined');
			}
		});
	});

	context('Check ERC20 Token Price', () => {
		it('should return current ERC20 TokenPrice', async () => {
			let price = await Contract.weiTokenPrice();
			price = web3.utils.fromWei(price, 'ether');
			console.log(price, ' Ether');
			assert.notEqual(price, 0.002);
		});
	});

	context('Check Address balances', () => {
		it('should return wei balances', async () => {
			let totalEther = 0;
			for (let i = 0; i < accounts.length; i++) {
				let amount = await Contract.investmentAmount.call(accounts[i]);
				amount = web3.utils.fromWei(amount, 'ether');
				totalEther += Number(amount);
				console.log('address ', accounts[i], ' has ', amount, ' ether');
			}

			assert.equal(totalEther, 700, 'Total Ether in contract is less than 700 Ether');
		});
	});

	context('Check ERC20 Token Price', () => {
		it('should return current ERC20 TokenPrice', async () => {
			let price = await Contract.weiTokenPrice();
			price = web3.utils.fromWei(price, 'ether');
			console.log(price, ' Ether');
			assert.notEqual(price, 0);
		});
	});

	context('Investment received', () => {
		it('should return total wei of contract balance', async () => {
			let amount = await Contract.investmentReceived();
			amount = Number(web3.utils.fromWei(amount, 'ether'));
			console.log('Total balance of contract is ', amount);
			assert.equal(amount, 700);
		});
	});

	context('Finalize Contract', () => {
		it('should prevent further investment on the contract', async () => {
			let { receipt } = await Contract.finalize({ from: ownerPK });
			assert.equal(receipt.status, true, 'receipt status is no true');
		});
	});


});
