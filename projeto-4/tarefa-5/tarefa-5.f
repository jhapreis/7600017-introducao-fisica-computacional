	implicit none
	double precision pi
	double precision dtau, delta_tau, gama, v
	double precision delta_tau_poincare
	
	parameter(pi=acos(-1.0d0))

	parameter(dtau               = 1.0d-3)
	parameter(delta_tau          = 50.0d0*2.0d0*pi)
	parameter(delta_tau_poincare = 10.0d0*delta_tau) ! Usaremos um delta_tau maior para termos mais pontos após o transitório
	parameter(gama               = 0.5d0)
	parameter(v                  = 2.0d0/3.0d0)
	
	open(file="tarefa-5a-continuous-alpha-050.dat", unit=20)
	open(file="tarefa-5a-continuous-alpha-075.dat", unit=21)
	open(file="tarefa-5a-continuous-alpha-100.dat", unit=22)
	open(file="tarefa-5a-continuous-alpha-125.dat", unit=23)
	open(file="tarefa-5a-continuous-alpha-140.dat", unit=24)
	open(file="tarefa-5a-continuous-alpha-150.dat", unit=25)
	
	open(file="tarefa-5c-poincare-alpha-050.dat", unit=30)
	open(file="tarefa-5c-poincare-alpha-075.dat", unit=31)
	open(file="tarefa-5c-poincare-alpha-100.dat", unit=32)
	open(file="tarefa-5c-poincare-alpha-125.dat", unit=33)
	open(file="tarefa-5c-poincare-alpha-140.dat", unit=34)
	open(file="tarefa-5c-poincare-alpha-150.dat", unit=35)
	
	call oscilacao(20, 0.50d0, dtau, delta_tau, gama, v)
	call oscilacao(21, 0.75d0, dtau, delta_tau, gama, v)
	call oscilacao(22, 1.00d0, dtau, delta_tau, gama, v)
	call oscilacao(23, 1.25d0, dtau, delta_tau, gama, v)
	call oscilacao(24, 1.40d0, dtau, delta_tau, gama, v)
	call oscilacao(25, 1.50d0, dtau, delta_tau, gama, v)
	
	call poincare(30, 0.50d0, dtau, delta_tau_poincare, gama, v, 30)
	call poincare(31, 0.75d0, dtau, delta_tau_poincare, gama, v, 30)
	call poincare(32, 1.00d0, dtau, delta_tau_poincare, gama, v, 30)
	call poincare(33, 1.25d0, dtau, delta_tau_poincare, gama, v, 30)
	call poincare(34, 1.40d0, dtau, delta_tau_poincare, gama, v, 30)
	call poincare(35, 1.50d0, dtau, delta_tau_poincare, gama, v, 30)
	
	close(20)
	close(21)
	close(22)
	close(23)
	close(24)
	close(25)
	
	close(30)
	close(31)
	close(32)
	close(33)
	close(34)
	close(35)
	
	stop
	end

	! ----------------------------------------------------------------
	! Subrotina para a oscilação do pêndulo amortecido e forçado
	! ----------------------------------------------------------------
	subroutine oscilacao(iunit, alpha, dtau, delta_tau, gama, v)
	
		implicit none
		integer iunit
		double precision alpha, dtau, delta_tau, gama, v

		double precision norm_theta, energy

		double precision tau, theta, omega
	
		! Condições iniciais
		tau   = 0.0d0
		theta = 0.0d0
		omega = 0.0d0
		
		do while(tau.le.delta_tau)
			write(iunit, *) tau, theta, omega, energy(theta,omega)

			omega = omega + dtau * (
     # 			- sin(theta)
     #				- gama*omega
     #				+ alpha*sin(v*tau)
     #			)
			theta = theta + omega * dtau
			tau 	= tau + dtau

			theta = norm_theta(theta)
		end do
	return
	end

	! ----------------------------------------------------------------
	! Subrotina para a simulação considerando pontos para Poincaré,
	! 	com tau = n * T_ext
	! Como estamos considerando dtau pequeno, 
	! ----------------------------------------------------------------
	subroutine poincare(iunit, alpha,dtau,delta_tau,gama,v, n_trans)
		implicit none

		integer iunit, n_trans
		double precision alpha, dtau, delta_tau, gama, v

		double precision norm_theta

		double precision tau, theta, omega
		double precision pi, T_ext
		integer n
		
		parameter(pi = acos(-1.0d0))

		! Período é ciclo da força externa
		T_ext = 2.0d0 * pi/v
		n     = 1

		! Condições iniciais
		tau   = 0.0d0
		theta = 0.0d0
		omega = 0.0d0
		
		do while(tau.le.delta_tau)

			omega = omega + dtau * (
     # 			- sin(theta)
     #				- gama*omega
     #				+ alpha*sin(v*tau)
     #			)
			theta = theta + omega * dtau
			tau 	= tau + dtau

			theta = norm_theta(theta)
			
			! Para cada passo dtau, verificamos se já andamos um ciclo
			if(tau.ge.dble(n)*T_ext) then
				n = n + 1
				
				! Caso estejamos após o número de ciclos do transitório, então salvamos no arquivo
				if(n.ge.n_trans) then
					write(iunit, *) theta, omega, n
				end if

			end if

		end do
	return
	end

	! ----------------------------------------------------------------
	! Função para normalizar theta -> -pi <= theta <= pi
	! ----------------------------------------------------------------
	double precision function norm_theta(theta0)
		implicit none
		double precision theta0

		double precision pi, theta
		parameter(pi=acos(-1.0d0))

		theta = theta0 ! Passar valor, não referência

		do while(1.eq.1)
			if(theta.lt.-pi) then
				theta = theta + 2.0d0*pi
			else if(theta.gt.pi) then
				theta = theta - 2.0d0*pi
			else
				exit
			end if
		end do
		
		norm_theta = theta
	return
	end

	double precision function energy(theta, omega)
		implicit none
		double precision theta, omega
		energy = 0.5d0 * omega**2 + 1.0d0 - cos(theta)
	return
	end

