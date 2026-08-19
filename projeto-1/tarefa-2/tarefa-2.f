	implicit none

	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! Num paralelepípedo de base triangular, programa para o cálculo
	!	do volume
	!	da sua área lateral 
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	double precision u(3), v(3), w(3)
	
	double precision norm, dot_prod
	
	double precision uv(3), norm_uv, u_minus_v(3)
	
	double precision uw(3), vw(3), u_minus_v_w(3)
	
	double precision prod_misto
	
	double precision volume, area
	
	double precision zero
	zero = 1.0d-12 ! considerando ~ 0, para desconsiderar erros de ponto flutuante
	
	print *, 'Digite as coordenadas de v1:'
	read(*,*) u(1),u(2),u(3)

	print *, 'Digite as coordenadas de v2:'
	read(*,*) v(1),v(2),v(3)

	print *, 'Digite as coordenadas de v3:'
	read(*,*) w(1),w(2),w(3)
	
	call cross_prod(u, v, uv)
	
	! Verifica se v1 e v2 são paralelos: se o módulo do vetor normal é nulo
	norm_uv = norm(uv)
	if(norm_uv.lt.zero) then
		print *, 'ERROR: v1 e v2 sao paralelos'
		stop
	end if
	
	! Verifica se o vetor v3 não é coplanar com v1 e v2: se v3 é perpendicular ao vetor normal ao plano de v1 e v2 (ou seja, está no mesmo plano)
	prod_misto = dot_prod(w, uv)
	if( abs(prod_misto).lt.zero ) then
		print *, 'ERROR: v3 e coplanar com v1 e v2'
		stop
	end if
	
	! Cálculo do volume: V = 1/2 * w · /u x v/ = 1/2 * prod_misto
	volume = 0.5d0 * abs(prod_misto)
	
	! Cálculo da área lateral: A = /u x w/ + /v x w/ + /(u - v) x w/
	call cross_prod(u, w, uw)
	call cross_prod(v, w, vw)
	call vector_diff(u, v, u_minus_v)
	call cross_prod(u_minus_v, w, u_minus_v_w)
	
	area = norm(uw) + norm(vw) + norm(u_minus_v_w)
	
	! Fim do programa
	print *, 'Volume =', volume
	print *, 'Area   =', area
	stop
	end


	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! Sub-rotinas e Funções
	! Nos casos onde precisamos retornar um array, usamos uma subrotina para modificar um valor em memória
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	! Função para o cálculo do módulo (ou norma) de um vetor de dimensão 3
	double precision function norm(u)
		double precision u(3)
		integer i
		norm = 0.0d0
		do i=1,3
			norm = norm + u(i)**2
		end do
		norm = sqrt(norm)
	return
	end
	
	! Função para o cálculo do produto interno de dois vetores de dimensão 3
	double precision function dot_prod(u, v)
		double precision u(3), v(3)
		integer i
		dot_prod = 0.0d0
		do i=1,3
			dot_prod = dot_prod + u(i)*v(i)
		end do
	return
	end
	
	! Função para o cálculo do produto vetorial de dois vetores (de dimensão 3)
	subroutine cross_prod(u, v, obj)
		double precision u(3), v(3), obj(3)
		obj(1) = u(2)*v(3) - v(2)*u(3)
		obj(2) = u(3)*v(1) - v(3)*u(1)
		obj(3) = u(1)*v(2) - v(1)*u(2)	
	return
	end

	! Função para o cálculo do vetor u-v em 3 dimensões
	subroutine vector_diff(u, v, obj)
		double precision u(3), v(3), obj(3)
		integer i
		do i=1,3
			obj(i) = u(i) - v(i)
		end do
	return
	end

