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

// variaveis

var disciplinaSelecionada = document.getElementById("disciplina-selecionada")
var avaliacaoSelecionada = document.getElementById("avaliacao-selecionada")
var tituloDisciplina = document.getElementById("titulo-disciplina")
var tabelaAlunos = document.getElementById("linhas-alunos")
var turno
var dSelecionada
var disciplina
var aSelecionada
var avaliacao

// preencher select disciplina

for(d of disciplinas){
   
    if(d.turno == "T"){
        turno = "TARDE"
    } else {
        turno = "NOITE"
    }

    disciplinaSelecionada.options[disciplinaSelecionada.options.length] = new Option(d.nome + " - "+ turno , d.id)
}

// preenche select avaliacao

for(a of avaliacoes){

    avaliacaoSelecionada.options[avaliacaoSelecionada.options.length] = new Option(a.tipo, a.codigo)
}

// preenche tabela alunos

let tableBody = alunos.map((aluno) => {
    return `<tr>
            <th scope="row">${aluno.ra}</th>
            <td>${aluno.nome}</td>
            <td><input id=nota${aluno.ra} type="number" value="0" min="0" max="10"></td>
            <td><button id=${aluno.ra} class="btn btn-outline-primary" >Salvar</button></td>
            </tr>`
})

tabelaAlunos.innerHTML = tableBody

// captura opcao disciplina 

disciplinaSelecionada.addEventListener('change', function() {
    
    dSelecionada = this.value
    disciplina = disciplinas[dSelecionada-1]
    tituloDisciplina.innerHTML = disciplinas[dSelecionada-1].nome + " - "+ turno


}, false);

// captura opcao avaliacao

avaliacaoSelecionada.addEventListener('change', function() {
    
    aSelecionada = this.value
    avaliacao = $(this).attr("id")

}, false);


$("button").click(function(){
    
    //id aluno
    var id = $(this).attr("id")

    //nota aluno
    var notaAluno = document.getElementById(`nota${id}`)
    console.log("notaAluno", notaAluno.value)
  
    //lancamento nota
    data = {
        aluno : id,
        disciplina : dSelecionada,
        avaliacao : aSelecionada,
        nota : notaAluno.value
    }
        
    var dataJson = JSON.stringify(data)

    console.log(dataJson)

    $.ajax({
        url: urlNotas, 
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: dataJson,
        success: function (result) {},
         error: function (err) {}
      }); // ajax call closing
  });