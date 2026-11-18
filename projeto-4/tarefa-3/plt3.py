import glob
import numpy as np
import matplotlib.pyplot as plt
from scipy.special import ellipk

plt.style.use("seaborn-v0_8-whitegrid")
plt.rcParams.update(
    {
        "font.size": 11,
        "axes.labelsize": 12,
        "axes.titlesize": 13,
        "xtick.labelsize": 10,
        "ytick.labelsize": 10,
        "legend.fontsize": 10,
        "figure.autolayout": True,
    }
)


def plot_tarefa3_temporal():
    f_euler = "tarefa-3ab-pendulo-euler.dat"
    f_ec = "tarefa-3c-pendulo-euler-cromer.dat"

    # Tenta carregar diretamente os arquivos do Fortran
    # Se o arquivo não existir, o np.loadtxt lançará FileNotFoundError
    d_e = np.loadtxt(f_euler)
    d_ec = np.loadtxt(f_ec)

    t_e, th_e, w_e, E_e = d_e[:, 0], d_e[:, 1], d_e[:, 2], d_e[:, 3]
    t_ec, th_ec, w_ec, E_ec = d_ec[:, 0], d_ec[:, 1], d_ec[:, 2], d_ec[:, 3]

    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 7), sharex=True)

    ax1.plot(
        t_e / np.pi,
        th_e,
        "r--",
        label="Método de Euler (instável)",
        alpha=0.8,
    )
    ax1.plot(
        t_ec / np.pi,
        th_ec,
        "b-",
        label="Método de Euler-Cromer",
        linewidth=1.5,
    )
    ax1.set_ylabel(r"$\theta(\tau)$ (rad)")
    ax1.set_title(
        r"Tarefa 3: Pêndulo Simples - Posição Angular ($\theta_0 = 90^\circ$)"
    )
    ax1.legend(loc="upper right")
    ax1.grid(True, linestyle=":", alpha=0.6)

    ax2.plot(
        t_e / np.pi, E_e, "r--", label="Método de Euler (ganho de energia)", alpha=0.8
    )
    ax2.plot(
        t_ec / np.pi,
        E_ec,
        "b-",
        label="Método de Euler-Cromer (conservação média)",
        linewidth=1.5,
    )
    ax2.axhline(1.0, color="k", linestyle=":", label="Energia Teórica $E_0 = 1.0$")
    ax2.set_xlabel(r"Tempo adimensional $\tau / \pi$")
    ax2.set_ylabel(r"Energia Mecânica $E / (mg\ell)$")
    ax2.set_title(r"Evolução da Energia Mecânica Adimensional")
    ax2.legend(loc="center right")
    ax2.grid(True, linestyle=":", alpha=0.6)

    plt.savefig("grafico_tarefa3_temporal_e_energia.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa3_temporal_e_energia.png")


def plot_tarefa3_espaco_fase():
    f_euler = "tarefa-3ab-pendulo-euler.dat"
    f_ec = "tarefa-3c-pendulo-euler-cromer.dat"

    d_e = np.loadtxt(f_euler)
    d_ec = np.loadtxt(f_ec)

    th_e, w_e = d_e[:, 1], d_e[:, 2]
    th_ec, w_ec = d_ec[:, 1], d_ec[:, 2]

    theta_analitico = np.linspace(-np.pi / 2, np.pi / 2, 500)
    omega_analitico_pos = np.sqrt(2.0 * np.cos(theta_analitico))
    omega_analitico_neg = -np.sqrt(2.0 * np.cos(theta_analitico))

    plt.figure(figsize=(8, 6))
    plt.plot(th_e, w_e, "r--", label="Euler (espiral divergente)", alpha=0.7)
    plt.plot(th_ec, w_ec, "b-", label="Euler-Cromer (órbita fechada)", linewidth=1.5)
    plt.plot(
        theta_analitico,
        omega_analitico_pos,
        "k:",
        linewidth=2,
        label=r"Teórico: $\omega(\theta) = \pm\sqrt{2\cos\theta}$",
    )
    plt.plot(theta_analitico, omega_analitico_neg, "k:", linewidth=2)

    plt.title(
        r"Tarefa 3b/c: Espaço de Fase ($\omega \times \theta$) para $\theta_0 = 90^\circ$",
    )
    plt.xlabel(r"Ângulo $\theta$ (rad)")
    plt.ylabel(r"Velocidade Angular $\omega = d\theta/d\tau$")
    plt.legend(loc="upper right")
    plt.grid(True, linestyle=":", alpha=0.6)

    plt.savefig("grafico_tarefa3_espaco_fase.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa3_espaco_fase.png")


def plot_tarefa3_periodo_e_erro():
    arquivos_periodo = sorted(glob.glob("tarefa-3d-periodo-*.dat"))
    if not arquivos_periodo:
        f_periodo = "tarefa-3d-periodo-theta-5E-3.dat"
    else:
        f_periodo = arquivos_periodo[0]

    dados = np.loadtxt(f_periodo)

    theta_deg = dados[:, 0]
    theta_rad = dados[:, 1]
    T_num = dados[:, 2]
    T_aprox = dados[:, 3]

    # Cálculo da referência analítica Teórica via Integral Elíptica K(k)
    k = np.sin(theta_rad / 2.0)
    T_exato = 4.0 * ellipk(k**2)

    # 1. Gráfico de Período vs Theta
    plt.figure(figsize=(8, 5))
    plt.plot(
        theta_deg,
        T_num / (2 * np.pi),
        "bo",
        label="Euler-Cromer (Fortran)",
        markersize=4,
        alpha=0.8,
    )
    plt.plot(
        theta_deg,
        T_exato / (2 * np.pi),
        "k-",
        label=r"Teórico via Integral Elíptica",
        linewidth=2,
    )
    plt.plot(
        theta_deg,
        T_aprox / (2 * np.pi),
        "r--",
        label=r"Aproximação $2\pi(1 + \theta_0^2/16)$",
        linewidth=1.5,
    )

    plt.title(r"Tarefa 3d: Período $T$ do Pêndulo em Função da Amplitude $\theta_0$")
    plt.xlabel(r"Amplitude Inicial $\theta_0$ (graus)")
    plt.ylabel(r"Período Normalizado $T / T_0$ ($T_0 = 2\pi$)")
    plt.legend(loc="upper left")
    plt.grid(True, linestyle=":", alpha=0.6)

    plt.savefig("grafico_tarefa3_periodo.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa3_periodo.png")

    # 2. Gráfico Semilog de Erro Relativo
    erro_num = np.abs(T_num - T_exato) / T_exato
    erro_aprox = np.abs(T_aprox - T_exato) / T_exato

    plt.figure(figsize=(8, 5))
    plt.semilogy(
        theta_deg,
        erro_num,
        "b-o",
        markersize=3,
        label="Erro Numérico Euler-Cromer (Fortran)",
        linewidth=1.5,
    )
    plt.semilogy(
        theta_deg,
        erro_aprox,
        "r--",
        label=r"Erro da Aproximação $2\pi(1 + \theta_0^2/16)$",
        linewidth=1.8,
    )
    plt.axhline(
        5.0e-3,
        color="k",
        linestyle=":",
        linewidth=1.2,
        label=r"Referência $d\tau = 5.0e-3$",
    )

    plt.title(
        r"Tarefa 3d: Erro Relativo em Função da Amplitude $\theta_0$ (Escala Semilog)"
    )
    plt.xlabel(r"Amplitude Inicial $\theta_0$ (graus)")
    plt.ylabel(r"Erro Relativo $|T - T_{\text{ref}}| / T_{\text{ref}}$")
    plt.legend(loc="lower right")
    plt.grid(True, which="both", linestyle=":", alpha=0.6)

    plt.savefig("grafico_tarefa3_erro_relativo.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa3_erro_relativo.png")


if __name__ == "__main__":
    print("Gerando gráficos da Tarefa 3 a partir dos arquivos do Fortran...")
    plot_tarefa3_temporal()
    plot_tarefa3_espaco_fase()
    plot_tarefa3_periodo_e_erro()
    print("Concluído!")
