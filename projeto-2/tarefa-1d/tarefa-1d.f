	implicit none
	
	integer iseed
	double precision n_total, a1, b1, a2, b2
	double precision f1, f2, integral, random
	double precision i, x1, x2, sum_f1, sum_f2
	double precision integral_f1, integral_f2
	
	iseed = 50
	
	call srand(iseed)

	n_total = 4.0d6
	
	a1 = 0.0d0
	b1 = 1.0d0
	
	a2 = 1.0d0
	b2 = 10.0d0
	
	i = 1.0d0
	sum_f1 = 0.0d0
	sum_f2 = 0.0d0
	
	do while(i.le.n_total)
		x1 = random(a1, b1)
		sum_f1 = sum_f1 + f1(x1)

		x2 = random(a2, b2)
		sum_f2 = sum_f2 + f2(x2)

		i = i + 1.0d0
	end do
	
	integral_f1 = integral(sum_f1, a1, b1, n_total)
	integral_f2 = integral(sum_f2, a2, b2, n_total)
	
	print *, "integral_f1=", integral_f1
	print *, "integral_f2=", integral_f2
	
	stop
	end

	! Função para gerar valores aleatórios de f(x) = 4 / (1 + x^2), 0 <= x <= 1
	double precision function f1(x)
		double precision x
		f1 = 4.0d0 / (1.0d0 + x**2)
	return
	end

	! Função para gerar valores aleatórios de f(x) = 1 / x, 1 <= x <= 10
	double precision function f2(x)
		double precision x
		f2 = 1.0d0 / x
	return
	end

	! Função para gerar valores aleatórios com probabilidade uniforme entre [a,b]
	double precision function random(a, b)
		double precision a, b
		random = (b - a) * rand() + a
	return
	end

	! Função para o cálculo da integral pelo Teorema do Valor Médio
	double precision function integral(sum_fx, a, b, n_total)
		double precision sum_fx, a, b, n_total
		integral = (b - a) / n_total * sum_fx
	return
	end

