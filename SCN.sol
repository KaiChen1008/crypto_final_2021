// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "hardhat/console.sol";
import "@openzeppelin/contracts@4.4.2/token/ERC1155/ERC1155.sol";

contract Company is ERC1155 {

    uint TOKENID = 0;
    struct Action {
        address promotor;
        bool executed;
        uint numConfirmations;
        string actionName;
        address target;
    }

    string name;
    string fundingDate;
    uint shares;
    address[] public funders;
    uint public numConfirmationsRequired;

    Action[] public actions;

    mapping(address => bool) public isFunder;
    mapping(string => bool) public isValidAction;
    mapping(uint => mapping(address => bool)) public isConfirmed;

    event SubmitAction(
        address indexed promotor,
        uint indexed acIndex
    );

    event ConfirmAction(
        address indexed funder,
        uint indexed acIndex
    );

    modifier onlyFunder(address _funder) {
        require(isFunder[_funder], "not funder");
        _;
    }

    modifier onlyValidAction(string memory _action) {
        require(isValidAction[_action], "action is invalid");
        _;
    }

    modifier notExecuted(uint _acIndex) {
        require(!actions[_acIndex].executed, "action already exectued");
        _;
    }
    
    modifier notConfirmed(address _funder, uint _acIndex) {
        require(!isConfirmed[_acIndex][_funder], "action already confirmed");
        _;
    }

    constructor(string memory _name, string memory _fundingDate, uint _shares, address[] memory _funders, uint _numConfirmationsRequired) ERC1155("https://abcoathup.github.io/SampleERC1155/api/token/{id}.json") {
        require(_funders.length > 0, "owners required");
        require(_numConfirmationsRequired > 0 && 
                _numConfirmationsRequired <= _funders.length,
                "invalid number of required confirmations"
        );
        require(_shares > 0, "shares should be at least 1");

        for (uint i = 0; i < _funders.length; i++) {
            address funder = _funders[i];

            require(funder != address(0), "invalid owner");
            require(!isFunder[funder], "funder not unique");

            isFunder[funder] = true;
            funders.push(funder);
        }

        numConfirmationsRequired = _numConfirmationsRequired;
        name = _name;
        fundingDate = _fundingDate;
        shares = _shares;

        // mint the genesis SCN
        _mint(msg.sender, TOKENID, shares, "");

        isValidAction["issue"] = true;
        isValidAction["reissue"] = true;
        isValidAction["transfer"] = true;
        isValidAction["redeem"] = true;
    }

    function compareString(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function submitAction(address _promotor, string memory _actionName, address _target) 
    public 
    onlyFunder(_promotor)
    onlyValidAction(_actionName)
    {

        if (compareString(_actionName, "transfer") || compareString(_actionName, "redeem") ) {
            require(_target != address(0));
        }

        uint acIndex = actions.length;
        actions.push(
            Action({
                promotor: _promotor,
                executed: false,
                numConfirmations: 0,
                actionName: _actionName,
                target: _target
            })
        );

        emit SubmitAction(_promotor, acIndex);
    }
    
    function confirmAction(address _funder, uint _acIndex)
    public
    onlyFunder(_funder)
    notExecuted(_acIndex)
    notConfirmed(_funder, _acIndex)
    {
        Action storage action = actions[_acIndex];
        action.numConfirmations += 1;
        isConfirmed[_acIndex][_funder] = true;

        if (action.numConfirmations >= numConfirmationsRequired) {
            executeAction(_acIndex);
        }

        emit ConfirmAction(_funder, _acIndex);
    }

    function executeAction(uint _acIndex) private{
        Action storage action = actions[_acIndex];

        action.executed = true;

        if (compareString(action.actionName, "issue")) {
            issue();
        }else if (compareString(action.actionName, "reissue")) {
            reissue();
        }else if (compareString(action.actionName, "transfer")) {
            transfer(action.target);
        }else if (compareString(action.actionName,"redeem")) {
            redeem(action.target);
        }
    }

    function issue() private {
        _mint(msg.sender, TOKENID, 1, "");
        console.log("issue a token");
    }
    
    function reissue() private {
        _burn(msg.sender, TOKENID, 1);
        _mint(msg.sender, TOKENID, 2, "");
        console.log("reissue 2 token");
    }

    function transfer(address target) private {
        safeTransferFrom(msg.sender, target, TOKENID, 1, "");
        console.log("transfered");
    }

    function redeem(address target) private {
        safeTransferFrom(target, msg.sender, TOKENID, 1, "");
        _burn(msg.sender, TOKENID, 1);
        console.log("redeemed");
    }
}
