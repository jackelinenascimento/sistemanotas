var urlDisciplinas = "http://127.0.0.1:8080/disciplinas";
var urlAlunos = "http://127.0.0.1:8080/alunos";
var urlAvaliacoes = "http://127.0.0.1:8080/avaliacoes";
var urlNotas = "http://127.0.0.1:8080/notas";


var disciplinaSelecionada = document.getElementById("disciplina-selecionada")

for(d of disciplinas){
   
    if(d.turno == "T"){
        turno = "TARDE"
    } else {
        turno = "NOITE"
    }

    disciplinaSelecionada.options[disciplinaSelecionada.options.length] = new Option(d.nome + " - "+ turno , d.id)
}
