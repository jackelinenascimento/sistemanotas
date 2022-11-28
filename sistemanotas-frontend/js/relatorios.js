var urlDisciplinas = "http://127.0.0.1:8080/disciplinas";
var urlAlunos = "http://127.0.0.1:8080/alunos";
var urlAvaliacoes = "http://127.0.0.1:8080/avaliacoes";
c


var disciplinaSelecionada = document.getElementById("disciplina-selecionada")
var botaoFaltas = document.getElementById("relatorio-faltas")
var botaoNotas = document.getElementById("relatorio-notas")
var tituloDisciplina = document.getElementById("titulo-disciplina")
var disciplinaCodigo

for(d of disciplinas){
   
    if(d.turno == "T"){
        turno = "TARDE"
    } else {
        turno = "NOITE"
    }

    disciplinaSelecionada.options[disciplinaSelecionada.options.length] = new Option(d.nome + " - "+ turno , d.id)
}


disciplinaSelecionada.addEventListener('change', function() {
    
    dSelecionada = this.value
    disciplina = disciplinas[dSelecionada-1]
    tituloDisciplina.innerHTML = disciplinas[dSelecionada-1].nome + " - "+ turno
    disciplinaCodigo = disciplinas[dSelecionada-1].codigo
    console.log(disciplinaCodigo)
    
}, false);

botaoFaltas.addEventListener("click", function(){

    var urlRelatorioFaltas = `http://127.0.0.1:8080/faltas/relatorio/${disciplinaCodigo}`

    var xhttpRequest = new XMLHttpRequest();
    xhttpRequest.open("GET", urlRelatorioFaltas, false);
    xhttpRequest.send();
    
    //var disciplinas = JSON.parse(xhttp.responseText)
    //console.log("disciplinas", disciplinas)
})
