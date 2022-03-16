// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Allowance is Ownable {

    event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);

    mapping(address => uint) public allowance;

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }

    function setAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, 'Get allowed from Owner');
        _;
    }

    function reduceAllowance(address _who, uint _amount) internal ownerOrAllowed(_amount) {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        allowance[_who] -= _amount;
    }
}

contract shareWallet is Allowance {

    event MoneySend(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);    

    function withdrawMoney (address payable _to, uint _amount) public ownerOrAllowed(_amount) {
           require(_amount <= address(this).balance, "Contract doesn't own enough money");
        if(!isOwner()){
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySend(_to,_amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() public override  {

       revert("Can not renounce to the Ownership!");

    }
    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
        
    }
}