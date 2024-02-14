// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract VerifySig{

// message to sign
// Hash(message)
// sign(hash(message), private key) | Offchain
// ecrecover(hash(message), signature) == signer

function Verify(address _signer, string memory _message, bytes memory _sig) public pure returns(bool) {
    bytes32 messageHash = getMessageHash(_message);
    bytes memory ethSignedMessageHash = ethGetMessageHash(messageHash);
    return recover(ethSignedMessageHash, _sig) == _signer;
}

function getMessageHash(string memory _message) public pure returns(bytes32){
    return keccak256(abi.encodePacked(_message));
}

function ethGetMessageHash(bytes32 _messageHash) public pure returns(bytes memory){
    return abi.encodePacked("\x19Ethereum Signed Message:\n", _messageHash);
}


function recover(bytes memory _ethSignedMessage, bytes memory _sig) public pure returns (address) {
    (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
    bytes32 ethSignedMessageHash = abi.decode(_ethSignedMessage, (bytes32));
    return ecrecover(ethSignedMessageHash, v, r, s);
}

function _split(bytes memory _sig) internal pure returns(bytes32 r, bytes32 s, uint8 v){
require(_sig.length==65, "invalid signature strength");

assembly{
    r := mload(add(_sig, 32))
    s := mload(add(_sig, 64))
    v := byte(0, mload(add(_sig, 96)))
}

}

}


// Firstly, the hash of a message is generated
// then the message which is hashed is converted into Ethereum Signed Message format
// After that in recover function, firstly a function called split is used to extract the value of _r, _s and _v
// then it is encrypted with the hashed message to create the public key and derive the ethereum address
// and finally in verify function then the generated ethereum address is compared with the user ethereum address 
// and then if it returns true
// it means that the account is verified and if it rturns false then it means that the verefied account is not 
// correct.

// MessageHash : 0x21d06c7ac0bff3ba7b621b61728e7b38d9e107eaa595be84c301beb00f827266
// Signature : 0x5f15377ab560a64c1641c0f3cde89a4b041ac5460c4e18c63c441beaf7b7b3571abc29333306cf0e754e317a88443554e1c6e85aeb6297ddcd73de4612e0a0d61c  
// ethGetMessage : 0x19457468657265756d205369676e6564204d6573736167653a0a21d06c7ac0bff3ba7b621b61728e7b38d9e107eaa595be84c301beb00f827266  
// signer : 0xe07C4cb1870c1FA37eC3c641B781286125a0a5FC

// So, firstly we hashed the message and then we generated the signature by a random account
// Then, we hashed the hashed message with a preffix to get hash in Ethereum Signed Message format
// Now to recover the signer, we will have to generate a hash by encrypting the hash in Ethereum Signed Message Format and the signature
// Then we will put the value of signer, message and signature to see if the message is right and is of the right owner.
