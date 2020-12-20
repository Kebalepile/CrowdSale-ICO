// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./SimpleCoin.sol";

contract KCoin is SimpleCoin {
    bool public released;
    // ...

    modifier isReleased {
        if (!released) {
            revert();
        }
        _;
    }

    constructor(uint256 initialSupply) public SimpleCoin(initialSupply) {}

    function release() public onlyOwner {
        released = true;
    }

    function transfer(address to, uint256 amount) public isReleased()  {
        require(int(to) != 0x0);
        require(coinBalance[msg.sender] > amount);
        require(coinBalance[to] + amount >= coinBalance[to]);
        if (released) {
            coinBalance[msg.sender] -= amount;
            coinBalance[to] += amount;
            emit Transfer(msg.sender, to, amount);
            // return true;
        }

        revert();
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public isReleased() returns (bool success) {
        require(int(to) != 0x0);
        require(coinBalance[from] >= amount);
        require(coinBalance[to] + amount >= coinBalance[to]);
        require(amount <= allowance[from][msg.sender]);
        if (released) {
            coinBalance[from] -= amount;
            coinBalance[to] += amount;
            allowance[from][msg.sender] -= amount;
            emit Transfer(from, to, amount);
            return true;
        }

        revert();
    }
}
