	real x, cos_series, fx, cos_x, error
	
	read(*,*) x
	
	fx = cos_series(x)
	
	cos_x = cos(x)
	
	error = abs(cos_x - fx)
	
	print *, 'x=', x, 'fx=', fx, 'cosx=', cos_x, 'err=', error
	
	stop
	end
	
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! Função para o cálculo do fatorial de um inteiro
	! Utiliza variáveis reais apenas para computar com maior precisão
	! 
	! Parâmetros:
	! 	n: número inteiro (como real). Exemplo: 2.0e0, 12.0e0
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	real function factorial(n)
		real n, i
		factorial = 2.0e0
		i = n
		do while (i.ge.3.0e0)
			factorial = factorial*i
			i = i - 1.0e0
		end do
	return
	end

	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! Função para o cálculo de cos(x) por séries
	! 
	! Parâmetros:
	! 	x: um valor real (de preferência entre -pi e pi)
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	real function cos_series(x)
		real x
		! Parâmetro passado para a função
		
		real delta
		! Módulo do incremento da série
		
		real signal
		! Ajuste de sinal dos termos da série. Alterna entre -+-+-...
		
		real error_max
		! Precisão a ser considerada no cálculo da série
		
		real factorial
		! Função auxiliar para o cálculo dos termos da série
		
		real i
		! Variável adicional para contar os passos da soma da série

		i = 2.0e0
		signal = -1e0
		error_max = 1.0e-5
		cos_series = 1.0e0 ! primeiro valor da série
		delta = 0.5e0 * x**2 ! segundo valor da série

		do while (delta.ge.error_max) ! Modifica os termos até o delta ser menor que a tolerância
			! print *, 'delta=', delta, 'factorial=', factorial(i)
			cos_series = cos_series + signal * delta
			i = i + 2.0e0
			signal = -1.0e0 * signal
			delta = 1.0e0 / factorial(i) * x**i
		end do
	return
	end

