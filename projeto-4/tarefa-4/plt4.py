import numpy as np
import matplotlib.pyplot as plt

plt.style.use('seaborn-v0_8-whitegrid')
plt.rcParams.update({
    'font.size': 11,
    'axes.labelsize': 12,
    'axes.titlesize': 13,
    'xtick.labelsize': 10,
    'ytick.labelsize': 10,
    'legend.fontsize': 10,
    'figure.autolayout': True
})

def simula_pendulo_amortecido(theta0, omega0, gama, dtau, tau_max):
    N = int(tau_max / dtau) + 1
    tau = np.linspace(0, tau_max, N)
    theta = np.zeros(N)
    omega = np.zeros(N)
    
    theta[0] = theta0
    omega[0] = omega0
    
    for i in range(N - 1):
        omega[i+1] = omega[i] + dtau * (-np.sin(theta[i]) - gama * omega[i])
        theta[i+1] = theta[i] + omega[i+1] * dtau
        
    return tau, theta, omega

def plot_tarefa4():
    dtau = 0.001
    tau_max = 40.0
    gamma = 0.5  # gama = 1/2
    theta0 = np.pi / 2.0  # pi/2 rad (~90 deg)
    omega0 = 0.0
    
    tau, theta, omega = simula_pendulo_amortecido(theta0, omega0, gamma, dtau, tau_max)
    
    plt.figure(figsize=(8, 5))
    plt.plot(tau, theta, 'k-', label=r'$\gamma = 1/2$ (Sub-amortecido)', linewidth=1.5)
    plt.axhline(0.0, color='r', linestyle='-', linewidth=0.8)
    
    plt.title(r'Tarefa 4: Pêndulo Amortecido ($\gamma = 0.5$)')
    plt.xlabel(r'Tempo Adimensional $	au$ (unidades de $1/\Omega_0$)')
    plt.ylabel(r'Deslocamento Angular $	heta$ (rad)')
    plt.xlim(0, 40)
    plt.ylim(-0.8, 2.0)
    plt.legend(loc='upper right')
    plt.grid(True, linestyle=':', alpha=0.6)
    
    plt.savefig('grafico_tarefa4_pendulo_amortecido.png', dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa4_pendulo_amortecido.png")

if __name__ == "__main__":
    print("Gerando gráficos da Tarefa 4...")
    plot_tarefa4()
    print("Concluído!")
