	implicit none

	! Definição dos números n (o tamanho do arquivo de input) e m (o subconjunto de menores valores)
	integer n, m
	
	! Definição de variáveis auxiliares para loop dentro do arquivo
	integer i, j
	
	! Valores da linha do arquivo, do atual candidato e do último salvo até então 
	double precision vl_row, vl_min, vl_min_last
	
	! Valor máximo, para comparação. Uma constante, interpretada como infinito
	double precision inf
	
	inf = 1.0d300
	
	print *, "Insira o tamanho do arquivo original: "
	read (*,*) n
	print *, n

	print *, "Insira o tamanho do subconjunto de menores valores: "
	read (*,*) m
	
	if( (n.lt.0).or.(m.lt.0) ) then
		print *, 'ERROR: (m,n) devem ser não-negativos: ', m, n
		stop
	else if(n.lt.m) then
		print *, 'ERROR: m não pode ser maior que n', m, n
		stop
	end if

	! Abrir arquivo de saída e salvar o valor de m
	open(unit=99, file="tarefa-3-saida-1.dat")
	
	write(99, *) m
	
	! Para iniciar o loop, consideramos que o menor já valor encontrado é -inf
	vl_min_last = -inf
	
	do i=1,m
	
		! Start/reset do vl_min do loop
		vl_min = inf

		! Ler o arquivo de dados de input
		open(unit=1, file="tarefa-3-entrada-1.in")

		do j=1,n
		
			read(1, *) vl_row

			if(j.eq.1) then
				vl_min = vl_row
			else
				if( (vl_row.lt.vl_min).and.(vl_row.gt.vl_min_last) ) then
					vl_min = vl_row	
				end if
			
			end if
			
			! print *, 'j=', j, 'vl_min=', vl_min, 'vl_min_last=', vl_min_last
			
		end do
		
		! print *, 'i=', i, 'vl_min=', vl_min
		
		write(99, *) vl_min
		
		! Fecha o arquivo, para ler novamente do começo no próximo laço
		close(1)
		
		! Define o menor valor como sendo o último mínimo encontrado
		vl_min_last = vl_min
		
	end do
		
	close(99)
	
	end
	
