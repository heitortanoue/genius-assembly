; Palavras/frases utilizadas
nomeJogo : string "GENIUS"
mensagemInicio : string "[enter para iniciar o jogo]"
Letra : var #0

; posições dos blocos (centro)
; tamanho = 8x6
posiCima : var #211
posiBaixo : var #851
posiEsq : var #525
posiDir : var #547

; cores dos blocos
corCima : var #512; verde
corBaixo : var #3072 ; azul
corEsq : var #2816 ; amarelo
corDir : var #2304 ; vermelho

; string desenhos
bloco : var #125 ; caracter usado para printar o bloco

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

	call esperaInicio

	call geraPaginaJogo

	halt

digLetra:	; Espera que uma tecla seja digitada e salva na variavel global "Letra"
	push fr		; Protege o registrador de flags
	push r0
	push r1
	loadn r1, #255	; Se nao digitar nada vem 255

   	digLetra_Loop:
		inchar r0			; Le o teclado, se nada for digitado = 255
		cmp r0, r1			;compara r0 com 255
		jeq digLetra_Loop	; Fica lendo ate' que digite uma tecla valida

	store Letra, r0			; Salva a tecla na variavel global "Letra"			
	
	pop r1
	pop r0
	pop fr
	rts

esperaInicio:
	push r0
	push r1
	loadn r1, #13
	esperaInicioLoop:
		call digLetra
		load r0, Letra
		cmp r0, r1
		jne esperaInicioLoop
	pop r1
	pop r0
	rts


geraPaginaJogo:
	push r0
	push r1
	push r2

	load r0, bloco ; tipo de caracter usado para desenhar o bloco
	load r1, corCima ; cor do bloco de cima
	load r2, posiCima ; posicao do bloco de cima
	call desenhaBloco

	load r0, bloco ; tipo de caracter usado para desenhar o bloco
	load r1, corEsq ; cor do bloco de cima
	load r2, posiEsq ; posicao do bloco de cima
	call desenhaBloco

	load r0, bloco ; tipo de caracter usado para desenhar o bloco
	load r1, corDir ; cor do bloco de cima
	load r2, posiDir ; posicao do bloco de cima
	call desenhaBloco

	load r0, bloco ; tipo de caracter usado para desenhar o bloco
	load r1, corBaixo ; cor do bloco de cima
	load r2, posiBaixo ; posicao do bloco de cima
	call desenhaBloco

	pop r2
	pop r1
	pop r0
	rts

desenhaBloco:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5

	loadn r4, #40
	loadn r5, #240 ; criterio de parada das linhas
	add r5, r5, r2 ; adicionando a posicao inicial, assim temos a posicao final do bloco

	desenhaColunaLoop:
		loadn r3, #8
		add r3, r3, r2 ; final da linha
		call desenhaLinha
		add r2, r2, r4
		cmp r2, r5
		jle desenhaColunaLoop

	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts


desenhaLinha:
	push r0 ; caracter
	push r1 ; cor
	push r2 ; posicao

	add r0, r0, r1 ; adiciona cor ao caracter

	desenhaLoop:
		outchar r0, r2 ; printa ele
		inc r2
		cmp r2, r3
		jle desenhaLoop
	
	pop r2
	pop r1
	pop r0
	rts

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
