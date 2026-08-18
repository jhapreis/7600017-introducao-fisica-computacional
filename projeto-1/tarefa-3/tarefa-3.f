	! Definição dos números n (o tamanho do arquivo de input) e m (o subconjunto de menores valores)
	integer n, m
	
	! Definição de variáveis auxiliares para loop dentro do arquivo
	integer i, j
	
	! Definição das unidades dos arquivos
	integer unit_file_in, unit_file_out
	
	! Valores da linha do arquivo, do atual candidato e do último salvo até então 
	double precision row, val_min, last_min, inf
	
	inf = 1.0d12
	
	val_min = inf
	last_min = inf
	
	print *, "Insira o tamanho do arquivo original: "
	read (*,*) n
	
	print *, "Insira o tamanho do subconjunto de menores valores: "
	read (*,*) m
	
	! Abrir arquivo de saída e salvar o valor de m
	open(unit=99, file="out.dat")
	
	write(99, *) m
	
	do i=0,m
	
		! Ler o arquivo de dados de input
		open(unit=1, file="dados.dat")

		do j=0,n
		
			read(1, *) row

			if(j.eq.0) then
				val_min = row
			else
				if(row.lt.val_min).and.(row.lt.last_min) then
					val_min = row	
				end if
			
			end if
			
		end do
		
		last_min = val_min
		
		print *, i, row, val_min, last_min
		
		close(1)
		
	end do
		
	close(99)
	
	end
	
