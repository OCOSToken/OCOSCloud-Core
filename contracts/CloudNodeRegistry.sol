// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CloudNodeRegistry
/// @notice Maintains a decentralized registry of compute and storage nodes on OCOS Cloud

contract CloudNodeRegistry {
    address public admin;

    enum NodeType { Compute, Storage }

    struct Node {
        NodeType nodeType;
        address operator;
        string metadataURI;     // IPFS or external metadata describing node specs
        uint256 registeredAt;
        bool active;
    }

    uint256 public nextNodeId;
    mapping(uint256 => Node) public nodes;
    mapping(address => uint256[]) public operatorNodes;

    event NodeRegistered(uint256 indexed nodeId, address indexed operator, NodeType nodeType);
    event NodeDeactivated(uint256 indexed nodeId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier onlyOperator(uint256 _nodeId) {
        require(nodes[_nodeId].operator == msg.sender, "Not node operator");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerNode(NodeType _type, string calldata _metadataURI) external returns (uint256) {
        uint256 nodeId = nextNodeId++;

        nodes[nodeId] = Node({
            nodeType: _type,
            operator: msg.sender,
            metadataURI: _metadataURI,
            registeredAt: block.timestamp,
            active: true
        });

        operatorNodes[msg.sender].push(nodeId);

        emit NodeRegistered(nodeId, msg.sender, _type);
        return nodeId;
    }

    function deactivateNode(uint256 _nodeId) external onlyOperator(_nodeId) {
        require(nodes[_nodeId].active, "Node already inactive");
        nodes[_nodeId].active = false;

        emit NodeDeactivated(_nodeId);
    }

    function getOperatorNodes(address _operator) external view returns (uint256[] memory) {
        return operatorNodes[_operator];
    }

    function getActiveNodes() external view returns (uint256[] memory) {
        uint256 total = nextNodeId;
        uint256 count;

        for (uint i = 0; i < total; i++) {
            if (nodes[i].active) count++;
        }

        uint256[] memory active = new uint256[](count);
        uint256 index;

        for (uint i = 0; i < total; i++) {
            if (nodes[i].active) {
                active[index++] = i;
            }
        }

        return active;
    }

    function transferAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }
}
