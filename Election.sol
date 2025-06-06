// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Election {
    string[] public electors;

    uint256 public maxVotes;
    uint256 public allVotes;
    uint256 public electionEndTime;
    address public owner;
    bool public isElectionActive;

    mapping(address => bool) public userVotes;

    mapping(uint256 => uint256) public numberOfVotes;

    constructor(string[] memory _electors, uint256 _maxVotes,uint256 _electionEndTime) {
        electors = _electors;
        maxVotes = _maxVotes;
        owner = msg.sender;
        isElectionActive = true;
        electionEndTime = _electionEndTime + block.timestamp;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not the contract owner");
        _;
    }

    function vote(uint256 _number) public {
        require(userVotes[msg.sender] == false, "Your address can't vote");
        require(_number < electors.length, "Elector does not exist");
        require(maxVotes > allVotes, "Maximum number of votes exceeded");
        require(owner != msg.sender, "Owner doesn`t vote");
        require(isElectionActive == true, 'Elections are closed');
        require(block.timestamp < electionEndTime, 'Time of elections is ended');
        userVotes[msg.sender] = true;
        numberOfVotes[_number] += 1;
        allVotes += 1;
    }

    function stopVote() public onlyOwner {
        electionEndTime = block.timestamp;
    }

    function resetMaxVotes(uint256 _newMaxVotes) public onlyOwner {
         require(_newMaxVotes > maxVotes,"You can`t decrease maxVotes");
         maxVotes = _newMaxVotes;
      
    }
}









}
