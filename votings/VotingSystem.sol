// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract VotingSystem {

    struct Candidate {
        string name;
        uint voteCount;
    }

    address public owner;
    bool public votingActive;
    mapping(address => bool) public hasVoted;
    Candidate[] public candidates;

    constructor(string[] memory candidateNames) {
        owner = msg.sender;
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate(candidateNames[i], 0));
        }
    }

    function startVoting() public onlyOwner {
        votingActive = true;
    }

    function endVoting() public onlyOwner {
        votingActive = false;
    }

    function vote(uint candidateIndex) public {
        require(votingActive, "Voting is not active.");
        require(!hasVoted[msg.sender], "You have already voted.");
        require(candidateIndex < candidates.length, "Invalid candidate index.");

        candidates[candidateIndex].voteCount += 1;
        hasVoted[msg.sender] = true;
    }

    function getCandidate(uint index) public view returns (string memory, uint) {
        require(index < candidates.length, "Invalid candidate index.");
        Candidate memory c = candidates[index];
        return (c.name, c.voteCount);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action.");
        _;
    }
}
