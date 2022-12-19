
jmp main

; Palavras/frases utilizadas
nomeJogo : string "GENIUS"
mensagemInicio : string "[enter para iniciar o jogo]"
apagaMensagem : string "                           "
Letra : var #0
pontos : string " Pontos: "
scoreTotal: string "0"
valorJogada: var #0
perdeu: var #0

randInicio: var #1
passoRand: var #1

incRand: var #1;circular a tabela de nr. Randomicos
incSequence: var #3
    static incSequence + #1 , #14
    static incSequence + #2 , #12
    static incSequence + #3 , #9

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
numJogadas: var #0

; da pra dividir em tres grupos
; um -> piscarSequencia e verificaExec
;   piscarSequencia -> pisca as cores de acordo com a sequencia (jogadas)
;   verificaExec -> verifica se a sequencia digitada pelo usuario esta correta
; dois-> geradordeAleatorio e escreve main
; tres -> geraPaginaJogo

main:   ; gera pagina inicial

    ; NAO REMOVER
    loadn r0, #0
    loadn r3, #1584
    store jogadasAtual, r0
    store scoreTotal, r3
    call insereJogadaAleatoria
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
	
	call Delay
	
	call limpaBlocos

    call loopJogo

    perdeuJogo:
        call geraTelaPerda
        call MiniDelay
        call musicGameOver

        call esperaInicio
        call limpaTelaPerda
        jmp main
		halt

reiniciaVal:
    loadn r2, #0
    rts
reiniciaVal2:
    loadn r5, #0
    rts

digLetra:	; Espera que uma tecla seja digitada e salva na variavel global "Letra"
	push fr		; Protege o registrador de flags
	push r0
	push r1
    push r2
    push r3
    push r4
    push r5
    push r6
	loadn r1, #255	; Se nao digitar nada vem 255

    loadn r2, #0
    loadn r3, #35
    loadn r5, #0
    loadn r6, #2
   	digLetra_Loop:
        inc r2
        cmp r2, r3
        ceq reiniciaVal
        inc r5
        cmp r5, r6
        ceq reiniciaVal2

		inchar r0			; Le o teclado, se nada for digitado = 255
		cmp r0, r1			;compara r0 com 255
		jeq digLetra_Loop	; Fica lendo ate' que digite uma tecla valida

    loadn r4, #randSequence
    add r4, r2, r4
    store randInicio, r4

    loadn r4, #incSequence
    add r4, r4, r5
    store incSequence, r4
	store Letra, r0			; Salva a tecla na variavel global "Letra"			
	
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
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
   push r2

   load r0, randInicio
   load r2, incSequence
   add r0, r0, r2
   loadn r1, #35
   mod r0, r0, r1
   store randInicio, r0

   pop r2
   pop r1
   rts


;(r0 - 1) é o valor maximo que pode ser gerado
geraAleatorioComMax:
   push r1
   push r2

   mov r1, r0
   call geraAleatorio
   mod r2, r0, r1
   mov r0, r2

    pop r2
   pop r1
   rts

; r0 = posicao a ser acessada
acessaJogada:
    push r1
    push r2

    mov r1, r0
    ; r0 esta livre
    ; r1 = posicao a ser acessada
    loadn r0, #jogadas
    add r2, r1, r0
    ; r2 agora aponta para a posicao da jogada
    loadi r0, r2

    pop r2
    pop r1
    rts


insereJogadaAleatoria:
    push r0
    push r1
    push r2
    push r3

    ; r3 = contador de jogadas
    load r3, jogadasAtual

    ; coloca em r1 a posicao a ser acessada
    loadn r1, #jogadas
    add r2, r1, r3

    ; r0 = num max - 1
    loadn r0, #4
    call geraAleatorioComMax

    ; r0 = valor aleatorio
    ; r2 = posicao a ser acessada
    storei r2, r0

    inc r3
    store jogadasAtual, r3

    pop r3
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

Delay:
	push r0
	push r1
	
	loadn r1, #2000  ; a
   	Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	loadn r0, #3000	; b
   	Delay_volta: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta	
	dec r1
	jnz Delay_volta2
	
	pop r1
	pop r0
	
	rts

MiniDelay:
	push r0
	push r1
	
	loadn r1, #1000  ; a
   	Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	loadn r0, #3000	; b
   	Delay_volta: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta	
	dec r1
	jnz Delay_volta2
	
	pop r1
	pop r0
	
	rts
	
limpaBlocos:
	push r1
	push r2

	loadn r1, #3840

	loadn r2, #216 ; posicao do bloco de cima
	call desenhaBloco

	loadn r2, #525 ; posicao do bloco de esq
	call desenhaBloco

	loadn r2, #547 ; posicao do bloco de dir
	call desenhaBloco
	
	loadn r2, #856 ; posicao do bloco de baixo
	call desenhaBloco
	
	pop r2
	pop r1
	
	rts
	
blocoCima:
	push r1
	push r2
	
	loadn r1, #512 ; cor
	loadn r2, #216 ; posicao do bloco de baixo
	call desenhaBloco
    call MiniDelay
    call soundUpPad
	
	pop r2
	pop r1
	
	rts
	
blocoBaixo:
	push r1
	push r2
	
	loadn r1, #3072 ; cor
	loadn r2, #856 ; posicao do bloco de baixo
	call desenhaBloco
    call MiniDelay
    call soundDownPad
	
	pop r2
	pop r1
	
	rts

blocoEsq:
	push r1
	push r2
	
	loadn r1, #2816 ; cor
	loadn r2, #525 ; posicao do bloco de baixo
	call desenhaBloco
    call MiniDelay
    call soundLeftPad
	
	pop r2
	pop r1
	
	rts

blocoDir:
	push r1
	push r2
	
	loadn r1, #2304 ; cor
	loadn r2, #547 ; posicao do bloco de baixo
	call desenhaBloco
    call MiniDelay
    call soundRightPad
	
	pop r2
	pop r1
	
	rts
	
geraBlocoAleat:
	push r0
	push r1
	push r2
	push r3
	push r4
	
    ; MODELO DE USO de acessaJogada
    ; acessa primeira jogada
    ; para acessar a ultima jogada, use o valor de jogadasAtual
    ; load r0, jogadasAtual
    ;call acessaJogada
    ; r0 contem o valor da jogada
	;load r0, jogadasAtual
	
	
    ;loadn r0, #4
    ;call geraAleatorioComMax
    
	loadn r1, #0
	cmp r0, r1
	ceq blocoCima
	
	loadn r2, #1
	cmp r0, r2
	ceq blocoDir
	
	loadn r3, #2
	cmp r0, r3
	ceq blocoEsq
	
	loadn r4, #3
	cmp r0, r4
	ceq blocoBaixo
	
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
LoopJogada:
	push r0
	push r1
	push r2
	push r3
	
	loadn r2, #1
	load r3, jogadasAtual ; contador
	
	geraLoop:
		mov r0, r2
		call acessaJogada
		call geraBlocoAleat
		call Delay
		call limpaBlocos
		inc r2
        cmp r2, r3
		jne geraLoop
	
	pop r3
	pop r2
	pop r1
	pop r0
	
	rts
	
entradasJogador:
	push r0
	push r1
	push r3
	push r4
	push r5
	push r6

	loadn r5, #64
	inchar r3
	load r1, jogadasAtual
	loadn r2, #1

	loopEntrada:
		call entrada
		call limpaBlocos
		call geraBlocoJogador
		call defValorJogada
        ; input r6
        mov r6, r2
		call testaJogada
		inc r2
        cmp r2, r1
		jne loopEntrada

    call MiniDelay
    call musicAcertou
	
	pop r6	
	pop r5
	pop r4
	pop r3
	pop r1	
	pop r0
	
	call Delay
	
	rts

entrada:
	push fr
	push r0
	push r1
	push r2
	push r3
	push r4
	
	digita:
		call digLetra
		
		load r0, Letra
		loadn r1, #'w'
		loadn r2, #'a'
		loadn r3, #'s'
		loadn r4, #'d'
		
		cmp r0, r1
		jeq retorna
		cmp r0, r2
		jeq retorna
		cmp r0, r3
		jeq retorna
		cmp r0, r4
		jeq retorna
		
		jmp digita 

	retorna:
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0	
		pop fr
		rts
	
geraBlocoJogador:
	push fr
	push r0
	push r1
	push r2
	push r3
	push r4
	
    ;loadn r0, #4
    ;call geraAleatorioComMax
	load r0, Letra
    
	loadn r1, #'w'
	cmp r0, r1
	ceq blocoCima
	
	loadn r2, #'d'
	cmp r0, r2
	ceq blocoDir
	
	loadn r3, #'a'
	cmp r0, r3
	ceq blocoEsq
	
	loadn r4, #'s'
	cmp r0, r4
	ceq blocoBaixo
	
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	pop fr
	rts
	
defValorJogada:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	
	load r0, Letra
	;loadn r0, #'d'
	
	loadn r1, #'w'
	loadn r5, #0
	cmp r0, r1
	jeq retornaDef
	
	loadn r2, #'d'
	loadn r5, #1
	cmp r0, r2
	jeq retornaDef

	loadn r3, #'a'
	loadn r5, #2
	cmp r0, r3
	jeq retornaDef

	loadn r4, #'s'
	loadn r5, #3
	cmp r0, r4
	jeq retornaDef

	retornaDef:	
		store valorJogada, r5
		pop r5
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		rts

;r0 indice da jogada	
testaJogada:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	
	loadn r5, #0 ; flag não perdeu
	
	load r1, valorJogada ; entrada do jogador
	;loadn r1, #1
    mov r0, r6
	call acessaJogada
	;loadn r0, #3 ; jogada certa cima (teste)
	
	cmp r0, r1 ; compara com a lista de jogadas
	jeq jogadaCerta
	
	;PARTE PRA QUANDO PERDE;
	;loadn r3, #1
	;store perdeu, r3 ;errou - perdeu o jogo
	jmp perdeuJogo
	
	jogadaCerta:
		store perdeu, r5
		
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
		
	rts
	
loopJogo:
	push r0
	push r1
	push r2
	push r3
	push r4
	
	load r3, scoreTotal ; pontuação
	loadn r4, #64
	
	load r0, numJogadas
	inc r0
	store numJogadas, r0
	
	call insereJogadaAleatoria
		
	call LoopJogada
		
	call entradasJogador
	
    
	inc r3
    loadn r4, #64
	outchar r3, r4
	store scoreTotal, r3

	call limpaBlocos
	
	call Delay
	call Delay
	call Delay


	pop r2
	pop r1
	pop r0

	jmp loopJogo
	
	rts

tocaNota: 
    ; r0 = frequencia
    ; r1 = duracao
    ; r2 = modo
    sound r0, r1, r2

    rts

;toca musica de gameOver
musicGameOver:
    ; Melodia:
    ; D4, C#4, C4, B4
    ; 5873, 5544, 5233, 4939
    push r0
    push r1
    push r2

    ; r0 = frequencia
    ; r1 = duracao
    ; r2 = modo

    loadn r0, #5873
    loadn r1, #250
    loadn r2, #2 ;onda triangular
    call tocaNota

    loadn r0, #5544
    call tocaNota

    loadn r0, #5233
    call tocaNota

    loadn r0, #4939
    loadn r1, #1000
    call tocaNota

    pop r2
    pop r1
    pop r0

    rts

;musica quando acerta toda a sequencia
musicAcertou:
    ; Melodia:
    ; D3, G3
    ; 2936, 3919

    push r2
    push r1
    push r0

    ; r0 = frequencia
    ; r1 = duracao
    ; r2 = modo

    loadn r0, #2936
    loadn r1, #250
    loadn r2, #2 ;onda triangular
    call tocaNota

    loadn r0, #3919
    loadn r1, #250
    call tocaNota

    pop r0
    pop r1
    pop r2

    rts

soundLeftPad:
    ; Nota E3: 3296
    push r0
    push r1
    push r2

    loadn r0, #3296
    loadn r1, #150
    loadn r2, #0
    call tocaNota

    pop r0
    pop r1
    pop r2

    rts

soundRightPad:
    ; Nota G3: 3919
    push r0
    push r1
    push r2

    loadn r0, #3919
    loadn r1, #150
    loadn r2, #0
    call tocaNota

    pop r0
    pop r1
    pop r2

    rts

soundUpPad:
    ; Nota A4: 4400
    push r0
    push r1
    push r2

    loadn r0, #4400
    loadn r1, #150
    loadn r2, #0
    call tocaNota

    pop r0
    pop r1
    pop r2

    rts


soundDownPad:
    ; Nota C3: 2616
    push r0
    push r1
    push r2

    loadn r0, #2616
    loadn r1, #150
    loadn r2, #0
    call tocaNota

    pop r0
    pop r1
    pop r2

    rts

telaPerda : var #1200
  ;Linha 0
  static telaPerda + #0, #3967
  static telaPerda + #1, #3967
  static telaPerda + #2, #3967
  static telaPerda + #3, #3967
  static telaPerda + #4, #3967
  static telaPerda + #5, #3967
  static telaPerda + #6, #3967
  static telaPerda + #7, #3967
  static telaPerda + #8, #3967
  static telaPerda + #9, #3967
  static telaPerda + #10, #3967
  static telaPerda + #11, #3967
  static telaPerda + #12, #3967
  static telaPerda + #13, #3967
  static telaPerda + #14, #3967
  static telaPerda + #15, #3967
  static telaPerda + #16, #3967
  static telaPerda + #17, #3967
  static telaPerda + #18, #3967
  static telaPerda + #19, #3967
  static telaPerda + #20, #3967
  static telaPerda + #21, #3967
  static telaPerda + #22, #3967
  static telaPerda + #23, #3967
  static telaPerda + #24, #3967
  static telaPerda + #25, #3967
  static telaPerda + #26, #3967
  static telaPerda + #27, #3967
  static telaPerda + #28, #3967
  static telaPerda + #29, #3967
  static telaPerda + #30, #3967
  static telaPerda + #31, #3967
  static telaPerda + #32, #3967
  static telaPerda + #33, #3967
  static telaPerda + #34, #3967
  static telaPerda + #35, #3967
  static telaPerda + #36, #3967
  static telaPerda + #37, #3967
  static telaPerda + #38, #3967
  static telaPerda + #39, #3967

  ;Linha 1
  static telaPerda + #40, #3967
  static telaPerda + #41, #3967
  static telaPerda + #42, #3967
  static telaPerda + #43, #3967
  static telaPerda + #44, #3967
  static telaPerda + #45, #3967
  static telaPerda + #46, #3967
  static telaPerda + #47, #3967
  static telaPerda + #48, #3967
  static telaPerda + #49, #3967
  static telaPerda + #50, #3967
  static telaPerda + #51, #3967
  static telaPerda + #52, #3967
  static telaPerda + #53, #3967
  static telaPerda + #54, #3967
  static telaPerda + #55, #3967
  static telaPerda + #56, #3967
  static telaPerda + #57, #3967
  static telaPerda + #58, #3967
  static telaPerda + #59, #3967
  static telaPerda + #60, #3967
  static telaPerda + #61, #3967
  static telaPerda + #62, #3967
  static telaPerda + #63, #3967
  static telaPerda + #64, #3967
  static telaPerda + #65, #3967
  static telaPerda + #66, #3967
  static telaPerda + #67, #3967
  static telaPerda + #68, #3967
  static telaPerda + #69, #3967
  static telaPerda + #70, #3967
  static telaPerda + #71, #3967
  static telaPerda + #72, #3967
  static telaPerda + #73, #3967
  static telaPerda + #74, #3967
  static telaPerda + #75, #3967
  static telaPerda + #76, #3967
  static telaPerda + #77, #3967
  static telaPerda + #78, #3967
  static telaPerda + #79, #3967

  ;Linha 2
  static telaPerda + #80, #3967
  static telaPerda + #81, #3967
  static telaPerda + #82, #3967
  static telaPerda + #83, #3967
  static telaPerda + #84, #3967
  static telaPerda + #85, #3967
  static telaPerda + #86, #3967
  static telaPerda + #87, #3967
  static telaPerda + #88, #3967
  static telaPerda + #89, #3967
  static telaPerda + #90, #3967
  static telaPerda + #91, #3967
  static telaPerda + #92, #3967
  static telaPerda + #93, #3967
  static telaPerda + #94, #1834
  static telaPerda + #95, #3967
  static telaPerda + #96, #3967
  static telaPerda + #97, #3967
  static telaPerda + #98, #3967
  static telaPerda + #99, #3967
  static telaPerda + #100, #3967
  static telaPerda + #101, #3967
  static telaPerda + #102, #3967
  static telaPerda + #103, #3967
  static telaPerda + #104, #3967
  static telaPerda + #105, #3967
  static telaPerda + #106, #1066
  static telaPerda + #107, #3967
  static telaPerda + #108, #3967
  static telaPerda + #109, #3967
  static telaPerda + #110, #3967
  static telaPerda + #111, #3967
  static telaPerda + #112, #3967
  static telaPerda + #113, #3967
  static telaPerda + #114, #3967
  static telaPerda + #115, #3370
  static telaPerda + #116, #3967
  static telaPerda + #117, #3967
  static telaPerda + #118, #3967
  static telaPerda + #119, #3967

  ;Linha 3
  static telaPerda + #120, #3967
  static telaPerda + #121, #3967
  static telaPerda + #122, #3967
  static telaPerda + #123, #3967
  static telaPerda + #124, #554
  static telaPerda + #125, #3967
  static telaPerda + #126, #3967
  static telaPerda + #127, #3967
  static telaPerda + #128, #3967
  static telaPerda + #129, #3967
  static telaPerda + #130, #3967
  static telaPerda + #131, #3967
  static telaPerda + #132, #3967
  static telaPerda + #133, #3967
  static telaPerda + #134, #3967
  static telaPerda + #135, #3967
  static telaPerda + #136, #3967
  static telaPerda + #137, #3967
  static telaPerda + #138, #3967
  static telaPerda + #139, #3967
  static telaPerda + #140, #3967
  static telaPerda + #141, #3967
  static telaPerda + #142, #3967
  static telaPerda + #143, #3967
  static telaPerda + #144, #3967
  static telaPerda + #145, #3967
  static telaPerda + #146, #3967
  static telaPerda + #147, #3967
  static telaPerda + #148, #3967
  static telaPerda + #149, #3967
  static telaPerda + #150, #3967
  static telaPerda + #151, #3967
  static telaPerda + #152, #3967
  static telaPerda + #153, #3967
  static telaPerda + #154, #3967
  static telaPerda + #155, #3967
  static telaPerda + #156, #3967
  static telaPerda + #157, #3967
  static telaPerda + #158, #3967
  static telaPerda + #159, #3967

  ;Linha 4
  static telaPerda + #160, #3967
  static telaPerda + #161, #3967
  static telaPerda + #162, #3967
  static telaPerda + #163, #3967
  static telaPerda + #164, #3967
  static telaPerda + #165, #3967
  static telaPerda + #166, #3967
  static telaPerda + #167, #3967
  static telaPerda + #168, #3967
  static telaPerda + #169, #3967
  static telaPerda + #170, #3967
  static telaPerda + #171, #3967
  static telaPerda + #172, #3967
  static telaPerda + #173, #3967
  static telaPerda + #174, #3967
  static telaPerda + #175, #3967
  static telaPerda + #176, #3967
  static telaPerda + #177, #3967
  static telaPerda + #178, #3967
  static telaPerda + #179, #3967
  static telaPerda + #180, #3967
  static telaPerda + #181, #3967
  static telaPerda + #182, #3967
  static telaPerda + #183, #3967
  static telaPerda + #184, #3967
  static telaPerda + #185, #3967
  static telaPerda + #186, #3967
  static telaPerda + #187, #3967
  static telaPerda + #188, #3967
  static telaPerda + #189, #3967
  static telaPerda + #190, #3967
  static telaPerda + #191, #3967
  static telaPerda + #192, #3967
  static telaPerda + #193, #3967
  static telaPerda + #194, #3967
  static telaPerda + #195, #3967
  static telaPerda + #196, #3967
  static telaPerda + #197, #3967
  static telaPerda + #198, #3967
  static telaPerda + #199, #3967

  ;Linha 5
  static telaPerda + #200, #3967
  static telaPerda + #201, #3967
  static telaPerda + #202, #3967
  static telaPerda + #203, #3967
  static telaPerda + #204, #3967
  static telaPerda + #205, #3967
  static telaPerda + #206, #3967
  static telaPerda + #207, #3967
  static telaPerda + #208, #3967
  static telaPerda + #209, #3967
  static telaPerda + #210, #3967
  static telaPerda + #211, #3967
  static telaPerda + #212, #3967
  static telaPerda + #213, #3967
  static telaPerda + #214, #3967
  static telaPerda + #215, #3967
  static telaPerda + #216, #3967
  static telaPerda + #217, #3967
  static telaPerda + #218, #3967
  static telaPerda + #219, #3967
  static telaPerda + #220, #3967
  static telaPerda + #221, #3967
  static telaPerda + #222, #3967
  static telaPerda + #223, #3967
  static telaPerda + #224, #3967
  static telaPerda + #225, #3967
  static telaPerda + #226, #3967
  static telaPerda + #227, #3967
  static telaPerda + #228, #3967
  static telaPerda + #229, #3967
  static telaPerda + #230, #3967
  static telaPerda + #231, #3967
  static telaPerda + #232, #3967
  static telaPerda + #233, #3967
  static telaPerda + #234, #3967
  static telaPerda + #235, #3967
  static telaPerda + #236, #3967
  static telaPerda + #237, #3967
  static telaPerda + #238, #3967
  static telaPerda + #239, #3967

  ;Linha 6
  static telaPerda + #240, #3967
  static telaPerda + #241, #3967
  static telaPerda + #242, #3967
  static telaPerda + #243, #3967
  static telaPerda + #244, #3967
  static telaPerda + #245, #3967
  static telaPerda + #246, #3967
  static telaPerda + #247, #3967
  static telaPerda + #248, #3967
  static telaPerda + #249, #3967
  static telaPerda + #250, #3967
  static telaPerda + #251, #3967
  static telaPerda + #252, #3967
  static telaPerda + #253, #3967
  static telaPerda + #254, #3967
  static telaPerda + #255, #3967
  static telaPerda + #256, #3967
  static telaPerda + #257, #3967
  static telaPerda + #258, #3967
  static telaPerda + #259, #3967
  static telaPerda + #260, #3967
  static telaPerda + #261, #3967
  static telaPerda + #262, #3967
  static telaPerda + #263, #3967
  static telaPerda + #264, #3967
  static telaPerda + #265, #3967
  static telaPerda + #266, #3967
  static telaPerda + #267, #3967
  static telaPerda + #268, #3967
  static telaPerda + #269, #3967
  static telaPerda + #270, #3967
  static telaPerda + #271, #3967
  static telaPerda + #272, #3967
  static telaPerda + #273, #3967
  static telaPerda + #274, #3967
  static telaPerda + #275, #3967
  static telaPerda + #276, #3967
  static telaPerda + #277, #3967
  static telaPerda + #278, #3967
  static telaPerda + #279, #3967

  ;Linha 7
  static telaPerda + #280, #3967
  static telaPerda + #281, #3967
  static telaPerda + #282, #3967
  static telaPerda + #283, #3967
  static telaPerda + #284, #3967
  static telaPerda + #285, #3967
  static telaPerda + #286, #3967
  static telaPerda + #287, #3967
  static telaPerda + #288, #3967
  static telaPerda + #289, #3967
  static telaPerda + #290, #3967
  static telaPerda + #291, #3967
  static telaPerda + #292, #3967
  static telaPerda + #293, #3967
  static telaPerda + #294, #3967
  static telaPerda + #295, #3967
  static telaPerda + #296, #3967
  static telaPerda + #297, #3967
  static telaPerda + #298, #3967
  static telaPerda + #299, #3967
  static telaPerda + #300, #3967
  static telaPerda + #301, #3967
  static telaPerda + #302, #3967
  static telaPerda + #303, #3967
  static telaPerda + #304, #3967
  static telaPerda + #305, #3967
  static telaPerda + #306, #3967
  static telaPerda + #307, #3967
  static telaPerda + #308, #3967
  static telaPerda + #309, #3967
  static telaPerda + #310, #3967
  static telaPerda + #311, #3967
  static telaPerda + #312, #3967
  static telaPerda + #313, #3967
  static telaPerda + #314, #3967
  static telaPerda + #315, #3967
  static telaPerda + #316, #3967
  static telaPerda + #317, #3114
  static telaPerda + #318, #3967
  static telaPerda + #319, #3967

  ;Linha 8
  static telaPerda + #320, #3967
  static telaPerda + #321, #3967
  static telaPerda + #322, #3967
  static telaPerda + #323, #3967
  static telaPerda + #324, #3967
  static telaPerda + #325, #3967
  static telaPerda + #326, #3967
  static telaPerda + #327, #3967
  static telaPerda + #328, #3967
  static telaPerda + #329, #1322
  static telaPerda + #330, #3967
  static telaPerda + #331, #3967
  static telaPerda + #332, #3967
  static telaPerda + #333, #3967
  static telaPerda + #334, #3967
  static telaPerda + #335, #3967
  static telaPerda + #336, #3967
  static telaPerda + #337, #3967
  static telaPerda + #338, #3967
  static telaPerda + #339, #3967
  static telaPerda + #340, #3967
  static telaPerda + #341, #3967
  static telaPerda + #342, #3967
  static telaPerda + #343, #3967
  static telaPerda + #344, #3626
  static telaPerda + #345, #3967
  static telaPerda + #346, #3967
  static telaPerda + #347, #3967
  static telaPerda + #348, #3967
  static telaPerda + #349, #3967
  static telaPerda + #350, #3967
  static telaPerda + #351, #3967
  static telaPerda + #352, #3626
  static telaPerda + #353, #3967
  static telaPerda + #354, #3967
  static telaPerda + #355, #3967
  static telaPerda + #356, #3967
  static telaPerda + #357, #3967
  static telaPerda + #358, #3967
  static telaPerda + #359, #3967

  ;Linha 9
  static telaPerda + #360, #3967
  static telaPerda + #361, #3967
  static telaPerda + #362, #3967
  static telaPerda + #363, #3967
  static telaPerda + #364, #3967
  static telaPerda + #365, #3967
  static telaPerda + #366, #3967
  static telaPerda + #367, #3967
  static telaPerda + #368, #3967
  static telaPerda + #369, #3967
  static telaPerda + #370, #3967
  static telaPerda + #371, #3967
  static telaPerda + #372, #3967
  static telaPerda + #373, #3967
  static telaPerda + #374, #3967
  static telaPerda + #375, #3967
  static telaPerda + #376, #3967
  static telaPerda + #377, #3967
  static telaPerda + #378, #3967
  static telaPerda + #379, #3967
  static telaPerda + #380, #3967
  static telaPerda + #381, #3967
  static telaPerda + #382, #3967
  static telaPerda + #383, #3967
  static telaPerda + #384, #3967
  static telaPerda + #385, #3967
  static telaPerda + #386, #3967
  static telaPerda + #387, #3967
  static telaPerda + #388, #3967
  static telaPerda + #389, #3967
  static telaPerda + #390, #3967
  static telaPerda + #391, #3967
  static telaPerda + #392, #3967
  static telaPerda + #393, #3967
  static telaPerda + #394, #3967
  static telaPerda + #395, #3967
  static telaPerda + #396, #3967
  static telaPerda + #397, #3967
  static telaPerda + #398, #3967
  static telaPerda + #399, #3967

  ;Linha 10
  static telaPerda + #400, #3967
  static telaPerda + #401, #3967
  static telaPerda + #402, #3967
  static telaPerda + #403, #3967
  static telaPerda + #404, #3967
  static telaPerda + #405, #3967
  static telaPerda + #406, #3967
  static telaPerda + #407, #3967
  static telaPerda + #408, #3967
  static telaPerda + #409, #3967
  static telaPerda + #410, #3967
  static telaPerda + #411, #3967
  static telaPerda + #412, #3967
  static telaPerda + #413, #3967
  static telaPerda + #414, #3967
  static telaPerda + #415, #3967
  static telaPerda + #416, #3967
  static telaPerda + #417, #3967
  static telaPerda + #418, #3967
  static telaPerda + #419, #3967
  static telaPerda + #420, #3967
  static telaPerda + #421, #3967
  static telaPerda + #422, #3967
  static telaPerda + #423, #3967
  static telaPerda + #424, #3967
  static telaPerda + #425, #3967
  static telaPerda + #426, #3967
  static telaPerda + #427, #3967
  static telaPerda + #428, #3967
  static telaPerda + #429, #3967
  static telaPerda + #430, #3967
  static telaPerda + #431, #3967
  static telaPerda + #432, #3967
  static telaPerda + #433, #3967
  static telaPerda + #434, #3967
  static telaPerda + #435, #3967
  static telaPerda + #436, #3967
  static telaPerda + #437, #3967
  static telaPerda + #438, #3967
  static telaPerda + #439, #3967

  ;Linha 11
  static telaPerda + #440, #3967
  static telaPerda + #441, #3967
  static telaPerda + #442, #3967
  static telaPerda + #443, #3967
  static telaPerda + #444, #3967
  static telaPerda + #445, #3967
  static telaPerda + #446, #3967
  static telaPerda + #447, #3967
  static telaPerda + #448, #3967
  static telaPerda + #449, #3967
  static telaPerda + #450, #3967
  static telaPerda + #451, #3967
  static telaPerda + #452, #3967
  static telaPerda + #453, #3967
  static telaPerda + #454, #3967
  static telaPerda + #455, #3967
  static telaPerda + #456, #3967
  static telaPerda + #457, #3967
  static telaPerda + #458, #3967
  static telaPerda + #459, #3967
  static telaPerda + #460, #3967
  static telaPerda + #461, #3967
  static telaPerda + #462, #3967
  static telaPerda + #463, #3967
  static telaPerda + #464, #3967
  static telaPerda + #465, #3967
  static telaPerda + #466, #3967
  static telaPerda + #467, #3967
  static telaPerda + #468, #3967
  static telaPerda + #469, #3967
  static telaPerda + #470, #3967
  static telaPerda + #471, #3967
  static telaPerda + #472, #3967
  static telaPerda + #473, #3967
  static telaPerda + #474, #3967
  static telaPerda + #475, #3967
  static telaPerda + #476, #3967
  static telaPerda + #477, #3967
  static telaPerda + #478, #3967
  static telaPerda + #479, #3967

  ;Linha 12
  static telaPerda + #480, #3967
  static telaPerda + #481, #3967
  static telaPerda + #482, #3967
  static telaPerda + #483, #3967
  static telaPerda + #484, #3370
  static telaPerda + #485, #3967
  static telaPerda + #486, #3967
  static telaPerda + #487, #3967
  static telaPerda + #488, #3967
  static telaPerda + #489, #3967
  static telaPerda + #490, #3967
  static telaPerda + #491, #3967
  static telaPerda + #492, #3967
  static telaPerda + #493, #2902
  static telaPerda + #494, #2895
  static telaPerda + #495, #2883
  static telaPerda + #496, #2885
  static telaPerda + #497, #3967
  static telaPerda + #498, #2896
  static telaPerda + #499, #2885
  static telaPerda + #500, #2898
  static telaPerda + #501, #2884
  static telaPerda + #502, #2885
  static telaPerda + #503, #2901
  static telaPerda + #504, #3967
  static telaPerda + #505, #2874
  static telaPerda + #506, #2915
  static telaPerda + #507, #3967
  static telaPerda + #508, #3967
  static telaPerda + #509, #3967
  static telaPerda + #510, #3967
  static telaPerda + #511, #3967
  static telaPerda + #512, #3967
  static telaPerda + #513, #3967
  static telaPerda + #514, #3967
  static telaPerda + #515, #3967
  static telaPerda + #516, #3967
  static telaPerda + #517, #3967
  static telaPerda + #518, #3967
  static telaPerda + #519, #3967

  ;Linha 13
  static telaPerda + #520, #3967
  static telaPerda + #521, #3967
  static telaPerda + #522, #3967
  static telaPerda + #523, #3967
  static telaPerda + #524, #3967
  static telaPerda + #525, #3967
  static telaPerda + #526, #3967
  static telaPerda + #527, #3967
  static telaPerda + #528, #3967
  static telaPerda + #529, #3967
  static telaPerda + #530, #3967
  static telaPerda + #531, #3967
  static telaPerda + #532, #3967
  static telaPerda + #533, #3967
  static telaPerda + #534, #3967
  static telaPerda + #535, #3967
  static telaPerda + #536, #3967
  static telaPerda + #537, #3967
  static telaPerda + #538, #3967
  static telaPerda + #539, #3967
  static telaPerda + #540, #3967
  static telaPerda + #541, #3967
  static telaPerda + #542, #3967
  static telaPerda + #543, #3967
  static telaPerda + #544, #3967
  static telaPerda + #545, #3967
  static telaPerda + #546, #3967
  static telaPerda + #547, #3967
  static telaPerda + #548, #3967
  static telaPerda + #549, #3967
  static telaPerda + #550, #3967
  static telaPerda + #551, #3967
  static telaPerda + #552, #3967
  static telaPerda + #553, #3967
  static telaPerda + #554, #3967
  static telaPerda + #555, #3967
  static telaPerda + #556, #554
  static telaPerda + #557, #3967
  static telaPerda + #558, #3967
  static telaPerda + #559, #3967

  ;Linha 14
  static telaPerda + #560, #3967
  static telaPerda + #561, #3967
  static telaPerda + #562, #3967
  static telaPerda + #563, #3967
  static telaPerda + #564, #3967
  static telaPerda + #565, #3967
  static telaPerda + #566, #3967
  static telaPerda + #567, #3967
  static telaPerda + #568, #3967
  static telaPerda + #569, #3967
  static telaPerda + #570, #3967
  static telaPerda + #571, #3967
  static telaPerda + #572, #3967
  static telaPerda + #573, #3967
  static telaPerda + #574, #3967
  static telaPerda + #575, #3967
  static telaPerda + #576, #3967
  static telaPerda + #577, #3967
  static telaPerda + #578, #3967
  static telaPerda + #579, #3967
  static telaPerda + #580, #3967
  static telaPerda + #581, #3967
  static telaPerda + #582, #3967
  static telaPerda + #583, #3967
  static telaPerda + #584, #3967
  static telaPerda + #585, #3967
  static telaPerda + #586, #3967
  static telaPerda + #587, #3967
  static telaPerda + #588, #3967
  static telaPerda + #589, #3967
  static telaPerda + #590, #3967
  static telaPerda + #591, #3967
  static telaPerda + #592, #3967
  static telaPerda + #593, #3967
  static telaPerda + #594, #3967
  static telaPerda + #595, #3967
  static telaPerda + #596, #3967
  static telaPerda + #597, #3967
  static telaPerda + #598, #3967
  static telaPerda + #599, #3967

  ;Linha 15
  static telaPerda + #600, #3967
  static telaPerda + #601, #3967
  static telaPerda + #602, #3967
  static telaPerda + #603, #3967
  static telaPerda + #604, #3967
  static telaPerda + #605, #3967
  static telaPerda + #606, #3967
  static telaPerda + #607, #3967
  static telaPerda + #608, #3967
  static telaPerda + #609, #3967
  static telaPerda + #610, #3967
  static telaPerda + #611, #3967
  static telaPerda + #612, #3967
  static telaPerda + #613, #3967
  static telaPerda + #614, #3967
  static telaPerda + #615, #3967
  static telaPerda + #616, #3967
  static telaPerda + #617, #3967
  static telaPerda + #618, #3967
  static telaPerda + #619, #3967
  static telaPerda + #620, #3967
  static telaPerda + #621, #3967
  static telaPerda + #622, #3967
  static telaPerda + #623, #3967
  static telaPerda + #624, #3967
  static telaPerda + #625, #3967
  static telaPerda + #626, #3967
  static telaPerda + #627, #3967
  static telaPerda + #628, #3967
  static telaPerda + #629, #3967
  static telaPerda + #630, #3967
  static telaPerda + #631, #3967
  static telaPerda + #632, #3967
  static telaPerda + #633, #3967
  static telaPerda + #634, #3967
  static telaPerda + #635, #3967
  static telaPerda + #636, #3967
  static telaPerda + #637, #3967
  static telaPerda + #638, #3967
  static telaPerda + #639, #3967

  ;Linha 16
  static telaPerda + #640, #3967
  static telaPerda + #641, #3967
  static telaPerda + #642, #3967
  static telaPerda + #643, #3967
  static telaPerda + #644, #3967
  static telaPerda + #645, #3967
  static telaPerda + #646, #3967
  static telaPerda + #647, #3967
  static telaPerda + #648, #3967
  static telaPerda + #649, #3967
  static telaPerda + #650, #2907
  static telaPerda + #651, #2917
  static telaPerda + #652, #2926
  static telaPerda + #653, #2932
  static telaPerda + #654, #2917
  static telaPerda + #655, #2930
  static telaPerda + #656, #2830
  static telaPerda + #657, #2928
  static telaPerda + #658, #2913
  static telaPerda + #659, #2930
  static telaPerda + #660, #2913
  static telaPerda + #661, #2943
  static telaPerda + #662, #2930
  static telaPerda + #663, #2917
  static telaPerda + #664, #2921
  static telaPerda + #665, #2915
  static telaPerda + #666, #2921
  static telaPerda + #667, #2913
  static telaPerda + #668, #2930
  static telaPerda + #669, #2909
  static telaPerda + #670, #3967
  static telaPerda + #671, #2346
  static telaPerda + #672, #3967
  static telaPerda + #673, #3967
  static telaPerda + #674, #3967
  static telaPerda + #675, #3967
  static telaPerda + #676, #3967
  static telaPerda + #677, #3967
  static telaPerda + #678, #3967
  static telaPerda + #679, #3967

  ;Linha 17
  static telaPerda + #680, #3967
  static telaPerda + #681, #3967
  static telaPerda + #682, #3967
  static telaPerda + #683, #3967
  static telaPerda + #684, #3967
  static telaPerda + #685, #3967
  static telaPerda + #686, #3967
  static telaPerda + #687, #3967
  static telaPerda + #688, #3967
  static telaPerda + #689, #3967
  static telaPerda + #690, #3967
  static telaPerda + #691, #3967
  static telaPerda + #692, #3967
  static telaPerda + #693, #3967
  static telaPerda + #694, #3967
  static telaPerda + #695, #3967
  static telaPerda + #696, #3967
  static telaPerda + #697, #3967
  static telaPerda + #698, #3967
  static telaPerda + #699, #3967
  static telaPerda + #700, #3967
  static telaPerda + #701, #3967
  static telaPerda + #702, #3967
  static telaPerda + #703, #3967
  static telaPerda + #704, #3967
  static telaPerda + #705, #3967
  static telaPerda + #706, #3967
  static telaPerda + #707, #3967
  static telaPerda + #708, #3967
  static telaPerda + #709, #3967
  static telaPerda + #710, #3967
  static telaPerda + #711, #3967
  static telaPerda + #712, #3967
  static telaPerda + #713, #3967
  static telaPerda + #714, #3967
  static telaPerda + #715, #3967
  static telaPerda + #716, #3967
  static telaPerda + #717, #3967
  static telaPerda + #718, #3967
  static telaPerda + #719, #3967

  ;Linha 18
  static telaPerda + #720, #3967
  static telaPerda + #721, #3967
  static telaPerda + #722, #3967
  static telaPerda + #723, #3967
  static telaPerda + #724, #3114
  static telaPerda + #725, #3967
  static telaPerda + #726, #3967
  static telaPerda + #727, #3967
  static telaPerda + #728, #3967
  static telaPerda + #729, #3967
  static telaPerda + #730, #3967
  static telaPerda + #731, #3967
  static telaPerda + #732, #3967
  static telaPerda + #733, #3967
  static telaPerda + #734, #3967
  static telaPerda + #735, #3967
  static telaPerda + #736, #3967
  static telaPerda + #737, #3967
  static telaPerda + #738, #3967
  static telaPerda + #739, #3967
  static telaPerda + #740, #3967
  static telaPerda + #741, #3967
  static telaPerda + #742, #3967
  static telaPerda + #743, #3967
  static telaPerda + #744, #3967
  static telaPerda + #745, #3967
  static telaPerda + #746, #3967
  static telaPerda + #747, #3967
  static telaPerda + #748, #3967
  static telaPerda + #749, #3967
  static telaPerda + #750, #3967
  static telaPerda + #751, #3967
  static telaPerda + #752, #3967
  static telaPerda + #753, #3967
  static telaPerda + #754, #3967
  static telaPerda + #755, #3967
  static telaPerda + #756, #3967
  static telaPerda + #757, #3967
  static telaPerda + #758, #3967
  static telaPerda + #759, #3967

  ;Linha 19
  static telaPerda + #760, #3967
  static telaPerda + #761, #3967
  static telaPerda + #762, #3967
  static telaPerda + #763, #3967
  static telaPerda + #764, #3967
  static telaPerda + #765, #3967
  static telaPerda + #766, #3967
  static telaPerda + #767, #3967
  static telaPerda + #768, #3967
  static telaPerda + #769, #3967
  static telaPerda + #770, #3967
  static telaPerda + #771, #3967
  static telaPerda + #772, #3967
  static telaPerda + #773, #3967
  static telaPerda + #774, #3967
  static telaPerda + #775, #3967
  static telaPerda + #776, #3967
  static telaPerda + #777, #3967
  static telaPerda + #778, #3967
  static telaPerda + #779, #3967
  static telaPerda + #780, #3967
  static telaPerda + #781, #3967
  static telaPerda + #782, #3967
  static telaPerda + #783, #3967
  static telaPerda + #784, #3967
  static telaPerda + #785, #3967
  static telaPerda + #786, #3967
  static telaPerda + #787, #3967
  static telaPerda + #788, #3967
  static telaPerda + #789, #3967
  static telaPerda + #790, #3967
  static telaPerda + #791, #3967
  static telaPerda + #792, #3967
  static telaPerda + #793, #3967
  static telaPerda + #794, #3967
  static telaPerda + #795, #3967
  static telaPerda + #796, #1066
  static telaPerda + #797, #3967
  static telaPerda + #798, #3967
  static telaPerda + #799, #3967

  ;Linha 20
  static telaPerda + #800, #3967
  static telaPerda + #801, #3967
  static telaPerda + #802, #3967
  static telaPerda + #803, #3967
  static telaPerda + #804, #3967
  static telaPerda + #805, #3967
  static telaPerda + #806, #3967
  static telaPerda + #807, #3967
  static telaPerda + #808, #3967
  static telaPerda + #809, #3967
  static telaPerda + #810, #3967
  static telaPerda + #811, #3967
  static telaPerda + #812, #3967
  static telaPerda + #813, #3967
  static telaPerda + #814, #3967
  static telaPerda + #815, #3967
  static telaPerda + #816, #3967
  static telaPerda + #817, #3967
  static telaPerda + #818, #3967
  static telaPerda + #819, #3967
  static telaPerda + #820, #3967
  static telaPerda + #821, #3967
  static telaPerda + #822, #3967
  static telaPerda + #823, #3967
  static telaPerda + #824, #3967
  static telaPerda + #825, #3967
  static telaPerda + #826, #3967
  static telaPerda + #827, #3967
  static telaPerda + #828, #3967
  static telaPerda + #829, #3967
  static telaPerda + #830, #3967
  static telaPerda + #831, #3967
  static telaPerda + #832, #3967
  static telaPerda + #833, #3967
  static telaPerda + #834, #3967
  static telaPerda + #835, #3967
  static telaPerda + #836, #3967
  static telaPerda + #837, #3967
  static telaPerda + #838, #3967
  static telaPerda + #839, #3967

  ;Linha 21
  static telaPerda + #840, #3967
  static telaPerda + #841, #3967
  static telaPerda + #842, #3967
  static telaPerda + #843, #3967
  static telaPerda + #844, #3967
  static telaPerda + #845, #3967
  static telaPerda + #846, #3967
  static telaPerda + #847, #3967
  static telaPerda + #848, #3967
  static telaPerda + #849, #3967
  static telaPerda + #850, #3967
  static telaPerda + #851, #3967
  static telaPerda + #852, #3967
  static telaPerda + #853, #2346
  static telaPerda + #854, #3967
  static telaPerda + #855, #3967
  static telaPerda + #856, #3967
  static telaPerda + #857, #3967
  static telaPerda + #858, #3967
  static telaPerda + #859, #3967
  static telaPerda + #860, #3967
  static telaPerda + #861, #3967
  static telaPerda + #862, #3967
  static telaPerda + #863, #3967
  static telaPerda + #864, #3626
  static telaPerda + #865, #3967
  static telaPerda + #866, #3967
  static telaPerda + #867, #3967
  static telaPerda + #868, #3967
  static telaPerda + #869, #3967
  static telaPerda + #870, #3967
  static telaPerda + #871, #3967
  static telaPerda + #872, #3967
  static telaPerda + #873, #3967
  static telaPerda + #874, #3967
  static telaPerda + #875, #3967
  static telaPerda + #876, #3967
  static telaPerda + #877, #3967
  static telaPerda + #878, #3967
  static telaPerda + #879, #3967

  ;Linha 22
  static telaPerda + #880, #3967
  static telaPerda + #881, #3967
  static telaPerda + #882, #3626
  static telaPerda + #883, #3967
  static telaPerda + #884, #3967
  static telaPerda + #885, #3967
  static telaPerda + #886, #3967
  static telaPerda + #887, #3967
  static telaPerda + #888, #3967
  static telaPerda + #889, #3967
  static telaPerda + #890, #3967
  static telaPerda + #891, #3967
  static telaPerda + #892, #3967
  static telaPerda + #893, #3967
  static telaPerda + #894, #3967
  static telaPerda + #895, #3967
  static telaPerda + #896, #3967
  static telaPerda + #897, #3967
  static telaPerda + #898, #3967
  static telaPerda + #899, #3967
  static telaPerda + #900, #3967
  static telaPerda + #901, #3967
  static telaPerda + #902, #3967
  static telaPerda + #903, #3967
  static telaPerda + #904, #3967
  static telaPerda + #905, #3967
  static telaPerda + #906, #3967
  static telaPerda + #907, #3967
  static telaPerda + #908, #3967
  static telaPerda + #909, #3967
  static telaPerda + #910, #3967
  static telaPerda + #911, #3967
  static telaPerda + #912, #3967
  static telaPerda + #913, #3626
  static telaPerda + #914, #3967
  static telaPerda + #915, #3967
  static telaPerda + #916, #3967
  static telaPerda + #917, #3967
  static telaPerda + #918, #3967
  static telaPerda + #919, #3967

  ;Linha 23
  static telaPerda + #920, #3967
  static telaPerda + #921, #3967
  static telaPerda + #922, #3967
  static telaPerda + #923, #3967
  static telaPerda + #924, #3967
  static telaPerda + #925, #3967
  static telaPerda + #926, #3967
  static telaPerda + #927, #3967
  static telaPerda + #928, #1066
  static telaPerda + #929, #3967
  static telaPerda + #930, #3967
  static telaPerda + #931, #3967
  static telaPerda + #932, #3967
  static telaPerda + #933, #3967
  static telaPerda + #934, #3967
  static telaPerda + #935, #3967
  static telaPerda + #936, #3967
  static telaPerda + #937, #3967
  static telaPerda + #938, #3967
  static telaPerda + #939, #3967
  static telaPerda + #940, #3967
  static telaPerda + #941, #3967
  static telaPerda + #942, #3967
  static telaPerda + #943, #3967
  static telaPerda + #944, #3967
  static telaPerda + #945, #3967
  static telaPerda + #946, #3967
  static telaPerda + #947, #3967
  static telaPerda + #948, #3967
  static telaPerda + #949, #3967
  static telaPerda + #950, #3967
  static telaPerda + #951, #3967
  static telaPerda + #952, #3967
  static telaPerda + #953, #3967
  static telaPerda + #954, #3967
  static telaPerda + #955, #3967
  static telaPerda + #956, #3967
  static telaPerda + #957, #3967
  static telaPerda + #958, #3967
  static telaPerda + #959, #3967

  ;Linha 24
  static telaPerda + #960, #3967
  static telaPerda + #961, #3967
  static telaPerda + #962, #3967
  static telaPerda + #963, #3967
  static telaPerda + #964, #3967
  static telaPerda + #965, #3967
  static telaPerda + #966, #3967
  static telaPerda + #967, #3967
  static telaPerda + #968, #3967
  static telaPerda + #969, #3967
  static telaPerda + #970, #3967
  static telaPerda + #971, #3967
  static telaPerda + #972, #3967
  static telaPerda + #973, #3967
  static telaPerda + #974, #3967
  static telaPerda + #975, #3967
  static telaPerda + #976, #3967
  static telaPerda + #977, #3967
  static telaPerda + #978, #3967
  static telaPerda + #979, #3967
  static telaPerda + #980, #3967
  static telaPerda + #981, #3967
  static telaPerda + #982, #3967
  static telaPerda + #983, #3967
  static telaPerda + #984, #3967
  static telaPerda + #985, #3967
  static telaPerda + #986, #3967
  static telaPerda + #987, #3967
  static telaPerda + #988, #3967
  static telaPerda + #989, #3967
  static telaPerda + #990, #3967
  static telaPerda + #991, #3967
  static telaPerda + #992, #3967
  static telaPerda + #993, #3967
  static telaPerda + #994, #3967
  static telaPerda + #995, #3967
  static telaPerda + #996, #3967
  static telaPerda + #997, #3967
  static telaPerda + #998, #3967
  static telaPerda + #999, #3967

  ;Linha 25
  static telaPerda + #1000, #3967
  static telaPerda + #1001, #3967
  static telaPerda + #1002, #3967
  static telaPerda + #1003, #3967
  static telaPerda + #1004, #3967
  static telaPerda + #1005, #3967
  static telaPerda + #1006, #3967
  static telaPerda + #1007, #3967
  static telaPerda + #1008, #3967
  static telaPerda + #1009, #3967
  static telaPerda + #1010, #3967
  static telaPerda + #1011, #3967
  static telaPerda + #1012, #3967
  static telaPerda + #1013, #3967
  static telaPerda + #1014, #3967
  static telaPerda + #1015, #3967
  static telaPerda + #1016, #3967
  static telaPerda + #1017, #3967
  static telaPerda + #1018, #3967
  static telaPerda + #1019, #3967
  static telaPerda + #1020, #3967
  static telaPerda + #1021, #3967
  static telaPerda + #1022, #3967
  static telaPerda + #1023, #3967
  static telaPerda + #1024, #3967
  static telaPerda + #1025, #3967
  static telaPerda + #1026, #298
  static telaPerda + #1027, #3967
  static telaPerda + #1028, #3967
  static telaPerda + #1029, #3967
  static telaPerda + #1030, #3967
  static telaPerda + #1031, #3967
  static telaPerda + #1032, #3967
  static telaPerda + #1033, #3967
  static telaPerda + #1034, #3967
  static telaPerda + #1035, #3967
  static telaPerda + #1036, #3967
  static telaPerda + #1037, #3967
  static telaPerda + #1038, #3967
  static telaPerda + #1039, #3967

  ;Linha 26
  static telaPerda + #1040, #3967
  static telaPerda + #1041, #3967
  static telaPerda + #1042, #3967
  static telaPerda + #1043, #3967
  static telaPerda + #1044, #3967
  static telaPerda + #1045, #2346
  static telaPerda + #1046, #3967
  static telaPerda + #1047, #3967
  static telaPerda + #1048, #3967
  static telaPerda + #1049, #3967
  static telaPerda + #1050, #3967
  static telaPerda + #1051, #3967
  static telaPerda + #1052, #3967
  static telaPerda + #1053, #3967
  static telaPerda + #1054, #3967
  static telaPerda + #1055, #3967
  static telaPerda + #1056, #3967
  static telaPerda + #1057, #3626
  static telaPerda + #1058, #3967
  static telaPerda + #1059, #3967
  static telaPerda + #1060, #3967
  static telaPerda + #1061, #3967
  static telaPerda + #1062, #3967
  static telaPerda + #1063, #3967
  static telaPerda + #1064, #3967
  static telaPerda + #1065, #3967
  static telaPerda + #1066, #3967
  static telaPerda + #1067, #3967
  static telaPerda + #1068, #3967
  static telaPerda + #1069, #3967
  static telaPerda + #1070, #3967
  static telaPerda + #1071, #3967
  static telaPerda + #1072, #3967
  static telaPerda + #1073, #3967
  static telaPerda + #1074, #3967
  static telaPerda + #1075, #2346
  static telaPerda + #1076, #3967
  static telaPerda + #1077, #3967
  static telaPerda + #1078, #3967
  static telaPerda + #1079, #3967

  ;Linha 27
  static telaPerda + #1080, #3967
  static telaPerda + #1081, #3967
  static telaPerda + #1082, #3967
  static telaPerda + #1083, #3967
  static telaPerda + #1084, #3967
  static telaPerda + #1085, #3967
  static telaPerda + #1086, #3967
  static telaPerda + #1087, #3967
  static telaPerda + #1088, #3967
  static telaPerda + #1089, #3967
  static telaPerda + #1090, #3967
  static telaPerda + #1091, #3967
  static telaPerda + #1092, #3967
  static telaPerda + #1093, #3967
  static telaPerda + #1094, #3967
  static telaPerda + #1095, #3967
  static telaPerda + #1096, #3967
  static telaPerda + #1097, #3967
  static telaPerda + #1098, #3967
  static telaPerda + #1099, #3967
  static telaPerda + #1100, #3967
  static telaPerda + #1101, #3967
  static telaPerda + #1102, #3967
  static telaPerda + #1103, #3967
  static telaPerda + #1104, #3967
  static telaPerda + #1105, #3967
  static telaPerda + #1106, #3967
  static telaPerda + #1107, #3967
  static telaPerda + #1108, #3967
  static telaPerda + #1109, #3967
  static telaPerda + #1110, #3967
  static telaPerda + #1111, #3967
  static telaPerda + #1112, #3967
  static telaPerda + #1113, #3967
  static telaPerda + #1114, #3967
  static telaPerda + #1115, #3967
  static telaPerda + #1116, #3967
  static telaPerda + #1117, #3967
  static telaPerda + #1118, #3967
  static telaPerda + #1119, #3967

  ;Linha 28
  static telaPerda + #1120, #3967
  static telaPerda + #1121, #3967
  static telaPerda + #1122, #3967
  static telaPerda + #1123, #3967
  static telaPerda + #1124, #3967
  static telaPerda + #1125, #3967
  static telaPerda + #1126, #3967
  static telaPerda + #1127, #3967
  static telaPerda + #1128, #3967
  static telaPerda + #1129, #3967
  static telaPerda + #1130, #3967
  static telaPerda + #1131, #3967
  static telaPerda + #1132, #3967
  static telaPerda + #1133, #3967
  static telaPerda + #1134, #3967
  static telaPerda + #1135, #3967
  static telaPerda + #1136, #3967
  static telaPerda + #1137, #3967
  static telaPerda + #1138, #3967
  static telaPerda + #1139, #3967
  static telaPerda + #1140, #3967
  static telaPerda + #1141, #3967
  static telaPerda + #1142, #3967
  static telaPerda + #1143, #3967
  static telaPerda + #1144, #3967
  static telaPerda + #1145, #3967
  static telaPerda + #1146, #3967
  static telaPerda + #1147, #3967
  static telaPerda + #1148, #3967
  static telaPerda + #1149, #1066
  static telaPerda + #1150, #3967
  static telaPerda + #1151, #3967
  static telaPerda + #1152, #3967
  static telaPerda + #1153, #3967
  static telaPerda + #1154, #3967
  static telaPerda + #1155, #3967
  static telaPerda + #1156, #3967
  static telaPerda + #1157, #3967
  static telaPerda + #1158, #3967
  static telaPerda + #1159, #3967

  ;Linha 29
  static telaPerda + #1160, #3967
  static telaPerda + #1161, #3967
  static telaPerda + #1162, #3967
  static telaPerda + #1163, #3967
  static telaPerda + #1164, #3967
  static telaPerda + #1165, #3967
  static telaPerda + #1166, #3967
  static telaPerda + #1167, #3967
  static telaPerda + #1168, #3967
  static telaPerda + #1169, #3967
  static telaPerda + #1170, #3967
  static telaPerda + #1171, #3967
  static telaPerda + #1172, #3967
  static telaPerda + #1173, #3967
  static telaPerda + #1174, #3967
  static telaPerda + #1175, #3967
  static telaPerda + #1176, #3967
  static telaPerda + #1177, #3967
  static telaPerda + #1178, #3967
  static telaPerda + #1179, #3967
  static telaPerda + #1180, #3967
  static telaPerda + #1181, #3967
  static telaPerda + #1182, #3967
  static telaPerda + #1183, #3967
  static telaPerda + #1184, #3967
  static telaPerda + #1185, #3967
  static telaPerda + #1186, #3967
  static telaPerda + #1187, #3967
  static telaPerda + #1188, #3967
  static telaPerda + #1189, #3967
  static telaPerda + #1190, #3967
  static telaPerda + #1191, #3967
  static telaPerda + #1192, #3967
  static telaPerda + #1193, #3967
  static telaPerda + #1194, #3967
  static telaPerda + #1195, #3967
  static telaPerda + #1196, #3967
  static telaPerda + #1197, #3967
  static telaPerda + #1198, #3967
  static telaPerda + #1199, #3967

geraTelaPerda:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #telaPerda
  loadn R1, #0
  loadn R2, #1200

  printtelaPerdaScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printtelaPerdaScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts

limpaTelaPerda:
  push R0
  push R1
  push R2

  loadn R0, #0
  loadn R1, #0
  loadn R2, #1200

  printlimpaTelaLoop:

    outchar R0, R1
    inc R1
    cmp R1, R2

    jne printlimpaTelaLoop

  pop R2
  pop R1
  pop R0
  rts