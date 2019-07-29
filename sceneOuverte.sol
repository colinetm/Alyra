pragma solidity ^0.4.25;
contract SceneOuverte {
  
  string[12] passagesArtistes;
  uint creneauxLibres = 12;
  uint tour;

  function sInscrire(string nomDArtiste) public {
    if (creneauxLibres > 0) {
      passagesArtistes[12-creneauxLibres] = nomDArtiste;
      creneauxLibres -= 1;
    }
  }

  function passerArtisteSuivant() public {
    if (tour < 12){
    tour += 1;
    }
  }

  function artisteEnCours () public constant returns (string) {
    if (tour <= 12){
    return passagesArtistes[tour];
    } else {
      return "FIN";
    }
  }
}