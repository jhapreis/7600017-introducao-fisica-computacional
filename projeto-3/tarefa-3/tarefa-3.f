! f(x) = 27*x**3 - 522*x**2 + 3003*x - 4508

	implicit none

	double precision f

	double precision eps ! tolerância para o método

	! Parâmetros para procura do intervalo com as raízes iniciais
	double precision x_start, x_end, h   ! O intervalo global para a busca de raízes e o passo dentro do intervalo
	double precision x_a, x_b            ! x_a = x_{-,n} e x_b = x_{+,n}, os limitantes do subintervalo na iteração

	eps     = 1.0d-6
	x_start = -10.0d0
	x_end   = 10.0d0
	h       = 0.1d0

	open(unit=20, file="tarefa-3-bisseccao.dat")
	open(unit=30, file="tarefa-3-secante.dat")
	open(unit=40, file="tarefa-3-newton-raphson.dat")

	! Encontrar intervalo onde o produto muda de sinal (onde há ao menos uma raiz)
	do while(x_start.le.x_end)
		x_a = x_start
		x_b = x_start + h
		
		! Se no subintervalo há uma raiz, procuramos por ela
		if ( ( f(x_a)*f(x_b) ).lt.0.0d0 ) then
			call bisseccao(x_a, x_b, eps)
			call secante(x_a, x_b, eps)
			call newton_raphson(x_a, eps)
		end if

		! Andamos com o intervalo para procurar mais uma
		x_start = x_start + h
	end do

	close(20)
	close(30)
	close(40)

	stop
	end

	double precision function f(x)
	! Função para encontrar as raízes
		implicit none
		double precision x
		f = 27.0d0*x**3 - 522.0d0*x**2 + 3003.0d0*x - 4508.0d0
	return
	end

	double precision function f_i(x)
	! Derivada primeira analítica de f, para o método de Newton-Raphson
		implicit none
		double precision x
		f_i = 3.0d0*27.0d0*x**2 - 2.0d0*522.0d0*x + 3003.0d0
	return
	end

	subroutine bisseccao(x_start, x_end, eps)
	! Método da bissecção:
	! 	Se o x_m*x_{+,n}>0, então o ponto médio caiu "à direita" da raiz,
	! indicando que devemos procurar "à esquerda" -> (x_{-,n}, x_m)
	!     Caso contrário, devemos procurar "à direita" -> (x_m, x_{+,n})
	!
	! 	Obs.: Essa subrotina adiciona os dados no mesmo arquivo já aberto, 
	! para facilitar o acompanhamento da busca do método. 

		implicit none

		double precision x_start, x_end, eps
		double precision f

		double precision x_m      ! Ponto médio do intervalo da bissecção
		double precision x_a, x_b ! Variáveis locais, para não modificar as variáveis fora do escopo

		x_a = x_start
		x_b = x_end

		do while(1.eq.1)

			x_m = 0.5d0 * (x_a + x_b)

			if( f(x_m)*f(x_b).gt.0.0d0 ) then
				x_b  = x_m
			else
				x_a = x_m
			end if

			write(20, *) x_a, x_b

			if(abs(x_b - x_a).lt.eps) then
				exit
			end if

		end do

		write(20, *) " "

	return
	end

	subroutine secante(x_start, x_end, eps)
	! Método da secante:
	! 	Não utiliza derivada diretamente, mas sim três pontos para as iterações
	! (derivada para trás de dois pontos)
		implicit none
		double precision x_start, x_end, eps
		double precision f

		double precision x_next   ! Terceiro ponto para o cálculo
		double precision x_a, x_b ! Variáveis locais, para não modificar as variáveis fora do escopo

		x_a = x_start
		x_b = x_end

		do while(1.eq.1)

			x_next = x_b - f(x_b) * (x_b - x_a) / (f(x_b) - f(x_a))

			x_a = x_b
			x_b = x_next

			write(30, *) x_a, x_b

			if(abs(x_b - x_a).lt.eps) then
				exit
			end if
		end do

		write(30, *) " "

	return
	end

	subroutine newton_raphson(x_start, eps)
	! Método de Newton-Raphson
	! 	Utiliza a derivada analítica para as iterações
		implicit none
		double precision x_start, eps
		double precision f, f_i

		double precision x_a, x_b

		x_a = x_start

		do while(1.eq.1)
			x_b = x_a - f(x_a) / f_i(x_a)
			write(40, *) x_a, x_b
			if(abs(x_b - x_a).lt.eps) then
				exit
			end if
			x_a = x_b
		end do

		write(40, *) " "
	return
	end

