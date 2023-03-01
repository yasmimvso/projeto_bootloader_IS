org 0x500
jmp 0x0000:start

;; ideia : desenhar uns pesinhos a cada load
 
loading db 'Loading structures for the kernel...', 0
setting db 'Setting up protected mode...', 0
memory db 'Loading kernel in memory...', 0
running db 'Running kernel...', 0

putchar: 
    mov ah, 0x0e
    int 10h
ret

printf:   
	lodsb ;; load em memoria o endereço setado em si
	cmp al, 0 
	je exit

	mov ah, 0eh ; escrita em tela
    mov bl, 15  ; cor de letra na tela  (branco)
	int 10h	 ; interrupção de tela

	call delay 
	jmp printf

    exit: ; print \n no final da frase
        mov al, 0x0a
        call putchar
        mov al, 0x0d
        call putchar
	    ret

    delay:
        mov cx, 1
        mov dx, 1 
        mov ah, 86h
        int 15h
        ret
ret

start:

   mov ah,0 
   mov al, 12h
   int 10h ;setando modo gráfico


   mov ah,0xb
   mov bh,0
   mov bl, 0 
   int 10h ;fundo preto

  mov si, loading
  call printf
  mov si, setting
  call printf
  mov si, memory
  call printf
  mov si, running
  call printf

reset:
        mov ah, 00h ;reseta o controlador de disco
        mov dl, 0   ;floppy disk
        int 13h
        jc reset    ;se o acesso falhar, tenta novamente
        jmp kernel

    kernel:
    
        xor ax, ax
        xor bx,bx		;Zerando o offset
	    mov ds, ax

        load:
        mov ax, 0x7E0 ; setor da sistema operaacional no disco rígido
        mov es,ax
        mov ah, 0x02 ;le o setor do disco
        mov ch, 0   ;track 0
        mov cl, 3   ;setor 3
        mov al, 20  ;porção de setores ocupados pelo kernel.asm
        mov dh, 0   ;head 0
        mov dl, 0   ;drive 0
        int 13h

        jc load
        jmp 0x7e00 

 times 510-($-$$) db 0 ;512 bytes
    dw 0xaa55