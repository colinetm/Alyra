pragma solidity ^0.5.7;

import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Credibilite {
  
   using SafeMath for uint256;
  
   mapping (address => uint256) public cred;
   bytes32[] private devoirs;
   
   function produireHash(string memory url) public pure returns (bytes32) {
       return keccak256(bytes(url));
   }
   
   function transfer(address destinataire, uint256 valeur) public {
       require(cred[msg.sender] > valeur);
       require(cred[destinataire]>0);
       cred[msg.sender]=cred[msg.sender].sub(valeur);
       cred[destinataire]=cred[destinataire].add(valeur);
   }
   
   function remettre(bytes32 dev) public returns(uint){
       devoirs.push(dev);
       
       uint ordre=devoirs.length;
       uint valeur=10;
       
       if (ordre==1){
           valeur=30;
       }
       if (ordre==2){
           valeur=20;
       }
       
       cred[msg.sender]=cred[msg.sender].add(valeur);
       return ordre;
   }

}


Deployé à l'adresse :
0x5243cce0e6b7822045cb7c8607a4892d860111f3

