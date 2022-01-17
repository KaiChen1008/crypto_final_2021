// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "hardhat/console.sol";
import "./SCN.sol";
import "@openzeppelin/contracts@4.4.2/token/ERC1155/utils/ERC1155Holder.sol";

contract SCS is ERC1155Holder{
    
    mapping(string => Company) public companies;
    mapping(string => bool) public registered;

    string[] public companyNames;
    
    modifier isRegistered(string memory name) {
        require(registered[name], "company does not exist");
        _;
    }

    function addCompoany(string memory _name, string memory _fundingDate, uint _shares, address[] memory _funders, uint _numConfirmationsRequired) public {
        require(registered[_name] == false, "company existed");
        // console.log("msg_sender in SCS:", msg.sender);
        Company c = new Company(_name,  _fundingDate, _shares, _funders, _numConfirmationsRequired);

        companies[_name] = c;
        registered[_name] = true;
        companyNames.push(_name);
    }

    function showCompany() public view{
        for(uint i = 0; i < companyNames.length; ++i) {
            console.log("%s: %s", companyNames[i], address(companies[companyNames[i]]));
        }
    }

    function issue(string memory _name) 
    public 
    isRegistered(_name) 
    {
        Company c = companies[_name];
        c.submitAction(msg.sender, "issue", address(0));
    }

    function reissue(string memory _name) 
    public 
    isRegistered(_name) 
    {
        Company c = companies[_name];
        c.submitAction(msg.sender, "reissue", address(0));
    }

    function transfer(string memory _name, address target) 
    public
    isRegistered(_name)
    {
        Company c = companies[_name];
        c.submitAction(msg.sender, "transfer", target);
    }

    function redeem(string memory _name, address target) 
    public
    isRegistered(_name)
    {
        Company c = companies[_name];
        c.submitAction(msg.sender, "redeem", target);
    }

    function confirmAction(string memory _name, uint _acIndex) 
    public 
    isRegistered(_name)
    {
        Company c = companies[_name];
        c.confirmAction(msg.sender, _acIndex);
    }
}
