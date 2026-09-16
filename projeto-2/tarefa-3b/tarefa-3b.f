	implicit none

	integer k_total ! Número de sequências ("passeios", ou "partículas a caminhar")
	integer t_max   ! Tempo máximo para a simulação
	integer iseed
	integer k, t

	double precision sum_r2, mean_r2
	double precision pos_x(500), pos_y(500) ! Lista com as posição em x,y de cada partícula. O valor é grande para poder variar k_total

	double precision step

	iseed   = 50
	k_total = 100
	t_max   = 200

	call srand(iseed)

	call null_vector(pos_x, k_total)
	call null_vector(pos_y, k_total)

	! Arquivo de saída para o gráfico de t vs <r2(t)>
	open(unit=10, file="arquivo-saida-r2-tempo.dat")

	! Para cada instante de tempo t, damos um passo aleatório com cada uma das partículas, nas duas dimensões

	do t=1,t_max

		sum_r2 = 0.0d0

		do k=1,k_total
			pos_x(k) = pos_x(k) + step()
			pos_y(k) = pos_y(k) + step()
			sum_r2   = sum_r2 + (pos_x(k)**2 + pos_y(k)**2)
		end do

		mean_r2 = sum_r2 / real(k_total, 8)

		write(10, *) t, mean_r2

	end do

	close(10)

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

	double precision function step()
		! Ajustar o valor do range do step para [-1, 1]
		step = 2.0d0 * rand() - 1.0d0
	return
	end

