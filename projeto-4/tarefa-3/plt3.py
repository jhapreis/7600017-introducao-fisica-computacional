import numpy as np
import matplotlib.pyplot as plt
from scipy.special import ellipk

plt.style.use('seaborn-v0_8-whitegrid' if 'seaborn-v0_8-whitegrid' in plt.style.available else 'default')
plt.rcParams.update({
    'font.size': 11,
    'axes.labelsize': 12,
    'axes.titlesize': 13,
    'xtick.labelsize': 10,
    'ytick.labelsize': 10,
    'legend.fontsize': 10,
    'figure.autolayout': True
})

def simula_pendulo_euler(theta0, omega0, dtau, tau_max):
    N = int(tau_max / dtau) + 1
    tau = np.linspace(0, tau_max, N)
    theta = np.zeros(N)
    omega = np.zeros(N)
    E = np.zeros(N)
    
    theta[0] = theta0
    omega[0] = omega0
    E[0] = 0.5 * omega0**2 + 1.0 - np.cos(theta0)
    
    for i in range(N - 1):
        omega[i+1] = omega[i] - np.sin(theta[i]) * dtau
        theta[i+1] = theta[i] + omega[i] * dtau
        E[i+1] = 0.5 * omega[i+1]**2 + 1.0 - np.cos(theta[i+1])
        
    return tau, theta, omega, E

def simula_pendulo_euler_cromer(theta0, omega0, dtau, tau_max):
    N = int(tau_max / dtau) + 1
    tau = np.linspace(0, tau_max, N)
    theta = np.zeros(N)
    omega = np.zeros(N)
    E = np.zeros(N)
    
    theta[0] = theta0
    omega[0] = omega0
    E[0] = 0.5 * omega0**2 + 1.0 - np.cos(theta0)
    
    for i in range(N - 1):
        omega[i+1] = omega[i] - np.sin(theta[i]) * dtau
        theta[i+1] = theta[i] + omega[i+1] * dtau
        E[i+1] = 0.5 * omega[i+1]**2 + 1.0 - np.cos(theta[i+1])
        
    return tau, theta, omega, E

def plot_tarefa3_temporal():
    dtau = 0.005
    tau_max = 10.0 * np.pi
    theta0 = np.pi / 2.0  # 90 graus
    omega0 = 0.0
    
    t_e, th_e, w_e, E_e = simula_pendulo_euler(theta0, omega0, dtau, tau_max)
    t_ec, th_ec, w_ec, E_ec = simula_pendulo_euler_cromer(theta0, omega0, dtau, tau_max)
    
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 7), sharex=True)
    
    ax1.plot(t_e / np.pi, th_e, 'r--', label='Método de Euler (instável)', alpha=0.8)
    ax1.plot(t_ec / np.pi, th_ec, 'b-', label='Método de Euler-Cromer', linewidth=1.5)
    ax1.set_ylabel(r'$\theta(\tau)$ (rad)')
    ax1.set_title(r'Tarefa 3: Pêndulo Simples - Posição Angular ($	heta_0 = 90^\circ$)')
    ax1.legend(loc='upper right')
    ax1.grid(True, linestyle=':', alpha=0.6)
    
    ax2.plot(t_e / np.pi, E_e, 'r--', label='Método de Euler (ganho de energia)', alpha=0.8)
    ax2.plot(t_ec / np.pi, E_ec, 'b-', label='Método de Euler-Cromer (conservação média)', linewidth=1.5)
    ax2.axhline(1.0, color='k', linestyle=':', label='Energia Teórica $E_0 = 1.0$')
    ax2.set_xlabel(r'Tempo adimensional $	au / \pi$')
    ax2.set_ylabel(r'Energia Mecânica $E / (mg\ell)$')
    ax2.set_title(r'Evolução da Energia Mecânica Adimensional')
    ax2.legend(loc='center right')
    ax2.grid(True, linestyle=':', alpha=0.6)
    
    plt.savefig('grafico_tarefa3_temporal_e_energia.png', dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa3_temporal_e_energia.png")

def plot_tarefa3_espaco_fase():
    dtau = 0.005
    tau_max = 10.0 * np.pi
    theta0 = np.pi / 2.0
    omega0 = 0.0
    
    t_e, th_e, w_e, E_e = simula_pendulo_euler(theta0, omega0, dtau, tau_max)
    t_ec, th_ec, w_ec, E_ec = simula_pendulo_euler_cromer(theta0, omega0, dtau, tau_max)
    
    theta_analitico = np.linspace(-np.pi/2, np.pi/2, 500)
    omega_analitico_pos = np.sqrt(2.0 * np.cos(theta_analitico))
    omega_analitico_neg = -np.sqrt(2.0 * np.cos(theta_analitico))
    
    plt.figure(figsize=(8, 6))
    plt.plot(th_e, w_e, 'r--', label='Euler (espiral divergente)', alpha=0.7)
    plt.plot(th_ec, w_ec, 'b-', label='Euler-Cromer (órbita fechada)', linewidth=1.5)
    plt.plot(theta_analitico, omega_analitico_pos, 'k:', linewidth=2, label='Curva Analítica Exata')
    plt.plot(theta_analitico, omega_analitico_neg, 'k:', linewidth=2)
    
    plt.title(r'Tarefa 3b/c: Espaço de Fase ($\omega 	imes 	heta$) para $	heta_0 = 90^\circ$')
    plt.xlabel(r'Ângulo $	heta$ (rad)')
    plt.ylabel(r'Velocidade Angular $\omega = d	heta/d	au$')
    plt.legend(loc='upper right')
    plt.grid(True, linestyle=':', alpha=0.6)
    
    plt.savefig('grafico_tarefa3_espaco_fase.png', dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa3_espaco_fase.png")

def plot_tarefa3_periodo():
    theta0_deg_list = np.linspace(2, 160, 80)
    theta0_rad_list = np.radians(theta0_deg_list)
    
    T_num = []
    dtau = 0.001
    tau_max = 50.0
    
    for th0 in theta0_rad_list:
        N = int(tau_max / dtau)
        th = th0
        w = 0.0
        cruzamentos = []
        for i in range(N):
            tau = i * dtau
            w_new = w - np.sin(th) * dtau
            th_new = th + w_new * dtau
            
            if th >= 0 and th_new < 0:
                t_cross = tau - dtau * (th / (th_new - th))
                cruzamentos.append(t_cross)
                if len(cruzamentos) == 3:
                    break
            th, w = th_new, w_new
            
        if len(cruzamentos) >= 3:
            T_num.append(cruzamentos[2] - cruzamentos[0])
        elif len(cruzamentos) >= 2:
            T_num.append(2.0 * (cruzamentos[1] - cruzamentos[0]))
        else:
            T_num.append(2.0 * np.pi)
            
    T_num = np.array(T_num)
    
    k = np.sin(theta0_rad_list / 2.0)
    T_exato = 4.0 * ellipk(k**2)
    T_aprox = 2.0 * np.pi * (1.0 + (1.0 / 16.0) * theta0_rad_list**2)
    
    plt.figure(figsize=(8, 5))
    plt.plot(theta0_deg_list, T_num / (2*np.pi), 'bo', label='Euler-Cromer (Numérico)', markersize=4, alpha=0.8)
    plt.plot(theta0_deg_list, T_exato / (2*np.pi), 'k-', label='Integral Elíptica Exata', linewidth=2)
    plt.plot(theta0_deg_list, T_aprox / (2*np.pi), 'r--', label=r'Aproximação $2\pi(1 + 	heta_0^2/16)$', linewidth=1.5)
    
    plt.title(r'Tarefa 3d: Período $T$ do Pêndulo em Função da Amplitude $	heta_0$')
    plt.xlabel(r'Amplitude Inicial $	heta_0$ (graus)')
    plt.ylabel(r'Período Normalizado $T / T_0$ ($T_0 = 2\pi$)')
    plt.legend(loc='upper left')
    plt.grid(True, linestyle=':', alpha=0.6)
    
    plt.savefig('grafico_tarefa3_periodo.png', dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa3_periodo.png")

if __name__ == "__main__":
    print("Gerando gráficos da Tarefa 3...")
    plot_tarefa3_temporal()
    plot_tarefa3_espaco_fase()
    plot_tarefa3_periodo()
    print("Concluído!")
