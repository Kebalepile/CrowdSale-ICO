// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./Ownable.sol";

contract SimpleCoin is Ownable {
    constructor(uint256 initialSupply) public {
        owner = msg.sender;
        coinBalance[msg.sender] = initialSupply;
        mint(owner, initialSupply);
    }

    string public constant tokenName = "pearl";
    string public constant tokenSymbol = "SCT";
    uint8 public constant decimals = 18;

    mapping(address => uint256) internal coinBalance;
    mapping(address => mapping(address => uint256)) internal allowances;

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
        require(amount <= allowances[from][msg.sender]);

        coinBalance[from] -= amount;
        coinBalance[to] += amount;
        allowances[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);

        return true;
    }

    function authorize(address authorizedAccount, uint256 allowance)
        public
        returns (bool success)
    {
        allowances[msg.sender][authorizedAccount] = allowance;
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

    event Approval(
        address indexed authorizer,
        address indexed to,
        uint256 value
    );

    function approve(address authorizedAcc, uint256 amt)
        public
        returns (bool success)
    {
        allowances[msg.sender][authorizedAcc] = amt;
        emit Approval(msg.sender, authorizedAcc, amt);
        return true;
    }

    function allowance(address authorizer, address authorizedAccount)
        public
        view
        returns (uint256)
    {
        return allowances[authorizer][authorizedAccount];
    }

    function balanceOf(address owner) public view returns (uint256 balance) {
        return coinBalance[owner];
    }

    // totalSupply returns uint256
}
