import Web3 from 'web3';
import crowdFundAbi from './build/contracts/SimpleCoin.json';

const web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:9545'));
const address = '0xb19d1f573cf78ab99c79051d68be3750c3e5ff85';
const contract = new web3.eth.Contract(crowdFundAbi.abi, address);
window.web3 = web3;
window.scoin = contract;
let accounts;
// console.log(contract);
document.querySelector('#transfer').onclick = transferCoins;
document.onload = function () {
	refreshAccountsTable();
};
getAccounts();

/********************************************************
 * ******************************************************
 * ******************************************************
 * ******************************************************
 */
async function getAccounts() {
	try {
		accounts = await web3.eth.getAccounts();
		// console.log(accounts);
		window.accounts = accounts;
		// console.log('hi');
	} catch (err) {
		console.error(err);
	}finally{
		refreshAccountsTable();
	}
}
async  function refreshAccountsTable() {
	let innerHtml = '<tr><td>Account</td><td>Balance</td>';

	for (let i = 0; i < accounts.length; i++) {
		let account = accounts[i];
	    let wei = await contract.methods.balanceOf(account).call();
		let balance =  web3.utils.fromWei(String(wei), 'ether');
		console.log(account, balance, ' Ether');
		innerHtml += '<tr><td>' + account + '</td><td>' + balance +' Ether' + '</td></tr>';
	}

	document.querySelector('#accountsBalanceTable').innerHTML = innerHtml;
}

function transferCoins() {
	let sender = document.querySelector('#from').value;
	let recipient = document.querySelector('#to').value;
	let tokensToTransfer = 
		web3.utils.toWei(document.querySelector('#amount').value, 'ether');
		console.log(tokensToTransfer)
	contract.methods
		.transfer(recipient, tokensToTransfer)
		.send({ from: sender }, function (error, result) {
			if (!error){
				console.log('' + result);
				refreshAccountsTable();
			}
			else console.error(error);
		});
}
