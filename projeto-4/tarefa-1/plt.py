import os
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


def carregar_dados_tempo(filepath):
    """
    Lê o arquivo de simulação temporal do Fortran.
    Colunas:
      0: t (s)
      1: v_analitica_sem_ar (m/s)
      2: K_sem_ar (J)
      3: K_com_ar (J)
      4: v_no_air (m/s)
      5: v_air (m/s)
    """
    dados = np.loadtxt(filepath)
    return {
        "t": dados[:, 0],
        "v_analitica": dados[:, 1],
        "k_no_air": dados[:, 2],
        "k_air": dados[:, 3],
        "v_no_air": dados[:, 4],
        "v_air": dados[:, 5],
    }


def carregar_deslocamento(filepath):
    """Retorna (r_no_air, r_air) em metros."""
    dados = np.loadtxt(filepath)
    return float(dados[0]), float(dados[1])


def carregar_v_terminal(filepath):
    """Retorna v_terminal teórica em m/s."""
    return float(np.loadtxt(filepath))


# ==============================================================================
# 1. FIGURA 1: ITEM (a) - Sem resistência do ar (A = 0.30, dt = 0.01)
# ==============================================================================
def plot_item_a():
    d = carregar_dados_tempo("tarefa-1_A0.30_dt0.01-simulacao-v-tempo.dat")

    plt.figure(figsize=(8, 5))
    plt.plot(
        d["t"],
        d["v_analitica"],
        "k--",
        label=r"Solução Exata $v(t) = \sqrt{2Pt/m}$",
        linewidth=2,
    )
    plt.plot(
        d["t"],
        d["v_no_air"],
        "r-",
        label=r"Integração Euler ($K$ sem ar)",
        linewidth=1.5,
        alpha=0.8,
    )

    plt.title(
        r"Tarefa 1a: Velocidade sem Ar ($A = 0.30\text{ m}^2, dt = 0.01\text{ s}$)"
    )
    plt.xlabel("Tempo $t$ (s)")
    plt.ylabel("Velocidade $v$ (m/s)")
    plt.legend(loc="lower right")
    plt.grid(True, linestyle=":", alpha=0.6)
    plt.savefig("grafico_tarefa1a_sem_ar.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa1a_sem_ar.png")


# ==============================================================================
# 2. FIGURA 2: ITEM (b) - Com resistência do ar vs Sem Ar (A = 0.30, dt = 0.01)
# ==============================================================================
def plot_item_b():
    d = carregar_dados_tempo("tarefa-1_A0.30_dt0.01-simulacao-v-tempo.dat")
    v_term = carregar_v_terminal("tarefa-1_A0.30_dt0.01-velocidade-terminal.dat")

    plt.figure(figsize=(8, 5))
    plt.plot(d["t"], d["v_no_air"], "k--", label="Sem resistência do ar", alpha=0.7)
    plt.plot(
        d["t"],
        d["v_air"],
        "b-",
        label=r"Com resistência do ar ($A = 0.30\text{ m}^2$)",
        linewidth=2,
    )

    plt.axhline(
        v_term,
        color="r",
        linestyle=":",
        label=rf"Velocidade Terminal Teórica $v^* = {v_term:.2f}\text{{ m/s}}$",
    )

    plt.title("Tarefa 1b: Efeito da Resistência do Ar na Velocidade")
    plt.xlabel("Tempo $t$ (s)")
    plt.ylabel("Velocidade $v$ (m/s)")
    plt.legend(loc="center right")
    plt.grid(True, linestyle=":", alpha=0.6)
    plt.savefig("grafico_tarefa1b_com_ar.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa1b_com_ar.png")


# ==============================================================================
# 3. FIGURA 3: ITEM (c) - Variação da Área Útil A (A = 0.20, 0.30, 0.40 m²)
# ==============================================================================
def plot_item_c():
    areas = [0.20, 0.30, 0.40]
    cores = ["green", "blue", "purple"]
    dt = "0.01"

    plt.figure(figsize=(8, 5))

    for a_val, cor in zip(areas, cores):
        f_sim = f"tarefa-1_A{a_val:.2f}_dt{dt}-simulacao-v-tempo.dat"
        f_vt = f"tarefa-1_A{a_val:.2f}_dt{dt}-velocidade-terminal.dat"

        if os.path.exists(f_sim):
            d = carregar_dados_tempo(f_sim)
            v_term = carregar_v_terminal(f_vt) if os.path.exists(f_vt) else None

            lbl = rf"$A = {a_val:.2f}\text{{ m}}^2$"
            if v_term:
                lbl += rf" ($v^* = {v_term:.2f}\text{{ m/s}}$)"

            plt.plot(d["t"], d["v_air"], color=cor, label=lbl, linewidth=2)
            if v_term:
                plt.axhline(v_term, color=cor, linestyle=":", alpha=0.5)

    plt.title(r"Tarefa 1c: Influência da Área Útil $A$ na Velocidade Terminal")
    plt.xlabel("Tempo $t$ (s)")
    plt.ylabel("Velocidade $v$ (m/s)")
    plt.legend(loc="lower right")
    plt.grid(True, linestyle=":", alpha=0.6)
    plt.savefig("grafico_tarefa1c_variacao_area.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa1c_variacao_area.png")


# ==============================================================================
# 4. FIGURA 4: Comparação de Passo de Tempo dt (dt = 0.10s vs dt = 0.01s)
# ==============================================================================
def plot_comparacao_dt():
    f_dt1 = "tarefa-1_A0.30_dt0.10-simulacao-v-tempo.dat"
    f_dt2 = "tarefa-1_A0.30_dt0.01-simulacao-v-tempo.dat"

    d1 = carregar_dados_tempo(f_dt1)
    d2 = carregar_dados_tempo(f_dt2)

    plt.figure(figsize=(8, 5))
    plt.plot(
        d1["t"],
        d1["v_air"],
        "r--",
        label=r"Passo $dt = 0.10\text{ s}$",
        linewidth=1.5,
    )
    plt.plot(
        d2["t"],
        d2["v_air"],
        "b-",
        label=r"Passo $dt = 0.01\text{ s}$",
        linewidth=1.5,
        alpha=0.8,
    )

    plt.title(r"Convergência do Método Numérico: Comparação de Passos $dt$")
    plt.xlabel("Tempo $t$ (s)")
    plt.ylabel("Velocidade $v$ (m/s)")
    plt.legend(loc="lower right")
    plt.grid(True, linestyle=":", alpha=0.6)
    plt.savefig("grafico_tarefa1_convergencia_dt.png", dpi=300)
    plt.close()
    print("-> Salvo: grafico_tarefa1_convergencia_dt.png")


# ==============================================================================
# 5. IMPRESSÃO DA TABELA RESUMO (Deslocamentos e Velocidades Terminais)
# ==============================================================================
def imprimir_resumo():
    print(
        "\n==================================================================================="
    )
    print("TABELA RESUMO - DISTÂNCIA PERCORRIDA E VELOCIDADE TERMINAL")
    print(
        "==================================================================================="
    )
    print(
        f"{'Área A (m²)':<12} | {'dt (s)':<8} | {'Dist. Sem Ar (m)':<18} | {'Dist. Com Ar (m)':<18} | {'v* Teórica (m/s)':<18}"
    )
    print(
        "--------------------------------------------------------------------------------"
    )

    for a in ["0.20", "0.30", "0.40"]:
        for dt in ["0.10", "0.01"]:
            f_desl = f"tarefa-1_A{a}_dt{dt}-deslocamento.dat"
            f_vt = f"tarefa-1_A{a}_dt{dt}-velocidade-terminal.dat"

            r_no, r_air = carregar_deslocamento(f_desl)
            v_term = carregar_v_terminal(f_vt)
            print(
                f"{a:<12} | {dt:<8} | {r_no:<18.2f} | {r_air:<18.2f} | {v_term:<18.2f}"
            )
    print(
        "==================================================================================="
    )


if __name__ == "__main__":
    print("Processando dados e gerando gráficos para a Tarefa 1...")
    plot_item_a()
    plot_item_b()
    plot_item_c()
    plot_comparacao_dt()
    imprimir_resumo()
    print("Concluído!")
