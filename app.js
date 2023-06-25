const Web3 = require('web3');
const Emprestimo = require('./build/contracts/Emprestimo.json');
const Investimento = require('./build/contracts/Investimento.json');

const web3 = new Web3('http://localhost:8545');

web3.eth.getAccounts().then((accounts) => {
  const [investidor, tomador] = accounts;

  const emprestimo = new web3.eth.Contract(
    Emprestimo.abi,
    '0x8523b6F1d8EAFca7a242cdE18c29951774899F69' //Emprestimo
  );

  const investimento = new web3.eth.Contract(
    Investimento.abi,
    '0x16EfA394defA11f79C43B5543c7397f77B9b4D27' //Investimento
  );
  function pedirEmprestimo(quantia) {
    return emprestimo.methods.pedirEmprestimo(quantia).send({ from: tomador });
  }

  function pagarEmprestimo(quantia) {
    return emprestimo.methods.pagarEmprestimo(quantia).send({ from: tomador });
  }

  function investir(quantia) {
    return investimento.methods.investir(quantia).send({ from: investidor });
  }
});
