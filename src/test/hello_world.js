const helloWorld = artifacts.require('helloWorld');

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract('helloWorld', function ([account_1]) {
	let Contract;

	before('contract instance', async () => {
		Contract = await helloWorld.deployed();
	});
	xcontext('adding message to the HelloWorld contract', () => {
		it('should set message', async () => {
			const { receipt } = await Contract.setMessage('Hi there', { from: account_1 });

			assert.equal(receipt.status, true, 'set message not successful');
		});
	});

	xcontext('reading message from HelloWorld Contract', () => {
		it('should get message', async () => {
			const message = await Contract.getMessage();
			assert.equal(message, 'Hi there', 'message not the same');
		});
	});
});
