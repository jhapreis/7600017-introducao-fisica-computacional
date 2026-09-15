	implicit none

	! Gerador de pares x,y para calcular o valor de pi
	! O intervalo é ajustado de [0,1] -> [-1,1] fazendo f(x) = 2x - 1
	
	integer is_on_the_circle
	double precision get_random_coordinate

	integer iseed
	double precision n_total, n_dentro, i
	double precision x, y, pi
	
	integer fl_debug, fl_save_to_file

	fl_debug = 1

	fl_save_to_file = 0

	iseed = 50
	
	open(unit=40, file="tarefa-1c-saida.dat")

	
	n_total = 4.0d6
	
	n_dentro = 0.0d0
	
	i = 1.0d0

	call srand(iseed)

	do while(i.le.n_total)
		x = get_random_coordinate()
		y = get_random_coordinate()
		
		if(is_on_the_circle(x, y).eq.1) then
			n_dentro = n_dentro + 1.0d0
		end if
		
		i = i + 1.0d0
		
		! Se for requisitado, exibe logs de debug
		if(fl_debug.eq.1) then 
			if(mod(i, 1.0d8).eq.0) then
				print *, "[DEBUG] Processando...", 1.0d2 * i / n_total, "%"
			end if
		end if

		! Se for requisitado, salva os dados para plot posterior
		if(fl_save_to_file.eq.1) then 
			write(40, *) x, y
		end if

	end do

	pi = 4.0d0 * n_dentro / n_total
	
	print *, 'pi=', pi

	close(40)

	stop
	end

	double precision function get_random_coordinate()
		get_random_coordinate = 2.0d0*rand() - 1.0d0
	return
	end

	integer function is_on_the_circle(x, y)
		double precision x, y
		
		if((x**2 + y**2).le.1.0d0) then
			is_on_the_circle = 1
		else
			is_on_the_circle = 0
		end if
	return
	end

