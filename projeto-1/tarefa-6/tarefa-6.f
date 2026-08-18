	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! TAREFA 6: Cálculo do volume de uma esfera de dimensão d e raio r
	! 	Salva os dados num arquivo de destino, para montar um gráfico depois 
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	double precision r, volume, volume_i
	integer d, i
	
	read(*,*) r, d
	
	open(unit=99, file='tarefa-6-saida.dat')
	
	do i=0,d,1
		volume_i = volume(r, i)
		write(99, *) r, i, volume_i
	end do
	
	close(99)
	
	stop
	end
	
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! Definição da função gamma, calculada com o número de dimensões
	! 
	! Parâmetros:
	! 
	!	d: número de dimensões
	!    	
	!	x: variável fracionária para a função gamma = 1 + d/2
	!     x_start: início do produtório (pode ser 1/2 ou 2 -- ou 1, mas usaremos 2)
	!     x_end: final do produtório (x-1)
	! 
	! Descrição:
	! 
	! 	Se d é par, então x é um inteiro, cujo gamma vira 1*2*3*...*x-1
	!	Se d é ímpar, então x é um fracionário de 1/2, cujo gamma vira gamma(1/2)*1/2*3/2*...*x-1
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	double precision function gamma_d(d)
	integer d
	double precision x, x_start, x_end
	
	x = 1.0d0 + real(d, 8)/2.0d0
	
	if(mod(d,2).eq.0) then
		gamma_d = 2.0d0
		x_start = 3.0d0
	else
		gamma_d = sqrt(acos(-1.0d0)) ! gamma(1/2) = sqrt(pi)
		x_start = 0.5d0
	end if
	
	do x_end=x-1.0d0, x_start, -1.0d0
		! print *, 'd=', d, 'x=', x, 'x_end=', x_end, 'gamma_d=', gamma_d
		gamma_d = gamma_d * x_end
	end do
	
	return
	end
	
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! Definição do volume da dimensão de uma esfera em d dimensões
	! 
	! Parâmetros:
	! 	r: raio da esfera
	!	d: número de dimensões
	!
	! Descrição:
	! V = pi**(d/2) * r**d / gamma(1 + d/2)
	!   = pi**(d/2) * r**d / gamma_d(d)
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	double precision function volume(r, d)
	integer d
	double precision r, pi, gamma_d
	pi = acos(-1.0d0)
	volume = pi**(d/2.0d0) * r**d / gamma_d(d)
	return
	end
	
