pragma solidity ^0.5.0;

import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Pulsation {

    using SafeMath for uint256;
    
    uint public battement;
    string private message;

    constructor(string memory m) public {
        battement = 0;
        message = m;
    }

    function ajouterBattement() public returns(string memory) {
        battement=battement.add(1);
        return message;
    }
}

contract Pendule {
    Pulsation pulse;
    
    constructor()public{
        pulse=new Pulsation("tic");
    }
    
    function provoquerUnePulsation()public{
        pulse.ajouterBattement();
    }
}

contract PenduleTicTac {
    string[] public balancier;
    Pulsation tic;
    Pulsation tac;
    
    
    function ajouterTicTac(Pulsation unTic, Pulsation unTac)public {
        tic=unTic;
        tac=unTac;
    }
    
     function mouvementsBalancier() public {
        balancier.push(tic.ajouterBattement());
        balancier.push(tac.ajouterBattement());
     }
}

contract PenduleTicTacBalancier {
    using SafeMath for uint256;
    
    string[] public balancier;
    Pulsation tic;
    Pulsation tac;
    
    
    constructor() public {
       tic = new Pulsation("tic");
       tac = new Pulsation("tac");
    }
    
     function mouvementsBalancier(uint k) public {
         for(uint i=0;i<k;i.add(1)){
             if(balancier.length%2==0){
                balancier.push(tic.ajouterBattement()); 
             }
             else {
                balancier.push(tac.ajouterBattement()); 
             }
         }
     }
}