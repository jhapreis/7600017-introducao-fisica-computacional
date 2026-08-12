!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Exemplos de programas do FORTRAN 77 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! O caracter "!" inicia um comentário... após !, tudo é desconsiderado para compilação 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Definições:
!    Variáveis: pedaços da memória que podem assumir distintos valores no decorrer do programa
!    Constantes: pedaços da memória que cujos valores são fixos no decorrer do programa 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! As variáveis são separadas de acordo com o tamanho de memória que ocumpam para seu armazenamento.
! Tipos de variáveis:
!	 inteira (são os inteiros - não tem a parte ponto flutuante) 
!       Ex: i1 = 2, i3 = 33445
!	 reais (são os números reais geral) ai1 = 2.33454, avo=6.02e23 
!	 complexas (pares de números reais) Ex. a1=(2.34,0.34),api=(0.e0,3.1416e0)
!	 characters (sao aquelas que asumem valores que são caracteres)
!   lógicas (que podem ser .true. ou .false.) Ex. al1=.true., al2 =.false.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! As variáveis são também distinguidas pelo espaço requerido ao seu armazenamento. 
! A unidade que medimos é o byte, que é o agregado de 8 bits, i.e., 1 byte = 8 bits. 
! Os tamanhos das variáveis inteiras  são:
!	            integer*4 -->inteira de 4 bytes
!	            integer*8 --> inteira de 8 bytes 
! Podem assumir os seguintes valores:
!              INTEGER*1: de –128 a 127 (note que de -128 até 127 há 2^8 = 256 números)
!                         o byte 00000000 corresponde ao número -128 enquanto o byte 11111111 corresponde ao número 127
!                         o byte 01000101 corresponde ao número 0*2^7+1*2^6+0*2^5+0*2^4+0*2^3+1*2^2+0*2^1+1*2^0 - 128 = -59
!              INTEGER*2 –32,768 a 32,767 (2^16 números - 16 bits) 
!              INTEGER*4 –2,147,483,648 a 2,147,483,647 (padrão - 2^32 números - 32 bits)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! O Default da máquina é integer*4
!	            integer ia1    => a variável ia1 será integer*4
!          Os tamanhos das variáveis reais são:
!	            Precisão simples, 6 casas decimais (padrão):
!                    REAL*4  (padrão), ou simplesmente REAL 
!              Precisão dupla, 15 casas decimais:
!                    REAL*8 ou DOUBLE PRECISION
!		    Complexo de precisão simples
!	            COMPLEX*8  (padrão), ou simplesmente COMPLEX
!	            COMPLEX*16 (parte real e imaginária em dupla precisão) 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!  A primeria etapa na confecçao do programa é a  declaração das variáveis
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! ATENÇÃO - ATENÇÃO - ATENÇÃO 
! A sintaxe de variáveis padrão do FORTRAN-77 é a seguinte:
!     variáveis inteiras se iniciam com i,j,k,l,m,n
!     variáveis reais se iniciam com a,b,c,d,f,g,h; o,p,q,r,s,t,u,v,x,z
!     Em suma, reais (a-h,o-z) e inteiras (i-n)
! Neste curso, adotaremos esse padrão para declarar variáveis
! Sugerimos fortemente que você também o adote
!	   Consideraremos os exemplos abaixo para declaração de variáveis
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!	Exemplo 1
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      real*8 a1,a2  !variáveis de preciso dupla
!     final da declaração de variáveis
      a1 = 1.2d-35
      a2 = a1*a1
      a3 = a2!note que a3 não foi declarada explicitamente. Logo, ela é real*4
      write(*,*)'a1 =',a1 !escreve o resultado de a1
      write(*,*)'a2 =',a2 !escreve o resultado de a2
      write(*,*)'a3 =',a3 !escreve o resultado de a3
      end  !obrigatório terminar o programa end (fim dos comandos)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Supondo que o código acima está num arquivo de nome exemplo1.f
! Ele é compilado pelo comando no terminal
        gfortran exemplo1.f -o exemplo1.exe
! Será gerado o executável exemplo1.exe 
! Para rodar o programa executável, usa-se o comando no terminal
        ./exemplo1.exe
! O resultado será	 
! a1 =  1.200000000000000E-035
! a2 =  1.440000000000000E-070
! a3 =  0.0000000E+00
!     Enquanto a2 dá o resultado esperado, a3 não.	
!     A razão se deve ao fato de a3 não tem os bytes necessários para dar o valor correto
!     Há funções que fazem a conversão correta entre variáveis distintas
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!	Exemplo 2
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      implicit real*8 (a-h,o-z)
      complex z1,z3  !variável complexa de simples precisão
      complex*16 z2  !variável complexa de dupla precisão
      character*6 h1,h3 !variável caractere de 6 letras
      character*9 h2 !variável caractere de 9 letras
C     final da declaração de variáveis
      z1 =(1.e0,0.5e0)
      z2 =(1.d0,0.3d0)
      h1='aleluiaaaa'
      h2='aleluiaaaa'
      h3='tomara'
      z3 = z1*z2
      write(*,*) 'z1*z2=',z1*z2
      write(*,*) 'h1 -->',h1,' h2-->',h2,' h3 -->',h3
      end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!      No programa acima, na primeira linha declaramos que todas 
!      as variáveis que comecam de (a-h) ou (o-z) são reais de dupla
!      precisão, z1 e z3 são complexas de precisão simples,
!      z2 é complexa de precisão dupla, h1 e h3 são caracteres de 6 letras
!      e h2 é caractere de 9 letras
!      
!Compilando como
	gfortran program2.f -o nomequequizer.exe
! e exectuando como
        ./nomequequizer.exe
! o resultado é
! z1*z2= ( 0.84999999999999998     , 0.80000000000000004     )
! h1 -->alelui h2-->aleluiaaa h3 -->tomara
! 
! Note que em h1, só apareceu --> alelui, porque h1 tem 6 letras. O programa só pega os primeiros 6 caracteres 
! Outro Exemplo:
      program hello
      implicit none!este comando diz que não há variáveis implicitas declardas. Logo, todoas as variáveis devem ser declardas. Sugerimos que use esta abordagem, principalmente em programas grandes.

      character*15 surname, firstname 
      character*6  title 
      character*25 greetings
   
      title = 'Mr. ' 
      firstname = 'Rowan ' 
      surname = 'Atkinson'
      greetings = 'A big hello from Mr. Bean'
   
      print *, 'Here is ', title, firstname, surname
      print *, greetings
   
      end program hello
! o resultado é:
!   Here is Mr. Rowan Atkinson       
!   A big hello from Mr. Bean
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!Declaração de vetores e matrizes.

!Como vetores e matrizes possuem as mais diversas dimensões, é  interessante 
!introduzir o comando PARAMETER.
!Com este commando introduzimos constantes que nos auxiliarão a declaração das dimensões. Vejamos o exemplo:

!Exemplo 3
!<><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!     programa3.f
      parameter(idim1=10,idim2=100) !idim1 e idim2 serão constantes (inteiras do tipo 4) no programa
      dimension a1(idim1),a2(-idim1:0,2:50),a3(idim1,idim1+idim2,3) 
      dimension ia1(-8:8),ia2(idim1*idim2,idim1)
      real*8 av1(-idim1:idim1)
      double precision av11(idim1,-2:idim2)
      complex z1(idim2,idim2,idim1)
      complex*16 z11(idim2,idim2,idim1)
      character*10 h(idim1)
! 
!	a1 -->real 4 (default)  vetor com componentes 1,2,...,idim1 
!	a2 -->real 4 (default)  matriz cujo 1o índice corre de -idim1,....,0 e o 2o de 2,3,...50
!	a3 --> real 4 (default) tensor de rank 3 (matriz com 3 índices)
!	av1 --> real 8: vetor de precisão dupla cujo índice corre de -idim1 ate idim1
!       av11 --> real 8: matriz
!       z1 --> complex 8 (default): tensor de rank 3 complexo de precisão simples
!       z11 --> complex 16: tensor de rank 3 complexo de precisão dupla
!	h ---> vetor de uma coluna com 10 caracteres em cada componente
      write(*,*) ' Nao vai fazer nada!'
      end 
! Fazer operações com essas variáveis violando os limites do índices dá erro
! Por exemplo, não se pode fazer a1(0) = 1.e0
! Mas pode-se fazer a2(-1,3) = 3.e-2
!<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!	Operações algébricas:  São as usuais +,-,*(multiplicação), / e **(exponenciacao)
!	Exemplos:

!<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C!       programa4.f
        a=3.67
        ia = 4.67! ia ficará com o valor 4
        ia1 = -a  ! ia1 ficará com o valor -3
        ia2 = ia1/4  ! o resultado será a parte inteira  porque ia é inteira
        a = 3/4   ! o resultado será zero porque foi a divisão entre  
                  !dois inteiros que dá um inteiro
        a1 =4.*(3/4) ! o resultado será zero porque a operação 
                     !3/4 tem parte inteira  nula
        a2 =4.*(3./4.) ! o resultado será 3.
        write(*,*) 'ia=',ia
        write(*,*) 'ia1=',ia1
        write(*,*) 'ia2=',ia2
        write(*,*) 'a=',a
        write(*,*) 'a1=',a1
        write(*,*) 'a2=',a2
        end
!<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!O resultado é    
 ia=           4
 ia1=          -3
 ia2=           0
 a=   0.00000000    
 a1=   0.00000000    
 a1=   3.00000000
!      Conforme comentado no programa

! Operações ja construídas no FORTRAN:

!   Existem  as funções já embutidas na compilação de seu programa, como: 
   sin(x), cos(x), e outras funções trigonométricas
   asin(x), atan(x), acos(x),etc... as funções inversas trigonométricas
   exp(x) e log(x) (logarítmo na base Neperiana)  
   funções hiperbólicas cosh(x),sinh(x), tanh(x), etc, 
   sqrt(x), 
!   no cartão de referência do curso existe mais algumas, mas uma busca simples na internet te dará a lista completa das mesmas.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!Operadores e operações lógicas:
     
!   Os operadores lógicos usuais são 
     .eq. (igual, equal)
     .ne. (diferente, not equal)
     .lt. (menor que, less than)
     .le. (menor ou igual que, less or equal than)
     .gt. (maior que, greater than)
     .ge. (maior ou igual que, greater or equal tan)
     .or. (ou, or)
     .and. (e, and)
!   O resultado dessas operações é uma variável lógica de valor T (verdadeiro) ou F (falso)

!Exemplo:
!<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
        logical alo1
        a1 = 2
        a2 = 3
        alo1 = a1.gt.a2
        write(*,*) 'a1.lt.a2 ---> ',a1.lt.a2,'alo1=',alo1
        end
!<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!O resultado é
 a1.lt.a2 ---> T alo1= F
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!  Comandos de leitura e escrita mais usuais são o read() e write().
  
!   Exemplos:
      read(1,*) a1,a2,a3  !você estará lendo na unidade 1 as variáveis a1,a2,a3
      read(3,*) a1,(a(j),j=1,10),aa1
      read(*,*) a1,aa1,ia1 !você estará lendo do terminal as três variáveis 
!(o programa ficara esperando voce dar as variáveis). Assim  recomendamos 
!fazer:
      write(*,*) 'De os valores de a1,aa1,ia1:'
      read(*,*) a1,aa1,ia1
      write(4,*) ' saiu os dados -->',a1,aa1,ia1  !escreve na unidade 4 os dados a1,aa1,ia1.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!Atenção: 
Por razões históricas write(6,*) é o mesmo que write(*,*)
E read(5,*) é o mesmo que read(*,*)
Portanto, não usem as unidade 5 e 6 para designar arquivos de entrada/saída
!Exemplo:
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      dimension a(20)
      read(3,*) a1,(a(j),j=1,5),aa1 !lê do arquivo da unidade 3
      write(*,*) 'a1 =',a1  ! escreve na tela
      write(*,*) 'vetor lido --->',(a(k),k=1,5)  !escreve na tela em uma linha
      end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!       O dado de entrada está na unidade 3, e como não foi especificado o 
!nome do arquivo o mesmo será fort.3. O dado de entrada em fort.3 será do tipo
1.11
3.4 
4.5 
4.6 
4.7 
4.8 
455.3
!A saida do programa apos sua execução será:
 a1 =   1.11000001    
 vetor lido --->   3.40000010       4.50000000       4.59999990       4.69999981       4.80000019 

!Note a falta de precisão após 6 dígitos. Esta precisão está além da precisão das variáveis que são de precisão simples
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
<><><><><><><><><> ATENCAO: PONTO IMPORTANTE  <><><><><><><>
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!USE sempre a terminação correta referente à precisão da variável
!Ex:
      a = 0 (errado)
      a = 0.e0 (se precisão simples)
      a = 0.d0 (se precisão dupla)
      a = 0.q0 (se precisão quádrupla)
      a3 = 3.4d1 ou 34.d0 (certo, se precisão dupla)
      a3 = 34 (errado)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!Nomear arquivos na unidade de leitura
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        dimension a(20)
        open(unit=3,file='dado-entrada') ! o arquivo de entrada --> dado-entrada. Tudo que fizer na unidade 3 será no arquivo dado-entrada
        open(unit=12,file='saida-minha')  ! o arquivo de saída --> saida-minha. Tudo que fizer na unidade 12 será no arquivo saida-minha
        read(3,*) a1,(a(j),j=1,5),aa1 !dados no arquivo dado-entrada
        write(*,*) 'a1 =',a1  ! escreve na tela
        write(*,*) 'vetor lido --->',(a(k),k=1,5)  !escreve na tela em uma linha
        close(3)  !fechou a unidade 3
        close(12)  !fechou a unidade 12
        open(unit=3,file='novos-dados' ) ! abriu a unidade 3 como novos-dados
        write(3,*)'Caramba, mudei de ideia.'  ! vai sair no arquivo: novos-dados
        close(3) ! fechou a unidade 3
        end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!FORMATAÇÃO
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 variáveis inteiras:    iw   (w = número de espaços)
 variáveis reais:       fw.d (w = número de espaços, sendo que d serão gastos para a parte fracionária)
 variáveis characteres: aw   (w = número de espaços)

! Os formatos de saída são dados no comando FORMAT que está na "linha" cujo apelido foi informado no comando WRITE correspondente.
! Alguns comandos interessantes que podem ser colocados no FORMAT
!             'oque quiser' !coloca exatamente o que esta entre ''
!	     1x, 2x ,... --> pula 1,2,... espacos
!              / --> vai para outra linha
!	  Vejamos um exemplo
!<><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!       Programa8.f
      dimension a(4)
      character*7 h1,h2
      a(1) = acos(-1.e0)
      a(2) = exp(1.e0)
      a(3) = 1244.022444e0
      a(4) = cos(a(3)*a(1))
      h1   = 'Aleluia'
      h2   = 'irmão'
      write(6,4) (a(i),i=1,3),h1,h2,a(4) ! a linha 4 tem o formato
4     format('dados de a:',3(f10.5,'|'),a8,' para quem ',a6,'? ||',/,
     &'Só para testar na outra linha.',4x,'pulou quatro espaços')
      end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!A saída do programa será em fort.3 e é:
dados de a:   3.14159|   2.71828|1244.02246| Aleluia para quem irmão? ||
Só para testar na outra linha.    pulou quatro espaços
   0.99751|
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Comando de repetição (laços) DO
!Exemplos:
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      do i=1,4!repete os comandos entre "do" e "enddo" com i variando de 1 a 4 de um em um 
         a = a + i
      enddo
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      do 100 i=1,4!repete os comandos até a linha com o apelido 100
100	   a = a + i1
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! ou equivalentemente usando o comando: continue (que só fala para continuar)
      do 100 i1 =1,4
         a = a+ i1
100   continue  
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      do 10 i2 =-2,6,3  !faz i2 variar de -2 a 6 de 3 em 3 ate a linha com 10
         do 11 i3=-4,2  !faz i3 variar de -4 a 2 de um em um ate linha 11
            a1 = a1 + 1.e0
11       continue
         a1 = a1+10.e0
10    continue
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!	Outros exemplos sem mencionar a linha de termino das ações	
      do i2 =-2,6,3  !faz i2 variar de -2 a 6 de 3 em 3 ate o enddo externo
         do i3=-4,2  !faz i3 variar de -4 a 2 de um em um ate o enddo interno
            a1 = a1 + 1.e0
         end do!note que pode-se usar enddo ou end do
         a1 = a1 + 10.e0
      end do
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Comando condicional if
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!   o if simples
      if(a.lt.0.e0)b = b + a!executa a ação b = b+a se a condição a<0 for verdadeira
! o if com mais comandos
      if(a.lt.0.e0)then!executa as linhas de comando até o endif se a<0
         a = a + 1.e0
         b = 1.e0*sin(b)
      endif
! o if com mais condições
      if(a.lt.0.e0)then !se a<0, então faça
         a = a + 1.e0
   	else if(a.gt.1.e0)then ! caso contrário se a>1, então faça
         a = sin(a)
      else! por fim, caso contrário de todas as condições anteriores, faça
         a = -a
   	endif
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Comando de repetição condicional: do while  
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      a = -1.e0
      do while(a.lt.0.e0) !repete as operações até seu END DO enquanto a for negativo
         a = a + 0.5e0
         b = b + sin(b)
      enddo
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Comando GOTO
C	Veja o exemplo
      if(a.lt.0 ) goto 11  ! se a condição for satisfeita vai para a linha de apelido 11
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!<><> exemplo de programa com os comandos acima
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!  programaex1.f
      parameter (idimax=100, nmax=2, pi = acos(-1.e0))
      real*8 dpi,ad1(-2:2*idimax)
!     final das declarações de variáveis
! 
!     Comando de leituras de dados
! 
      open(unit=1,file='dado.in')  ! nome ao arquivo com dado de entrada
      open(unit=2,file='dado.dat') ! nome ao arquivo com dado de saída
! 
!       comandos de opera coes
! 
      asum    = 0.e0
      aleluia = 1.e0
      dpi     = acos(-1.d0)  ! aqui teremos o valor de pi em dupla  precisão
      do j1=1,2*idimax
         ad1(j1) = 0.d0 !colocamos d0 por ser dupla precisão
      end do
      a = -1000.e0
! outro exemplo de comandos
      do i=1,100
         a = a +1.e0
         if(a.lt.O) goto 4
      end do
4     continue
! mais outro exemplo
      a = -1000.e0
      do while(a.lt.0)
         a = a+1.e0
      end do
!mais comandos
      aai = 0.e0
      do ik1=-2,5
         read(1,*) ad1(ik1)! dará erro se não tiver 7 linhas com dados no arquivo dado.in
         aad = aad + ad1(ik1)!aad não foi inicializado... o valor inicial é 0
         do j1 =-2,56
            if (aad.gt.15) goto 10
         end do
10       continue
14       continue
         do kk =1,10
            if(aleluia.gt.0) then
               aleluia = -aleluia
               goto 14  !repare que você pode sair do laço do DO 
            else
               aleluia = 2.e0*aleluia
            endif
          end do
          aai = aai + ik1
      end do
      rewind(1)! este comando faz o ponteiro de leitura ou escrita da unidade 1 voltar ao início
      do i2=1,50
         read(1,*,end=24) ad1(i2) !se os dados acabarem ele vai para a linha 24 não dando erro
      end do
24    continue
      write(2,*) (ad1(io),io=1,10)  ! escreve os dados
      close(1)!fecha o arquivo aberto da unidade 1
      close(2)!fecha o arquivo aberto da unidade 2
      end
!<><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!<><>  outro exemplo de programa 
!<><><><><><><><><><><><><><><><><><><><><><
!  programaex7.f
        parameter (idimax=100, nmax=2, api = acos(-1.e0))
        dimension i11(idimax),ai2(nmax,idimax)
        real*8 dpi,ad1(idimax)
!     final das declarações de variáveis
! 
!     Comando de leituras de dados
!        
      open(unit=1,file='dado.in')  ! nome ao arquivo com dado de entrada
      open(unit=2,file='dado.out') ! nome ao arquivo com dado de saída
! 
!       comandos de operações
! 
      write(*,*) 'passou aqui 0'
      asum = 0.e0
      aleluia = 1.e0
      dpi = acos(-1.d0)  ! aqui teremos o valor de pi em dupla  precisão
      write(*,*) 'passou aqui 1'
      do j1 =1,2*idimax
!	  write(*,*) 'j1 =',j1
          ad1(j1) = 0.d0 !colocamos d0 por ser dupla precisão
      end do
15    continue
      write(*,*) 'passou aqui 2'
      write(*,*) 'valores de ia1,ia2,aa,bb?' !pede na tela os valores
      read(*,*) ia1,ia2,aa,bb !lê na tela os valores 
      if((ia1.gt.ia2).or.(aa.ge.bb)) then
         write(*,*) 'ia1 maior que ia2, ou então aa maior ou igual a bb 
     &repare que a linha é maior que o tamanho de 72, neste caso tem que
     * colocar algum caracter como continuação, & ou * um número de um d
     1igito'
      else
         write(*,*) 'não satisfez!'
      endif
      end
!<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
     Functions & Subroutines: 
!São unidades externas ao programa principal (cujas próprias variáveis devem ser definidas dentro de sua unidade) 
!e são acessadas pelo programa principal. 
!A FUNCTION são como as funções usuais, podendo ter vários argumentos e serem operadas em uma linha de comando. 
!A saída sempre será um número apenas. 
!A subrotina (subroutine) poderá ter vários argumentos de entrada e de saída, ou mesmo os de saída serem os de entrada. 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! exemplo de programa usando function
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!	programa4.f
      implicit real*8(a-h,o-z)  !todas as variáveis serão de dupla precisão
      dimension a1(20,2:30) ! automaticamente será de dupla precisão
      real*4 aiai1  !escolhi variável de simples precisão
      complex z1(100)  ! será complexo de simples precisão
! 
      write(*,*) ' me de o valor de m.'
      read(*,*) m
      api = acos(-1.d0)
      do i1=1,20
         do j1 = 4,15
            a1(i1,j1)= dsin(api*m/dsqrt(2.d0))
            write(2,*) 'i1,j1=',i1,j1,'a1-->',a1(i1,j1)
         end do
      end do
      o1 = f1(2.d0,1.d0)
      write(*,*) 'o1 =',o1
100	o2 = o1 + f1(o1,2*o1) + f1(o1,o1) + sin(f1(o1,2.d0-o1))
      write(*,*) 'o2 =',o2
      aiai1 =o1 + f1(o1,2*o1) + f1(o1,o1) + sin(f1(o1,2.d0-o1))
      write(*,*) 'aiai1 =',aiai1! repare que foi truncado para precisão simples (as variáveis e FUNCTIONs eram de precião dupla e aiai1 é de precisão simples)
!	Se a function fosse de precisão simples, o programa não compilaria devido a linha 100 acima, pois a variável o2 teria uma precisão maior que aquela dada pela function
   	aa2 = 0.334d0
	   aa3 = -0.45d0
	   aaa = g1(aa2)*f1(aa2,aa3)
	   write(*,*) 'aaa --->',aaa
   	end
!++++++++++++++++++++++++++++++++++++++++++++++++
! 
!	function  nome:f1(y1,y2) 
! 
!	Calcula a rebimbeta da parafuseta a partir de y1 e y2
! 
!++++++++++++++++++++++++++++++++++++++++++++++++
   	function f1(y1,y2)
   	implicit real*8 (a-h,o-z)
   	dimension a1(2,2)
   	do i1=1,2
   	   do j1 =1,2
      	   a1(i1,j1) = 0.e0
   	   end do
	   end do
      aa = y1 +sin(y2)
      if(aa.ge.0) then
         f1 = aa
      else
         f1 = sin(aa)
      endif
      return! a function após o cálculo retorna no programa principal com o comando return
      end function f1
!++++++++++++++++++++++++++++++++++++++++++++++++
! 
!	function  nome:g1(y1) 
! 
!	Calcula a parafuseta da rebimbeta  a partir de y1 
! 
!++++++++++++++++++++++++++++++++++++++++++++++++
      function g1(y1)
      implicit real*8 (a-h,o-z)
      dimension a1(2,2)
      aa = y1 +sin(y1)
      g1 = aa
      return
      end function g1
!<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
!  Daremos um exemplo de subrotina
!<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
!       programa4.f
      implicit real*8(a-h,o-z)  !todas as variáveis serão de dupla precisão
      dimension a1(20,2:30) ! automaticamente será de  dupla precisão
      real*4 aiai1  !escolhi variável de simples precisão
      complex z2(10,10),zz2 ! será complexa de simples precisão
      complex*16 z1(100)  ! será complexo de dupla precisão
      dimension amora(30)
! 
      write(*,*) ' me de o valor de m.'
      read(*,*) m
      api = acos(-1.d0)
      do i1=1,20
         do j1 = 4,15
            a1(i1,j1)= dsin(api*m/dsqrt(2.d0))
            write(2,*) 'i1,j1=',i1,j1,'a1-->',a1(i1,j1)
         end do
      end do
      x1 = 1.d0+a1(20,3)
      x2 = 2.d0+ a1(2,28)
      x3 = 1.d0
      write(*,*) 'antes x1,x2,x3 -->',x1,x2,x3
      call subrot1(x1,x2,x3,amora) ! chama a subrotina com as entradas x1,x2 e x3
                              ! vai voltar os valores que os equivalentes
                              ! da subrotina tomaram
                           ! a matrix amora tem que ser do mesmo tipo e 
                           ! dimensão que a ,matrix abobora na subrotina
      write(*,*) 'x1 =',x1,'x2=',x2,'x3 =',x3
      write(*,*) amora
! 
      end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!subrotina subrot1!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      subroutine subrot1(abacaxi, amortadela, salamei,abobora)
      implicit real*8 (a-h,o-z)
      dimension abobora(30)
      abacaxi = abacaxi + amortadela
      salame  = amortadela
      write(*,*) 'dentro abacaxi =',abacaxi
      do i =1,30
         abobora(i) = i
      end do
      return
      end subroutine subrot1
!<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
! Exemplo de uso do gerador de números pseudo-aleatórios
! a função intrínseca rand() da um numero "aleatório" 
! entre 0 e 1. O início da sequência  é dada pela 
! semente iseed (faz uma primeira vez rand(iseed)). A
! sequência será sempre a mesma para dado valor de 
! "iseed". No exemplo abaixo calculamos o primeiro,
! segundo e terceiro momentos do número aleatório.
!<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
!       Program: gerador.f
      iseed = 10!semente do gerador de números pseudo-aleatórios. Precisa ser um inteiro*4
      CALL srand(iseed)!inicializa o gerador de números aleatórios rand()
      do i=1,5
         write(*,*)rand()
      enddo
      CALL srand(iseed)!reinicializa o gerador de números aleatórios
      do i=1,5
         write(*,*)rand()!obtem-se, portanto, a mesma sequencia anterior
      enddo
      CALL random_seed()!reinicializa o gerador de números aleatórios com uma "seed" desconhecida e aleatória. Desta maneira, toda vez que rodar o programa, será uma nova sequência de números pseudo-aleatórios
      asum1 = 0.e0
      asum2 = 0.e0
      asum3 = 0.e0
      write(*,*) 'N?'
      read(*,*) N
      write(*,*) 'valor de N -->',N
      do i1 =1,N
         rr = rand()!o gerador já foi inicializado, chame a função rand() sem argumentos dentro dos parênteses
         asum1 = asum1 + rr
         asum2 = asum2 + rr*rr
         asum3 = asum3 + rr*rr*rr
      end do
      write(*,*) '<rr> =',asum1/N  !média dos números aleatórios
      write(*,*) '<rr**2> =',asum2/N ! média do quadrado
      write(*,*) '<rr**3> =',asum3/N ! média do cubo
      stop!o comando stop encerra a execução do programa, independentemente de sua posição no programa
      end
