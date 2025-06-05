// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title NodeSentinel
/// @notice Smart contract for logging node uptime, latency, and signal events for monitoring OCOS Cloud reliability

contract NodeSentinel {
    address public admin;

    struct NodeStatus {
        uint256 lastHeartbeat;
        uint256 avgLatencyMs;
        uint256 uptimeBlocks;
        uint256 totalFailures;
        bool flagged;
    }

    mapping(uint256 => NodeStatus) public nodeLogs; // nodeId => status

    event Heartbeat(uint256 indexed nodeId, uint256 blockNumber, uint256 latencyMs);
    event NodeFlagged(uint256 indexed nodeId, string reason);
    event NodeCleared(uint256 indexed nodeId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function submitHeartbeat(uint256 _nodeId, uint256 _latencyMs) external {
        NodeStatus storage node = nodeLogs[_nodeId];

        if (block.number > node.lastHeartbeat) {
            node.uptimeBlocks += (block.number - node.lastHeartbeat);
        }

        node.lastHeartbeat = block.number;
        node.avgLatencyMs = (node.avgLatencyMs + _latencyMs) / 2;

        emit Heartbeat(_nodeId, block.number, _latencyMs);
    }

    function reportFailure(uint256 _nodeId) external onlyAdmin {
        nodeLogs[_nodeId].totalFailures++;
    }

    function flagNode(uint256 _nodeId, string calldata _reason) external onlyAdmin {
        nodeLogs[_nodeId].flagged = true;
        emit NodeFlagged(_nodeId, _reason);
    }

    function clearNode(uint256 _nodeId) external onlyAdmin {
        nodeLogs[_nodeId].flagged = false;
        emit NodeCleared(_nodeId);
    }

    function getNodeStatus(uint256 _nodeId) external view returns (
        uint256 lastBlock,
        uint256 latency,
        uint256 uptime,
        uint256 failures,
        bool isFlagged
    ) {
        NodeStatus storage n = nodeLogs[_nodeId];
        return (n.lastHeartbeat, n.avgLatencyMs, n.uptimeBlocks, n.totalFailures, n.flagged);
    }

    function transferAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }
}
