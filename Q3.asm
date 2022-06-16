;---------------------------------------------------
; Programa: Maior e Menor de um Vetor
; Autor: Grupo I(Lucas Araujo Carvalho, Francisco José Santos de Oliveira, Iago Rafael Lucas Martins)
; Data: 11/06/2022
;---------------------------------------------------


          ORG     100

V:        DW      166, -391, 222, 311, 200, 981, 231, 0, 9000, -3189, 44, -888, 21, 3188, -9871, 311, 789, 2222, -988, 100
PTR1:     DW      V
PTR2:     DW      MAIOR
PTR3:     DW      MENOR
SIZE:     DB      20
MAIOR:    DW      -32768       ; Colocamos o menor número possível, justamente para forçar a mudança
MENOR:    DW      32767        ; Nesse caso, selecionamos o maior possível
I:        DB      0

          ORG     0

INICIO:   LDA     I
          SUB     SIZE
          JN      PRECOMP      ; If (I-Size) < 0. Checa o fim das iterações
          JMP     FINAL

PRECOMP:  LDA     PTR3+1       ; Colocamos os endereços das 3 variáveis na pilha (parte alta e baixa). As variáveis são:
          PUSH                 ; 1ª) O conteúdo do atual índice do vetor. Será comparado com o MAIOR e MENOR
          LDA     PTR3         ; 2ª) O maior valor encontrado até o momento
          PUSH                 ; 3ª) O menor valor encontrado até o momento
          LDA     PTR2+1
          PUSH
          LDA     PTR2
          PUSH
          LDA     PTR1+1
          PUSH
          LDA     PTR1
          PUSH
          JSR     COMPARA      ; Pulamos para a Comparação


                               ; Parte final do programa principal
FINAL:    LDA     MAIOR+1      ; Aqui, colocamos os resultados na pilha
          PUSH
          LDA     MAIOR
          PUSH
          LDA     MENOR+1
          PUSH
          LDA     MENOR
          PUSH
          HLT

          ORG     200

ENDER1:   DW      0
ENDER2:   DW      0
ENDER3:   DW      0
VAR1:     DW      0
VAR2:     DW      0
VAR3:     DW      0

COMPARA:  POP
          POP
          POP                  ; Salva os endereços (que já estão na pilha) das duas partes das variáveis
          STA     ENDER1
          POP
          STA     ENDER1+1
          POP
          STA     ENDER2
          POP
          STA     ENDER2+1
          POP
          STA     ENDER3
          POP
          STA     ENDER3+1

          LDA     @ENDER1      ; Salvamos os conteúdos de cada um dos ENDER's nas VAR's (Variáveis auxiliares). Agora,
                               ; cada VAR será comparada com as demais (principalmente a VAR1, uma vez que ela sendo
          STA     VAR1         ; > MAIOR ou < MENOR, será necessário realizar uma atualização desses valores)
          LDA     ENDER1
          ADD     #1
          STA     ENDER1
          LDA     ENDER1+1
          ADC     #0
          STA     ENDER1+1
          LDA     @ENDER1
          STA     VAR1+1

          LDA     @ENDER2
          STA     VAR2
          LDA     ENDER2
          ADD     #1
          STA     ENDER2
          LDA     ENDER2+1
          ADC     #0
          STA     ENDER2+1
          LDA     @ENDER2
          STA     VAR2+1

          LDA     @ENDER3
          STA     VAR3
          LDA     ENDER3
          ADD     #1
          STA     ENDER3
          LDA     ENDER3+1
          ADC     #0
          STA     ENDER3+1
          LDA     @ENDER3
          STA     VAR3+1

CMPIGUAL: LDA     VAR1+1       ; Comparação entre as partes altas
          XOR     VAR2+1
          JNZ     CMPSINAL     ; Aqui já ocorre um jump se já constatarmos diferença na parte alta
          LDA     VAR1         ; Comparação entre as partes baixas
          XOR     VAR2
          JZ      NAOMUDA      ; Caso seja provado que as duas partes são idênticas, pulamos para a rotina NAOMUDA
                               ; Uma vez provado que VAR1 = VAR2, não há necessidade de comparar com VAR3, já que 3
                               ; se refere ao menor valor, e se MAIOR é maior que MENOR , um número igual
                               ; ao maior também é, descartando atualização do menor valor nessa iteração

CMPSINAL: LDA     VAR1+1       ; Comparamos os sinais, já que é uma forma rápida de constatar maior/menor
          JN      NEGVAR1      ; Pulamos para uma nova rotina, caso se constate que a variável 1 é negativa
          LDA     VAR2+1
          JN      UPMAIOR      ; Pulamos para uma nova rotina, caso se constate que a variável 2 é negativa. Como não
                               ; houve jump anteriormente, sabemos que var1 é positiva. Logo, isso vai significar que
                               ; var1 > var2. Ou seja, atualizaremos o MAIOR.
          JMP     CMPVALOR     ; Pulamos para a comparação de valores, já que ambas são positivas

NEGVAR1:  LDA     VAR2+1       ; Já sabendo que a variável 1 é negativa, vamos carregar e checar se a dois também é

          JN      CMPVALOR     ; Pulamos para uma nova rotina, caso as duas sejam negativas e não seja possível
                               ; constatar maior/menor
          LDA     VAR3+1
          JN      VARXMEN      ; VAR1 e VAR3 negativas, enquanto VAR2 é positiva. Isso significa que o valor
                               ; em análise (VAR1) é menor que o MAIOR. Portanto, resta saber sobre a comparação com o MENOR.
                               ; Dessa forma, faremos um JUMP para a comparação particular VARXMEN (Variável versus Menor)

          JMP     UPMENOR      ; Se não pulou anteriormente, é porque a variável 3 é positiva. Como só é possível entrar
                               ; nessa parte do código se var1 for negativa, constatamos então que var3 > var1. Ou seja,
                               ; deveremos atualizar MENOR, já que encontramos um número ainda menor

CMPVALOR: LDA     VAR1+1       ; Carregamos a parte alta da variável 1 e realizamos um Shift Left. Caso dê carry,
          SHL                  ; significa que eliminamos um "1" significativo. Se fizermos o mesmo processo na
                               ; variável 2 e não for obtido um carry, isso vai sinalizar que VAR1 > VAR2. Caso
                               ; isso venha a não acontecer e ambos tenham o mesmo resultado (carry ou não), iremos
                               ; repetir o processo até que seja encontrada uma diferença. Como a igualdade já foi
                               ; testada anteriormente, sabemos que as três variáveis são necessariamente diferentes, uma
                               ; vez que chegaram nessa parte do código
          STA     VAR1+1
          JC      CVAR1
          LDA     VAR2+1
          SHL
          STA     VAR2+1
          JC      CMPSINALMEN  ; MAIOR > Conteúdo do Atual Índice. Pulamos para a comparação com MENOR.

CVARBAX:  LDA     VAR1         ; Realizamos um Shift Left das partes baixas, de forma a "acompanhar" o Shift Left das partes
          SHL                  ; altas. Isso nos permite realizar comparações apenas entre as partes altas das variáveis, já
                               ; que os bits da parte baixa vão entrando na alta, gradativamente.
          STA     VAR1
          LDA     VAR1+1
          ADC     #0
          STA     VAR1+1

          LDA     VAR2
          SHL
          STA     VAR2
          LDA     VAR2+1
          ADC     #0
          STA     VAR2+1

          LDA     VAR3
          SHL
          STA     VAR3
          LDA     VAR3+1
          ADC     #0
          STA     VAR3+1

          JMP     CMPVALOR

CVAR1:    LDA     VAR2+1
          SHL
          STA     VAR2+1
          JNC     UPMAIOR       ; Constatação que VAR1 > MAIOR
          LDA     VAR3+1
          SHL
          JNC     VARXMAI       ; VAR1 > MENOR. Logo, precisamos comparar apenas entre VAR1 e MAIOR
          JMP     CVARBAX       ; Significa que todos deram carry, logo precisamos de mais uma iteração para saber mais

NAOMUDA:  LDA     I             ; Se MAIOR > VAR1 > MENOR, nada precisa ser atualizado. Somente incrementamos o i.
          ADD     #1
          STA     I
          LDA     #0
          JMP     INCREMENTAPTR

UPMAIOR:  LDA     I             ; Atualização da variável MAIOR. Receberá o conteúdo do atual índice do vetor
          ADD     #1
          STA     I
          LDA     @ENDER1
          STA     MAIOR+1
          LDA     ENDER1
          SUB     #1
          STA     ENDER1
          LDA     @ENDER1
          STA     MAIOR
          JMP     INCREMENTAPTR

UPMENOR:  LDA     I             ; Atualização da variável MENOR. Receberá o conteúdo do atual índice do vetor
          ADD     #1
          STA     I
          LDA     @ENDER1
          STA     MENOR+1
          LDA     ENDER1
          SUB     #1
          STA     ENDER1
          LDA     @ENDER1
          STA     MENOR
          JMP     INCREMENTAPTR

VARXMAI:  LDA     VAR1+1        ; Comparação particular entre conteúdo do índice atual e MAIOR.
          SHL
          STA     VAR1+1
          JC      CVAR1MAI
          LDA     VAR2+1
          SHL
          STA     VAR2+1
          JC      NAOMUDA       ; MAIOR > VAR1 > MENOR. Ou seja, nada deve mudar.


CVARBAXMAI:
          LDA     VAR1
          SHL
          STA     VAR1
          LDA     VAR1+1
          ADC     #0
          STA     VAR1+1

          LDA     VAR2
          SHL
          STA     VAR2
          LDA     VAR2+1
          ADC     #0
          STA     VAR2+1
          JMP     VARXMAI

CVAR1MAI:
          LDA     VAR2+1
          SHL
          STA     VAR2+1
          JNC     UPMAIOR       ; Constatação que VAR1 > MAIOR
          JMP     CVARBAXMAI    ; Regresso para CVARBAX, para dar sequência ao shift (Agora na parte baixa)



VARXMEN:                        ; Comparação particular entre Índice atual e MENOR.
          LDA     VAR1+1
          SHL
          STA     VAR1+1
          JC      CVAR1MEN
          LDA     VAR3+1
          SHL
          STA     VAR3+1
          JC      UPMENOR       ; Constatação que VAR < MENOR. Logo, devemos atualizar o menor.


CVARBAXMEN:
          LDA     VAR1
          SHL
          STA     VAR1
          LDA     VAR1+1
          ADC     #0
          STA     VAR1+1

          LDA     VAR3
          SHL
          STA     VAR3
          LDA     VAR3+1
          ADC     #0
          STA     VAR3+1
          JMP     VARXMEN

CMPSINALMEN:                    ; Essa etapa do código se faz necessária para casos onde VAR1 é positiva, pois se trata
                                ; de uma situação onde a comparação de sinais com a VAR3 ainda não foi feita.
          LDA     @ENDER3
          JN      NAOMUDA       ; VAR1 > VAR3. Ou seja, nada deve ser atualizado.

          JMP     CVARBAXMEN    ; Pulamos para a comparação de valores, já que ambas são positivas

CVAR1MEN:
          LDA     VAR3+1
          SHL
          STA     VAR3+1
          JNC     NAOMUDA       ; Constatação que VAR1 > MENOR. Como já sabemos que MAIOR > VAR1, nada deve mudar.
          JMP     CVARBAXMEN    ; Regresso para CVARBAXMEN, para dar sequência ao shift (Agora na parte baixa)

INCREMENTAPTR:                  ; Seção do código dedicada a avançar de índice no vetor
          LDA     PTR1
          ADD     #2
          STA     PTR1
          LDA     PTR1+1
          ADC     #0
          STA     PTR1+1
          JMP     INICIO

