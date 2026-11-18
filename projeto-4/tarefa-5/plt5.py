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


def plot_tarefa5():
    alphas = [0.50, 0.75, 1.00, 1.25, 1.40, 1.50]

    # Verificar existência de todos os arquivos do Fortran
    for a_val in alphas:
        f_str = f"{a_val*100:03.0f}"
        f_a = f"tarefa-5a-continuous-alpha-{f_str}.dat"
        f_c = f"tarefa-5c-poincare-alpha-{f_str}.dat"
        f_d = f"tarefa-5d-lyapunov-alpha-{f_str}.dat"
        for f in [f_a, f_c, f_d]:
            if not os.path.exists(f):
                raise FileNotFoundError(
                    f"Erro: Arquivo '{f}' do Fortran não encontrado."
                )

    # 1. FIGURA DE TRAJETÓRIAS TEMPORAIS theta(tau)
    _fig, axes = plt.subplots(3, 2, figsize=(12, 9), sharex=True, sharey=True)
    axes = axes.flatten()

    for i, a_val in enumerate(alphas):
        f_str = f"{a_val*100:03.0f}"
        f_dat = f"tarefa-5a-continuous-alpha-{f_str}.dat"
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

    # 2. ESPAÇO DE FASE CONTINUO (omega x theta)
    _fig, axes = plt.subplots(3, 2, figsize=(12, 9), sharex=True, sharey=True)
    axes = axes.flatten()

    for i, a_val in enumerate(alphas):
        f_str = f"{a_val*100:03.0f}"
        f_dat = f"tarefa-5a-continuous-alpha-{f_str}.dat"
        dados = np.loadtxt(f_dat)
        theta, omega = dados[:, 1], dados[:, 2]

        ax = axes[i]
        ax.plot(theta, omega, "b-", linewidth=0.6, alpha=0.7)
        ax.set_title(r"Espaço de Fase para $\alpha = " + f"{a_val:.2f}" + r"$")
        ax.set_xlim(-np.pi, np.pi)
        ax.set_ylim(-3.0, 3.0)
        ax.grid(True, linestyle=":", alpha=0.6)

        if i >= 4:
            ax.set_xlabel(r"$\theta$ (rad)")
        if i % 2 == 0:
            ax.set_ylabel(r"$\omega = d\theta/d\tau$")

    plt.suptitle(
        r"Tarefa 5b: Espaço de Fase $(\omega \times \theta)$ para Diferentes Amplitudes $\alpha$",
        fontsize=14,
    )
    plt.savefig("grafico_tarefa5b_espaco_fase.png", dpi=300)
    plt.close()

    # 3. SEÇÕES DE POINCARÉ
    _fig, axes = plt.subplots(3, 2, figsize=(11, 10))
    axes = axes.flatten()

    for i, a_val in enumerate(alphas):
        f_str = f"{a_val*100:03.0f}"
        f_poinc = f"tarefa-5c-poincare-alpha-{f_str}.dat"
        dados = np.loadtxt(f_poinc)
        th_p, w_p = dados[:, 0], dados[:, 1]

        ax = axes[i]
        if a_val < 1.0:
            ax.plot(th_p, w_p, "ro", markersize=5, label="Atrator Periódico (1 ponto)")
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

    # 4. EXPOENTE DE LYAPUNOV (ln|Delta theta| vs tau em painéis 3x2)
    _fig, axes = plt.subplots(3, 2, figsize=(12, 9), sharex=True)
    axes = axes.flatten()

    colors = ["green", "green", "orange", "red", "red", "darkred"]

    for i, a_val in enumerate(alphas):
        f_str = f"{a_val*100:03.0f}"
        f_lyap = f"tarefa-5d-lyapunov-alpha-{f_str}.dat"
        dados = np.loadtxt(f_lyap)
        tau, _dtheta, log_dtheta = dados[:, 0], dados[:, 1], dados[:, 2]

        ax = axes[i]
        ax.plot(
            tau / (2 * np.pi),
            log_dtheta,
            color=colors[i],
            linewidth=1.2,
            label=r"$\alpha = " + f"{a_val:.2f}" + r"$",
        )
        ax.set_title(
            r"Crescimento de $\Delta\theta$ para $\alpha = " + f"{a_val:.2f}" + r"$"
        )
        ax.grid(True, linestyle=":", alpha=0.6)
        ax.legend(loc="lower right")

        if i >= 4:
            ax.set_xlabel(r"Tempo $\tau / (2\pi)$")
        if i % 2 == 0:
            ax.set_ylabel(r"$\ln |\Delta\theta(\tau)|$")

    plt.suptitle(
        r"Tarefa 5d: Divergência de Trajetórias Perturbadas $\ln |\Delta\theta(\tau)|$",
        fontsize=14,
    )
    plt.savefig("grafico_tarefa5d_lyapunov.png", dpi=300)
    plt.close()

    # 5. FIGURA COMBINADA DE LYAPUNOV (Todas as curvas num mesmo gráfico)
    plt.figure(figsize=(9, 6))
    for i, a_val in enumerate(alphas):
        f_str = f"{a_val*100:03.0f}"
        f_lyap = f"tarefa-5d-lyapunov-alpha-{f_str}.dat"
        dados = np.loadtxt(f_lyap)
        tau, log_dtheta = dados[:, 0], dados[:, 2]
        plt.plot(
            tau / (2 * np.pi),
            log_dtheta,
            linewidth=1.3,
            label=r"$\alpha = " + f"{a_val:.2f}" + r"$",
        )

    plt.title(r"Tarefa 5d: Comparação do Crescimento de $\ln |\Delta\theta(\tau)|$")
    plt.xlabel(r"Tempo em Ciclos $\tau / (2\pi)$")
    plt.ylabel(r"$\ln |\Delta\theta(\tau)|$")
    plt.axhline(
        np.log(1.0e-5),
        color="k",
        linestyle=":",
        alpha=0.6,
        label=r"Perturbação Inicial $\Delta\omega_0 = 10^{-5}$",
    )
    plt.legend(loc="lower right")
    plt.grid(True, linestyle=":", alpha=0.6)
    plt.savefig("grafico_tarefa5d_lyapunov_comparativo.png", dpi=300)
    plt.close()

    print("-> Gráficos da Tarefa 5 gerados com sucesso!")


if __name__ == "__main__":
    plot_tarefa5()
