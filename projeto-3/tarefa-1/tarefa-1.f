! Derivação numérica

	implicit none

	integer i
	double precision x ! Ponto para cálculo da derivada
	double precision h ! Tamanho dos passos a cada interação
	double precision f, f_i, f_ii
	double precision f_i_2f, f_i_2t, f_i_3s, f_i_5s, f_ii_3s, f_ii_5s

	open(unit=10, file="tarefa-1-saida-derivadas-f.dat")

	x = 0.1d0

	write(10, *) "Valores exatos:"
	write(10, *) x, f(x), f_i(x), f_ii(x)
	write(10, *) "Valores das derivadas numéricas:"

	do i=-1,-12,-1
		h = 5.0d0 ** i
		write(10,*)
     #            h,
     # 		f_i_2f(x, h),
     # 		f_i_2t(x, h),
     # 		f_i_3s(x, h),
     #			f_i_5s(x, h),
     #      		f_ii_3s(x, h),
     # 		f_ii_5s(x, h)
	end do

	close(10)

	stop
	end

	double precision function f(x)
		implicit none
		double precision x
		f = exp(x**2) / tan(2.0d0*x)	
	return
	end

	double precision function f_i(x)
		implicit none
		double precision x
		f_i = 2.0d0 * exp(x**2) * (
     #		 	x / tan(2.0d0*x)
     #		 	- 1.0d0 / sin(2.0d0*x)**2
     #	 	)
	return
	end

	double precision function f_ii(x)
		implicit none
		double precision x
		f_ii = exp(x**2) * (
     #			4.0d0*x**2 / tan(2.0d0*x)
     #	 	      - 8.0d0*x / (tan(2.0d0*x)**2)
     #	            - 8.0d0*x
     #            + 8.0d0 / tan(2.0d0*x)**3
     #		      + 10.0d0 / tan(2.0d0*x)
     #	 	)
	return
	end

	! Derivada i (1ª) de dois pontos, para frente
	double precision function f_i_2f(x, h)
		implicit none
		double precision f
		double precision x, h
		f_i_2f = 1.0d0 / h * (f(x+h) - f(x))
	return
	end

	! Derivada i (1ª) de dois pontos, para trás
	double precision function f_i_2t(x, h)
		implicit none
		double precision f
		double precision x, h
		f_i_2t = 1.0d0 / h * (f(x) - f(x-h))
	return
	end

	! Derivada i (1ª) de três pontos, simétrica
	double precision function f_i_3s(x, h)
		implicit none
		double precision f
		double precision x, h
		f_i_3s = 1.0d0 / (2.0d0 * h) * (f(x+h) - f(x-h))
	return
	end

	! Derivada i (1ª) de cinco pontos, simétrica
	double precision function f_i_5s(x, h)
		implicit none
		double precision f
		double precision x, h
		f_i_5s = 1.0d0 / (12.0d0 * h) * (
     #			f(x - 2.0d0*h)
     #            - 8.0d0 * f(x-h)
     #			+ 8.0d0 * f(x+h)
     # 		- f(x + 2.0d0*h)
     #		)
	return
	end

	! Derivada ii (2ª) de três pontos, simétrica
	double precision function f_ii_3s(x, h)
		implicit none
		double precision f
		double precision x, h
		f_ii_3s = 1.0d0/h**2 * (f(x+h) - 2.0d0*f(x) + f(x-h))	
	return
	end

	! Derivada ii (2ª) de cinco pontos, simétrica
	double precision function f_ii_5s(x, h)
		implicit none
		double precision f
		double precision x, h
		f_ii_5s = 1.0d0/(12.0d0 * h**2) * (
     # 		- f(x-2.0d0*h)
     # 		+ 16.0d0*f(x-h)
     # 		- 30.0d0*f(x)
     # 		+ 16.0d0*f(x+h)
     # 		- f(x+2.0d0*h)
     #		)
	return
	end

