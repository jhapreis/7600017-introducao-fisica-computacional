	implicit none
	
	! Calcular:
	! 	A velocidade como função do tempo -- como temos a energia cinética, iremos depois trocar pela velocidade
	! 	A distância percorrida -- com a velocidade, necessário integrar no tempo
	! Valores para simulação:
	! 	dt = 0.1 e 0.01
	! 	A  = 0.2, 0.3 (item a) e 0.4

	character*20 fprefix     ! Prefixo do arquivo de dados de cada execução

	double precision m       ! Massa do ciclista
	double precision p       ! Potência do ciclista
	double precision rho     ! Densidade do fluido (associado com a resistência do ar)
	double precision a       ! "Área" útil do ciclista

	double precision delta_t ! Tempo total do experimento
	double precision dt      ! Intervalo de tempo entre cada ponto

	integer n
	! 	Número de pontos com informações de dados. No caso, como o número de intervalos é N = (b-a)/h,
	! então o número de pontos n = delta_t/dt + 1

	parameter(fprefix="tarefa-1")

	parameter(m   = 70.0d0)  ! kg
	parameter(p   = 400.0d0) ! W
	parameter(rho = 1.3d0)   ! kg/m^3
	parameter(a   = 0.3d0)   ! m^2

	parameter(delta_t = 5.0d0 * 60.0d0) ! minutos -> segundos

	call simulacao(fprefix, delta_t, p, m, rho, 0.40d0, 0.10d0)
	call simulacao(fprefix, delta_t, p, m, rho, 0.30d0, 0.10d0)
	call simulacao(fprefix, delta_t, p, m, rho, 0.20d0, 0.10d0)

	call simulacao(fprefix, delta_t, p, m, rho, 0.40d0, 0.01d0)
	call simulacao(fprefix, delta_t, p, m, rho, 0.30d0, 0.01d0)
	call simulacao(fprefix, delta_t, p, m, rho, 0.20d0, 0.01d0)

	stop
	end



!------------------------------------------------------------------------------
! SUBROTINA PRINCIPAL PARA A EXECUÇÃO DO PROGRAMA
! 	Obs.: como n é diferente para cada execução da simulação (pois dt pode variar),
! então a subrotina da execução foi abstraída dessa. Isso porque é necessário já ter n
! definido para poder definir os vetores e aplicar a integração.
! 	A outra alternativa seria reler o arquivo, que acabou de ser escrito para computar a integral
!------------------------------------------------------------------------------
	subroutine simulacao(fprefix, delta_t, p, m, rho, a, dt)
		implicit none

		character*20 fprefix
		double precision delta_t, dt
		double precision p, m, rho, a

		character*40 format_filename

		character*40 fname
		integer n

		fname = format_filename(fprefix, a, dt)
		n     = nint(delta_t/dt, 8) + 1

		call resistencia_do_ar(fname, n, p, m, rho, a, dt)
		call velocidade_terminal(fname, p, rho, a)
	return
	end


!------------------------------------------------------------------------------
! Subrotina para execução da simulação a cada intervalo de tempo
! 	e para o cálculo do deslocamento total (integral de v(t) dt)
! Obs.: como o deslocamento depende primeiro do cálculo de v(t) em todos os pontos,
! 	faz mais sentido manter os dois blocos juntos.
!------------------------------------------------------------------------------
	subroutine resistencia_do_ar(fname, n, p, m, rho, a, dt)
		implicit none
		character*40 fname
		integer n
		double precision dt
		double precision p, m, rho, a

		double precision k_energy
		double precision velocity, velocity_t_no_air
		double precision integral_simpson

		double precision v(n), v_no_air(n), v_air(n)
		double precision t, k_no_air, k_air
		double precision r_no_air, r_air
		integer i

		! Valores iniciais a partir do repouso (com e sem resistência do ar)
		t         = 0.0d0
		k_air     = 0.0d0
		k_no_air  = 0.0d0

		open(unit=20, file=trim(fname)//"-simulacao-v-tempo.dat")
		do i=1,n
			v(i)        = velocity_t_no_air(p, t, m)
			v_no_air(i) = velocity(k_no_air, m)
			v_air(i)    = velocity(k_air   , m)

			write(20, *)
     # 			t,
     #				v(i),
     #				k_no_air,
     #				k_air,
     # 			v_no_air(i),
     # 			v_air(i)

			k_no_air = k_energy(k_no_air, dt, p, m, 0.0d0, 0.0d0)
			k_air    = k_energy(k_air   , dt, p, m, rho  , a    )
			t        = t + dt
		end do
		close(20)

		open(unit=20, file=trim(fname)//"-deslocamento.dat")
			r_no_air = integral_simpson(v_no_air, n, dt)
			r_air    = integral_simpson(v_air   , n, dt)
			write(20, *) r_no_air, r_air
		close(20)
	return
	end

!------------------------------------------------------------------------------
! Subrotina para salvar os dados da velocidade terminal teórica
! 	v = (2P/rho*A)**(1/3)
!------------------------------------------------------------------------------
	subroutine velocidade_terminal(fname, p, rho, a)
		implicit none
		character*40 fname
		double precision p, rho, a

		double precision v

		v = (2.0d0*p/(rho*a))**(1.0d0/3.0d0)

		open(unit=20, file=trim(fname)//"-velocidade-terminal.dat")
			write(20, *) v
		close(20)
	return
	end



!------------------------------------------------------------------------------
! Energia cinética: termo de iteração
!------------------------------------------------------------------------------
	double precision function k_energy(k, dt, p, m, rho, a)
		implicit none
		double precision k, dt, p, m, rho, a
		k_energy = k
     #      		+ dt * (
     # 			p -
     # 			sqrt(2.0d0/m**3)*rho*a*k**(3.0d0/2.0d0)
     # 		)
	return
	end

!------------------------------------------------------------------------------
! Velocidade em função da energia cinética k
!------------------------------------------------------------------------------
	double precision function velocity(k, m)
		implicit none
		double precision k, m
		velocity = sqrt(2.0d0*k/m)
	return
	end

!------------------------------------------------------------------------------
! Velocidade (teórica) em função do tempo, desconsiderando a resistência do ar
!------------------------------------------------------------------------------
	double precision function velocity_t_no_air(p, t, m)
		implicit none
		double precision p, t, m
		velocity_t_no_air = sqrt(2.0d0*p*t/m)
	return
	end

!------------------------------------------------------------------------------
! Integral de Simpson:
! 	I = h/3 * ( f(a) + 4f(a+h) + 2f(a+2h) + ... + f(b) )
! Considerando que temos pontos espaçados de intervalo h, o cálculo fica apenas como
! 	I = h/3 * ( y[1] + 4*y[2] + 2*y[3] + ... + y[n] )
!------------------------------------------------------------------------------
	double precision function integral_simpson(y, n, h)
		implicit none
		integer n
		double precision y(n), h

		integer i
		double precision soma

		soma = y(1) + y(n)

		do i=2,n-1
			if(mod(i, 2).eq.0) then
				soma = soma + 4.0d0*y(i)
			else
				soma = soma + 2.0d0*y(i)
			end if
		end do

		integral_simpson = h/3.0d0 * soma
	return
	end

!------------------------------------------------------------------------------
! Função para formatar o nome do arquivo de destino dos dados
! 	O objetivo principal é imitar o comportamento do Python com suas f-strings
! 		filename = f"{fprefix}_A{a}_dt{dt}"
!	Obs.: trim é usado para remover os espaços em branco que são automaticamente
! 		adicionados nas strings do FORTRAN
!------------------------------------------------------------------------------
	character*40 function format_filename(fprefix, a, dt)
		character*20 fprefix
		double precision a, dt
		
		character*20 str_a, str_dt
		
		write(str_a , "(F4.2)") a
		write(str_dt, "(F4.2)") dt
		
		format_filename = trim(fprefix) //
     # 		"_A" // trim(str_a) //
     #			"_dt" // trim(str_dt)
	return
	end

