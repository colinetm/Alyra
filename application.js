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

async function balance(){
    let item=document.getElementById('balance');
    dapp.provider.getBalance(dapp.address).then((balance) => {
      let etherString = ethers.utils.formatEther(balance);
      console.log("Balance: " + etherString);
      item.innerHTML=etherString;
    });
   }

async function getLastBlock(){
    let item=document.getElementById('lastblock');
    dapp.provider.getBlockNumber().then((number) => {
        console.log("Dernier bloc :"+number);
        item.innerHTML=number;
    });
}

async function getGasPrice(){
    let item=document.getElementById('gasprice');
    dapp.provider.getGasPrice().then((price) => {
        let etherGas= ethers.utils.formatEther(price);
        console.log("Prix du gaz : "+etherGas);
        item.innerHTML=etherGas;
    })
}

const credibilite = {
  address : 0x5243cce0e6b7822045cb7c8607a4892d860111f3,
  abi : [
    {
      "constant": false,
      "inputs": [
        {
          "name": "dev",
          "type": "bytes32"
        }
      ],
      "name": "remettre",
      "outputs": [
        {
          "name": "",
          "type": "uint256"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "",
          "type": "address"
        }
      ],
      "name": "cred",
      "outputs": [
        {
          "name": "",
          "type": "uint256"
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
          "name": "url",
          "type": "string"
        }
      ],
      "name": "produireHash",
      "outputs": [
        {
          "name": "",
          "type": "bytes32"
        }
      ],
      "payable": false,
      "stateMutability": "pure",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "destinataire",
          "type": "address"
        },
        {
          "name": "valeur",
          "type": "uint256"
        }
      ],
      "name": "transfer",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]
}

async function getMyCredibility(){
  let item=document.getElementById("cred");
  let contratCredibilite = new ethers.Contract(credibilite.address,credibilite.abi,dapp.provider);
  let maCredibilite = await contratCredibilite.cred(dapp.address);
  console.log("Ma crédibilité : "+maCredibilite);
  item.innerHTML=maCredibilite;
}

async function getMyHomework(){
  let contratCredibilite = new ethers.Contract(credibilite.address,credibilite.abi,dapp.provider);
  
  let devoirUrl=document.getElementById("urlDevoir").value;
  let urlHash= await contratCredibilite.produireHash(devoirUrl);
  document.getElementById("hash").innerHTML=urlHash;
  console.log("Condensat : "+urlHash);
  let maPosition= await contratCredibilite.remettre(urlHash);
  document.getElementById("Classement").innerHTML=maPosition;
  console.log("Ma position : "+maPosition);
}
