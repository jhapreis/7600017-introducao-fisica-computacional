! Programa para calcular o desvio padrão das médias em cada arquivo do problema 1a
! Nesse contexto, agora r representa a média da sequência (não mais o valor em cada elemento da sequência)

	implicit none

	character(100) filename

	integer k_seq, n, k, i
	double precision r, std_r ! Variáveis para leitura do arquivo
	double precision sum_r, sum_r2, mean_r, mean_r2, std 

	open(unit=10, file="arquivo-saida-mean-std.dat")

	do i=1,9

		filename = "../tarefa-1a/arquivo-saida-"//char(i+48)//".dat"

		open(unit=20, file=filename)

		sum_r = 0.0d0
		sum_r2 = 0.0d0

		do k=1,100
			read(20, *) k_seq, n, r, std_r
			sum_r = sum_r + r
			sum_r2 = sum_r2 + r**2
		end do

		close(20)
		
		mean_r = sum_r / real(k_seq, 8)
		mean_r2 = sum_r2 / real(k_seq, 8)
		std = sqrt(mean_r2 - mean_r**2)

		write(10, *) n, std

	end do

	close(10)

	stop
	end

