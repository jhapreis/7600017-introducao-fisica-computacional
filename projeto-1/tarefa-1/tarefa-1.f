	! Cálculo da Área e do Volume do Toróide
	! Definições
	! 	Ra: raio até o meio do toróide
	! 	Rb: raio da circunferência da espessura do toróide
	!	r1: raio interno do toróide
	!	r2: raio externo do toróide
	! Cálculo:
	! 	A = 4 * pi**2 * Ra * Rb
	! 	V = 4 * pi**2 * Ra * Rb**2
	! 	R = (r2 + r1) / 2
	!	r = (r2 - r1) / 2

	! Ler o valor de input
	double precision r1, r2
	double precision radius_a, radius_b, area, volume
	read (*,*) r1,r2
	
	print *, area(r1,r2), volume(r1,r2)
	end
	
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! Funções
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	! Função para o cálculo do raio R do toro
	double precision function radius_a(r1, r2)
	double precision r1, r2
	radius_a = 0.5d0 * (r1 + r2)
	return
	end
	
	! Função para o cálculo do raio r do toro 
	double precision function radius_b(r1, r2)
	double precision r1, r2
	radius_b = 0.5d0 * (r2 - r1)
	return
	end

	! Função para o cálculo da Área A
	double precision function area(r1, r2)
	double precision radius_a, radius_b ! outras funções
	double precision r1, r2, pi ! variáveis
	pi = acos(-1d0)
	area = 4d0 * pi**2 * radius_a(r1, r2) * radius_b(r1,r2)
	return
	end
	
	! Função para o cálculo do Volume V
	double precision function volume(r1, r2)
	double precision radius_a, radius_b ! outras funções
	double precision r1, r2, pi ! variáveis
	pi = acos(-1d0)
	volume = 4d0 * pi**2 * radius_a(r1, r2) * radius_b(r1,r2)**2
	return
	end
	
