
jmp main

; Palavras/frases utilizadas
nomeJogo : string "GENIUS"
mensagemInicio : string "[enter para iniciar o jogo]"
apagaMensagem : string "                           "
Letra : var #0
pontos : string " Pontos: "

incRand: var #1;circular a tabela de nr. Randomicos
randSequence : var #35; tabela de nr. Randomicos
   static randSequence + #0 , #56241    ; %4 = 1
   static randSequence + #1 , #53281    ; %4 = 2
   static randSequence + #2 , #1409     ; %4 = 3
   static randSequence + #3 , #30428    ; %4 = 0
   static randSequence + #4 , #51627    ; %4 = 3
   static randSequence + #7 , #10476    ; %4 = 0
   static randSequence + #8 , #42149    ; %4 = 1
   static randSequence + #9 , #15652    ; %4 = 2
   static randSequence + #10, #40367    ; %4 = 3
   static randSequence + #11, #1221     ; %4 = 1
   static randSequence + #12, #33317    ; %4 = 2
   static randSequence + #13, #49878    ; %4 = 0
   static randSequence + #14, #57321    ; %4 = 1
   static randSequence + #15, #13091    ; %4 = 2
   static randSequence + #16, #12214    ; %4 = 3
   static randSequence + #17, #7925     ; %4 = 1
   static randSequence + #18, #15409    ; %4 = 2
   static randSequence + #19, #51788    ; %4 = 0
   static randSequence + #20, #29654    ; %4 = 2
   static randSequence + #21, #23848    ; %4 = 0
   static randSequence + #22, #43871    ; %4 = 3
   static randSequence + #23, #56169    ; %4 = 1
   static randSequence + #24, #33517    ; %4 = 3
   static randSequence + #25, #39218    ; %4 = 2
   static randSequence + #26, #39371    ; %4 = 3
   static randSequence + #27, #61204    ; %4 = 0
   static randSequence + #28, #47533    ; %4 = 1
   static randSequence + #29, #18006    ; %4 = 2
   static randSequence + #30, #18996    ; %4 = 2
   static randSequence + #31, #18456    ; %4 = 3
   static randSequence + #32, #19456    ; %4 = 0
   static randSequence + #33, #21456    ; %4 = 1
   static randSequence + #34, #0        ; %4 = 0
; %4: 0 = verde, 1 = vermelho, 2 = amarelo, 3 = azul
; cima: verde, direita: vermelho, esquerda: amarelo, baixo: azul
; probabilidades:
; 0: 0.25 (8)
; 1: 0.25 (8)
; 2: 0.25 (8)
; 3: 0.25 (8)
; fim da tabela de nr. Randomicos

jogadasAtual : var #0 ; indice da ultima jogada no vetor jogadas
ultimaJogada : var #0 ; converte Letra para numero
jogadas : var #32

; da pra dividir em tres grupos
; um -> piscarSequencia e verificaExec
;   piscarSequencia -> pisca as cores de acordo com a sequencia (jogadas)
;   verificaExec -> verifica se a sequencia digitada pelo usuario esta correta
; dois-> geradordeAleatorio e escreve main
; tres -> geraPaginaJogo

main:   ; gera pagina inicial

    ; NAO REMOVER
    loadn r0, #0
    store jogadasAtual, r0
    ; NAO REMOVER

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
	
    ; gera a primeira jogada
    call insereJogadaAleatoria

    ; MODELO DE USO de acessaJogada
    ; acessa primeira jogada
    loadn r0, #1
    ; para acessar a ultima jogada, use o valor de jogadasAtual
    ; load r0, jogadasAtual
    call acessaJogada
    ; r0 contem o valor da jogada

    call digLetra


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

	; apaga mensagem da tela
	loadn r0, #807			; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #apagaMensagem
	loadn r2, #0			; Seleciona a COR da Mensagem
	
	call Imprimestr

	loadn r0, #53
	loadn r1, #pontos
	loadn r2, #1536
	call Imprimestr

	loadn r0, #64
	loadn r1, #1584
	outchar r1, r0

	loadn r1, #512 ; cor do bloco de cima
	loadn r2, #216 ; posicao do bloco de cima
	call desenhaBloco

	loadn r1, #2816 ; cor do bloco de esq
	loadn r2, #525 ; posicao do bloco de esq
	call desenhaBloco

	loadn r1, #2304 ; cor do bloco de dir
	loadn r2, #547 ; posicao do bloco de dir
	call desenhaBloco
	
	loadn r1, #3072 ; cor do bloco de baixo
	loadn r2, #856 ; posicao do bloco de baixo
	call desenhaBloco

	pop r2
	pop r1
	pop r0
	rts

; definir r1 como cor do bloco e r2 a posicao de INICIO
desenhaBloco:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5

	loadn r0, #125 ; tipo de caracter usado para desenhar o bloco
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

geraAleatorio: ; gera num aleatorio de 0 a 3 (para o proximo valor do genius)
   push r1

   load r0, incRand
   inc r0
   loadn r1, #35
   mod r0, r0, r1
   store incRand, r0
   loadn r1, #randSequence
   add r1, r1, r0
   loadi r0, r1

   pop r1
   rts


;(r0 - 1) é o valor maximo que pode ser gerado
geraAleatorioComMax:
   push r1

   mov r1, r0
   call geraAleatorio
   mod r0, r0, r1

   pop r1
   rts

; r0 = posicao a ser acessada
acessaJogada:
    push r1

    mov r1, r0
    ; r0 esta livre
    ; r1 = posicao a ser acessada
    loadn r0, #jogadas
    add r1, r1, r0
    ; r1 agora aponta para a posicao da jogada
    loadi r0, r1

    pop r1
    rts


insereJogadaAleatoria:
    push r0
    push r1

    ; incrementa o contador de jogadas
    load r0, jogadasAtual
    inc r0
    store jogadasAtual, r0
    ; coloca em r1 a posicao a ser acessada
    loadn r1, #jogadas
    add r1, r1, r0

    ; r0 = num max - 1
    loadn r0, #4
    call geraAleatorioComMax

    ; r0 = valor aleatorio
    ; r1 = posicao a ser acessada
    storei r1, r0

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
