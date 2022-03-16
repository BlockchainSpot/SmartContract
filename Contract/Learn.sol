// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract ValueTypes {
    // Write your code here
     bool public b = true;
     
     int public i = -1;
     
     uint public u = 123;
     
     address public addr = ;
     
     bytes32 public b32 = ;


  
    function add(uint x, uint y) external pure returns (uint) {
        return x + y;
    }
    
    function sub(uint x, uint y) external pure returns (uint) {
        return x - y;
    }



}
