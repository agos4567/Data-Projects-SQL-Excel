# 🛒 Walmart Sales: Análisis Estadístico y Detección de Patrones

<p align="center">
  <img src="Images/Walmart_logo.png" width="300" alt="Walmart Logo">
</p>

## 📌 1.0 Overview
Este análisis busca identificar patrones de ventas en Walmart para entender qué factores (festivos, ubicación) impulsan los picos de rendimiento. A través de este estudio, desglosamos la estabilidad operativa de la empresa y el comportamiento de sus valores extremos utilizando **PostgreSQL**.

* **Dataset:** [Walmart Sales Dataset (Kaggle)](https://www.kaggle.com/datasets/mikhail1681/walmart-sales)
* **Herramientas:** SQL (PostgreSQL), CTEs, Window Functions.
* **Enfoque:** Análisis descriptivo de tendencia central, dispersión y posición.

## 🛠️ 2.0 Etapas del Análisis

### 2.1 Tendencia Central (El Corazón de los Datos)
* **Tarea:** Calcular el promedio y la mediana de las ventas semanales.
* **Concepto:** Se utilizó `AVG` y `PERCENTILE_CONT(0.5)` para hallar la mediana y entender el valor central real, mitigando el efecto de valores atípicos.

![Captura de Resultados](images/resultado_tendencia.png)

![Captura de Resultados](images/query_tendencia.png)