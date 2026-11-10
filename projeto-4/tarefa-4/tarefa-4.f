	implicit none
	
	double precision dtau, gama
	parameter(dtau=1.0d-4)
	parameter(gama=0.5d0)
	
	call oscilacao(dtau, gama)
	
	stop
	end
	
	! ----------------------------------------------------------------
	! Subrotina que implementa a oscilação do pêndulo amortecido considerando Euler-Cromer.
	! 	O objetivo final é um gráfico de theta(tau) para indicar o tipo de
	! amortecimento (sub-, super- ou criticamente amortecido)
	! ----------------------------------------------------------------
	subroutine oscilacao(dtau, gama)
		implicit none
		double precision dtau, gama

		double precision pi, tau, delta_tau, omega, theta
		parameter(pi = acos(-1.0d0))
		
		! Valores iniciais e finais
		tau       = 0.0d0
		delta_tau = 10.0d0*pi
		omega     = 0.0d0
		theta     = pi / 2.0d0

		open(file="tarefa-4.dat", unit=20)
		
		do while(tau.le.delta_tau)
			write(20, *) tau, theta, omega
			omega = omega - ( sin(theta) + gama*omega ) * dtau
			theta = theta + omega * dtau
			tau   = tau + dtau
		end do
		
		close(20)
	return
	end

