function convertDeciToHexa(d){
	hexa=Number.parseInt(d).toString(16);
	if (d.length % 2 == 1){
		hexa='0' + hexa;
	}
	return hexa;
}
document.getElementById('convertir').addEventListener('click',event => {
decimal2=document.getElementById('decimal2').value;
hexa2=convertDeciToHexa(decimal2);
document.getElementById('hexadecimal2').innerHTML='0x'+hexa2;
})

document.getElementById('convertHexToDec').addEventListener('click',event => {
hexadecimal3=document.getElementById('hexadecimal3').value;
document.getElementById('decimal3').innerHTML=parseInt(hexadecimal3,16);
})

function convertHexaLittleEndianToHexa(h){
	if (h.lenght % 2 == 1){
		h ='0'+h;
	}
	let retour="";
	for (var i=0;i<h.length-1;i+=2){
		retour=h[i]+h[i+1]+retour;
	}
	return retour;
}
document.getElementById('convertHexaLE').addEventListener('click',event => {
	hle=document.getElementById('hle').value;
	hexa=convertHexaLittleEndianToHexa(hle);
	document.getElementById('hexadecimal').innerHTML='0x'+hexa;
	document.getElementById('decimal').innerHTML=parseInt(hexa,16);
})
document.getElementById('convertVarInt').addEventListener('click',event => {
varintin=document.getElementById('varintin').value;
document.getElementById('decimal4').innerHTML=parseInt(varintin,16);
})

function calculerCible(bits){
	let exposant=bits.substring(2,4);
	let coefficient=bits.substring(4,10);
	let exp=parseInt(exposant,16);
	let coeff=parseInt(coefficient,16);
	let cible=coeff*Math.pow(2,(8*(exp-3)));
	return cible;
}

function calculerDifficulte(cible){
	const cibleMax=(Math.pow(2,16)-1)*(Math.pow(2,208));
	let difficulte;
	difficulte=cibleMax/cible;
	return difficulte;
}

document.getElementById('convertBits').addEventListener('click',event => {
bits=document.getElementById('bits').value;
cible=calculerCible(bits);
difficulte=calculerDifficulte(cible);
document.getElementById('cible').innerHTML=cible;
document.getElementById('difficulte').innerHTML=difficulte;
})

document.getElementById('convertCible').addEventListener('click',event => {
cible2=document.getElementById('cible2').value;
difficulte2=calculerDifficulte(cible2);
document.getElementById('difficulte2').innerHTML=difficulte2;
})
		
function decomposerTransaction(transaction){
	let a,b,c,d;
	let version=transaction.substring(0,8);
	let entrees=transaction.substring(8,10);
	let input=transaction.substring(10,74);
	let output=transaction.substring(74,82);
	let h=version.length+entrees.length+input.length+output.length;
	let varintScriptSig=transaction.substring(h,h+2);
	let g=h+2;
	function varInt(str){
		if (str=="fd"){
			str=transaction.substring(g,g+4);
		}
		else if (str=="fe"){
			str=transaction.substring(g,g+6);
		}
		else if (str=="ff") {
			str=transaction.substring(g,g+10);
		}
	}
	varInt(varintScriptSig);
	a=varintScriptSig.length;
	let varintSignature=transaction.substring(a+h,a+h+2);
	g=a+h;
	varInt(varintSignature);
	b=varintSignature.length;
	let signature;
	let signLongueur=2*parseInt(varintSignature,16);
	signature=transaction.substring(a+b+h,a+b+h+signLongueur);
	let varintPubKey=transaction.substring(a+b+h+signLongueur,a+b+h+signLongueur+2);
	g=a+b+h+signLongueur;
	varInt(varintPubKey);
	c=varintPubKey.length;
	let pubKeyLongueur=2*parseInt(varintPubKey,16);
	let pubKey=transaction.substring(g+c,g+c+pubKeyLongueur);
	g=a+b+h+signLongueur+c+pubKeyLongueur;
	let sequence=transaction.substring(g,g+8);
	g=a+b+h+signLongueur+c+pubKeyLongueur+sequence.length;
	let varintOut=transaction.substring(g,g+2);
	let array=[version,entrees,input,output,varintScriptSig,varintSignature,signature,varintPubKey,pubKey,sequence,varintOut];
	g=a+b+h+signLongueur+c+pubKeyLongueur+sequence.length+2;
	let montant;
	let varintOutX;
	let outLongueur;
	let out;
	for (i=1;i<=varintOut;i++){
	montant=transaction.substring(g,g+16);
	varintOutX=transaction.substring(g+16,g+18);
	varInt(varintOutX);
	d=varintOutX.length;
	outLongueur=2*parseInt(varintOutX,16);
	out=transaction.substring(g+montant.length+d,g+montant.length+d+outLongueur);
	g=g+montant.length+d+outLongueur;
	array.push([montant,varintOutX,out]);
	}
	let locktime=transaction.substring(g,g+8);
	array.push(locktime);
	return array;
}
	
document.getElementById('decomposeTransaction').addEventListener('click',event => {
transaction=document.getElementById('transactionText').value;
array=decomposerTransaction(transaction);
document.getElementById('version').innerHTML=array[0];
document.getElementById('entrees').innerHTML=array[1];
document.getElementById('input').innerHTML=array[2];
document.getElementById('output').innerHTML=array[3];
document.getElementById('varintScriptSig').innerHTML='0x'+array[4];
document.getElementById('varintSignature').innerHTML='0x'+array[5];
document.getElementById('signature').innerHTML=array[6];
document.getElementById('varintPubKey').innerHTML='0x'+array[7];
document.getElementById('pubKey').innerHTML=array[8];
document.getElementById('sequence').innerHTML=array[9];
document.getElementById('varintOut').innerHTML=array[10];
document.getElementById('locktime').innerHTML=array[array.length-1];
document.getElementById('transaction1').innerHTML="Montant :"+array[11][0]+"  Longueur du ScriptPubKey : "+array[11][1]+"  ScriptPubKey : "+array[11][2];
document.getElementById('transaction2').innerHTML="Montant :"+array[12][0]+"  Longueur du ScriptPubKey : "+array[12][1]+"  ScriptPubKey : "+array[12][2];
document.getElementById('transaction3').innerHTML="Montant :"+array[13][0]+"  Longueur du ScriptPubKey : "+array[13][1]+"  ScriptPubKey : "+array[13][2];
})
	
function longueurTransaction(transactions){
	let h=82;
	let varintScriptSig=transactions.substring(h,h+2);
		function varInt(str){
			if (str=="fd"){
				h+=6;
			}
			else if (str=="fe"){
				h+=8;
			}
			else if (str=="ff") {
				h+=12;
			}
		}
	varInt(varintScriptSig);
	let scriptSig=2*parseInt(varintScriptSig,16);
	h+=scriptSig+8;
	let varintOut=transactions.substring(h,h+2);
	varInt(varintOut);
	let varintOutX;
	let outLongueur;
	for (i=1;i<=varintOut;i++){
		h+=16;
		varintOutX=transaction.substring(h,h+2);
		varInt(varintOutX);
		outLongueur=2*parseInt(varintOutX,16);
		h+=outLongueur;
	}
	h+=8;
	return h;
}

function decomposerEntete(entete){
	let versionEntete=entete.substring(0,8);
	let previousBlock=entete.substring(8,72);
	let arbre=entete.substring(72,136);
	let timestamp=entete.substring(136,144);
	let bits=entete.substring(144,152);
	let nonce=entete.substring(152,160);
	let array4=[versionEntete,previousBlock,arbre,timestamp,bits,nonce];
	return array4;
}

function decomposerBlock(block){
	if (/^0xf9b4bef9/.test('block')){
		let tailleBloc=block.substring(8,16);
		let array3=[tailleBloc];
		let blockS=block.substring(0,16);
	} else {
		let array3=[""];
		let blockS="";
	}
	let entete=block.substring(blockS.length,blockS.length+80);
	array3.push(decomposerEntete(entete));
	let nombreTransactions=2*parseInt(block.substring(blockS.length+80,blockS.length+82),16);
	array3.push(nombreTransactions);
	let transactions=block.substring(blockS.length+82,block.length-1);
	let transactionTaille=longueurTransaction(transactions);
	let transaction1=transactions.substring(0,transactionTaille);
	array3.push(transaction1);
	let tailleToutesTransactions=transactionTaille;
	while (tailleToutesTransactions < block.length){
		let transactionSS=transactions.substring(tailleToutesTransactions,transactions.length-1);
		let transactionsX=longueurTransaction(transactionSS);
		array3.push(transactionSS.substring(0,transactionsX));
		tailleToutesTransactions+=transactionsX;
	}
	return array3;
}

document.getElementById('decomposeBlock').addEventListener('click',event => {
	block=document.getElementById('block').value;
	document.getElementById('tailleBloc').innerHTML=array3[0];
	document.getElementById('versionEntete').innerHTML=array3[1][0];
	document.getElementById('previousBlock').innerHTML=array3[1][1];
	document.getElementById('arbre').innerHTML=array3[1][2];
	document.getElementById('timestamp').innerHTML=array3[1][3];
	document.getElementById('bits').innerHTML=array3[1][4];
	document.getElementById('nonce').innerHTML=array3[1][5];
	document.getElementById('nombreTransactions').innerHTML=array3[4];
	document.getElementById('transactions').innerHTML=array3[3,array3.length-1];
})