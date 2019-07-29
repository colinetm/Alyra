pragma solidity ^0.5.7;
contract Assemblee {
    address[] membres;
    address[] admins;
    
    string public nomAssemblee;
    
    constructor(string memory nom) public {
        nomAssemblee = nom;
        admins.push(msg.sender);
    }
    
    function rejoindre() public {
        membres.push(msg.sender);
    }
    
    function estMembre(address utilisateur) public view returns (bool){
         for (uint i=0; i<membres.length; i++){
             if(membres[i]==utilisateur){
                 return true;
             } else {
                 return false;
             }
         }
    }
    
    struct Decision {
        string description;
        uint votesPour;
        uint votesContre;
        mapping (address => bool) aVote;
        uint timeStart;
        uint voteEndTime;
    }
    
    Decision[] decisions;
    
    function proposerDecision(string memory description) public {
       require(estMembre(msg.sender));
       decisions.push(Decision(description,0,0,now,604800));
       
    }
    
    
    function voter(uint vote,bool sens)public {
        require(estMembre(msg.sender));
        require(vote<decisions.length);
        require(decisions[vote].aVote[msg.sender]=false);
        require(now < decisions[vote].timeStart + decisions[vote].voteEndTime);
        if (sens==true){
            decisions[vote].votesPour +=1;
        } else {
            decisions[vote].votesContre +=1;
        }
    }

    function comptabiliser(uint indice) public view returns (int){
        require(indice<decisions.length);
        return int(decisions[indice].votesPour-decisions[indice].votesContre);
    }
    
    function estAdmin (address utilisateur) public view returns (bool){
         for (uint i=0; i<admins.length; i++){
             if(admins[i]==utilisateur){
                 return true;
             } else {
                 return false;
             }
         }
    }
    
    function nommerAdmin (address pretendant) public {
        require(estAdmin(msg.sender));
        require(estMembre(pretendant));
        require(estAdmin(pretendant) ==false);
        admins.push(pretendant);
    }
    
    function fermerDecision (uint vote) public {
       require(estAdmin(msg.sender));
       uint time= now-decisions[vote].timeStart;
       decisions[vote].voteEndTime=time;
    }
    
    function demissionAdmin (address admin) public {
        require(estAdmin(msg.sender));
        for (uint i=0; i<admins.length; i++){
            if(admins[i]==admin){
                admins[i]=admins[admins.length-1];
                admins.pop();
            }
        }
    }
}