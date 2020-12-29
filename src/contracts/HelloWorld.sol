// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract HelloWorld {
  string message;
  function setMessage(string calldata msgStr) external {
    message = msgStr;
  }
  function getMessage() view external returns(string memory) {
        return message;
  }
}
