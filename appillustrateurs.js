async function createMetaMaskDapp() {
    try {
      // Demande à MetaMask l'autorisation de se connecter
      const addresses = await ethereum.enable();
      const address = addresses[0]
      // Connection au noeud fourni par l'objet web3
      const provider = new ethers.providers.Web3Provider(ethereum);
      dapp = { address, provider };
      console.log(dapp)
    } catch(err) {
      // Gestion des erreurs
      console.error(err);
    }
   }

   const illustrateurs = {
    address : "0x56d9ad83fae23922b7b0c6328e25b62c929e3d91",
    abi :[
	{
		"constant": false,
		"inputs": [
			{
				"name": "numDeOffre",
				"type": "uint256"
			},
			{
				"name": "numCandidature",
				"type": "uint256"
			}
		],
		"name": "accepterOffre",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "numDeOffre",
				"type": "uint256"
			}
		],
		"name": "accepterTravail",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "entreprise",
				"type": "string"
			},
			{
				"name": "demandeur",
				"type": "address"
			},
			{
				"name": "mail",
				"type": "string"
			},
			{
				"name": "descriptif",
				"type": "string"
			},
			{
				"name": "notorieteMin",
				"type": "uint256"
			},
			{
				"name": "remuneration",
				"type": "uint256"
			},
			{
				"name": "delai",
				"type": "uint256"
			}
		],
		"name": "ajouterDemande",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "numDeOffre",
				"type": "uint256"
			},
			{
				"name": "_satisfaction",
				"type": "uint8"
			}
		],
		"name": "appreciation",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "numDeOffre",
				"type": "uint256"
			},
			{
				"name": "illustrateur",
				"type": "address"
			}
		],
		"name": "etrePayer",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "name",
				"type": "string"
			},
			{
				"name": "identification",
				"type": "address"
			},
			{
				"name": "mail",
				"type": "string"
			},
			{
				"name": "urlbook",
				"type": "string"
			}
		],
		"name": "inscription",
		"outputs": [
			{
				"name": "message",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "numDeOffre",
				"type": "uint256"
			},
			{
				"name": "url",
				"type": "string"
			},
			{
				"name": "illustrateur",
				"type": "address"
			}
		],
		"name": "livraison",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "numDeOffre",
				"type": "uint256"
			},
			{
				"name": "name",
				"type": "string"
			},
			{
				"name": "_address",
				"type": "address"
			}
		],
		"name": "postuler",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "numDeOffre",
				"type": "uint256"
			}
		],
		"name": "retard",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"payable": true,
		"stateMutability": "payable",
		"type": "fallback"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "numCandidature",
				"type": "uint256"
			}
		],
		"name": "afficherCandidat",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "numDeOffre",
				"type": "uint256"
			}
		],
		"name": "afficherCandidature",
		"outputs": [
			{
				"name": "",
				"type": "uint256[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "numDeOffre",
				"type": "uint256"
			}
		],
		"name": "afficherIllustrateurRetenu",
		"outputs": [
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_address",
				"type": "address"
			}
		],
		"name": "voirIllustrateur",
		"outputs": [
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "address"
			},
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "voirLesIllustrateurs",
		"outputs": [
			{
				"components": [
					{
						"name": "Name",
						"type": "string"
					},
					{
						"name": "Identification",
						"type": "address"
					},
					{
						"name": "Mail",
						"type": "string"
					},
					{
						"name": "Notoriete",
						"type": "uint256"
					},
					{
						"name": "Urlbook",
						"type": "string"
					}
				],
				"name": "",
				"type": "tuple[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "voirLesOffres",
		"outputs": [
			{
				"components": [
					{
						"name": "NumeroDOffre",
						"type": "uint256"
					},
					{
						"name": "Entreprise",
						"type": "string"
					},
					{
						"name": "Demandeur",
						"type": "address"
					},
					{
						"name": "Mail",
						"type": "string"
					},
					{
						"name": "Descriptif",
						"type": "string"
					},
					{
						"name": "NotorieteMin",
						"type": "uint256"
					},
					{
						"name": "Remuneration",
						"type": "uint256"
					},
					{
						"name": "Delai",
						"type": "uint256"
					},
					{
						"name": "statut",
						"type": "uint8"
					},
					{
						"name": "ListReponses",
						"type": "uint256[]"
					}
				],
				"name": "",
				"type": "tuple[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "numOffreRecherche",
				"type": "uint256"
			}
		],
		"name": "voirOffre",
		"outputs": [
			{
				"components": [
					{
						"name": "NumeroDOffre",
						"type": "uint256"
					},
					{
						"name": "Entreprise",
						"type": "string"
					},
					{
						"name": "Demandeur",
						"type": "address"
					},
					{
						"name": "Mail",
						"type": "string"
					},
					{
						"name": "Descriptif",
						"type": "string"
					},
					{
						"name": "NotorieteMin",
						"type": "uint256"
					},
					{
						"name": "Remuneration",
						"type": "uint256"
					},
					{
						"name": "Delai",
						"type": "uint256"
					},
					{
						"name": "statut",
						"type": "uint8"
					},
					{
						"name": "ListReponses",
						"type": "uint256[]"
					}
				],
				"name": "",
				"type": "tuple"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]
}

   
async function creerDemande(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider.getSigner());
  let entrepriseEnt = document.getElementById("entreprise").value;
  let demandeurEnt = document.getElementById("demandeur").value;
  let maildemandeurEnt = document.getElementById("maildemandeur").value;
  let descriptifEnt = document.getElementById("descriptif").value;
  let notminEnt = parseInt(document.getElementById("notmin").value,10);
  let remunerationEnt = parseInt(document.getElementById("remuneration").value,10);
  let delaiEnt = parseInt(document.getElementById("delai").value,10);
  let demande = await contractIllustrateurs.ajouterDemande(entrepriseEnt,demandeurEnt,maildemandeurEnt,descriptifEnt,notminEnt,remunerationEnt,delaiEnt);
  console.log(entrepriseEnt,demandeurEnt,maildemandeurEnt,descriptifEnt,notminEnt,remunerationEnt,delaiEnt);
}

async function voirLesOffres(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider);
  let demandes= await contractIllustrateurs.voirLesOffres();
  console.log(demandes);
  document.getElementById("offres").innerHTML= demandes;   
}

async function inscription(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider.getSigner());
  let nameInscrit = document.getElementById("name").value;
  let addresseInscrit = document.getElementById("identification").value;
  let mailInscrit = document.getElementById("mailillustrateur").value;
  let urlbookInscrit = document.getElementById("urlbook").value;
  console.log(nameInscrit,addresseInscrit,mailInscrit,urlbookInscrit);
  let inscrit = await contractIllustrateurs.inscription(nameInscrit,addresseInscrit,mailInscrit,urlbookInscrit);
}

async function voirLesIllustrateurs(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider);
  let illustrateursAll= await contractIllustrateurs.voirLesIllustrateurs();
  console.log(illustrateursAll);
  document.getElementById("illustrateurs").innerHTML=illustrateursAll;
}

async function postulerOffre(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider.getSigner());
  let numOffrePostuler = document.getElementById("numoffrepostul").value;
  let namepostuler = document.getElementById("namepostulant").value;
  let addresspostuler = document.getElementById("addresspostulant").value;
  let postulant = await contractIllustrateurs.postuler(numOffrePostuler,namepostuler,addresspostuler);
  console.log(postulant);
}

async function afficherCandidatures(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider);
  let numOffreCandidatee = document.getElementById("numoffrecandidatures").value;
  let numCandidatures = await contractIllustrateurs.afficherCandidature(numOffreCandidatee);
  document.getElementById("candidatures").innerHTML=numCandidatures;
}

async function voirUnCandidat(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider);
  let numCandidature= document.getElementById("numcandidature").value;
  let candidat = await contractIllustrateurs.afficherCandidat(numCandidature);
  document.getElementById("candidature").innerHTML=candidat;
}

async function validCandidature(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider.getSigner());
  let numOffre = document.getElementById("numoffrevalid").value;
  let numCandidature = document.getElementById("numcandidatvalid").value;
  let validation = await contractIllustrateurs.accepterOffre(numOffre,numCandidature);
  console.log(validation);
}

async function rendreTravail(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider.getSigner());
  let numOffre = document.getElementById("numlivraison").value;
  let urlTravail = document.getElementById("urllivraison").value;
  let addresslivreur = document.getElementById("addresslivraison").value;
  let dessin = await contractIllustrateurs.livraison(numOffre,urlTravail,addresslivreur);
  console.log(dessin);
}

async function seFairePayer(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider.getSigner());
  let numOffre = document.getElementById("numoffrepayer").value;
  let addressDestinataire = document.getElementById("addresspayer").value;
  let paye = await contractIllustrateurs.etrePayer(numOffre,addressDestinataire);
  console.log(paye);
}

async function accepterTravail(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider.getSigner());
  let numOffre = document.getElementById("numaccepter").value;
  let acceptation = await contractIllustrateurs.accepterTravail(numOffre);
  console.log(acceptation);
}

async function apprecierTravail(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider.getSigner());
  let numOffre = document.getElementById("numoffreaccepte").value;
  let valeurEnt = document.getElementById("appreciation").querySelector("option").value;
  let valeur;
  if (valeurEnt=="tresbon"){
    valeur=0;
  } else if (valeurEnt=="bon"){
    valeur=1;
  } else if (valeurEnt=="correct"){
    valeur=2;
  } else {
    valeur=3;
  }
  let appreciationDonnee = await contractIllustrateurs.appreciation(numOffre,valeur);
  console.log(appreciationDonnee);
}

async function sanctionRetard(){
  let contractIllustrateurs = new ethers.Contract(illustrateurs.address,illustrateurs.abi,dapp.provider.getSigner());
  let numOffre = document.getElementById("numretard").value;
  let sanction = await contractIllustrateurs.retard(numOffre);
  console.log(sanction);
}