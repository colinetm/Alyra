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
        uint[] ListReponses;
    }
    
    struct Candidature {
        uint NumeroOffre;
        uint numCadidature;
        string Name;
        address payable Identification;
    }
    
    mapping (address => Illustrateur) private inscripts;
    mapping (uint => Offre) private demandes;
    mapping (uint => Candidature) private reponses;
    mapping (uint => uint) private illustrateursRetenus;
    mapping (uint => uint) private datesRendus;
    mapping (uint => uint) private dateLivraison;
    mapping (uint => bytes32) private livraisons;
    mapping (uint => bool)private travailAccepte;
   
    
    Illustrateur[] private illustrateurs;
    Offre[] private offres;
    Candidature[] private candidatures;
   
    
    function payer(address payable destinataire, uint montant) private {
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
        uint[] memory listReponses;
        Offre memory nouvelleOffre = Offre(entreprise, demandeur, mail, descriptif, notorieteMin, remuneration, delai, StatutDemande.Ouverte, listReponses);
        demandes[numOffre]=nouvelleOffre;
        offres.push(Offre(entreprise, demandeur, mail, descriptif, notorieteMin, remuneration, delai, StatutDemande.Ouverte, listReponses));
        uint montant;
        montant=remuneration.add((remuneration.mul(2)).div(100));
        montant=msg.value;
        payer(plateformeAdresse, montant);
        numOffre=numOffre.add(1);
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
        Candidature memory nouvelleCandidature = Candidature(numDeOffre, numCadidature, name, _address);
        candidatures.push(nouvelleCandidature);
        reponses[numCadidature]=nouvelleCandidature;
        (demandes[numDeOffre].ListReponses).push(numCadidature);
        numCadidature=numCadidature.add(1);
    }
    
    function afficherCandidature(uint numDeOffre)public view returns (uint[] memory){
       uint[] memory liste=demandes[numDeOffre].ListReponses;
       return liste;
    }
    
    function afficherCandidat(uint numCandidature)public view returns (uint, string memory, address){
        return (reponses[numCandidature].NumeroOffre,reponses[numCandidature].Name,reponses[numCandidature].Identification);
    }
    
    function accepterOffre(uint numDeOffre, uint numCandidature) public {
        require(demandes[numDeOffre].Demandeur==msg.sender, "Seul celui qui a déposé la demande peut choisir le candidat");
        demandes[numDeOffre].statut=StatutDemande.Encours;
        illustrateursRetenus[numDeOffre]=numCandidature;
        datesRendus[numDeOffre]=block.timestamp.add(demandes[numDeOffre].Delai);
        
    }
    
    function afficherIllustrateurRetenu(uint numDeOffre)public view returns(string memory, address){
        require(illustrateursRetenus[numDeOffre]>=0, "Aucun illustrateur retenu pour l'instant");
        uint a=illustrateursRetenus[numDeOffre];
        return (reponses[a].Name,reponses[a].Identification);
    }
    
    
    function livraison(uint numDeOffre, string memory url, address payable illustrateur) public payable {
        require(inscripts[illustrateur].Identification==msg.sender);
        bytes32 dessin;
        dessin=keccak256(bytes(url));
        livraisons[numDeOffre]=dessin;
        dateLivraison[numDeOffre]=block.timestamp;
        inscripts[illustrateur].Notoriete=(inscripts[illustrateur].Notoriete).add(1);
        uint montant;
        montant=(demandes[numDeOffre].Remuneration).div(2);
        payer(illustrateur,montant);
    }
    
    function retard(uint numDeOffre) public {
        require(demandes[numDeOffre].Demandeur==msg.sender);
        require(datesRendus[numDeOffre]<block.timestamp, "Nous sommes dans les temps");
        address illustrateur;
        uint a=illustrateursRetenus[numDeOffre];
        illustrateur=reponses[a].Identification;
        inscripts[illustrateur].Notoriete=(inscripts[illustrateur].Notoriete).sub(1);
    }
    
    function accepterTravail(uint numDeOffre)public payable {
        require(demandes[numDeOffre].Demandeur==msg.sender);
        require(dateLivraison[numDeOffre] + 1 weeks > block.timestamp);
        address payable illustrateur;
        uint a=illustrateursRetenus[numDeOffre];
        illustrateur=reponses[a].Identification;
        travailAccepte[numDeOffre]=true;
        uint montant;
        montant=(demandes[numDeOffre].Remuneration).div(2);
        payer(illustrateur,montant);
        demandes[numDeOffre].statut=StatutDemande.Fermee;
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
    
    function etrePayer(uint numDeOffre, address payable illustrateur) public payable {
        require(dateLivraison[numDeOffre] + 1 weeks < block.timestamp, "Atendez quelques jours");
        require(inscripts[illustrateur].Identification==msg.sender);
        require(travailAccepte[numDeOffre]==false, "Vous avez déjà été payer");
        uint montant;
        montant=(demandes[numDeOffre].Remuneration).div(2);
        payer(illustrateur,montant);
        demandes[numDeOffre].statut=StatutDemande.Fermee;
    }
    
    function () external payable {
       
   }
}