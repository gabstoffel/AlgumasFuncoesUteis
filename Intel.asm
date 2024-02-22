		.model small
		.stack

; ########################
; #         DADOS        #
; ########################

		.data

; Constantes interessantes de se deixar
CR			equ		13  				; Carriage Return (Enter)
LF			equ		10  				; Line Feed ('\n')
TAB			equ 	9
ESPACO		equ 	32

; Variavel e constante necessarias pra algumas funcoes do Cechin funcionarem
MAXSTRING 	equ		200 				; Necessario para gets funcionar (loucura, eu sei), pode alterar o valor

String		db		MAXSTRING dup (?)	; Usado dentro da funcao gets. Sim, ela nao funciona sem. Sim, isso eh ma pratica.
sw_n	dw	0 							; Usada dentro da funcao sprintf_w
sw_f	db	0							; Usada dentro da funcao sprintf_w
sw_m	dw	0							; Usada dentro da funcao sprintf_w
FileBuffer		db		300 dup (?)		; Usada dentro do setChar e getChar
MsgErroAbr	db "Erro ao abrir arquivo!$"	; msg de erro ao abrir arquivo, terminada em $
CMDLINE		db	100	dup (?)
InputFileName	db	200 dup(0)				; nome do arquivo a ser lido
OutputFileName	db 	100 dup(0)			; nome do arquivo a ser escrito	
msgAchou	db "chegou aq",LF,CR,0
msgAbriuArquivo	db "Abriu o Arquivo",LF,CR,0
msgFechouArquivo db "Fechou o Arquivo",LF,CR,0
quantCaracteres	db	0
NaoEncontrouI	db	"Opcao [-i] sem parametro",LF,CR,0
NaoEncontrouO	db	"Opcao [-o] sem parametro",LF,CR,0
NaoEncontrouV	db	"Opcao [-v] sem parametro",LF,CR,0
TensaoInvalida	db "Parametro da opcao [-v] deve ser 127 ou 220",LF,CR,0
MensagemErroLinha	db 50 dup(0),LF,CR,0
NomeInputFileDefault	db 	"a.in",0,LF,CR,0
NomeOutputFileDefault	db 	"a.out",0,LF,CR,0
TensaoPadrao	DW	127
TensaoEscolhida	DW	0
StringTensaoEscolhida	db	3	dup(0),LF,CR,0
StringTensao	db	3 dup (0),0
filePtr	dw	1	dup(0)
linha db	30	dup(0),LF,CR,0
ContentBuffer      DB 4096 dup (?)     
BufferEnd   DW $-ContentBuffer         
QuantBytesLidos	dw	0


; ########################
; #        FUNCOES       #
; ########################

;; minhas funcoes:

;; -------------------------------------------------------------------
criaArquivo proc near

	lea dx,OutputFileName
	call fopen
	
	JC criaArq
	jmp continuaArquivo
	
	criaArq:

		lea dx,OutputFileName
		call fcreate
		
	continuaArquivo:
		
		escreveParamI:
			mov cx,15
			lea si,InfoConsideradaParametroI
			
			loopEscreveParamI:
				mov dl,[si]
				call setChar
				
				mov ax, si     ; Move o valor do ponteiro si para ax
				inc ax         ; Incrementa ax
				mov si, ax     ; Move o valor de volta para si
				
				loop loopEscreveParamI
				
				escreveEntradaI:
					lea si,InputFileName
					
					loopescreveEntradaI:
						mov dl,[si]
						cmp dl,0
						je FinalDeLInhaI
					
						call setChar
						inc si
						jmp loopescreveEntradaI
		
				FinalDeLInhaI:
					mov dl,LF
					call setChar
					
					mov dl,CR
					call setChar
					
					
		escreveParamO:
			mov cx,15
			lea si,InfoConsideradaParametroO
			
			loopEscreveParamO:
				mov dl,[si]
				call setChar
				
				mov ax, si     ; Move o valor do ponteiro si para ax
				inc ax         ; Incrementa ax
				mov si, ax     ; Move o valor de volta para si
				
				loop loopEscreveParamO
				
				escreveEntradaO:
					lea si,OutputFileName
					
					loopescreveEntradaO:
						mov dl,[si]
						cmp dl,0
						je FinalDeLInhaO
					
						call setChar
						inc si
						jmp loopescreveEntradaO
		
				FinalDeLInhaO:
					mov dl,LF
					call setChar
					
					mov dl,CR
					call setChar
					
					
		escreveParamV:
			mov cx,15
			mov si,TensaoEscolhida
			mov ax,[si]
			
			push bx
			
			
			lea bx,StringTensaoEscolhida
			call sprintf_w
			
			pop bx
			
			lea si,StringTensaoEscolhida
			
			loopEscreveParamV:
				mov dl,[si]
				call setChar
				
				mov ax, si     ; Move o valor do ponteiro si para ax
				inc ax         ; Incrementa ax
				mov si, ax     ; Move o valor de volta para si
				
				loop loopEscreveParamV
				
				escreveEntradaV:
					lea si,InputFileName
					
					loopescreveEntradaV:
						mov dl,[si]
						cmp dl,0
						je FinalDeLInhaV
					
						call setChar
						mov ax, si     ; Move o valor do ponteiro si para ax
						inc ax         ; Incrementa ax
						mov si, ax     ; Move o valor de volta para si
						jmp loopescreveEntradaV
		
				FinalDeLInhaV:
					mov dl,LF
					call setChar
					
					mov dl,CR
					call setChar
					
		escreveTempoDeTensaoAdequada:
			mov cx,20
			lea si,stringTensaoAdequadaDefault
			
			loopEscreveTempoDeTensaoAdequada:
				mov dl,[si]
				call setChar
				inc si
				
				dec cx
				test cx,cx
				jz fimLooopTempoTensaoAdequadaDefault
				jmp escreveTempoDeTensaoAdequada
				
			fimLooopTempoTensaoAdequadaDefault:
				mov cx,8
				lea si,stringTensaoAdequada
				
				LoopDois:
					mov dl,[si]
					call setChar
					
					mov ax, si     ; Move o valor do ponteiro si para ax
					inc ax         ; Incrementa ax
					mov si, ax     ; Move o valor de volta para si
					
					dec cx
					test cx,cx
					jz FinalLinhaTensaoDefault
					jmp LoopDois
					
			FinalLinhaTensaoDefault:
				mov dl,LF
				call setChar
				
				mov dl,CR
				call setChar
				
		escreveTempoSemTensaoDefault:
			mov cx,12
			lea si,stringSemTensaoDefault
			
			loopescreveTempoSemTensaoDef:
				mov dl,[si]
				call setChar
				
				
				mov ax, si     ; Move o valor do ponteiro si para ax
				inc ax         ; Incrementa ax
				mov si, ax     ; Move o valor de volta para si
				dec cx
				
				test cx,cx
				jz escreveTempoSemTensao
				jmp loopescreveTempoSemTensaoDef
				
			escreveTempoSemTensao:
				mov cx,8
				lea si,stringSemTensao
				
				loopEscreveTempoSemTensao:
					mov dl,[si]
					call setChar
					
					mov ax, si     ; Move o valor do ponteiro si para ax
					inc ax         ; Incrementa ax
					mov si, ax     ; Move o valor de volta para si
					dec cx
					
					test cx,cx
					jz finalDeLInhaEscreveTempoSemTensao
					jmp loopEscreveTempoSemTensao
					
			finalDeLInhaEscreveTempoSemTensao:
				mov dl,LF
				call setChar
				
				mov dl,CR
				call setChar
				
		escreveTempoTotal:
			mov cx,13
			lea si,stringTempoTotalDefault
			
			loopescreveTempoTotalDefault:
				mov dl,[si]
				call setChar
				
				
				mov ax, si     ; Move o valor do ponteiro si para ax
				inc ax         ; Incrementa ax
				mov si, ax     ; Move o valor de volta para si
				dec cx
				
				test cx,cx
				jz escreveTempo
				jmp loopescreveTempoTotalDefault
				
			escreveTempo:
				mov cx,8
				lea si,stringTempoTotal	
				
				loopEscreveTempo:
					mov dl,[si]
					call setChar
					
					inc si
					dec cx
					
					test cx,cx
					jz finalDeLInhaEscreveTempo
					jmp loopEscreveTempo
					
			finalDeLInhaEscreveTempo:
				mov dl,LF
				call setChar
				
				mov dl,CR
				call setChar
				
				ret

	ret
criaArquivo endp


TestaSeENum proc near
	;;	recebe o dig no dl
	;; deve retornar 1 no dh se for dig
	;; deve retornar 0 no dh se NÃO for dig
	
	cmp dl,48
	JGE segundoTeste
	jmp NaoENum

	
	segundoTeste:
		cmp dl,57
		JLE Enum
		
	NaoENum:
		mov dh,0
		jmp returnTestaSeENum
	
	Enum:
		mov dh,1

returnTestaSeENum:
	ret
TestaSeENum	endp


processaLinha proc near 
	

	push bx
	push si

	lea bx,ContentBuffer
	lea si,linha
	
	loopLinha:
	
		mov dl,[bx]

		verificaSeEFinalDaLinha:
			
			cmp dl,CR
			je FinalDaLinha			
			;;compara o que está no dl, que veio do buffer, com o CR e com o LF
			
			cmp dl,LF				
			;; sempre que encontrar um line feed, deve incrementar o contador de linhas
			je FinalDaLinhaProcessaLinha
			
			salvaLinha:
				
				mov [si],dl
				inc s
				inc bx
				jmp loopLinha
	

FinalDaLinhaProcessaLinha:

	push bx
	push si
	
	
	call contabilizaLinhaAtual				;;	contabiliza linha

	lea bx,linha							;;	;;printa o conteudo da linha em cada 			
	call printf_s
	
finalDOArquivo:
	pop si 
	pop bx

	ret

processaLinha endp 



contabilizaLinhaAtual proc near

	lea si,TempoTotalDeAnalise
	mov dx,[si]
	add dx,1
	mov [si],dx

	ret

contabilizaLinhaAtual endp

validaLinhaDeComando proc near
	
	test ax,ax
	lea bx,quantCaracteres
	mov [bx],ax
	jz return

ProcuraParametroI:

	mov cx, ax
    lea bx, CMDLINE
    lea si, InputFileName

    percorreInput:
        mov al, [bx]
        cmp al, '-'
        jne proximoChar
        inc bx
        mov al, [bx]
        cmp al, 'i'
        je salvaArquivoInput

	proximoChar:
        inc bx
        loop percorreInput
        JMP ParametroINaoInformado

	salvaArquivoInput:
		add bx,2
		
	percorreSalvando:
		mov al,[bx]
		cmp al,32			;;no primeiro espaço, termina a leitura
		je  printa
		cmp al,CR
		je printa
		cmp al,LF
		je printa
		mov [si],al
		inc bx
		inc si
		loop percorreSalvando	
	
	printa:
		lea bx,InputFileName
		call printf_s
		JMP ProcuraParametroO
			
ParametroINaoInformado:	
	call inputFileNameDefault
	lea bx,InputFileName
	call printf_s
	lea bx,NaoEncontrouI
	call printf_s	
	

ProcuraParametroO:

	lea bx,quantCaracteres
	mov cx,[bx]
    lea bx, CMDLINE
    lea si, OutputFileName
	
	percorreOutput:
        mov al, [bx]
        cmp al, '-'
        jne proximoCaracter
        inc bx
        mov al, [bx]
        cmp al, 'o'
        je salvaArquivoOutput

	proximoCaracter:
        inc bx
        loop percorreOutput
        JMP ParametroONaoInformado
	
	salvaArquivoOutput:
		add bx,2		
	percorreSalvandoOutput:
		mov al,[bx]
		cmp al,32			;;no primeiro espaço, termina a leitura
		je  printaOutput
		cmp al,CR
		je printaOutput
		cmp al,LF
		je printaOutput
		mov [si],al
		inc bx
		inc si
		loop percorreSalvandoOutput

printaOutput:
	lea bx,OutputFileName
	call printf_s
	jmp ProcuraParametroV

ParametroONaoInformado:	
	call outputFileNameDefault
	lea bx,OutputFileName
	call printf_s
	lea bx,NaoEncontrouO
	call printf_s
	
ProcuraParametroV:

	
	lea bx,quantCaracteres
	mov cx,[bx]
    lea bx, CMDLINE
	
	percorreTensao:
        mov al, [bx]
        cmp al, '-'
        jne proximoNum
        inc bx
        mov al, [bx]
        cmp al, 'v'
        je salvaTensao

	proximoNum:
        inc bx
        loop percorreTensao
        JMP tensaoNaoInformada

	salvaTensao:
		add bx,2
		
		lea si,StringTensao
		mov al,[bx]
		mov [si],al
		inc si
		inc bx
		mov al,[bx]
		mov [si],al
		inc si
		inc bx
		mov al,[bx]
		mov [si],al
		
		call validaTensao
		ret 
	
	tensaoNaoInformada:
		;;deve mostrar a mensagem de que o -v não foi informado
		lea bx,NaoEncontrouV
		call printf_s
		call salvaTensaoDefault
		ret
		

return:
	ret
validaLinhaDeComando	endp


inputFileNameDefault proc near
	;;coloca "a.in" como nome do arquivo padrao
	
	mov cx,4
	lea si,InputFileName
	lea bx,NomeInputFileDefault
	
	loopInputFileName:	
		mov al,[bx]
		mov [si],al
		inc si
		inc bx
		loop loopInputFileName

	ret
inputFileNameDefault endp


outputFileNameDefault proc near
	;;coloca "a.out" como nome do arquivo padrao
	
	mov cx,5
	lea si,OutputFileName
	lea bx,NomeOutputFileDefault
	
	loopOutputFileName:	
		mov al,[bx]
		mov [si],al
		inc si
		inc bx
		loop loopOutputFileName

	ret
outputFileNameDefault endp

validaTensao proc near

	;;recebe tensao, no bx, devolve o num em ax
	;;converte de string ascii -> numero
	;;compara com 127
	;;compara com 220
	; se for igual a algum dos dois, salva
	; caso contrario, salva com a tensao padrao: 127
	
	lea bx,StringTensao
	call atoi

	cmp ax,127
	je salvaMenorTensao
	
	cmp ax,220
	je salvaMaiorTensao
	;;chega aq caso != 127 e != 2020, logo, salva menor tensao
	
	;;indicar o caso de Tensao Invalida -> fora dos valores permitidos
	lea bx,TensaoInvalida
	call printf_s
	
	salvaMenorTensao:
		lea bx,TensaoEscolhida
		mov [bx],127
		ret
		
	salvaMaiorTensao:
		lea bx,TensaoEscolhida
		mov [bx],220
	
	ret
validaTensao endp


leituraArquivoInput proc near
	;;deve ler o conteudo dos arquivos
	
	;; procura por um arquivo com o nome fornecido no input
	;; string com o nome do arquivo -> dx
	lea dx,InputFileName
	call fopen
	jc	returnLeituraArquivo	;;indica que o CF = 1, ou seja, não conseguiu abrir o arquivo
	push bx
	lea bx,msgAbriuArquivo
	call printf_s
	
	pop bx

	
	call leituraConteudo		;; aqui, temos todo o conteudo do arquivo lido, no buffer
	jc ErroAoLerALinha
	
	
	
	push bx
	pop bx
	
	fechaArquivo:
		call fclose
		jc returnLeituraArquivo
		lea bx,msgFechouArquivo
		call printf_s

returnLeituraArquivo:
	ret 
leituraArquivoInput endp


;; ----------------------------------------------------------------


leituraConteudo proc near

	;; le até 4096 bytes, coloca no buffer, caso o arquivo seja maior que isso, é necessário aumentar
	;; a memoria do buffer
	; bx <- *FilePtr
	; dl <- caracter
	; ax <- num Bytes Lidoss
	
	lea si,ContentBuffer
	
loopConteudo:	


		call getChar
		jc returnLeituraConteudo
		
		
		cmp ax,1
		je verificaFIM
		jmp returnLeituraConteudo 	;; significa que nao tem mais bytes a serem lidos		
		
		
		verificaFIM:
			cmp dl,70
			je returnLeituraConteudo
			
			cmp dl,102
			je returnLeituraConteudo
		
		SalvaConteudoNoString:
			push bx
			call registraByte
			pop bx
			mov [si],dl
			inc si
			jmp loopConteudo
	
	
returnLeituraConteudo:
	ret
leituraConteudo endp

registraByte proc near


	lea bx,QuantBytesLidos
	push ax
	
	mov ax,[bx]
	add ax,1
	
	mov [bx],ax
	
	pop ax
	ret

registraByte	endp

;; ----------------------------------------------------------------


lePrompt	proc near
	
	push ds					; Salva as informações de segmentos
	push es
	mov ax,ds				; Troca DS com ES para poder usa o REP MOVSB
	mov bx,es
	mov ds,bx
	mov es,ax
	mov si,80h				; Obtém o tamanho do string da linha de comando e coloca em CX
	mov ch,0
	mov cl,[si]
	mov ax,cx				; Salva o tamanho do string em AX, para uso futuro
	mov si,81h				; Inicializa o ponteiro de origem
	lea di,CMDLINE			; Inicializa o ponteiro de destino
	rep movsb
	pop es					; retorna as informações dos registradores de segmentos
	pop ds


return_:
	ret
	
lePrompt	endp

salvaTensaoDefault proc near

	lea bx,TensaoEscolhida
	mov [bx],127
	
	ret

salvaTensaoDefault endp


atoi	proc near

		mov		ax,0
		
atoi_2:
		cmp		byte ptr[bx], 0
		jz		atoi_1

		mov		cx,10
		mul		cx

		mov		ch,0
		mov		cl,[bx]
		add		ax,cx

		sub		ax,'0'

		inc		bx
		
		jmp		atoi_2

atoi_1:
		ret

atoi	endp

printf_s	proc	near

	mov		dl,[bx]
	cmp		dl,0
	je		ps_1

	push	bx
	mov		ah,2
	int		21H
	pop		bx

	inc		bx
		
	jmp		printf_s
		
ps_1:
	ret
	
printf_s	endp


ReadString	proc	near

		mov		dx,0

RDSTR_1:

		mov		ah,7
		int		21H

		cmp		al,0DH
		jne		RDSTR_A

		mov		byte ptr[bx],0
		ret
		
RDSTR_A:
		cmp		al,08H
		jne		RDSTR_B

		cmp		dx,0
		jz		RDSTR_1

		push	dx
		
		mov		dl,08H
		mov		ah,2
		int		21H
		
		mov		dl,' '
		mov		ah,2
		int		21H
		
		mov		dl,08H
		mov		ah,2
		int		21H
		
		pop		dx

		dec		bx
		inc		cx
		dec		dx
		
		jmp		RDSTR_1

RDSTR_B:
		cmp		cx,0
		je		RDSTR_1

		cmp		al,' '
		jl		RDSTR_1

		mov		[bx],al

		inc		bx
		dec		cx
		inc		dx

		push	dx
		mov		dl,al
		mov		ah,2
		int		21H
		pop		dx

		jmp		RDSTR_1

ReadString	endp


sprintf_w	proc	near

	mov		sw_n,ax

	mov		cx,5
	
	mov		sw_m,10000
	
	mov		sw_f,0
	
sw_do:

	mov		dx,0
	mov		ax,sw_n
	div		sw_m
	

	cmp		al,0
	jne		sw_store
	cmp		sw_f,0
	je		sw_continue
sw_store:
	add		al,'0'
	mov		[bx],al
	inc		bx
	
	mov		sw_f,1
sw_continue:
	
	mov		sw_n,dx
	
	mov		dx,0
	mov		ax,sw_m
	mov		bp,10
	div		bp
	mov		sw_m,ax
	
	dec		cx
	
	cmp		cx,0
	jnz		sw_do


	cmp		sw_f,0
	jnz		sw_continua2
	mov		[bx],'0'
	inc		bx
sw_continua2:


	mov		byte ptr[bx],0
		
	ret
		
sprintf_w	endp


fopen	proc	near
	mov		al,0
	mov		ah,3dh
	int		21h
	mov		bx,ax
	ret
fopen	endp


 fcreate	proc	near
	mov		cx,0
	mov		ah,3ch
	int		21h
	mov		bx,ax
	ret
fcreate	endp


fclose	proc	near
	mov		ah,3eh
	int		21h
	ret
fclose	endp


getChar	proc	near
	mov		ah,3fh
	mov		cx,1					;; indica que será lido apenas um caracter
	lea		dx,FileBuffer
	int		21h
	mov		dl,FileBuffer
	ret
getChar	endp


setChar	proc	near
	mov		ah,40h
	mov		cx,1
	mov		FileBuffer,dl
	lea		dx,FileBuffer
	int		21h
	ret
setChar	endp	

gets	proc	near
	push	bx

	mov		ah,0ah							; Le uma linha do teclado
	lea		dx,String
	mov		byte ptr String, MAXSTRING-4	; 2 caracteres no inicio e um eventual CR LF no final
	int		21h

	lea		si,String+2						; Copia do buffer de teclado para o FileName
	pop		di
	mov		cl,String+1
	mov		ch,0
	mov		ax,ds							; Ajusta ES=DS para poder usar o MOVSB
	mov		es,ax
	rep 	movsb

	mov		byte ptr es:[di],0				; Coloca marca de fim de string
	ret
gets	endp


		end