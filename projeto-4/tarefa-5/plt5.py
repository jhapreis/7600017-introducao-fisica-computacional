import numpy as np
import matplotlib.pyplot as plt
import os

plt.style.use(
    "seaborn-v0_8-whitegrid"
    if "seaborn-v0_8-whitegrid" in plt.style.available
    else "default"
)
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


def plot_tarefa5():
    alphas = [0.50, 0.75, 1.00, 1.25, 1.40, 1.50]

    # 1. FIGURA DE TRAJETÓRIAS TEMPORAIS
    fig, axes = plt.subplots(3, 2, figsize=(12, 9), sharex=True, sharey=True)
    axes = axes.flatten()

    for i, a_val in enumerate(alphas):
        f_dat = f"tarefa-5a-continuous-alpha-{a_val*100:03.0f}.dat"
        # Sem fallback: np.loadtxt falha com FileNotFoundError se o arquivo não existir
        dados = np.loadtxt(f_dat)
        tau, theta = dados[:, 0], dados[:, 1]

        ax = axes[i]
        ax.plot(tau / (2 * np.pi), theta, "b-", linewidth=1.0)
        ax.set_title(r"Regime para $\alpha = " + f"{a_val:.2f}" + r"$")
        ax.set_ylim(-np.pi, np.pi)
        ax.grid(True, linestyle=":", alpha=0.6)

        if i >= 4:
            ax.set_xlabel(r"Tempo $\tau / (2\pi)$")
        if i % 2 == 0:
            ax.set_ylabel(r"$\theta(\tau)$ (rad)")

    plt.suptitle(
        r"Tarefa 5a: Evolução Temporal $\theta(\tau)$ para Diferentes Amplitudes $\alpha$",
        fontsize=14,
    )
    plt.savefig("grafico_tarefa5a_trajetorias_temporais.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa5a_trajetorias_temporais.png")

    # 2. FIGURA DAS SEÇÕES DE POINCARÉ
    fig, axes = plt.subplots(3, 2, figsize=(11, 10))
    axes = axes.flatten()

    for i, a_val in enumerate(alphas):
        f_poinc = f"tarefa-5c-poincare-alpha-{a_val*100:03.0f}.dat"
        # Sem fallback: np.loadtxt falha com FileNotFoundError se o arquivo não existir
        dados = np.loadtxt(f_poinc)
        th_p, w_p = dados[:, 0], dados[:, 1]

        ax = axes[i]
        if a_val < 1.0:
            ax.plot(th_p, w_p, "ro", markersize=6, label=f"Atrator Periódico (1 ponto)")
        elif a_val == 1.00:
            ax.plot(th_p, w_p, "go", markersize=5, label="Bifurcação / Período Duplo")
        else:
            ax.plot(
                th_p,
                w_p,
                "b.",
                markersize=2,
                alpha=0.7,
                label="Atrator Estranho (Caos)",
            )

        ax.set_title(r"Seção de Poincaré para $\alpha = " + f"{a_val:.2f}" + r"$")
        ax.set_xlim(-np.pi, np.pi)
        ax.set_ylim(-2.5, 2.5)
        ax.grid(True, linestyle=":", alpha=0.6)
        ax.legend(loc="upper right")

        if i >= 4:
            ax.set_xlabel(r"$\theta$ (rad)")
        if i % 2 == 0:
            ax.set_ylabel(r"$\omega = d\theta/d\tau$")

    plt.suptitle(r"Tarefa 5c: Seções de Poincaré $(\omega \times \theta)$", fontsize=14)
    plt.savefig("grafico_tarefa5c_secoes_poincare.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa5c_secoes_poincare.png")


if __name__ == "__main__":
    print("Gerando gráficos da Tarefa 5...")
    plot_tarefa5()
    print("Concluído!")
