// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title zkComputeProof
/// @notice Zero-knowledge compute verification registry for OCOS Cloud tasks

contract zkComputeProof {
    address public admin;

    struct Proof {
        uint256 taskId;
        address submitter;
        string proofHash;        // IPFS or external zk-proof location
        string publicSignals;    // Encoded public inputs used in verification
        uint256 timestamp;
        bool verified;
    }

    mapping(uint256 => Proof) public taskProofs;
    mapping(address => uint256[]) public submittedTasks;

    event ProofSubmitted(uint256 indexed taskId, address indexed submitter, string proofHash);
    event ProofVerified(uint256 indexed taskId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function submitProof(uint256 _taskId, string calldata _proofHash, string calldata _publicSignals) external {
        require(taskProofs[_taskId].timestamp == 0, "Proof already exists");

        taskProofs[_taskId] = Proof({
            taskId: _taskId,
            submitter: msg.sender,
            proofHash: _proofHash,
            publicSignals: _publicSignals,
            timestamp: block.timestamp,
            verified: false
        });

        submittedTasks[msg.sender].push(_taskId);

        emit ProofSubmitted(_taskId, msg.sender, _proofHash);
    }

    function verifyProof(uint256 _taskId) external onlyAdmin {
        require(taskProofs[_taskId].timestamp > 0, "Proof not found");
        require(!taskProofs[_taskId].verified, "Already verified");

        taskProofs[_taskId].verified = true;
        emit ProofVerified(_taskId);
    }

    function getSubmitterTasks(address _submitter) external view returns (uint256[] memory) {
        return submittedTasks[_submitter];
    }

    function transferAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }
}
