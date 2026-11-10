! TODO: modificar as funções e subrotinas para receber theta e omega?
! TODO: gráfico semilog do erro relativo vs theta

	implicit none
	
	double precision pi
	double precision tau, dtau, delta_tau
	double precision theta, omega
	
	parameter(pi        = acos(-1.0d0))
	parameter(dtau      = 5.0d-3)
	parameter(delta_tau = 10.0d0*pi)
	
	call euler(dtau, delta_tau)
	call euler_cromer(dtau, delta_tau)
	
	
	open(unit=20, file="tarefa-3d-periodo-theta-5E-3.dat")
	call periodo(dtau, 20)
	close(20)
	
	return
	end

!-----------------------------------------------------------------------
! obs.: No método de Euler, omega e theta fazem referência
! 	às suas "versões antigas" e, por isso,
! 	precisamos guardar o valor de um passo atrás.
!-----------------------------------------------------------------------
	subroutine euler(dtau, delta_tau)
		implicit none
		double precision dtau, delta_tau
		
		double precision energy
		
		double precision pi, tau, theta, omega0, omega1
		parameter(pi=acos(-1.0d0))
		
		open(unit=20, file="tarefa-3ab-pendulo-euler.dat")
		
		tau    = 0.0d0
		theta  = pi/2.0d0
		omega0 = 0.0d0
		
		do while(tau.le.delta_tau)
			write(20, *) tau, theta, omega0, energy(theta, omega0)
			omega1 = omega0 - sin(theta)*dtau
			theta  = theta  + omega0*dtau
			omega0 = omega1
			tau    = tau + dtau
		end do

		close(20)
	return
	end

	subroutine euler_cromer(dtau, delta_tau)
		implicit none
		double precision dtau, delta_tau
		
		double precision energy
		
		double precision pi, tau, theta, omega
		parameter(pi=acos(-1.0d0))
		
		open(unit=20, file="tarefa-3c-pendulo-euler-cromer.dat")
		
		tau   = 0.0d0
		theta = pi/2.0d0
		omega = 0.0d0
		
		do while(tau.le.delta_tau)
			write(20, *) tau, theta, omega, energy(theta, omega)
			omega = omega - sin(theta)*dtau
			theta = theta + omega*dtau
			tau   = tau + dtau
		end do

		close(20)
	return
	end

	subroutine periodo(dtau, iunit)
		implicit none
		double precision dtau
		integer iunit

		double precision periodo_theta, periodo_aproximado_theta
		double precision erro_relativo
		
		double precision pi, thetai, thetaf, dtheta
		double precision T, Tapprox, Tharm
		parameter(pi = acos(-1.0d0))
		parameter(dtheta = 1.0d-1 * pi/180.0d0)
		parameter(Tharm = 2.0d0*pi)
		
		! Não verificamos em 0 ou pi pois o pêndulo não oscila (T -> inf)
		thetai = dtheta 
		thetaf = pi - dtheta

		do while(thetai.le.thetaf)
			T       = periodo_theta(dtau, thetai)
			Tapprox = periodo_aproximado_theta(thetai)

			write(iunit, *)
     # 			thetai*180.0d0/pi,
     # 			thetai,
     # 			T,
     # 			Tapprox,
     # 			Tharm,
     # 			erro_relativo(T, Tapprox),
     # 			erro_relativo(T, Tharm)

			thetai = thetai + dtheta
		end do
	return
	end

	double precision function periodo_theta(dtau, theta)
		implicit none
		double precision dtau, theta
		
		double precision tau0, tau1, theta0, theta1, omega
		double precision tau
		! Salvamos o valor anterior e o atual de tau e theta para interpolar
		
		tau0   = 0.0d0
		tau1   = 0.0d0
		theta0 = theta
		theta1 = theta
		omega  = 0.0d0

		do while(1.eq.1)
			omega  = omega - sin(theta0)*dtau
			theta1 = theta0 + omega*dtau
			tau1   = tau0 + dtau
			
			if(theta1.le.0.0d0) exit
			
			theta0 = theta1
			tau0   = tau1
		end do
		
		tau = tau0 - theta0 * (tau1 - tau0) / (theta1 - theta0)
		periodo_theta = 4.0d0 * tau
	return
	end

	double precision function energy(theta, omega)
		implicit none
		double precision theta, omega
		energy = 0.5d0*omega**2 + 1.0d0 - cos(theta)		
	return
	end

	double precision function periodo_aproximado_theta(theta)
		implicit none
		double precision theta
		double precision pi
		parameter(pi=acos(-1.0d0))
		periodo_aproximado_theta = 2.0d0*pi * (
     # 		1.0d0 +
     # 		1.0d0/16.0d0 * theta**2
     # 	)
	return
	end

	double precision function erro_relativo(u, uref)
		implicit none
		double precision u, uref
		erro_relativo = abs(u - uref) / u * 100.0d0
	return
	end

