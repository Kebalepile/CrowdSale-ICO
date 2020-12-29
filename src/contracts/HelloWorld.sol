// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract HelloWorld {
  bytes32 message;
  function setMessage(bytes32 str) external {
    message = str;
  }
  function getMessage() view external returns(bytes32) {
        return message;
  }
}
