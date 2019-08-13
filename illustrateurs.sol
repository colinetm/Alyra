pragma solidity ^0.5.7;

pragma experimental ABIEncoderV2;
import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract MarcheIllustrateurs {
    
    using SafeMath for uint256;
    
    address payable plateformeAdresse;
    uint numOffre;
    uint numCadidature;
    enum StatutDemande {Ouverte, Encours, Fermee}
    enum Satisfaction {Mauvais, Correct, Bon, Tresbon}
    
    constructor() public {
        plateformeAdresse=msg.sender;
        numOffre=0;
        numCadidature=0;
    }
    
    struct Illustrateur {
        string Name;
        address payable Identification;
        string Mail;
        uint Notoriete;
        string Urlbook;
    }
    
    struct Offre {
        string Entreprise;
        address Demandeur;
        string Mail;
        string Descriptif;
        uint NotorieteMin;
        uint Remuneration;
        uint Delai;
        StatutDemande statut;
    }
    
    struct Candidature {
        uint NumeroOffre;
        string Name;
        address payable Identification;
    }
    
    mapping (address => Illustrateur) private inscripts;
    mapping (uint => Offre) private demandes;
    mapping (uint => Candidature)public reponses;
   
    
    Illustrateur[] private illustrateurs;
    Offre[] private offres;
    Candidature[] public candidatures;
    uint[][] public listReponses;
    uint[] public illustrateursRetenus;
    bytes32[] private livraisons;
    uint[] private datesRendus;
    uint[] private dateLivraison;
    
    
    function payer(address payable destinataire, uint montant) public {
        require(destinataire != address(0));
        require(montant>0);
        destinataire.transfer(montant);
    }
    
    function inscription(string memory name, address payable identification, string memory mail, string memory urlbook) public returns(string memory message) {
        if (inscripts[identification].Identification==identification){
            message="Vous êtes déjà inscrit!";
            return message;
        } else {
        Illustrateur memory nouvelIllustrateur=Illustrateur(name, identification, mail, 1, urlbook);
        inscripts[identification]=nouvelIllustrateur;
        illustrateurs.push(Illustrateur(name, identification, mail, 1, urlbook));
        message="Bravo! Vous venez de vous inscrire.";
        return message;
        }
    }
    
    function voirIllustrateur(address _address)public view returns(string memory, address, string memory, string memory){
        return (inscripts[_address].Name, inscripts[_address].Identification, inscripts[_address].Mail, inscripts[_address].Urlbook);
    }
    
    function voirLesIllustrateurs()public view returns(Illustrateur[] memory){
        return illustrateurs;
    }
    
    function ajouterDemande(string memory entreprise, address demandeur,string memory mail, string memory descriptif, uint notorieteMin, uint remuneration, uint delai) public payable {
        Offre memory nouvelleOffre = Offre(entreprise, demandeur, mail, descriptif, notorieteMin, remuneration, delai, StatutDemande.Ouverte);
        demandes[numOffre]=nouvelleOffre;
        offres.push(Offre(entreprise, demandeur, mail, descriptif, notorieteMin, remuneration, delai, StatutDemande.Ouverte));
        uint montant;
        montant=remuneration.add((remuneration.mul(2)).div(100));
	montant=msg.value;
        payer(plateformeAdresse, montant);
        numOffre=numOffre++;
    }
    
    function voirOffre(uint numOffreRecherche)public view returns(Offre memory){
        return (demandes[numOffreRecherche]);
    }
    
    function voirLesOffres()public view returns(Offre[] memory){
        return offres;
    }
    
    function postuler(uint numDeOffre, string memory name, address payable _address) public{
        require(inscripts[_address].Identification==_address,"Il faut vous inscrire pour postuler");
        require(_address==msg.sender, "Attention vous postulez pour quelqu'un d'autre");
		require(demandes[numDeOffre].NotorieteMin<=inscripts[_address].Notoriete);
        Candidature memory nouvelleCandidature = Candidature(numDeOffre, name, _address);
        candidatures.push(nouvelleCandidature);
        reponses[numCadidature]=nouvelleCandidature;
        listReponses[numDeOffre].push(numCadidature);
        numCadidature=numCadidature++;
    }
    
    function afficherCandidature(uint numDeOffre)public view returns(uint, string memory, address){
        if (listReponses[numDeOffre].length>0){
            for (uint i=0;i<listReponses[numDeOffre].length;i.add(1)){
                uint a=listReponses[numDeOffre][i];
                return (a, reponses[a].Name,reponses[a].Identification);
            }
        }
        
    }
    
    function accepterOffre(uint numDeOffre, uint numCandidature) private returns(uint){
        demandes[numDeOffre].statut=StatutDemande.Encours;
        illustrateursRetenus[numDeOffre]=numCandidature;
        datesRendus[numDeOffre]=block.timestamp.add(demandes[numDeOffre].Delai);
        return numCandidature;
    }
    
    function afficherIllustrateurRetenu(uint numDeOffre)public view returns(string memory, address){
        require(illustrateursRetenus[numDeOffre]>=0, "Aucun illustrateur retenu pour l'instant");
        uint a=illustrateursRetenus[numDeOffre];
        return (reponses[a].Name,reponses[a].Identification);
    }
    
    function produireHash(string memory url) public pure returns (bytes32) {
       return keccak256(bytes(url));
   }
    
    function livraison(uint numDeOffre, bytes32 dessin, address payable illustrateur) public {
        require(inscripts[illustrateur].Identification==msg.sender);
        livraisons[numDeOffre]=dessin;
        dateLivraison[numDeOffre]=block.timestamp;
        inscripts[illustrateur].Notoriete=(inscripts[illustrateur].Notoriete).add(1);
        uint montant;
        montant=(demandes[numDeOffre].Remuneration).div(2);
        payer(illustrateur,montant);
    }
    
    function retard(uint numDeOffre) public {
        require(demandes[numDeOffre].Demandeur==msg.sender);
        require(datesRendus[numDeOffre]<block.timestamp);
        require(livraisons[numDeOffre]>0);
        address illustrateur;
        uint a=illustrateursRetenus[numDeOffre];
        illustrateur=reponses[a].Identification;
        inscripts[illustrateur].Notoriete=(inscripts[illustrateur].Notoriete).sub(1);
    }
    
    function accepterTravail(uint numDeOffre)private returns(bool) {
        require(demandes[numDeOffre].Demandeur==msg.sender);
        require(dateLivraison[numDeOffre] + 1 weeks > block.timestamp);
        address payable illustrateur;
        uint a=illustrateursRetenus[numDeOffre];
        illustrateur=reponses[a].Identification;
        uint montant;
        montant=(demandes[numDeOffre].Remuneration).div(2);
        payer(illustrateur,montant);
        demandes[numDeOffre].statut=StatutDemande.Fermee;
        return true;
    }
    
    function appreciation(uint numDeOffre, Satisfaction _satisfaction)public {
        address illustrateur;
        uint a=illustrateursRetenus[numDeOffre];
        illustrateur=reponses[a].Identification;
         if (_satisfaction==Satisfaction.Tresbon){
            inscripts[illustrateur].Notoriete=(inscripts[illustrateur].Notoriete).add(3);
        } else if (_satisfaction==Satisfaction.Bon) {
            inscripts[illustrateur].Notoriete=(inscripts[illustrateur].Notoriete).add(2);
        } else if (_satisfaction==Satisfaction.Correct){
            inscripts[illustrateur].Notoriete=(inscripts[illustrateur].Notoriete).add(1);
        } else {
            inscripts[illustrateur].Notoriete=(inscripts[illustrateur].Notoriete).sub(1);
        }
    }
    
    function etrePayer(uint numDeOffre, address payable illustrateur) public {
        require(dateLivraison[numDeOffre] + 1 weeks < block.timestamp, "Atendez quelques jours");
        require(inscripts[illustrateur].Identification==msg.sender);
        require(accepterTravail(numDeOffre));
        uint montant;
        montant=(demandes[numDeOffre].Remuneration).div(2);
        payer(illustrateur,montant);
        demandes[numDeOffre].statut=StatutDemande.Fermee;
    }
    
    function () external payable {
       
   }
}
