	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! Funções
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	! Função para o cálculo do módulo de um vetor de dimensão 3
	double precision function absolute_value(u)
	double precision u(3)
	absolute_value = sqrt( u(1)**2 + u(2)**2 + u(3)**2 )
	return
	end
	
	! Função para o cálculo do produto interno de dois vetores de dimensão 3
	double precision function dot_product(u, v)
	double precision u(3), v(3)
	dot_product = u(1)*v(1) + u(2)*v(2) + u(3)*v(3)
	return
	end
	
	! Função para o cálculo do produto vetorial de dois vetores de dimensão 3
	double precision function cross_product(u, v)
	double precision u(3), v(3), cross_product(3)
	cross_product(1) = u(2)*v(3) - v(2)*u(3)
	cross_product(2) = u(3)*v(1) - v(3)*u(1)
	cross_product(3) = u(1)*v(2) - v(1)*u(2)	
	return
	end

	! Área Lateral
	! A = 2 * Abase + Awu + Awv + Awu-v
	!   = /u x v/ + /u x w/ + /v x w/ + /(u - v) x w/
	double precision function area(u, v, w)
	double precision u(3), v(3), w(3)
	! double precision absolute_value, cross_product(3)
	double precision u_x_v, u_x_w, v_x_w, u_minus_v, u_minus_v_x_w

	u_minus_v(1) = u(1) - v(1)
	u_minus_v(2) = u(2) - v(2)
	u_minus_v(3) = u(3) - v(3)
	
	u_minus_v_x_w = absolute_value(cross_product(u_minus_v, w))
	
	u_x_v = absolute_value(cross_product(u,v))
	u_x_w = absolute_value(cross_product(u,w))
	v_x_w = absolute_value(cross_product(v,w))
	
	area = u_x_v + u_x_w + v_x_w + u_minus_v_x_w
	return
	end
	
	! Volume
	! V = 1/2 * w · /u x v/

	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! Programa principal
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	! Ler o valor de input
	! double precision absolute_value, dot_product, cross_product(3)
	! read (*,*) r1,r2
	
	double precision absolute_value
	double precision u(3)

	u(1) = 1
	u(2) = 1
	u(3) = 1
	
	print *, absolute_value(u)
	end
	
