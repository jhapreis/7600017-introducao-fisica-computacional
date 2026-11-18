import numpy as np
import matplotlib.pyplot as plt
import os

plt.style.use("seaborn-v0_8-whitegrid")
plt.rcParams.update(
    {
        "font.size": 10,
        "axes.labelsize": 11,
        "axes.titlesize": 12,
        "xtick.labelsize": 9,
        "ytick.labelsize": 9,
        "legend.fontsize": 9,
        "figure.autolayout": True,
    }
)


def plot_tarefa4():
    f_dat = "tarefa-4.dat"

    if not os.path.exists(f_dat):
        raise FileNotFoundError(
            f"Erro: Arquivo '{f_dat}' do Fortran não encontrado para a Tarefa 4."
        )

    dados = np.loadtxt(f_dat)
    tau, theta, omega = dados[:, 0], dados[:, 1], dados[:, 2]

    # 1. FIGURA TEMPORAL: theta(tau)
    plt.figure(figsize=(8, 5))
    plt.plot(
        tau / np.pi,
        theta,
        "b-",
        label=r"$\gamma = 0.5$ (Sub-amortecido)",
        linewidth=1.5,
    )
    plt.axhline(0.0, color="r", linestyle="--", linewidth=0.8, alpha=0.7)

    plt.title(r"Tarefa 4: Pêndulo Amortecido ($\gamma = 0.5, \theta_0 = \pi/2$)")
    plt.xlabel(r"Tempo Adimensional $\tau / \pi$")
    plt.ylabel(r"Deslocamento Angular $\theta$ (rad)")
    plt.legend(loc="upper right")
    plt.grid(True, linestyle=":", alpha=0.6)

    plt.savefig("grafico_tarefa4_pendulo_amortecido.png", dpi=300)
    plt.close()

    # 2. ESPAÇO DE FASE: omega vs theta
    plt.figure(figsize=(7, 6))
    plt.plot(theta, omega, "b-", linewidth=1.2, label=r"Trajetória ($\gamma = 0.5$)")
    plt.plot(
        theta[0],
        omega[0],
        "go",
        markersize=6,
        label=r"Início ($\theta_0 = \pi/2, \omega_0 = 0$)",
    )
    plt.plot(0, 0, "rx", markersize=8, label=r"Atrator (Origem: $(0,0)$)")

    plt.title(
        r"Tarefa 4: Espaço de Fase do Pêndulo Amortecido ($\omega \times \theta$)"
    )
    plt.xlabel(r"Ângulo $\theta$ (rad)")
    plt.ylabel(r"Velocidade Angular $\omega = d\theta/d\tau$")
    plt.legend(loc="upper right")
    plt.grid(True, linestyle=":", alpha=0.6)

    plt.savefig("grafico_tarefa4_espaco_fase.png", dpi=300)
    plt.close()

    print("-> Gráficos da Tarefa 4 gerados com sucesso!")


if __name__ == "__main__":
    plot_tarefa4()
