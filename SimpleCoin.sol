// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./Ownable.sol";

contract SimpleCoin is Ownable {
    constructor(uint256 initialSupply) public {
        owner = msg.sender;
        coinBalance[msg.sender] = initialSupply;
        mint(owner, initialSupply);
    }

    mapping(address => uint256) public coinBalance;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function transfer(address to, uint256 amount) public {
        require(coinBalance[msg.sender] > amount);
        require(coinBalance[to] + amount >= coinBalance[to]);
        coinBalance[msg.sender] -= amount;
        coinBalance[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool success) {
        require(int256(to) != 0x0);
        require(coinBalance[from] > amount);
        require(coinBalance[to] + amount >= coinBalance[to]);
        require(amount <= allowance[from][msg.sender]);

        coinBalance[from] -= amount;
        coinBalance[to] += amount;
        allowance[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);

        return true;
    }

    function authorize(address authorizedAccount, uint256 _allowance)
        public
        returns (bool success)
    {
        allowance[msg.sender][authorizedAccount] = _allowance;
        return true;
    }

    function mint(address recipient, uint256 mintAmount) public onlyOwner {
        coinBalance[recipient] += mintAmount;
        emit Transfer(owner, recipient, mintAmount);
    }

    mapping(address => bool) public frozenAccount;
    event FrozenAccount(address target, bool frozen);

    function freezeAccount(address target, bool freeze) public onlyOwner {
        frozenAccount[target] = freeze;
        emit FrozenAccount(target, freeze);
    }
}
