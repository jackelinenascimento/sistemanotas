//requisicoes GET

var urlDisciplinas = "http://127.0.0.1:8080/disciplinas";
var urlAlunos = "http://127.0.0.1:8080/alunos";
<<<<<<< HEAD
var urlFaltas = "http://127.0.0.1:8080/faltas";
=======
var urlFatas = "http://127.0.0.1:8080/faltas";
>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999

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

<<<<<<< HEAD
=======

// preencher disciplinas no select

>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999
var disciplinaSelecionada = document.getElementById("disciplina-selecionada")
var tituloDisciplina = document.getElementById("titulo-disciplina")
var tabelaAlunos = document.getElementById("linhas-alunos")
var turno
var dSelecionada
var disciplina

for(d of disciplinas){
   
    if(d.turno == "T"){
        turno = "TARDE"
    } else {
        turno = "NOITE"
    }

    disciplinaSelecionada.options[disciplinaSelecionada.options.length] = new Option(d.nome + " - "+ turno , d.id)
}

let tableBody = alunos.map((aluno) => {
    return `<tr>
            <th scope="row">${aluno.ra}</th>
            <td>${aluno.nome}</td>
<<<<<<< HEAD
            <td><input id=faltas${aluno.ra} type="number" value="0" min="0" max="4"></td>
=======
            <td><input id=faltas${aluno.ra} type="number" min="0" max="4"></td>
>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999
            <td><button id=${aluno.ra} class="btn btn-outline-primary" >Salvar</button></td>
            </tr>`
})


tabelaAlunos.innerHTML = tableBody

// capturar opção disciplina

disciplinaSelecionada.addEventListener('change', function() {
    
    dSelecionada = this.value
    disciplina = disciplinas[dSelecionada-1]
    tituloDisciplina.innerHTML = disciplinas[dSelecionada-1].nome + " - "+ turno


}, false);

$("button").click(function(){
    
    //id aluno
    var id = $(this).attr("id")
    console.log("id aluno: ", id)

    //qtdade faltas
    var qtdFaltas = document.getElementById(`faltas${id}`)
    console.log("qtdade faltas", qtdFaltas.value)

<<<<<<< HEAD

    var aulasDisciplina =  disciplinas[dSelecionada-1].numAulas/20
    console.log(aulasDisciplina)

    presenca = aulasDisciplina - qtdFaltas.value

    if(presenca >= 0) {

    //lancamento faltas
    data = {
        aluno : id,
        disciplina : dSelecionada,
        presenca
    }
        
=======
    //disciplina
    console.log(disciplina)
    console.log("id disciplina: ", dSelecionada)

    //lancamento faltas
    data = {
        "raluno": id,
        "disciplina": dSelecionada,
        "presenca": qtdFaltas.value
    }

>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999
    var dataJson = JSON.stringify(data)

    console.log(dataJson)

    $.ajax({
<<<<<<< HEAD
        url: urlFaltas, 
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: dataJson,
        success: function (result) {},
         error: function (err) {}
      }); // ajax call closing
    
    } else {
        alert("Lançamento de faltas invalida - tente novamente")
    }
=======
        url: urlFatas, 
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: data,
        success: function (result) {
            // when call is sucessfull
         },
         error: function (err) {
         // check the err for error details
         }
      }); // ajax call closing
>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999

  });