var urlDisciplinas = "http://127.0.0.1:8080/disciplinas";
var urlAlunos = "http://127.0.0.1:8080/alunos";
var urlAvaliacoes = "http://127.0.0.1:8080/avaliacoes";
var urlNotas = "http://127.0.0.1:8080/notas";

var xhttp = new XMLHttpRequest();

//request disciplinas

xhttp.open("GET", urlDisciplinas, false);
xhttp.send();
var disciplinas = JSON.parse(xhttp.responseText)
console.log("disciplinas", disciplinas)

//request alunos

xhttp.open("GET", urlAlunos, false);
xhttp.send();

var alunos = JSON.parse(xhttp.responseText)
console.log("alunos", alunos)

//request notas

xhttp.open("GET", urlAvaliacoes, false);
xhttp.send();

var avaliacoes = JSON.parse(xhttp.responseText)
console.log("avaliacoes", avaliacoes)