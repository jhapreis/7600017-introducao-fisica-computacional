	implicit none

	! Gerador de sequência de números aleatórios

	character(100) filename

	integer iseed, m, n_size, k_seq
	
	double precision r, r2, sum_r, sum_r2
	double precision mean_r, mean_r2, std

	iseed = 50

	call srand(iseed)

	do m=1,9 ! com m=1, 2, 3, ..., 9
		
		filename = "arquivo-saida-"//char(m+48)//".dat" ! Transforma o número em caracter pela tabela ASCII ("0" = 48)
		
		print *, filename

		open(unit=10, file=filename)

		do k_seq=1,100 ! gere 100 sequências

			sum_r = 0.0d0
			sum_r2 = 0.0d0
			
			do n_size=1,3**m - 1 ! de tamanho 3**m
				r = rand()
				r2 = r**2
				sum_r = sum_r + r
				sum_r2 = sum_r2 + r2
			end do	
			
			mean_r = sum_r / real(n_size, 8)
			mean_r2 = sum_r2 / real(n_size, 8)
			std = sqrt(mean_r2 - mean_r**2)
			
			write(10, *) k_seq, n_size, mean_r, std
			
		end do

		close(10)

	end do

	stop
	end

