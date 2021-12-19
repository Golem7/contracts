// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import 'base64-sol/base64.sol';


contract GolemVII is ERC1155, Ownable, Pausable, VRFConsumerBase {
    uint256 public constant SCRAP = 0;
    uint256 public constant FUEL = 1;

    uint256 public constant GOLEM = 10;

    uint256 public golemIdCounter = 0;

    bytes32 internal keyHash;
    uint256 public fee;


    struct Golem {
        string name;
        uint8 attribute1;
        uint8 attribute2;
        uint8 attribute3;
        uint8 attribute4;
        uint8 attribute5;
        uint8 attribute6;
        uint8 attribute7;
    }
    

    mapping (uint256 => Golem) private _tokenDetails;
    mapping (uint256 => uint256) private _tokenIdToRandomNumber;
    mapping (uint256 => string) private _tokenIdIdToTokenURI;


    mapping (bytes32 => uint256) public requestIdToTokenId;
    mapping (bytes32 => address) public requestIdToSender;


    event requestedGolem(bytes32 indexed requestId);

    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash) 
    VRFConsumerBase(_VRFCoordinator, _LinkToken)
    ERC1155("JSON_URI") {
        keyHash = _keyhash;
        fee = 0.0001 * 10 ** 18; 
    }

    function getTokenDetails(uint256 tokenId) public view returns(Golem memory){
        return _tokenDetails[tokenId];
    }

    function uri(uint256 tokenId) override public view returns (string memory) {
        return(_tokenIdIdToTokenURI[tokenId]);
    }

    function newMintGolem()
    public returns (bytes32)
    {
        bytes32 requestId = requestRandomness(keyHash, fee);
        requestIdToSender[requestId] = msg.sender;
        emit requestedGolem(requestId);
        return requestId;
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override{
        address golemOwner = requestIdToSender[requestId];
        uint256 newItemId = GOLEM + golemIdCounter;
        _tokenDetails[newItemId] = Golem(
            "NAME",  //TODO: generate random name of Golems
            uint8(randomNumber%50),
            uint8((randomNumber%5000)/100),
            uint8((randomNumber%500000)/10000),
            uint8((randomNumber%50000000)/1000000),
            uint8((randomNumber%5000000000)/100000000),
            uint8((randomNumber%500000000000)/10000000000),
            uint8((randomNumber%50000000000000)/1000000000000));
        _tokenIdToRandomNumber[newItemId] = randomNumber;
        _tokenIdIdToTokenURI[newItemId] = formatTokenURI("", newItemId);
        requestIdToTokenId[requestId] = newItemId;
        _mint(golemOwner, newItemId, 1, "");
        golemIdCounter++;
    }

    function formatTokenURI(string memory image_data, uint256 tokenId) public returns (string memory) {
        return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "', _tokenDetails[tokenId].name, '",',
                                '"image_data": "', image_data, '",',
                                '"attributes": [', generate_attributes(_tokenDetails[tokenId]),
                                ']}'
                            )
                        )
                    )
                )
            );
    }

    function generate_attributes(Golem memory golem) internal returns (string memory){
        return string(abi.encodePacked(
            genrate_attribute("attribute1", toString(golem.attribute1)),', ',
            genrate_attribute("attribute2", toString(golem.attribute2)),', ',
            genrate_attribute("attribute3", toString(golem.attribute3)),', ',
            genrate_attribute("attribute4", toString(golem.attribute4)),', ',
            genrate_attribute("attribute5", toString(golem.attribute5)),', ',
            genrate_attribute("attribute6", toString(golem.attribute6)),', ',
            genrate_attribute("attribute7", toString(golem.attribute7))


        ));
    }

    function genrate_attribute(string memory name, string memory value) internal pure returns (string memory){
        return string(abi.encodePacked(
            '{"trait_type": "', name, '", "value": ', value, '}'
        ));
    }

    function toString(uint value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint temp = value;
        uint digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint8(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}