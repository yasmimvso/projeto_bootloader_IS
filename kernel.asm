org 0x7e00
jmp 0x0000:start

;pontos por fases
points0 db 'Points: 0' , 0
points1 db 'Points: 1' , 0
points2 db 'Points: 2' , 0

nivel dw 0
fase dw 0
;tela inicial
string1 db 'Tenho uma piada sobre criptografia :)', 0
string2 db 'Mas...', 0
string3 db '$993%)*@ljMHDKh682%$@', 0
iniciar_game db 'Pressione a tecla "Enter" caso voce consiga decifrar a mensagem.', 0

str1 db 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' ; alocando espaço para 34 caracters
senhas db '* * * * * * * * *  * * * * * * * *  * * * * * * *  * * * * * *  * * * * * * *', 0
;Menu
titulo      db ' < / CriptoCin  >', 0
jogar_menu db '< / Jogar >', 0
instrucoes_menu db '< / Instrucoes >', 0
creditos_menu db '< / Creditos >', 0
jogar       db 'j#g@r (1)', 0
instrucoes  db '!nstr%c#&s (2)', 0
creditos    db 'Cr&d!t#s(3)', 0

;instrucoes
instrucao1 db 'Voce eh capaz de quebrar a criptografia do CriptoCIn?', 0
instrucao2 db '> No primeiro nivel voce tera apenas 1 chance para decifrar a mensagem', 0
instrucao4 db '> O sistema e super inteligente, qualquer erro eh considerado = /', 0
instrucao3 db '> No segundo nivel integre regras do desafio anterior', 0

;creditos
gab db 'Gabriel Pierre Carvalho Coelho - gpcc', 0
yasm db 'Yasmim Vitoria Silva de Oliveira - yvso', 0
retornar db 'Pressione "Esc" para voltar', 0

;jogo nivel1
nivel1 db 'Como sera sua desenvoltura nesse inicio?', 0
desafio1 db '< / Desafio 1 >', 0
titulo_dica db 'Dica:', 0
titulo_texto db 'Texto: ', 0
dica1 db ' De ponta a ponta as vogais invertem a onda', 0
texto1 db ' &sm%l@ d&m@!s @t& s@nt% d&sc%nf!@', 0
corect_texto1 db 'esmola demais ate santo desconfia', 0

;jogo nivel2
nivel2 db 'Sua logica e observacao eh de surpreender!', 0
desafio2 db '< / Desafio 2 > ', 0
dica2 db ' A sequencia das fontes condizem as 4 primeiras consoantes', 0
texto2 db ' >%>>@ q#& >>>>@l@ >>>@ @ >>@r@ ', 0
corect_texto2 db 'boca que fala da a cara', 0

;score
score1 db '  SUA PONTUACAO: 1  ', 0
score2 db 'Eh uma boa noticia que voce esteja estudando Engenharia...', 0
score3 db 'Wow, voce seria um excelente detetive!', 0

surpresa db 'Ha uma brecha na criptografia do cin.Voce tera mais uma chance!', 0
over db 'Voce nao e pario para a criptografia do cin', 0

modo_visor:
   mov ah,0 
   mov al, 12h
   int 10h ;setando modo gráfico
   ret

getchar:
   mov ah, 0
   int 16h
   ret

putchar:
   mov ah, 0eh
   int 10h
   ret

delchar:
    mov al,''
    mov dh, 15
    call set_cursor
    call putchar
    ret

background:
    mov ah, 0bh
    mov bh, 0
    int 10h 
    ret

printString:
    lodsb
    mov ah, 0xe
    mov bh, 0
    int 10h

    cmp al, 0
    jne printString
    ret

exit:
    mov al, 0x0a
    call putchar
    mov al, 0x0d
    call putchar
	ret

print_string:
; Imprime a string em si, com um pequeno atraso entre cada caractere
    lodsb
    cmp al, 0
    je exit

    mov ah, 0xe
    int 10h

    mov dx, 100
    call delay

    jmp print_string

delay:
        mov cx, 1 ; delay em microsegundos
        mov dx, 1 
        mov ah, 86h
        int 15h ; interrupcao de espera
        ret

set_cursor:
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
    int 10h
    ret

esc:
    mov ah, 0
    int 16h ; modo leitura de telclado

    cmp al, 27 ;ao identificar em buffer tecla esc clicanda faz comando
    je Menu ; se pressionado chama Menu
    jmp esc ; caso contrario continua em modo espera

start:
    ;Zerando os registradores
    xor ax, ax
    mov ds, ax
    mov es, ax
    call modo_visor

	mov bl, 2 
    call background
    ;call desenha_pegada ; desenha a pegada na posição (10, 20)

    mov si, string1
    mov dh, 7
    mov dl, 9
    call set_cursor
    mov bl, 0xf
    call print_string
    call exit

    mov si, string2
    mov bl, 0xf
    mov dh, 9
    mov dl, 9
    call set_cursor
    call print_string
    call exit

    mov si, string3
    mov bl, 0xf
    mov dh, 11
    mov dl, 9
    call set_cursor
    call print_string
    call exit
    
    mov si, iniciar_game
    mov bl, 0xf
    mov dh, 13
    mov dl, 9
    call set_cursor
    call print_string

    jmp enter_

enter_:
    mov ah, 0   ; prepara o ah para a chamada do teclado
    int 16h     ; interrupcao para ler o caractere e armazena-lo em al

    cmp al, 13 ; 'enter'
    jne enter_ ; se não for enter, chamar Menu

    call Menu
    jmp done

_strcmp:                             ; compara duas strings armazanadas em di e setadas em si
	.loop1:
		lodsb
		cmp byte[di], 0
		jne .continue
		cmp al, 0
		jne .end
		stc
		jmp .end
		
		.continue:
			cmp al, byte[di]
    			jne .end
			clc
    			inc di
    			jmp .loop1

		.end:
			ret
;fim_jogo:

analisa_nova_chance:
    mov di, str1
    mov si, corect_texto2
    call _strcmp

    jne goals ; se o retorno da funcao strcmp for al == 0, call goals
    jmp finish ; caso contrario finish
 
jogo_nivel2:
;declarar um wordem tentativa
    mov di, str1
    mov si, corect_texto2
    call _strcmp 

    jne nova_chance ; o call strcmp retorna uma valor 0 se for igual
    jmp finish

jogo_nivel1:
    mov di, str1
    mov si, corect_texto1
    call _strcmp 

    jne game_over ; o call strcmp retorna uma valor 0 se for igual
    jmp jogo2
    
analisa:
    mov al, 0
    stosb

    cmp word[nivel], 0
    je jogo_nivel1

    cmp word[fase] , 1
    je analisa_nova_chance

    cmp word[nivel], 1
    jmp jogo_nivel2

keyboard:
    mov dl, 17;; setar inicialente coluna em 2
    mov dh, 15 ;; linhas
    xor cx, cx
    jmp loop1
     loop1:
        call getchar
        cmp al, 0x08
        je backspace
        cmp al, 13; verifica 'enter'
        je analisa
        stosb ;; caso contrario seta para str1
        inc cl
        mov bl, 15
        inc dl
        call set_cursor
        call putchar
        jmp loop1

        backspace:
         cmp cl, 0
         je loop1
         dec di
         dec cl
         mov byte[di], 0
         call delchar
         dec dl
         jmp loop1

       ret
goals:
    call modo_visor
    ;Mudando a cor do background para azul escuro
    mov bl, 2
    call background

    mov dh, 3    ;Linha
	mov dl, 30   ;Coluna
	call set_cursor
    mov si, titulo
    mov bl, 0xf
    call printString

    mov dh, 6   ;Linha
	mov dl, 10   ;Coluna
	call set_cursor
    mov si, score2
    mov bl, 0xf
    call printString

    mov dh, 10   ;Linha
	mov dl, 8   ;Coluna
	call set_cursor
    mov si, score1
    mov bl, 0xf
    call printString

    mov dh, 25   ;Linha
	mov dl, 9  ;Coluna
	call set_cursor
    mov si, retornar
    mov bl, 4
    call printString
    call esc
    ret

game_over:
    call modo_visor
    mov bl, 4
    call background

    ; centralizando a frase "Voce nao e pario para a criptografia do cin"
    mov dh, 12
    mov dl, 11
    call set_cursor
    mov si, over
    mov bl, 15
    call printString

    ; centralizando a frase "Pressione 'Esc' para voltar"
    mov dh, 25
    mov dl, 11
    call set_cursor
    mov si, retornar
    mov bl, 15
    call printString
    ; aguarda pressionamento da tecla ESC para voltar ao menu
    call esc

finish:
    call modo_visor
    ;Mudando a cor do background para azul escuro
    mov bl, 1
    call background

    mov dh, 3    ;Linha
	mov dl, 30   ;Coluna
	call set_cursor
    mov si, titulo
    mov bl, 0xf
    call printString

    ;Colocando a string jogar   
	mov dh, 9;Linha
	mov dl, 19  ;Coluna
	call set_cursor
    mov si, score3
    mov bl, 0xf
    call printString
    
    ;Colocando a string intrucoes
	mov dh, 14  ;Linha
	mov dl, 10 ;Coluna
	call set_cursor
    mov si, score2
    mov bl, 0xf
    call printString

    mov dh,  25 ;Linha
	mov dl, 25   ;Coluna
	call set_cursor
    mov si,points2
    mov bl, 0xf
    call printString

    mov dh,  25 ;Linha
	mov dl, 60   ;Coluna
	call set_cursor
    mov si,points2
    mov bl, 0xf
    call printString

    mov dh, 25   ;Linha
	mov dl, 9  ;Coluna
	call set_cursor
    mov si, retornar
    mov bl, 4
    call printString
    call esc 
   
    ;; chama done

Menu:
    ;Carregando o video
    call modo_visor
    ;Mudando a cor do background para azul escuro
    mov bl, 1
    call background

    mov dh, 1
    mov dl, 1
    call set_cursor
    mov si, senhas
    mov bl, 0xf
    call printString

    mov dh, 28
    mov dl, 1
    call set_cursor
    mov si, senhas
    mov bl, 0xf
    call printString

    ;Colocando o TituloS
	mov dh, 4   ;Linha
	mov dl, 30   ;Coluna
	call set_cursor
    mov si, titulo
    mov bl, 0xf
    call printString

    ;Colocando a string jogar   
	mov dh, 10;Linha
	mov dl, 10  ;Coluna
	call set_cursor
    mov si, jogar
    mov bl, 0xf
    call printString
    
    ;Colocando a string intrucoes
	mov dh, 10   ;Linha
	mov dl, 30  ;Coluna
	call set_cursor
    mov si, instrucoes
    mov bl, 0xf
    call printString
    
    ;Colocando a string creditos
	mov dh, 10   ;Linha
	mov dl, 55  ;Coluna
	call set_cursor
    mov si, creditos
    mov bl, 0xf
    call printString

    opcoes_menu:
        ;Receber a opção
        mov ah, 0
        int 16h
        
        ;Comparando com '1'
        cmp al, 49
        je jogo
        
        ;Comparando com '2'
        cmp al, 50
        je instrucao
        
        ;Comparando com '3'
        cmp al, 51
        je credito
        
        ;Caso não seja nem '1' ou '2' ou '3' ele vai receber a string dnv
        jne opcoes_menu

jogo:
    ;Carregando o video para limpar a tela
    jmp jogo1

    jogo1:
    mov word[nivel], 0
    mov word[fase], 0
    ;mov word[points], 0
    call modo_visor
    ;Mudando a cor do background para azul escuro
    mov bl, 2
    call background

    ;Colocando o titulo
	mov dh, 2    ;Linha
	mov dl, 29   ;Coluna
	call set_cursor
    mov si,desafio1
    mov bl, 0xf
    call printString

    mov dh, 5   ;Linha
	mov dl, 17   ;Coluna
	call set_cursor
    mov si,nivel1
    mov bl, 0xf
    call printString

    mov dh,  7 ;Linha
	mov dl,  12;Coluna
	call set_cursor
    mov si,titulo_dica
    mov bl, 4
    call printString

    mov dh, 7   ;Linha
	mov dl, 17   ;Coluna
	call set_cursor
    mov si,dica1
    mov bl, 0xf
    call printString

    mov dh,  9 ;Linha
	mov dl, 11;Coluna
	call set_cursor
    mov si,titulo_texto
    mov bl, 4
    call printString

    mov dh,  9 ;Linha
	mov dl, 17   ;Coluna
	call set_cursor
    mov si,texto1
    mov bl, 0xf
    call printString

    mov dh,  25 ;Linha
	mov dl,  60;Coluna
	call set_cursor
    mov si,points0
    mov bl, 0xf
    call printString

    mov di, str1 ; seta str1 para escrita em mem
    jmp keyboard

    jogo2:
    mov word[nivel], 1
    call modo_visor
    ;Mudando a cor do background para azul escuro
    mov bl, 2
    call background

    mov dh, 2   ;Linha
	mov dl, 17   ;Coluna
	call set_cursor
    mov si,nivel2
    mov bl, 0xf
    call printString

    ;Colocando o titulo
	mov dh, 5    ;Linha
	mov dl, 29   ;Coluna
	call set_cursor
    mov si,desafio2
    mov bl, 0xf
    call printString

    mov dh,  7 ;Linha
	mov dl,  12;Coluna
	call set_cursor
    mov si,titulo_dica
    mov bl, 4
    call printString

    mov dh, 7   ;Linha
	mov dl, 17   ;Coluna
	call set_cursor
    mov si,dica2
    mov bl, 0xf
    call printString

    mov dh,  9;Linha
	mov dl, 11;Coluna
	call set_cursor
    mov si,titulo_texto
    mov bl, 4
    call printString

    mov dh,  9 ;Linha
	mov dl, 17   ;Coluna
	call set_cursor
    mov si,texto2
    mov bl, 0xf
    call printString

    mov dh,  25 ;Linha
	mov dl, 60   ;Coluna
	call set_cursor
    mov si,points1
    mov bl, 0xf
    call printString

    mov di, str1 ; seta str1 para escrita em mem
    jmp keyboard

    nova_chance:
    mov word[fase], 1
    call modo_visor
    ;Mudando a cor do background para azul escuro
    mov bl, 2
    call background

    mov dh,  2   ;Linha
	mov dl, 7  ;Coluna
	call set_cursor
    mov si, surpresa
    mov bl, 4
    call printString
       ;Colocando o titulo
	mov dh, 5    ;Linha
	mov dl, 27   ;Coluna
	call set_cursor
    mov si,desafio2
    mov bl, 0xf
    call printString

    mov dh,  7 ;Linha
	mov dl,  12;Coluna
	call set_cursor
    mov si, titulo_dica
    mov bl, 4
    call printString

    mov dh, 7   ;Linha
	mov dl, 17   ;Coluna
	call set_cursor
    mov si,dica2
    mov bl, 0xf
    call printString

    mov dh,  9 ;Linha
	mov dl, 11;Coluna
	call set_cursor
    mov si,titulo_texto
    mov bl, 4
    call printString

    mov dh,  9 ;Linha
	mov dl, 17   ;Coluna
	call set_cursor
    mov si,texto2
    mov bl, 0xf
    call printString

    mov dh,  25 ;Linha
	mov dl, 60   ;Coluna
	call set_cursor
    mov si,points1
    mov bl, 0xf
    call printString

    mov di, str1 ; seta str1 para escrita em memoria
    jmp keyboard
    call esc

instrucao:
    ;Carregando o video para limpar a tela
    call modo_visor
    ;Mudando a cor do background para verde
    mov bl, 2
    call background
    ;Colocando o titulo
	mov dh, 2    ;Linha
	mov dl, 30   ;Coluna
    call set_cursor
    mov si, instrucoes_menu
    mov bl, 0xf
    call printString
    ;Colocando a string instrucao1
	mov dh, 7    ;Linha
	mov dl, 10   ;Coluna
    call set_cursor
    mov si, instrucao1
    mov bl, 0xf
    call printString
    ;Colocando a string instrucao2
	mov dh, 9    ;Linha
	mov dl, 9   ;Coluna
    call set_cursor
    mov si, instrucao2
    mov bl, 0xf
    call printString
    ;Colocando a string instrucao3
	mov dh, 11   ;Linha
	mov dl, 9   ;Coluna
	call set_cursor
    mov si, instrucao3
    mov bl, 0xf
    call printString
    ;Colocando a string instrucao4
    mov dh, 13  ;Linha
	mov dl, 9   ;Coluna
	call set_cursor
    mov si, instrucao4
    mov bl, 0xf
    call printString
    ;Colocando a string retornar
	mov dh, 25   ;Linha
	mov dl, 9   ;Coluna
	call set_cursor
    mov si, retornar
    mov bl, 4
    call printString
    call esc

credito:
    ;Carregando o video para limpar a tela
    call modo_visor
    ;Mudando a cor do background para verde
    mov bl, 2
    call background
    ;Colocando o titulo
	mov dh, 2    ;Linha
	mov dl, 30   ;Coluna
	call set_cursor
    mov si, creditos_menu
    mov bl, 0xf
    call printString
    ;Colocando a string gab
	mov dh, 7    ;Linha
	mov dl, 10   ;Coluna
	call set_cursor
    mov si, gab
    mov bl, 0xf
    call printString
    ;Colocando a string yasm
	mov dh, 9    ;Linha
	mov dl, 10   ;Coluna
	call set_cursor
    mov si, yasm
    mov bl, 0xf
    call printString
    ;Colocando a string retornar
	mov dh, 25   ;Linha
	mov dl, 11   ;Coluna
	call set_cursor
    mov si, retornar
    mov bl, 4
    call printString
    call esc
done:
    jmp $
