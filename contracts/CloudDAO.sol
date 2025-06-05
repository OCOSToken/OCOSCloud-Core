// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CloudDAO
/// @notice A decentralized governance system for OCOS Cloud to manage proposals and voting using OCOS tokens

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract CloudDAO {
    IERC20 public ocosToken;
    address public admin;

    struct Proposal {
        uint256 id;
        string title;
        string description;
        uint256 startTime;
        uint256 endTime;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
        mapping(address => bool) voters;
    }

    uint256 public nextProposalId;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => string) public results;

    event ProposalCreated(uint256 indexed proposalId, string title);
    event VoteCast(uint256 indexed proposalId, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed proposalId, string result);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor(address _tokenAddress) {
        admin = msg.sender;
        ocosToken = IERC20(_tokenAddress);
    }

    function createProposal(string calldata _title, string calldata _description, uint256 _durationSeconds) external onlyAdmin {
        require(_durationSeconds >= 1 hours, "Minimum duration is 1 hour");

        Proposal storage p = proposals[nextProposalId];
        p.id = nextProposalId;
        p.title = _title;
        p.description = _description;
        p.startTime = block.timestamp;
        p.endTime = block.timestamp + _durationSeconds;
        p.executed = false;

        emit ProposalCreated(nextProposalId, _title);
        nextProposalId++;
    }

    function vote(uint256 _proposalId, bool _support) external {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp >= p.startTime && block.timestamp <= p.endTime, "Voting is closed");
        require(!p.voters[msg.sender], "Already voted");
        require(ocosToken.balanceOf(msg.sender) > 0, "Must hold OCOS to vote");

        p.voters[msg.sender] = true;

        if (_support) {
            p.yesVotes += ocosToken.balanceOf(msg.sender);
        } else {
            p.noVotes += ocosToken.balanceOf(msg.sender);
        }

        emit VoteCast(_proposalId, msg.sender, _support);
    }

    function executeProposal(uint256 _proposalId, string calldata _result) external onlyAdmin {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp > p.endTime, "Voting still ongoing");
        require(!p.executed, "Already executed");

        p.executed = true;
        results[_proposalId] = _result;

        emit ProposalExecuted(_proposalId, _result);
    }

    function transferAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }
}
