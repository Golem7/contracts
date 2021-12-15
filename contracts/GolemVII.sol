// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract GolemVII is ERC1155, Ownable, Pausable, VRFConsumerBase {
    uint256 public constant SCRAP = 0;
    uint256 public constant FUEL = 1;

    uint256 public constant SHIP = 10;

    uint256 public shipIdCounter = 0;

    bytes32 internal keyHash;
    uint256 public fee;


    struct Ship {
        uint8 attackpower;
        uint8 shields;
        uint8 fuelefficiency;
        uint8 mining;
        uint8 computerpower;
    }
    

    mapping (uint256 => Ship) private _tokenDetails;
    mapping (uint256 => uint256) private tokenIdToRandomNumber;
    mapping (bytes32 => uint256) public requestIdToTokenId;
    mapping (bytes32 => address) public requestIdToSender;
    mapping (bytes32 => string) public requestIdToTokenURI;

    event requestedShip(bytes32 indexed requestId);

    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash) 
    VRFConsumerBase(_VRFCoordinator, _LinkToken)
    ERC1155("JSON_URI") {
        keyHash = _keyhash;
        fee = 0.0001 * 10 ** 18; 
    }

    function getTokenDetails(uint256 tokenId) public view returns(Ship memory){
        return _tokenDetails[tokenId];
    }

    function newMintShip(string memory tokenURI)
    public returns (bytes32)
    {
        bytes32 requestId = requestRandomness(keyHash, fee);
        requestIdToSender[requestId] = msg.sender;
        requestIdToTokenURI[requestId] = tokenURI;
        emit requestedShip(requestId);
        return requestId;
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override{
        address shipOwner = requestIdToSender[requestId];
        // string memory tokenURI = requestIdToTokenURI[requestId];
        uint256 newItemId = SHIP + shipIdCounter;
        _tokenDetails[newItemId] = Ship(
            uint8(randomNumber%50),
            uint8((randomNumber%5000)/100),
            uint8((randomNumber%500000)/10000),
            uint8((randomNumber%50000000)/1000000),
            uint8((randomNumber%5000000000)/100000000));
        tokenIdToRandomNumber[newItemId] = randomNumber;
        requestIdToTokenId[requestId] = newItemId;
        _mint(shipOwner, newItemId, 1, "");
        shipIdCounter++;
    }
}