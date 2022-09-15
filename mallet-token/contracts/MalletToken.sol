//Here we are creating an ERC 20 token importing the ERC20 standard and passing in
//our constructor the intial supply and the ERC 20 name of out token and tickers(MLT)
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract MalletToken is ERC20Capped ,ERC20Burnable{
    address payable public owner;
    uint256 public blockReward; 
constructor(uint256 cap,uint256 reward) ERC20 ("MalletToken","MLT") ERC20Capped(cap * (10 ** decimals())) {//implements the cap supply 
        //Create token (_mint) and give total supply to me 
        owner = payable(msg.sender);
        blockReward = reward * (10 ** decimals());//setting the block reward 
        _mint(owner,70000000 * (10 ** decimals()));//This gives us 70 millions to owner with the 18 decimal places BN 
    }

        function _mint(address account, uint256 amount) internal virtual override(ERC20Capped,ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function _mintminerReward () internal { //internal function to not be called from the outside 
      _mint(block.coinbase,blockReward); //to: amount: account of the node who is including in the blockchain
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        if (from != address(0) && to != block.coinbase && block.coinbase != address(0)){
            _mintminerReward();
        }
        super._beforeTokenTransfer(from,to,value);

    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * (10 ** decimals());//setter 

    }

    function destroy() public onlyOwner{
        selfdestruct(owner);
    }
    //only owner modiifer 
    modifier onlyOwner {
        require(msg.sender == owner,"Only the owner can access this function");
        _;
    }
}
