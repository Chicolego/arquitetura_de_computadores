;---------------------------------------------------
; Programa: Compara valor
; Autor: Grupo I(Lucas Araujo Carvalho, Francisco José Santos de Oliveira, Iago Rafael Lucas Martins)
; Data: 10/06/2022
;---------------------------------------------------

          ORG     100

NUM1:     DW      3            ; Criação de duas variáveis (que serão comparadas) e dois ponteiros
NUM2:     DW      5
PTR1:     DW      NUM1
PTR2:     DW      NUM2

          ORG     0

          LDA     PTR1+1       ; Colocamos os endereços das duas variáveis na pilha
          PUSH
          LDA     PTR1
          PUSH
          LDA     PTR2+1
          PUSH
          LDA     PTR2
          PUSH
          JSR     COMPARA
                               ; Parte final do programa principal
          OUT     3            ; Limpeza do banner
          JN      PRINTNEG
          ADD     #30h         ; Adaptação da saída para ASCII
          OUT     2            ; Printa o valor do acumulador no banner
          HLT

PRINTNEG: LDA     #2Dh         ; Printa "-"
          OUT     2
          LDA     #31h         ; Printa "1"
          OUT     2
          HLT

          ORG     200

ENDERRET: DW      0
ENDER1:   DW      0
VAR1:     DW      0
ENDER2:   DW      0
VAR2:     DW      0

COMPARA:  STS     ENDERRET     ; ENDERRET salva o endereço de retorno
          POP
          POP
          POP
          STA     ENDER2       ; Salva os endereços (que já estão na pilha) das duas partes das duas variáveis
          POP
          STA     ENDER2+1
          POP
          STA     ENDER1
          POP
          STA     ENDER1+1

          LDA     @ENDER1      ; Passamos conteúdo dos endereços ENDER1, ENDER1+1, ENDER2 e ENDER2+1 para variáveis
          STA     VAR1
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

CMPIGUAL: LDA     VAR1+1       ; Comparação entre as partes altas
          XOR     VAR2+1
          JNZ     CMPSINAL     ; Aqui já ocorre um jump se já constatarmos diferença na parte alta
          LDA     VAR1         ; Comparação entre as partes baixas
          XOR     VAR2
          JZ      EHIGUAL      ; Caso seja provado que as duas partes são idênticas, pulamos para a rotina EHIGUAL

CMPSINAL: LDA     VAR1+1       ; Comparamos os sinais, já que é uma forma rápida de constatar maior/menor
          JN      NEGVAR1      ; Pulamos para uma nova rotina, caso se constate que a variável 1 é negativa
          LDA     VAR2+1
          JN      EHMAIOR      ; Pulamos para uma nova rotina, caso se constate que a variável 2 é negativa. Como não
                               ; houve jump anteriormente, sabemos que var1 é positiva. Logo, isso vai significar que
                               ; var1 > var2
          JMP     CMPVALOR     ; Pulamos para a comparação de valores, já que ambas são positivas

NEGVAR1:  LDA     VAR2+1       ; Já sabendo que a variável 1 é negativa, vamos carregar e checar se a dois também é
          JN      CMPVALOR     ; Pulamos para uma nova rotina, caso as duas sejam negativas e não seja possível
                               ; constatar maior/menor

          JMP     EHMENOR      ; Se não pulou anteriormente, é porque a variável 2 é positiva. Logo, var2 > var1

CMPVALOR: LDA     VAR1+1       ; Carregamos a parte alta da variável 1 e realizamos um Shift Left. Caso dê carry,
          SHL                  ; significa que eliminamos um "1" significativo. Se fizermos o mesmo processo na
                               ; variável 2 e não for obtido um carry, isso vai sinalizar que VAR1 > VAR2. Caso
                               ; isso venha a não acontecer e ambos tenham o mesmo resultado (carry ou não), iremos
                               ; repetir o processo até que seja encontrada uma diferença. Como a igualdade já foi
                               ; testada anteriormente, sabemos que as duas variáveis são necessariamente diferentes, uma
                               ; vez que chegaram nessa parte do código
          STA     VAR1+1
          JC      CVAR1
          LDA     VAR2+1
          SHL
          STA     VAR2+1
          JC      EHMENOR

CVARBAX:  LDA     VAR1
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
          JMP     CMPVALOR

CVAR1:    LDA     VAR2+1
          SHL
          STA     VAR2+1
          JNC     EHMAIOR       ; Constatação que VAR1 > VAR2
          JMP     CVARBAX       ; Regresso para CVARBAX, para dar sequência ao shift (Agora na parte baixa)

RETORNA:  LDS     ENDERRET      ; Carrega o ENDERRET para dar retorno ao final do programa principal
          RET
                                ; Aqui estão as 3 possibilidades. O valor vai ser colocado no acumulador e, em sequência,
                                ; o código será transportado para a rotina RETORNA
EHIGUAL:  LDA     #0
          JMP     RETORNA

EHMAIOR:  LDA     #1
          JMP     RETORNA

EHMENOR:  LDA     #-1
          JMP     RETORNA
