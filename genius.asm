; ------- TABELA DE CORES -------
; adicione ao caracter para Selecionar a cor correspondente

; 0 branco							0000 0000
; 256 marrom						0001 0000
; 512 verde							0010 0000
; 768 oliva							0011 0000
; 1024 azul marinho					0100 0000
; 1280 roxo							0101 0000
; 1536 teal							0110 0000
; 1792 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2560 lima							1010 0000
; 2816 amarelo						1011 0000
; 3072 azul							1100 0000
; 3328 rosa							1101 0000
; 3584 aqua							1110 0000
; 3840 branco						1111 0000


; posições dos blocos (inicio)
; tamanho = 5x4
posiCima: var #178
posiBaixo: var #858
posiEsq: var #372
posiDir: var #384

; cores dos blocos
corCima: 0010 0000 ; verde
corBaixo: 0100 0000 ; azul
corEsq: 1011 0000 ; amarelo
corDir: 1001 0000 ; vermelho

; string desenhos
bloco: #125 ; caracter usado para printar o bloco

jmp main


main:
	



desenharSeta:
