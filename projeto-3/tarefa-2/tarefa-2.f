! integral_0^2pi e^(-x)*cos(x) dx
	implicit none

	! Intervalo de integração: [0, 2pi] -> tamanho = 2pi
	!	Então o número de intervalos é n = (b - a) / h = 2pi/h = 2pi * h^-1

	double precision integral_trapezio
	double precision integral_simpson
	double precision integral_boole

	double precision pi, h, a, b
	integer i, n
	
	open(unit=20, file="tarefa-2-integral-trapezio.dat")
	open(unit=30, file="tarefa-2-integral-simpson.dat")
	open(unit=40, file="tarefa-2-integral-boole.dat")
	
	pi = acos(-1.0d0)

	a = 0.0d0
	b = 2.0d0 * pi

	do i=2,13
		n = 2**i
		h = (b - a) / real(n, 8)
		write(20, *) n, h, integral_trapezio(a, b, h, n)
		write(30, *) n, h, integral_simpson(a, b, h, n)
		write(40, *) n, h, integral_boole(a, b, h, n)
	end do

	close(20)
	close(30)
	close(40)

	stop
	end

	double precision function f(x)
		implicit none
		double precision x
		f = exp(-x)*cos(x)
	return
	end

	double precision function integral_trapezio(a, b, h, n)
		implicit none
		double precision a, b, h
		integer n

		double precision f
		
		integer i
		double precision x_i, soma
		
		! Ajusta os passos do inicio e fim
		soma = 0.5d0 * ( f(a) + f(b) )
		do i=1,n-1
			x_i = a + real(i, 8) * h
			soma = soma + f(x_i)
		end do

		integral_trapezio = h * soma
	return
	end

	double precision function integral_simpson(a, b, h, n)
		implicit none
		double precision a, b, h
		integer n
		
		double precision f
		
		integer i
		double precision x_i, soma
		
		soma = f(a) + f(b)
		
		do i=1,n-1
			x_i = a + real(i, 8) * h
			if(mod(i, 2).ne.0) then
				soma = soma + 4.0d0*f(x_i)
			else
				soma = soma + 2.0d0*f(x_i)
			end if
		end do

		integral_simpson = h/3.0d0 * soma
	return
	end


	double precision function integral_boole(a, b, h, n)
	! Como n é sempre múltiplo de 4
	!	(no nosso caso, pois fazemos com n = 4, 8, ...)
	! 	podemos iterar por blocos de 4 subintervalos
	!	(ou seja, com 5 elementos)
		implicit none
		double precision a, b, h
		integer n
		
		double precision f
		
		integer i
		double precision soma, x0, x1, x2, x3, x4
		
		soma = 0.0d0
		
		do i=0, n-4, 4
		
			soma = soma
     #				+ 7.0d0  * f( a + real(i  , 8) * h )
     #				+ 32.0d0 * f( a + real(i+1, 8) * h )
     #				+ 12.0d0 * f( a + real(i+2, 8) * h )
     #				+ 32.0d0 * f( a + real(i+3, 8) * h )
     #				+ 7.0d0  * f( a + real(i+4, 8) * h )
		end do

		integral_boole = 2.0d0*h/45.0d0 * soma
	return
	end

