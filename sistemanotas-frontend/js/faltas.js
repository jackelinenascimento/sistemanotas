var urlDisciplinas = "http://127.0.0.1:8080/disciplinas";
var urlAlunos = "http://127.0.0.1:8080/alunos";
var urlAvaliacoes = "http://127.0.0.1:8080/avaliacoes";
var urlNotas = "http://127.0.0.1:8080/notas";
var urlFaltas = "http://127.0.0.1:8080/faltas";



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
            <td><input id=faltas${aluno.ra} type="number" value="0" min="0" max="4"></td>
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
        
    var dataJson = JSON.stringify(data)

    console.log(dataJson)

    $.ajax({
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

  });