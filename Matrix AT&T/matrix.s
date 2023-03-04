.data

    cerinta: .space 4
    n: .space 4
    v: .space 1000
    matrix: .space 300000
    matrix_copy: .space 300000
    matrix_aux: .space 300000
    fs1: .asciz "%ld"
    i: .long 0
    j: .long 0
    nod: .space 4
    nr_vecini: .space 4
    vecin: .long 2
    fsprint: .asciz "%ld "
    newLine: .asciz "\n"
    k: .space 4
    start: .space 4
    end: .space 4
    cnt: .space 4
    t: .space 4
    ii: .space 4
    jj: .space 4
    mit: .space 4
    mkj: .space 4
    mij: .space 4
    nn: .space 8
    p: .space 8
    iii: .space 8 #2 3 1 2 1 1 0 2 0 90 1 0
.text
    matrix_mult:
        #matrix 8(%ebp)
        #matrix_copy 12(%ebp)
        #matrix_aux 16(%ebp)
        #n 20(%ebp)
        pushl %ebx
        movl %esp, %ebp

        pushl %esi # -4(%ebp)
        pushl %edi # -8(%ebp)
        pushl %ebx # -12(%ebp)

        subl $4, %esp #i -16(%ebp)
        subl $4, %esp #j -20(%ebp)
        subl $4, %esp #t -24(%ebp)

        subl $4, %esp #mit -28(%ebp)
        subl $4, %esp #mkj -32(%ebp)
        subl $4, %esp #mij -36(%ebp)

        movl $0, -16(%ebp)#i
            et_for_lines3: #o iau pe linii cu i
                movl -16(%ebp), %ecx
                cmp %ecx, 20(%ebp)#n
                je et_exit3

                    movl $0, -20(%ebp)#j
                    et_for_columns3: #o iau pe coloane cu j
                        movl -20(%ebp), %ecx
                        cmp %ecx, 20(%ebp)#n
                        je et_space3

                        movl $0, -24(%ebp)#t
                        et_for_columns4: #o iau pe coloane cu t
                            movl -24(%ebp), %ecx
                            cmp %ecx, 20(%ebp)#n
                            je et_space4

                            movl -16(%ebp), %eax
                            movl $0, %edx
                            mull 20(%ebp)
                            addl -24(%ebp), %eax
                            movl 12(%ebp), %edi #poate movl nush inca 
                            movl (%edi, %eax, 4), %ebx #elementul m[i][k]
                            movl %ebx, -28(%ebp) #mit

                            movl -24(%ebp), %eax
                            movl $0, %edx
                            mull 20(%ebp) #n
                            addl -20(%ebp), %eax
                            movl 8(%ebp), %edi
                            movl (%edi, %eax, 4), %ebx #elementul m[k][j]
                            movl %ebx, -32(%ebp)

                            movl -32(%ebp), %eax #inmultesc elementele matrix[i][k]*matrix_copy[k][j]
                            movl $0, %edx
                            mull -28(%ebp) 
                            movl %eax, -36(%ebp) #pastrez in matrix_aux[i][j]

                            

                            movl -36(%ebp), %ebx #bag mij in ebx
                            movl -16(%ebp), %eax
                            movl $0, %edx
                            mull 20(%ebp)
                            addl -20(%ebp), %eax
                            movl 16(%ebp), %edi
                            addl %ebx, (%edi, %eax, 4) #fac mij elementul m[i][j]

                            incl -24(%ebp)
                            jmp et_for_columns4

                    et_space4:

                        incl -20(%ebp)
                        jmp et_for_columns3

                et_space3:                
                    incl -16(%ebp)
                    jmp et_for_lines3 
            et_exit3:
            
        addl $24, %esp
        popl %esi # -4(%ebp)
        popl %edi # -8(%ebp)
        popl %ebx # -12(%ebp)

        movl %ebp, %esp
        popl %ebp

        ret

.global main

main:
    pushl $cerinta #citesc nr cerinta
    pushl $fs1
    call scanf
    popl %ebx
    popl %ebx

    pushl $n #citesc nr noduri
    pushl $fs1
    call scanf
    popl %ebx
    popl %ebx

    lea v, %edi
    et_for: #citire lista v
        movl i, %ecx
        cmp %ecx, n
        je et_final_for
        
        pushl $nr_vecini #citesc nr vecini
        pushl $fs1
        call scanf
        popl %ebx
        popl %ebx
        movl i, %ecx
        movl nr_vecini, %ebx
        movl %ebx, (%edi, %ecx, 4)
        incl i
        jmp et_for

    et_final_for:

    movl $0, i
    et_for2:#for pentru fiecare nod
        movl i, %ecx
        cmp %ecx, n
        je et_final_for2

        lea v, %edi
        movl i, %ecx
        movl (%edi, %ecx, 4), %eax
        movl %eax, nr_vecini

        movl $0, j
        et_for3:#for pentru citit vecinii nodului i
            movl j, %ecx
            cmp %ecx, nr_vecini
            je et_final_for3

            pushl $vecin #citesc vecinul
            pushl $fs1
            call scanf
            popl %ebx
            popl %ebx  

            movl $0, %edx
            movl i, %eax
            mull n 
            addl vecin, %eax
            #sub $1, %eax

            lea matrix, %edi
            movl $1, (%edi, %eax, 4)

            incl j
            jmp et_for3
        et_final_for3:
        incl i
        jmp et_for2

    et_final_for2:

    movl cerinta, %eax #verific cerinta sa fie 1 pentru a afisa
    movl $1, %ebx
    cmp %eax, %ebx
    jne et_fara_afisare

    

    et_afisare_matrice_adiacenta: #afisez matricea
        movl $0, i
        et_for_lines: #o iau pe linii cu i
            movl i, %ecx
            cmp %ecx, n
            je et_exit

                movl $0, j
                et_for_columns: #o iau pe coloane cu j
                    movl j, %ecx
                    cmp %ecx, n
                    je et_space

                    movl i, %eax
                    movl $0, %edx
                    mull n
                    addl j, %eax
                    lea matrix, %edi
                    movl (%edi, %eax, 4), %ebx #elementul m[i][j]

                    pushl %ebx
                    pushl $fsprint
                    call printf
                    popl %ebx
                    popl %ebx

                    pushl $0
                    call fflush
                    popl %ebx

                    incl j
                    jmp et_for_columns

            et_space:#afiseaza \n dupa fiecare modificare la i
                movl $4, %eax
                movl $1, %ebx
                movl $newLine, %ecx
                movl $2, %edx
                int $0x80
                
                incl i
                jmp et_for_lines
        et_exit:
    
    movl $1, %eax #termin programul dupa afisare
    xor %ebx, %ebx
    int $0x80

    et_fara_afisare: #cazul 2 
    
    pushl $k #citesc lungimea drumului
    pushl $fs1
    call scanf
    popl %ebx
    popl %ebx

    pushl $start #citesc sursa
    pushl $fs1
    call scanf
    popl %ebx
    popl %ebx

    pushl $end #citesc destinatia
    pushl $fs1
    call scanf
    popl %ebx
    popl %ebx

    et_copiere_matrice: #fac o copie a matricei in matrix_copy
        movl $0, i
        et_for_lines2: #o iau pe linii cu i
            movl i, %ecx
            cmp %ecx, n
            je et_exit2

                movl $0, j
                et_for_columns2: #o iau pe coloane cu j
                    movl j, %ecx
                    cmp %ecx, n
                    je et_space2

                    movl i, %eax
                    movl $0, %edx
                    mull n
                    addl j, %eax
                    lea matrix, %edi
                    movl (%edi, %eax, 4), %ebx #elementul m[i][j]

                    lea matrix_copy, %edi
                    movl %ebx, (%edi, %eax, 4) #copiez elementul m[i][j] in m2[i][j]

                    incl j
                    jmp et_for_columns2

            et_space2:                
                incl i
                jmp et_for_lines2
        et_exit2:
    
    et_caz_3:
    movl cerinta, %eax #verific cerinta sa fie 3 
    movl $3, %ebx
    cmp %eax, %ebx
    jne et_fin_caz_3

    pushl %ebp

    movl $192, %eax #apel mmap2
    xorl %ebx, %ebx #adresa null pentru a se alege una automat
    movl $40000, %ecx #marimea spatiului, n*n
    movl $0x3, %edx #cod pt w-r
    movl $0x22, %esi # anonymous mapping and shared memory
    movl $-1, %edi #nu se foloseste fisiier
    int $0x80

    popl %ebp

    movl %eax, p #am pointerul p pentru spatiul de memorie alocat dinamic
    #momentan am matricea aux initializata si matricea rez egala cu O
    #vreau sa mut in p matricea citita

    et_copiere_matrice3: #fac o copie a matricei in matrix_copy
        movl $0, i
        et_for_lines23: #o iau pe linii cu i
            movl i, %ecx
            cmp %ecx, n
            je et_exit23

                movl $0, j
                et_for_columns23: #o iau pe coloane cu j
                    movl j, %ecx
                    cmp %ecx, n
                    je et_space23

                    movl i, %eax
                    movl $0, %edx
                    mull n
                    addl j, %eax
                    lea matrix, %edi
                    movl (%edi, %eax, 4), %ebx #elementul m[i][j]

                    movl p, %edi
                    movl %ebx, (%edi, %eax, 4) #copiez elementul m[i][j] in m2[i][j]

                    incl j
                    jmp et_for_columns23

            et_space23:                
                incl i
                jmp et_for_lines23
        et_exit23:

    movl $1, cnt #initializez cu 1 pentru a ridica la k, nu la k+1             1 4 2 2 1 0 1 2 2 3 3 2 0 3
    et_for_k3: #for pentru ridicat matricea la k

        movl cnt, %ecx
        cmp %ecx, k 
        je et_end_for_k3

        pushl n
        pushl $matrix_aux
        pushl $matrix_copy
        pushl p###muta adresa si da push dupa

        call matrix_mult

        popl %edx
        popl %edx
        popl %edx
        popl %edx

     et_copiere_matrice23: #mut matrix_aux in matrix
        movl $0, ii
        et_for_lines_ii3: #o iau pe linii cu ii
            movl ii, %ecx
            cmp %ecx, n
            je et_exit2_23

                movl $0, jj
                et_for_columns_jj3: #o iau pe coloane cu jj
                    movl jj, %ecx
                    cmp %ecx, n
                    je et_space2_23

                    movl ii, %eax
                    movl $0, %edx
                    mull n
                    addl jj, %eax
                    lea matrix_aux, %edi
                    movl (%edi, %eax, 4), %ebx #elementul matrix_aux[i][j]
                    movl $0, (%edi, %eax, 4)

                    movl p, %edi
                    movl %ebx, (%edi, %eax, 4) #copiez elementul matrix_aux[i][j] in matrix[i][j]

                    incl jj
                    jmp et_for_columns_jj3

            et_space2_23:                
                incl ii
                jmp et_for_lines_ii3
        et_exit2_23:
        
        movl $0, iii
        movl $0, %edx
        movl n, %eax
        mull n
        movl %eax, iii
        
        incl cnt
        jmp et_for_k3 #pana aici trebuie sa actualizez matrix cu matrix_aux
    et_end_for_k3:

    movl $0, %edx
    movl start, %eax
    mull n
    addl end, %eax

    movl p, %edi
    movl (%edi, %eax, 4), %ebx

    pushl %ebx
    pushl $fs1
    call printf
    popl %ebx
    popl %ebx

    pushl $0
    call fflush
    popl %ebx


    movl $1, %eax
    xor %ebx, %ebx
    int $0x80

    et_fin_caz_3:

    movl $1, cnt #initializez cu 1 pentru a ridica la k, nu la k+1             3 4 2 2 1 0 1 2 2 3 3 2 0 3
    et_for_k: #for pentru ridicat matricea la k

        movl cnt, %ecx
        cmp %ecx, k 
        je et_end_for_k

        pushl n
        pushl $matrix_aux
        pushl $matrix_copy
        pushl $matrix###muta adresa si da push dupa

        call matrix_mult

        popl %edx
        popl %edx
        popl %edx
        popl %edx

     et_copiere_matrice2: #mut matrix_aux in matrix
        movl $0, ii
        et_for_lines_ii: #o iau pe linii cu ii
            movl ii, %ecx
            cmp %ecx, n
            je et_exit2_2

                movl $0, jj
                et_for_columns_jj: #o iau pe coloane cu jj
                    movl jj, %ecx
                    cmp %ecx, n
                    je et_space2_2

                    movl ii, %eax
                    movl $0, %edx
                    mull n
                    addl jj, %eax
                    lea matrix_aux, %edi
                    movl (%edi, %eax, 4), %ebx #elementul matrix_aux[i][j]
                    movl $0, (%edi, %eax, 4)

                    lea matrix, %edi
                    movl %ebx, (%edi, %eax, 4) #copiez elementul matrix_aux[i][j] in matrix[i][j]

                    incl jj
                    jmp et_for_columns_jj

            et_space2_2:                
                incl ii
                jmp et_for_lines_ii
        et_exit2_2:
        
        movl $0, iii
        movl $0, %edx
        movl n, %eax
        mull n
        movl %eax, iii
        
        incl cnt
        jmp et_for_k #pana aici trebuie sa actualizez matrix cu matrix_aux
    et_end_for_k:

    movl $0, %edx
    movl start, %eax
    mull n
    addl end, %eax

    lea matrix, %edi
    movl (%edi, %eax, 4), %ebx

    pushl %ebx
    pushl $fs1
    call printf
    popl %ebx
    popl %ebx

    pushl $0
    call fflush
    popl %ebx


    movl $1, %eax
    xor %ebx, %ebx
    int $0x80