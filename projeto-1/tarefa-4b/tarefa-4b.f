	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! Geração de valores para verificar o quanto nós conseguimos modificar error_max para obter melhor precisão
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	double precision x, cos_series, fx, cos_x, error, error_max
	
	read(*,*) x
	
	error_max = 1.0d-5 ! valor inicial igual à precisão do exercício anterior
	
	open(unit=99, file="tarefa-4b-saida.dat")
	
	do while(error_max.ge.1.0d-40) ! um valor de precisão final (arbitrário)
		fx = cos_series(x, error_max)
		
		cos_x = cos(x)
		
		error = abs(cos_x - fx)
		
		write(99,*) x, fx, cos_x, error_max, error, error_max, error ! salvar dados para exibir num gráfico log x log
	
		error_max = error_max * 1.0d-1 ! step do processamento
	end do
	
	close(99)
	
	stop
	end
	
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! Função para o cálculo do fatorial de um inteiro
	! Utiliza variáveis reais apenas para computar com maior precisão
	! 
	! Parâmetros:
	! 	n: número inteiro (como double precision). Exemplo: 2.0d0, 12.0d0
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	double precision function factorial(n)
		double precision n, i
		factorial = 2.0d0
		i = n
		do while (i.ge.3.0d0)
			factorial = factorial*i
			i = i - 1.0d0
		end do
	return
	end

	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! Função para o cálculo de cos(x) por séries
	! 
	! Parâmetros:
	! 	x: um valor real (de preferência entre -pi e pi)
	!	error_max: a precisão para cálculo da série
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	double precision function cos_series(x, error_max)
		double precision x
		! Parâmetro passado para a função
		
		double precision error_max
		! Precisão a ser considerada no cálculo da série
		
		double precision delta
		! Módulo do incremento da série
		
		double precision signal
		! Ajuste de sinal dos termos da série. Alterna entre -+-+-...
		
		double precision factorial
		! Função auxiliar para o cálculo dos termos da série
		
		double precision i
		! Variável adicional para contar os passos da soma da série

		i = 2.0d0
		signal = -1d0
		cos_series = 1.0d0 ! primeiro valor da série
		delta = 0.5d0 * x**2 ! segundo valor da série

		do while (delta.ge.error_max) ! Modifica os termos até o delta ser menor que a tolerância
			! print *, 'delta=', delta, 'factorial=', factorial(i)
			cos_series = cos_series + signal * delta
			i = i + 2.0d0
			signal = -1.0d0 * signal
			delta = 1.0d0 / factorial(i) * x**i
		end do
	return
	end

