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

jmp main

nomeJogo : string "GENIUS"
mensagemInicio : string "[enter para iniciar o jogo]"

; posições dos blocos (centro)
; tamanho = 8x6
posiCima: var #294
posiBaixo: var #934
posiEsq: var #608
posiDir: var #630

; cores dos blocos
; corCima: 0010 0000 ; verde
; corBaixo: 0100 0000 ; azul
; corEsq: 1011 0000 ; amarelo
; corDir: 1001 0000 ; vermelho

; string desenhos
bloco: var #125 ; caracter usado para printar o bloco

; da pra dividir em tres grupos
; um -> piscarSequencia e verificaExec
; dois-> geradordeAleatorio e escreve main
; tres -> geraPaginaJogo

main:   ; gera pagina inicial
	call DesenharEstrelas;
	loadn r0, #296			; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #nomeJogo	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0			; Seleciona a COR da Mensagem
	
	call Imprimestr

	loadn r0, #807			; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #mensagemInicio	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0			; Seleciona a COR da Mensagem
	
	call Imprimestr

	halt

DesenharEstrelas:
	loadn r0, #70
	loadn r1, #810
	outchar r1, r0

	loadn r0, #126
	loadn r1, #1578
	outchar r1, r0

	loadn r0, #456
	loadn r1, #2858
	outchar r1, r0

	loadn r0, #924
	loadn r1, #2858
	outchar r1, r0

	loadn r0, #515
	loadn r1, #810
	outchar r1, r0

	loadn r0, #723
	loadn r1, #1578
	outchar r1, r0

	loadn r0, #664
	loadn r1, #3626
	outchar r1, r0

	loadn r0, #1032
	loadn r1, #1322
	outchar r1, r0

	loadn r0, #232
	loadn r1, #3370
	outchar r1, r0

	loadn r0, #282
	loadn r1, #1322
	outchar r1, r0

	loadn r0, #1055
	loadn r1, #2858
	outchar r1, r0

	loadn r0, #1185
	loadn r1, #3370
	outchar r1, r0
	rts


Imprimestr:		;  Rotina de Impresao de Mensagens:    
				; r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso
				; r1 = endereco onde comeca a mensagem
				; r2 = cor da mensagem
				; Obs: a mensagem sera' impressa ate' encontrar "/0"
				
;---- Empilhamento: protege os registradores utilizados na subrotina na pilha para preservar seu valor				
	push r0	; Posicao da tela que o primeiro caractere da mensagem sera' impresso
	push r1	; endereco onde comeca a mensagem
	push r2	; cor da mensagem
	push r3	; Criterio de parada
	push r4	; Recebe o codigo do caractere da Mensagem
	
	loadn r3, #'\0'	; Criterio de parada

ImprimestrLoop:	
	loadi r4, r1		; aponta para a memoria no endereco r1 e busca seu conteudo em r4
	cmp r4, r3			; compara o codigo do caractere buscado com o criterio de parada
	jeq ImprimestrSai	; goto Final da rotina
	add r4, r2, r4		; soma a cor (r2) no codigo do caractere em r4
	outchar r4, r0		; imprime o caractere cujo codigo está em r4 na posicao r0 da tela
	inc r0				; incrementa a posicao que o proximo caractere sera' escrito na tela
	inc r1				; incrementa o ponteiro para a mensagem na memoria
	jmp ImprimestrLoop	; goto Loop
	
ImprimestrSai:	
;---- Desempilhamento: resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4	
	pop r3
	pop r2
	pop r1
	pop r0
	rts		; retorno da subrotina
