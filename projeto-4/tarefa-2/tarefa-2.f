	! Efeito resistivo do ar em movimentos 2D
	
	implicit none
	double precision pi

	double precision v0     ! Velocidade inicial de lançamento
	double precision dt     ! Intervalo de tempo entre as iterações
	double precision theta  ! Ângulo de arremesso (em radianos)
	double precision thetamax
	
	parameter(pi = acos(-1.0d0))
	
	v0 = 377.0d0 ! m/s
	dt = 1.0d-3  ! s
	
	! ITEM A: Simulações de ângulo definido (com e se o arrasto)
	call itema_simulacao_tempo(pi/6.0d0, dt, v0, 1)
	call itema_simulacao_tempo(pi/4.0d0, dt, v0, 1)
	call itema_simulacao_tempo(pi/3.0d0, dt, v0, 1)

	call itema_simulacao_tempo(pi/6.0d0, dt, v0, 0)
	call itema_simulacao_tempo(pi/4.0d0, dt, v0, 0)
	call itema_simulacao_tempo(pi/3.0d0, dt, v0, 0)
	
	! ITEM B: Simulação do alcance em função do theta (atualizando thetamax)
	call itemb_alcance_maximo(thetamax, dt, v0)

	! ITEM C: Simulação do alcance em função do theta (atualizando thetamax)
	call itemc_alcance_com_arrasto_variavel(thetamax, dt, v0)

	stop
	end


!==============================================================================
! SUBROTINAS PARA OS ITEMS A, B e C
!==============================================================================

!------------------------------------------------------------------------------
! SUBROTINA PARA O ITEM A:
! 	Execução da simulação com valores específicos de theta, ao longo do tempo
!------------------------------------------------------------------------------
	subroutine itema_simulacao_tempo(theta, dt, v0, fl_arrasto)
		implicit none
		double precision theta, dt, v0
		integer fl_arrasto

		character*8 str_theta, str_dt
		double precision alcance

		character*60 fname
		double precision Dx ! Obs.: Variável é utilizada apenas para invocar a função

		if(fl_arrasto.eq.0) then
			fname = 
     # 			"tarefa-2a-simulacao-sem-arrasto" //
     # 			trim(str_theta(theta)) //
     # 			trim(str_dt(dt)) //
     # 			".dat"
		else
			fname = 
     # 			"tarefa-2a-simulacao-com-arrasto" //
     # 			trim(str_theta(theta)) //
     # 			trim(str_dt(dt)) //
     # 			".dat"
		end if

		open(unit=20, file=trim(fname))
			Dx = alcance(theta, dt, v0, fl_arrasto, 20)
		close(20)

	return
	end


!------------------------------------------------------------------------------
! SUBROTINA PARA O ITEM B:
! 	Execução da simulação variando theta, para determinar o alcance máximo
! Obs.: sempre considerando o arrasto
!------------------------------------------------------------------------------
	subroutine itemb_alcance_maximo(thetamax, dt, v0)
		implicit none
		double precision thetamax, dt, v0

		character*8 str_dt
		double precision alcance

		character*60 fname
		integer i
		double precision pi
		double precision theta, thetaf, dtheta
		double precision dx, dxmax

		parameter(pi=acos(-1.0d0))

		theta  = 0.0d0
		thetaf = pi/2.0d0
		dtheta = 1.0d-1 * pi/180.0d0

		! Valor inicial para procurar o máximo
		dxmax    = 0.0d0
		thetamax = 0.0d0

		fname = 
     # 		"tarefa-2b-alcance-theta" //
     # 		trim(str_dt(dt)) //
     # 		".dat"

		open(unit=20, file=fname)

		do while(theta.le.thetaf)
			! Calcula o Dx considerando o arrasto, mas sem salvar dados
			dx = alcance(theta, dt, v0, 1, 0) 

			if(dx.gt.dxmax) then
				dxmax    = dx
				thetamax = theta
			end if

			write(20, *) theta, theta*180.0d0/pi, dx

			theta = theta + dtheta
		end do

		close(20)

		fname = 
     # 		"tarefa-2b-alcance-theta-maximo" //
     # 		trim(str_dt(dt)) //
     # 		".dat"
		
		open(unit=30, file=fname)
		write(30, *) thetamax, thetamax*180.0d0/pi, dxmax
		close(30)
	return
	end


!------------------------------------------------------------------------------
! SUBROTINA PARA O ITEM C:
! 	Execução da simulação variando levemente a velocidade inicial e usando theta = thetamax.
! Obs.:
! 	- va = v0 + 1% e vb = v0 - 1%
! 	- salvamos os dados em arquivos para graficar v(t)
!------------------------------------------------------------------------------
	subroutine itemc_alcance_com_arrasto_variavel(theta, dt, v0)
		implicit none
		double precision theta, dt, v0
		
		character*8 str_theta, str_dt
		character*60 fname
		double precision alcance

		double precision va, vb, dx

		va = 1.01d0 * v0 ! v0 + 1%
		vb = 0.99d0 * v0 ! v0 - 1%

		open(
     # 		unit=20,
     # 		file=
     # 			"tarefa-2c-arrasto-variavel-plus-a" //
     # 			trim(str_theta(theta)) //
     # 			trim(str_dt(dt)) //
     # 			".dat"
     # 	)
		dx = alcance(theta, dt, va, 2, 20)
		close(20)

		open(
     # 		unit=20,
     # 		file=
     # 			"tarefa-2c-arrasto-variavel-minus-b" //
     # 			trim(str_theta(theta)) //
     # 			trim(str_dt(dt)) //
     # 			".dat"
     # 	)
		dx = alcance(theta, dt, vb, 2, 20)
		close(20)
	return
	end



!==============================================================================
! FUNÇ	ÕES E SUBROTINAS AUXILIARES
!==============================================================================

!------------------------------------------------------------------------------
! Função para cálculo do alcance (Dx) em função de theta
! 	- Retorna o alcance da simulação
! 	- Possui uma flag para salvar os dados em um arquivo (opcional)
!------------------------------------------------------------------------------
	double precision function alcance(theta, dt, v0, fl_arrasto,iunit)
		implicit none
		double precision theta, dt, v0
		integer fl_arrasto, iunit

		double precision velocity_x, velocity_y
		double precision position_x, position_y

		double precision t, x, y, vx, vy, v
		double precision xi, xf ! guardamos a posição do início do lançamento para calcular Dx
		double precision xa, ya ! variáveis para interpolação da posição y=0

		! Obs.: D = diâmetro do calibre e A = pi*D**2/4 é a área do calibre
		double precision pi, m, D, A, g
		double precision rho, cd

		parameter( pi = acos(-1.0d0)  )
		parameter( m  = 42.0d0        ) ! kg
		parameter( D  = 149.1d-3      ) ! m
		parameter( A  = pi*d**2/4.0d0 ) ! m^2
		parameter( g  = 9.8d0         ) ! m/s^2

		x  = 0.0d0
		y  = 0.0d0
		t  = 0.0d0
		vx = v0*cos(theta)
		vy = v0*sin(theta)

		xi = x

		! Executa as iterações até que y=0 novamente (ou seja, com t>0)
		do while(y.ge.0.0d0)
			v = sqrt(vx**2 + vy**2)

			if(iunit.gt.0) write(iunit, *) t, x, y, vx, vy, v

			! Obtém os valores das constantes de arrasto
			call constantes_arrasto(cd,rho, y, v, fl_arrasto)

			xa = x
			ya = y

			vx = velocity_x(vx, vy, dt, rho, A, cd, m)
			vy = velocity_y(vx, vy, dt, rho, A, cd, m, g)

			x  = position_x(x, vx, dt)
			y  = position_y(y, vy, dt)
			t  = t + dt
		end do
		
		! Alcance: Dx = xf - xi = xf (pois xi = 0)
		! Porém, como estamos iterando com passos discretos, faremos uma interpolação
		! 	com o penúltimo e último valores de x para achar um valor que represente melhor o y=0
		! Isso porque o último ponto pode já ter passado do solo, enquanto o anterior está acima dele
		! Daí:
		! 	xf = xa - ya * (xb-xa)/(yb-ya),
		! onde (xa,ya) é o penúltimo ponto e (xb,yb) é o último ponto da simulação
		xf = xa - ya * (x-xa)/(y-ya)
		alcance = xf - xi
	return
	end


!------------------------------------------------------------------------------
! Subrotina para atualização dos valores de cd(v) e rho(y)
! 	uso de valores variáveis a depender do tipo de arrasto considerado
! Obs.:
! 	- fl_arrasto: flag para os valores dos tipos de arrasto
! 		- 0: sem arrasto
! 		- 1: arrasto constante
! 		- 2: arrasto variável
!------------------------------------------------------------------------------
	subroutine constantes_arrasto(cd, rho, y, v, fl_arrasto)
		implicit none
		double precision cd, rho
		double precision y, v
		integer fl_arrasto

		double precision vsom, cd0, cdsom
		double precision rho0, beta, T0, alpha
		
		parameter(vsom  = 344.0d0) ! m/s
		parameter(cd0   = 0.295d0)
		parameter(cdsom = 0.500d0)
		
		parameter(rho0 = 1.3d0 )  ! kg/m^3
		parameter(beta = 6.49d-3) ! K/m
		parameter(T0 = 300.0d0)   ! K
		parameter(alpha = 4.256d0)
		
		if(fl_arrasto.eq.0) then
			rho = 0.0d0
			cd  = 0.0d0
		else if(fl_arrasto.eq.1) then
			rho = rho0
			cd  = cd0
		else
			rho = rho0 * (1.0d0 - beta/T0 * y)**alpha
			if(v.lt.vsom) then
				cd = cd0
			else
				cd = cdsom
			end if
		end if
	return
	end

!------------------------------------------------------------------------------
! Funções para os cálculos das velocidades vx(t) e vy(t)
! Uma função depende da outra, por causa da decomposição das velocidades 
!------------------------------------------------------------------------------
	double precision function velocity_x(
     # 	vx,
     # 	vy,
     # 	dt,
     # 	rho,
     # 	A,
     # 	cd,
     # 	m
     # )
		implicit none
		double precision vx, vy, dt, rho, A, cd, m
		velocity_x = vx -
     # 		rho*A*cd/(2.0d0*m)*sqrt(vx**2 + vy**2)*vx*dt
	return
	end

	double precision function velocity_y(
     # 	vx,
     # 	vy,
     # 	dt,
     # 	rho,
     # 	A,
     # 	cd,
     # 	m,
     # 	g
     # )
		implicit none
		double precision vx, vy, dt, rho, A, cd, m, g
		velocity_y = vy -
     # 		(g + rho*A*cd/(2.0d0*m)*sqrt(vx**2 + vy**2)*vy) * dt
	return
	end

!------------------------------------------------------------------------------
! Funções para os cálculos das posições x(t) e y(t)
!------------------------------------------------------------------------------

	double precision function position_x(x, vx, dt)
		implicit none
		double precision x, vx, dt
		position_x = x + vx*dt
	return
	end

	double precision function position_y(y, vy, dt)
		implicit none
		double precision y, vy, dt
		position_y = y + vy*dt
	return
	end

!------------------------------------------------------------------------------
! Funções para formatar as variáveis como string
!------------------------------------------------------------------------------

	character*8 function str_dt(dt)
		implicit none
		double precision dt
		
		character*10 s
		write(s, "(I4)") nint( 1.0d3*dt, 8 )
		
		str_dt = "_dt" // trim(adjustl(s)) // "ms"
	return
	end

	character*8 function str_theta(theta)
		implicit none
		double precision theta
		
		double precision pi
		character*10 s
		parameter(pi=acos(-1.0d0))

		write(s, "(I2)") nint( theta*180.0d0/pi , 8 )
		
		str_theta = "_theta" // trim(adjustl(s))
	return
	end

