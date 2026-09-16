	implicit none

	integer k_total ! Número de sequências ("passeios", ou "partículas a caminhar")
	integer t_max   ! Tempo máximo para a simulação
	integer iseed
	integer k, t

	double precision sum_x, sum_x2, mean_x, mean_x2
	double precision pos_x(500) ! Lista com a posição em x de cada partícula. O valor é grande para poder variar k_total

	double precision step

	iseed   = 50
	k_total = 100
	t_max   = 200

	call srand(iseed)

	call null_vector(pos_x, k_total)

	! Arquivo de saída para o gráfico de t, <x(t)> e <x2(t)>
	open(unit=10, file="arquivo-saida-media-posicao-tempo.dat")

	! Arquivos de saída para os histogramas
	open(unit=50, file="arquivo-saida-posicoes-t50.dat")
	open(unit=100, file="arquivo-saida-posicoes-t100.dat")
	open(unit=200, file="arquivo-saida-posicoes-t200.dat")

	! Para cada instante de tempo t, damos um passo aleatório com cada uma das partículas
	! Além disso, nos instantes t = 50, 100 e 200 nós salvamos a posição de cada uma (para análise)

	do t=1,t_max

		sum_x  = 0.0d0
		sum_x2 = 0.0d0
		
		do k=1,k_total
			pos_x(k) = pos_x(k) + step()
			sum_x    = sum_x + pos_x(k)
			sum_x2   = sum_x2 + pos_x(k)**2
		end do

		mean_x  = sum_x / real(k_total, 8)
		mean_x2 = sum_x2 / real(k_total, 8)

		write(10, *) t, mean_x, mean_x2

		if(t.eq.50) then
			call save_vector(50, pos_x, k_total)
		end if

		if(t.eq.100) then
			call save_vector(100, pos_x, k_total)
		end if

		if(t.eq.200) then
			call save_vector(200, pos_x, k_total)
		end if

	end do

	close(10)
	close(50)
	close(100)
	close(200)

	stop
	end

	subroutine null_vector(v, n)
		integer n, i
		double precision v(n)
		do i=1,n
			v(i) = 0.0d0
		end do
	return
	end

	subroutine save_vector(file_unit, pos, k_total)
		integer file_unit
		integer k_total, k
		double precision pos(k_total)
		do k=1,k_total
			write(file_unit, *) pos(k)
		end do
	return
	end

	double precision function step()
		! Ajustar o valor do range do step para [-1, 1]
		step = 2.0d0 * rand() - 1.0d0
	return
	end


