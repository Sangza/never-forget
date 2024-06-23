// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Example{
  uint256 a = 100;

  constructor(){
    uint256 x;
    assembly {
        x := sload(0x0)
    }
   console.log(x);

  }
}