pragma solidity^0.5.0;

import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Cogere {
    using SafeMath for uint256;
    
    mapping (address => uint) organisateurs;
    
     constructor() internal {
        organisateurs[msg.sender] = 100;
    }
    
    function transfererOrga(address orga, uint parts) public {
        require(organisateurs[msg.sender] >0);
        require(orga != msg.sender);
        organisateurs[msg.sender] = organisateurs[msg.sender].sub(parts);
        organisateurs[orga] = organisateurs[orga].add(parts);
    }
    
    function estOrga(address orga) public view returns (bool){ 
        return organisateurs[orga] > 0;
    }
}

contract CagnotteFestival is Cogere {
    
    mapping (address => bool) festivaliers;
    mapping (address => string) sponsors;
    mapping (uint => uint) depensesJournaliere;
    mapping (uint => uint) cagnotte;
    uint placesRestantes;
    uint private depensesTotales;
    uint private seuilDepenseJournaliere;
    uint dateFestival;
    uint dateLiquidation;
    uint benefice;
    uint part;
    uint partsRestantes;
    
     constructor(uint date, uint places, uint seuil, uint miseDepart) internal {
        organisateurs[msg.sender] = 100;
        partsRestantes = 100;
        dateFestival = date;
        dateLiquidation = dateFestival + 2 weeks;
        seuilDepenseJournaliere = seuil;
        placesRestantes = places;
        cagnotte[now] = miseDepart;
    }
    
    function acheterTicket() public payable {
        require(msg.value>= 500 finney, "Place à 0.5 Ethers");
        require(placesRestantes>0, "Plus de places !");
        festivaliers[msg.sender]=true;
        placesRestantes -=1;
        cagnotte[now] = cagnotte[now].add(msg.value);
    }
    
    function payer(address payable destinataire, uint montant) public {
        require(estOrga(msg.sender));
        require(destinataire != address(0));
        require(montant>0);
        destinataire.transfer(montant);
    }
    
    function controlerDepense(uint montant) internal view returns (bool){
        return depensesJournaliere[now].add(montant) <= seuilDepenseJournaliere;
    }
    
     function comptabiliserDepense(uint montant) private {
         require (controlerDepense(montant));
         depensesJournaliere[now]=depensesJournaliere[now].add(montant);
        depensesTotales = depensesTotales.add(montant);
    }
    
    function retraitOrganisateur(address payable destinataire) public {
    require(block.timestamp >= dateLiquidation);
    require(estOrga(msg.sender));
    require(organisateurs[msg.sender]>0);
    require(partsRestantes >0);
    require(destinataire != address(0));
    require(cagnotte[now]>depensesTotales);
    benefice = cagnotte[now].sub(depensesTotales);
    part = benefice.div(organisateurs[msg.sender]);
    destinataire.transfer(part);
    partsRestantes=partsRestantes.sub(organisateurs[msg.sender]);
        if (partsRestantes > 0){
            delete organisateurs[msg.sender];
        } else {
            selfdestruct(msg.sender);
        }
    }
    
   function sponsoriser(string memory nom) public payable {
       require(msg.value>= 30 ether, "Sponsorisation pour un minimum de 30 Ethers");
       sponsors[msg.sender]=nom;
   }
   
   function () external payable {
       
   }
}

contract LoterieFestival is CagnotteFestival {
    using SafeMath for uint256;
    mapping (address => bool) festivaliers;
    mapping (address => uint8) numeroLoterie;
    uint dateLoterieStart;
    uint dateTirage;
    uint nbTire;
    bytes32 number;
    uint8[] nbchoisis;
    address[] participants;
    uint gain;
    
    constructor (uint date) public {
        dateLoterieStart = date;
        dateTirage = date + 5 days;
        number =blockhash(block.number -1);
        gain=0;
    }
    
    
    function convert(bytes32 b) public pure returns(uint) {
        return uint(b);
    }
    
    function acheterTicketLoterie(uint8 nbchoisi) public payable {
        require(festivaliers[msg.sender]=true);
        require(nbchoisi>=0,"Le nombre choisi doit être entre 0 et 255");
        require(nbchoisi+1>nbchoisi, "Le nombre choisi doit être entre 0 et 255");
        require(msg.value>= 100 finney,"Billet de loterie à 0.1 Ethers");
        numeroLoterie[msg.sender]=nbchoisi;
        nbchoisis.push(nbchoisi);
        participants.push(msg.sender);
        gain=gain.add(msg.value);
    }
    
   
    function tirage() private returns(bool){
        require(now>=dateTirage);
        nbTire=uint8(convert(number));
        for (uint i=0;i<nbchoisis.length;i++){
            if (nbTire==nbchoisis[i]){
                return true;
            }
            else {
                return false;
            }
        }
    }
    
    function payerLoterie(address payable destinataire) public {
        require(block.timestamp >= dateLiquidation);
        require(numeroLoterie[destinataire]>0);
        require(destinataire != address(0));
        require(gain>0);
        require(tirage());
        require(numeroLoterie[destinataire]==nbTire);
        destinataire.transfer(gain);
    }
    
     function () external payable {
       
   }
}

