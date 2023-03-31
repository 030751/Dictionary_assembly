INCLUDE irvine32.inc
.data
dotcounter1 dword 0h
dotcounter2 dword 0h
msg byte "Matched",0
msg1 byte "enter the word you want to search: ",0
msg2 byte " NOT FOUND IN DICTIONARY",0
msg3 byte " Meaning of the word is: ",0
msg4 byte "Similar words: ",0
msg5 byte "Enter the word you want to delete: ",0
msg6 byte 0ah,0dh,"Deleted ",0
msg7 byte "Thank you for using humari dictionary",0
msg8 byte "Cannot delete it it is not in dictionary",0

msgP byte "Sorry, The word already exists in the dictionary",0
msgD byte "Sorry, The word doesn't exists in the dictionary",0

in1 dword 0h
finalCounter dword 0h
pval dword 0h

str2 byte 20 dup(?)
dbuffer BYTE 500 dup(" ")
starting_point dword 0
Ending_point dword 0
dbytesWritten DWORD ?

filename byte "humaridictionary.txt",0
filehandle1 dword ?
filehandle dword ?
filehandle2 dword ?
filehandlenew HANDLE ?
Newname byte "Test.txt",0
val  byte 7 dup(?)
anya byte 5 dup(?)
count byte 0h

Misstr byte 5000 dup(?)
miscount dword 0h

mcount byte 0h
m1count byte 0h

sizeanya byte ?
lv dword ?
buffer byte 80000 dup(?)
sbuffer byte 80000 dup(?)
wrd byte 80000 dup(?)
syn byte sizeof sbuffer dup(?)

;INSERT WORD VARIABLES

Inword byte 6 dup(?),0ah,0dh
Inwordsize dword ($-Inword)



lword byte 15000 dup(?)
lwordlength dword ($-lword)
bytesWritten DWORD ?  
rfilehandle HANDLE ?

Insertmsg byte "Enter the word you want to add in Humari Dictionary: ",0

;INSERT Meaning VARIABLES
Meaningmsg byte "Enter the meaning of the entered word: ",0
WrdMean byte 50 dup(0)
Mwrdsize dword ($-WrdMean)
Mfilehandle HANDLE ?
Mword byte 90000 dup(?)
Mwordlength dword ($-Mword)
MbytesWritten DWORD ?  

Startmsg1 byte " Welcome to HUMARI DICTIONARY",0
Startmsg2 byte "Enter 1 to exit",0ah,0dh,
               "Enter 2 to search a word and its meaning",0ah,0dh,
               "Enter 3 to add a word in dictionary",0ah,0dh,
               "Enter 4 to delete a word from dictionary",0ah,0dh,0
                



synonymfile byte "berry.txt",0
.code


upperLower PROC
    pushad
    mov eax,0
	mov al,anya[0]
	cmp al,'a'
	jb notLower
	cmp al,'z'
	ja notLower

	and al,11011111b
	mov anya[0],al
	jmp M2
	notLower:
	mov anya[0],al
	M2:
	mov eax,0
	mov esi,1
	mov ecx,4
	l1:
	mov al,anya[esi]
	cmp al,'A'
	jb notCapital
	cmp al,'Z'
	ja notCapital

	or al, 00100000b
	mov anya[esi],al
	jmp M3
	notCapital:
	mov anya[esi],al
	M3:
	inc esi
	loop l1
    popad
ret
upperLower ENDP


hira PROC
    mov edx,offset synonymfile
    call openinputfile
   

    mov edx,offset sbuffer
    mov ecx,sizeof sbuffer
    
    call readfromfile

    ;call WriteWindowsMsg

    INVOKE Str_copy,
    ADDR sbuffer,ADDR syn

    mov edx,offset msg3
    call writestring
    call crlf

    mov ebx,0
    mov ebx,dotcounter1
    

    mov eax,0
   
    mov esi,0
    mov ecx,100000

    qb:
        mov al,syn[esi]
        .IF al != '.'
        inc esi
        .ELSE
       
        inc dotcounter2
        inc esi
        .ENDIF

        .IF dotcounter2 == ebx
        mov ecx,sizeof syn

        iqra:
                  
            mov al,syn[esi]
            .IF al == '.'
            
            ret
            .ENDIF
            call writechar
            inc esi
        loop iqra
        .ENDIF

    loop qb

    mov eax,filehandle2
    call Closefile
 
   ret

    hira ENDP
Meaning PROC


    
        
    mov eax,0
    mov finalCounter,0


    mov edx,offset filename
    call openinputfile
    mov filehandle,eax
   
    mov edx,offset buffer
    mov ecx,sizeof buffer
    call readfromfile

   
    INVOKE Str_copy,
    ADDR buffer,ADDR wrd

    mov esi,offset wrd
    mov ecx,sizeof wrd
    mov eax,0
    counter:
    mov al,[esi]
    .IF al == '.'
    inc finalCounter
    .ENDIF
    inc esi

    loop counter
    mov eax,finalCounter
    
    mov edx,offset msg1
    call writestring

    mov edx,offset anya
    mov ecx,6
    call readstring

    call upperLower
    ;mov edx, offset anya
    ;call writestring
   
    mov ebx,0

    mov eax,0
    mov lv,0
    mov esi,0
    mov ecx,8000
    l: 
        .IF count ==5
        
        jmp ammara
        .ENDIF
        .IF al == 10
        .IF count >=3
        call misspelled
        .ENDIF
        mov count,0
        mov esi,0
        .ENDIF
        mov edx,esi
        
        mov bl,anya[esi]
        
        mov esi,lv
        mov al,wrd[esi]
        ;call writechar
        ;call crlf
        
        
        .IF al == bl
        inc count
        
         .ENDIF
        .IF al == '.'
        inc dotcounter1
       
        
        
        
         .ENDIF
        mov esi,edx
        inc esi
        inc lv
        
        

    loop l
    
    
    ammara:
    mov eax,finalCounter
    .IF dotcounter1 >= eax
    jmp notfound
    .ELSE
    call hira
    jmp _exit
    .ENDIF
 
 notfound:
    mov edx, offset msg2
    call writestring
    call crlf
    
    mov edx,offset msg4
    call writestring
  
    call crlf
  
    mov edx,offset Misstr
    call writestring
    
    
    jmp _exit
    
    ret
        

    _exit:
    mov eax,filehandle
    call Closefile
 

    

ret
    Meaning ENDP

misspelled PROC

    mov eax,0
    sub lv,8
    mov ecx,8
    loop3:
    mov eax,0
    mov esi,lv
    mov al,wrd[esi]
    mov esi,miscount
    mov Misstr[esi],al
    
    inc lv
    inc miscount
    loop loop3
    
    ret
    misspelled ENDP

    IsPresent PROC
    
    
        
    mov eax,0
    mov finalCounter,0


    mov edx,offset filename
    call openinputfile
    mov filehandle,eax
   
    mov edx,offset buffer
    mov ecx,sizeof buffer
    call readfromfile

   
    INVOKE Str_copy,
    ADDR buffer,ADDR wrd

    mov esi,offset wrd
    mov ecx,sizeof wrd
    mov eax,0
    counter:
    mov al,[esi]
    .IF al == '.'
    inc finalCounter
    .ENDIF
    inc esi

    loop counter
    mov eax,finalCounter
    
    
    mov edx,offset Insertmsg
    call writestring
    call crlf

    mov edx,offset anya
    mov ecx,6
    call readstring

    call upperLower
    INVOKE Str_copy,
    ADDR anya,ADDR Inword

    ;mov edx, offset Inword
    ;call writestring
   
    mov ebx,0

    mov eax,0
    mov lv,0
    mov esi,0
    mov ecx,8000
    l: 
        .IF count ==5
        
        jmp ammara
        .ENDIF
        .IF al == 10
        
        mov count,0
        mov esi,0
        .ENDIF
        mov edx,esi
        
        mov bl,anya[esi]
        
        mov esi,lv
        mov al,wrd[esi]
        ;call writechar
        ;call crlf
        
        
        .IF al == bl
        inc count
        
         .ENDIF
        .IF al == '.'
        inc dotcounter1
       
        
        
        
         .ENDIF
        mov esi,edx
        inc esi
        inc lv
        
        

    loop l
    
    
    ammara:
    mov eax,finalCounter
    .IF dotcounter1 >= eax
      mov pval,1
      jmp _exit
    .ELSE
    mov pval,0
    jmp _exit
    .ENDIF
 

    
 
        

    _exit:
    mov eax,filehandle
    call Closefile
 

    

ret
IsPresent ENDP


WordInsert PROC



   INVOKE CreateFile,
	  ADDR filename, GENERIC_WRITE, DO_NOT_SHARE, NULL,
	  OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0

	mov fileHandlenew,eax			; save file handle
	

	
    
     mov esi,offset Inword
     mov ebx,0
     mov m1count,0
     mov bl,'.'
     mov bh,' '
     mov ecx, Inwordsize
    loop6: 

    mov eax,0
    mov al,[esi]
    .IF al == 00
    xchg [esi],bl
    inc m1count

    inc m1count
    inc esi
    mov bl,13
    mov bh,' '
    xchg [esi],bl
    
     inc m1count
    inc esi
    mov bl,10
    mov bh,' '
    xchg [esi],bl
    jmp bahir1
    .ENDIF

    inc esi
    inc m1count
    loop loop6
   
    bahir1:

    ;mov al,m1count
    ;call writeint


	; Move the file pointer to the end of the file
	INVOKE SetFilePointer,
	  fileHandlenew,0,0,FILE_END

	; Append text to the file
	INVOKE WriteFile,
	    fileHandlenew, ADDR Inword, m1count,
	    ADDR bytesWritten, 0
    INVOKE CloseHandle, fileHandlenew
    
	mov edx,offset filename
	call openinputfile
	mov fileHandlenew,eax

	mov edx,offset lword
	mov ecx,lwordlength
	call readfromfile

    mov eax,fileHandlenew
    call CloseFile

QuitNow:
	
   


   ret
    WordInsert ENDP



MeaningInsert PROC

    
    mov edx,offset Meaningmsg
    call writestring
    call crlf

   INVOKE CreateFile,
	  ADDR synonymfile, GENERIC_WRITE, DO_NOT_SHARE, NULL,
	  OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0

	mov fileHandle1,eax			; save file handle
	

	mov edx,offset WrdMean
	mov ecx,Mwrdsize
	call readstring


     mov esi,offset WrdMean
     mov ebx,0
     mov mcount,0
     mov bl,'.'
     mov bh,' '
     mov ecx, Mwrdsize
    loop6: 

    mov eax,0
    mov al,[esi]
    .IF al == 00
    xchg [esi],bl
    inc mcount

    inc mcount
    inc esi
    mov bl,13
    mov bh,' '
    xchg [esi],bl
    
     inc mcount
    inc esi
    mov bl,10
    mov bh,' '
    xchg [esi],bl
    jmp bahir
    .ENDIF

    inc esi
    inc mcount
    loop loop6
   
    bahir:

    ;mov al,mcount
    ;call writeint


    
	; Move the file pointer to the end of the file
	INVOKE SetFilePointer,
	  fileHandle1,0,0,FILE_END

	; Append text to the file
	INVOKE WriteFile,
	    fileHandle1, ADDR WrdMean, mcount,
	    ADDR MbytesWritten, 0
    INVOKE CloseHandle, fileHandle1
    

	mov edx,offset synonymfile
	call openinputfile
	mov Mfilehandle,eax

	mov edx,offset Mword
	mov ecx,Mwordlength
	call readfromfile

	
    mov eax,Mfilehandle
    call CloseFile

QuitNow:
	
   
    


    ret
     MeaningInsert ENDP


DMean PROC 
     mov edx,offset synonymfile
    call openinputfile
    mov filehandle2,eax
   

    mov edx,offset sbuffer
    mov ecx,sizeof sbuffer
    
    call readfromfile

    ;call WriteWindowsMsg

    INVOKE Str_copy,
    ADDR sbuffer,ADDR syn

    mov edx,offset msg6
    call writestring
    call crlf

    mov ebx,0
    mov ebx,dotcounter1
    

    mov eax,0
   
    mov esi,0
    mov ecx,100000
    mov Ending_point,0

    qb:
        mov al,syn[esi]
        .IF al != '.'
        inc esi
        .ELSE
       
        inc dotcounter2
        inc esi
        .ENDIF

        .IF dotcounter2 == ebx
        mov ecx,sizeof syn
        mov starting_point,esi

        iqra:
                  
            mov al,syn[esi]
            .IF al == '.'
            inc Ending_point
            mov eax,filehandle2
            call Closefile
            call De
            ret
            
            .ENDIF
            inc Ending_point
            inc esi
        loop iqra
        .ENDIF

    loop qb

    mov eax,filehandle2
    call Closefile

     DMean ENDP

de PROC
        INVOKE CreateFile,
	  ADDR synonymfile, GENERIC_WRITE, DO_NOT_SHARE, NULL,
	  OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0

	
	mov fileHandle,eax			; save file handle
    

	

	;It will replace the things
	INVOKE SetFilePointer,
	  fileHandle,starting_point,0,FILE_BEGIN

	INVOKE WriteFile,
	    fileHandle, ADDR dbuffer,Ending_point,
	    ADDR dbytesWritten, 0

	INVOKE CloseHandle, fileHandle

    ret
de ENDP


dMeaning PROC
  
    mov eax,0
    mov finalCounter,0

    mov edx,offset filename
    call openinputfile
    mov filehandle,eax
   
    mov edx,offset buffer
    mov ecx,sizeof buffer
    call readfromfile

   
    INVOKE Str_copy,
    ADDR buffer,ADDR wrd

    mov esi,offset wrd
    mov ecx,sizeof wrd
    mov eax,0
    counter:
    mov al,[esi]
    .IF al == '.'
    inc finalCounter
    .ENDIF
    inc esi

    loop counter
    mov eax,finalCounter
    
    mov edx,offset msg5
    call writestring

    mov edx,offset anya
    mov ecx,6
    call readstring
    call upperLower
    ;mov edx, offset anya
    ;call writestring
   
    mov ebx,0

    mov eax,0
    mov lv,0
    mov esi,0
    mov ecx,8000
    l: 
        .IF count ==5
        jmp ammara
        

        .ENDIF
        .IF al == 10
        
        mov count,0
        mov esi,0
        .ENDIF
        mov edx,esi
        
        mov bl,anya[esi]
        
        mov esi,lv
        mov al,wrd[esi]
        ;call writechar
        ;call crlf
        
        
        .IF al == bl
        inc count
        
         .ENDIF
        .IF al == '.'
        inc dotcounter1
       
        
        
        
         .ENDIF
        mov esi,edx
        inc esi
        inc lv
        
        

    loop l

     ammara:
     mov eax,finalCounter
    .IF dotcounter1 >= eax
     jmp notfound
    .ELSE
    Sub lv,5
        mov eax,lv
        mov starting_point, eax
        mov eax,6
        mov Ending_point, eax
        mov eax,filehandle
        call Closefile
        call deleteword
        call DMean
      jmp _exit
   
   
    .ENDIF

    notfound:
    
     mov edx,offset msg8
     call writestring
    
    jmp _exit
    
    ret
        

    _exit:
    mov eax,filehandle
    call Closefile
 

    

ret
    dMeaning ENDP

deleteword PROC
INVOKE CreateFile,
	  ADDR filename, GENERIC_WRITE, DO_NOT_SHARE, NULL,
	  OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0

	
	mov fileHandle,eax			; save file handle
    

	

	;It will replace the things
	INVOKE SetFilePointer,
	  fileHandle,starting_point,0,FILE_BEGIN

	INVOKE WriteFile,
	    fileHandle, ADDR dbuffer,Ending_point,
	    ADDR dbytesWritten, 0

	INVOKE CloseHandle, fileHandle

    ret
deleteword ENDP

main PROC
mov edx,offset Startmsg1
    call writestring
    call crlf

    mov ecx,0

    L1:
        call crlf
        mov edx,offset Startmsg2
        call writestring
        call readint
       
        .IF eax==2
           call Meaning
           jmp _e
        .ELSEIF eax==3
            call IsPresent
            call crlf
            .IF (pval == 1)
             call crlf
            call WordInsert
            call MeaningInsert
            jmp _e
            .ELSE
            mov edx,offset msgp
            call writestring
             jmp _e
            .ENDIF
        .ELSEIF eax==1
       
        jmp _e
        .ELSEIF eax==4
        call crlf
            call dMeaning
 
            jmp _e
        .ENDIF

    loop L1
  
    _e:
     call crlf
      mov edx,offset msg7
      call writestring
       call crlf
     exit

    
     main ENDP
    END main
    