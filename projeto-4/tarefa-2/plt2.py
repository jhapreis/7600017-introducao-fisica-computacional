import glob
import numpy as np
import matplotlib.pyplot as plt

# Configuração de estilo dos gráficos
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


def carregar_dados_trajetoria(filepath):
    """
    Lê o arquivo de simulação de trajetória.
    Colunas: 0: t, 1: x, 2: y, 3: vx, 4: vy, 5: v
    """
    dados = np.loadtxt(filepath)
    return {
        "t": dados[:, 0],
        "x": dados[:, 1],
        "y": dados[:, 2],
        "vx": dados[:, 3],
        "vy": dados[:, 4],
        "v": dados[:, 5],
    }


# ==============================================================================
# 1. ITEM 2a: TRAJETÓRIAS Y(X) E VELOCIDADES V(T) COM E SEM ARRASTO
# ==============================================================================
def plot_item_2a():
    angles = [30, 45, 60]
    colors = {30: "blue", 45: "green", 60: "red"}

    fig_traj, ax_traj = plt.subplots(figsize=(9, 5.5))
    fig_v, ax_v = plt.subplots(figsize=(8, 5))

    encontrou_arquivos = False

    for ang in angles:
        # Busca flexível por padrão de arquivo
        patt_com = f"tarefa-2a-simulacao-com-arrasto*theta{ang}*.dat"
        patt_sem = f"tarefa-2a-simulacao-sem-arrasto*theta{ang}*.dat"

        files_com = glob.glob(patt_com)
        files_sem = glob.glob(patt_sem)

        if files_com and files_sem:
            encontrou_arquivos = True
            d_com = carregar_dados_trajetoria(files_com[0])
            d_sem = carregar_dados_trajetoria(files_sem[0])

            # Trajetória y(x)
            ax_traj.plot(
                d_sem["x"],
                d_sem["y"],
                color=colors[ang],
                linestyle="--",
                alpha=0.6,
                label=f"Sem arrasto ({ang}°)",
            )
            ax_traj.plot(
                d_com["x"],
                d_com["y"],
                color=colors[ang],
                linestyle="-",
                linewidth=2,
                label=f"Com arrasto ({ang}°)",
            )

            # Velocidade no tempo v(t)
            ax_v.plot(
                d_com["t"],
                d_com["v"],
                color=colors[ang],
                linestyle="-",
                linewidth=2,
                label=f"Com arrasto ({ang}°)",
            )
            ax_v.plot(
                d_sem["t"],
                d_sem["v"],
                color=colors[ang],
                linestyle="--",
                alpha=0.6,
                label=f"Sem arrasto ({ang}°)",
            )

    if encontrou_arquivos:
        # Formatação do gráfico de Trajetória
        ax_traj.set_title(
            "Tarefa 2a: Trajetórias 2D de Projetil com e sem Resistência do Ar ($v_0 = 377$ m/s)"
        )
        ax_traj.set_xlabel("Distância Horizontal $x$ (m)")
        ax_traj.set_ylabel("Altura $y$ (m)")
        ax_traj.set_ylim(bottom=0)
        ax_traj.set_xlim(left=0)
        ax_traj.legend(loc="upper right", ncol=2)
        ax_traj.grid(True, linestyle=":", alpha=0.6)
        fig_traj.savefig("grafico_tarefa2a_trajetorias.png", dpi=300)
        print("-> Salvo: grafico_tarefa2a_trajetorias.png")

        # Formatação do gráfico de Velocidade
        ax_v.set_title("Tarefa 2a: Evolução da Velocidade $v(t)$ no Tempo")
        ax_v.set_xlabel("Tempo $t$ (s)")
        ax_v.set_ylabel("Velocidade $v$ (m/s)")
        ax_v.legend(loc="upper right", ncol=2)
        ax_v.grid(True, linestyle=":", alpha=0.6)
        fig_v.savefig("grafico_tarefa2a_velocidade_tempo.png", dpi=300)
        print("-> Salvo: grafico_tarefa2a_velocidade_tempo.png")
    else:
        print("Aviso (Item 2a): Arquivos de simulação não encontrados.")

    plt.close(fig_traj)
    plt.close(fig_v)


# ==============================================================================
# 2. ITEM 2b: ALCANCE HORIZONTAL DX EM FUNÇÃO DO ÂNGULO DE LANÇAMENTO THETA
# ==============================================================================
def plot_item_2b():
    files_theta = glob.glob("tarefa-2b-alcance-theta*.dat")
    files_max = glob.glob("tarefa-2b-alcance-theta-maximo*.dat")

    # Filtra para pegar apenas o arquivo de curva completa
    files_curva = [f for f in files_theta if "maximo" not in f]

    if not files_curva:
        print("Aviso (Item 2b): Arquivo tarefa-2b-alcance-theta*.dat não encontrado.")
        return

    dados = np.loadtxt(files_curva[0])
    theta_deg = dados[:, 1]
    dx = dados[:, 2]

    plt.figure(figsize=(8, 5))
    plt.plot(
        theta_deg,
        dx,
        "b-",
        linewidth=2,
        label=r"Alcance com Arrasto $D_x(\theta)$",
    )

    # Se encontrar o arquivo de máximo, destaca o ponto
    if files_max:
        max_info = np.loadtxt(files_max[0])
        th_max_deg = max_info[1]
        dx_max = max_info[2]

        plt.plot(
            th_max_deg,
            dx_max,
            "ro",
            markersize=8,
            label=rf"Ângulo de Alcance Máximo ($\theta^* = {th_max_deg:.1f}^\circ$, $D_x = {dx_max:.1f}\text{{ m}}$)",
        )
        plt.axvline(th_max_deg, color="r", linestyle=":", alpha=0.7)

    # Marca também o ângulo ideal sem arrasto (45°) para comparação
    plt.axvline(
        45.0,
        color="gray",
        linestyle="--",
        alpha=0.6,
        label=r"Ângulo Ideal sem Arrasto ($45^\circ$)",
    )

    plt.title(
        r"Tarefa 2b: Alcance Horizontal $D_x$ em Função do Ângulo de Lançamento $\theta$"
    )
    plt.xlabel(r"Ângulo de Lançamento $\theta$ (graus)")
    plt.ylabel("Alcance Horizontal $D_x$ (m)")
    plt.legend(loc="lower center")
    plt.grid(True, linestyle=":", alpha=0.6)
    plt.savefig("grafico_tarefa2b_alcance_theta.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa2b_alcance_theta_maximo.png")


# ==============================================================================
# 3. ITEM 2c: ARRASTO VARIÁVEL (DENSIDADE DO AR E BARREIRA DO SOM)
# ==============================================================================
def plot_item_2c():
    files_plus = glob.glob("tarefa-2c-arrasto-variavel-plus-a*.dat")
    files_minus = glob.glob("tarefa-2c-arrasto-variavel-minus-b*.dat")

    if not (files_plus and files_minus):
        print("Aviso (Item 2c): Arquivos de arrasto variável não encontrados.")
        return

    d_plus = carregar_dados_trajetoria(files_plus[0])
    d_minus = carregar_dados_trajetoria(files_minus[0])

    # Trajetórias 2D
    plt.figure(figsize=(9, 5))
    plt.plot(
        d_plus["x"],
        d_plus["y"],
        "g-",
        linewidth=2,
        label=r"Arrasto Variável ($v_0 + 1\% = 380.77\text{ m/s}$)",
    )
    plt.plot(
        d_minus["x"],
        d_minus["y"],
        "m-",
        linewidth=2,
        label=r"Arrasto Variável ($v_0 - 1\% = 373.23\text{ m/s}$)",
    )

    plt.title(r"Tarefa 2c: Trajetória com Arrasto Variável $\rho(y)$ e $C_d(v)$")
    plt.xlabel("Distância Horizontal $x$ (m)")
    plt.ylabel("Altura $y$ (m)")
    plt.ylim(bottom=0)
    plt.xlim(left=0)
    plt.legend(loc="upper right")
    plt.grid(True, linestyle=":", alpha=0.6)
    plt.savefig("grafico_tarefa2c_trajetoria_arrasto_variavel.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa2c_trajetoria_arrasto_variavel.png")

    # Velocidade no Tempo destacando a velocidade do som
    plt.figure(figsize=(8, 5))
    plt.plot(d_plus["t"], d_plus["v"], "g-", linewidth=2, label=r"$v_0 + 1\%$")
    plt.plot(d_minus["t"], d_minus["v"], "m-", linewidth=2, label=r"$v_0 - 1\%$")
    plt.axhline(
        344.0,
        color="r",
        linestyle="--",
        label=r"Velocidade do Som $v_{\text{som}} = 344\text{ m/s}$",
    )

    plt.title("Tarefa 2c: Transição da Barreira do Som na Trajetória")
    plt.xlabel("Tempo $t$ (s)")
    plt.ylabel("Velocidade $v$ (m/s)")
    plt.legend(loc="upper right")
    plt.grid(True, linestyle=":", alpha=0.6)
    plt.savefig("grafico_tarefa2c_velocidade_transonica.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa2c_velocidade_transonica.png")


# ==============================================================================
# 4. IMPRESSÃO DA TABELA RESUMO DA TAREFA 2
# ==============================================================================
def imprimir_resumo_tarefa2():
    print("\n" + "=" * 75)
    print(" TABELA RESUMO - TAREFA 2: LANÇAMENTO DE PROJÉTEIS Em 2D")
    print("=" * 75)

    files_max = glob.glob("tarefa-2b-alcance-theta-maximo*.dat")
    if files_max:
        max_info = np.loadtxt(files_max[0])
        th_max_rad = max_info[0]
        th_max_deg = max_info[1]
        dx_max = max_info[2]
        print(
            f"Ângulo de Alcance Máximo Com Arrasto: {th_max_deg:.2f}° ({th_max_rad:.4f} rad)"
        )
        print(f"Alcance Máximo Com Arrasto Constante: {dx_max:.2f} m")

    files_plus = glob.glob("tarefa-2c-arrasto-variavel-plus-a*.dat")
    files_minus = glob.glob("tarefa-2c-arrasto-variavel-minus-b*.dat")

    if files_plus and files_minus:
        d_plus = carregar_dados_trajetoria(files_plus[0])
        d_minus = carregar_dados_trajetoria(files_minus[0])
        print(f"Alcance com Arrasto Variável (v0 + 1%): {d_plus['x'][-1]:.2f} m")
        print(f"Alcance com Arrasto Variável (v0 - 1%): {d_minus['x'][-1]:.2f} m")

    print("=" * 75 + "\n")


if __name__ == "__main__":
    print("Processando dados e gerando gráficos para a Tarefa 2...")
    plot_item_2a()
    plot_item_2b()
    plot_item_2c()
    imprimir_resumo_tarefa2()
    print("Concluído!")
