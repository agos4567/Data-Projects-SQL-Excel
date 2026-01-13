-- Borramos la anterior para limpiar errores
DROP TABLE IF EXISTS walmart_sales;


CREATE TABLE walmart_sales (
    store INT,
    "Date" DATE, -- Usamos "Date" con mayuscula para que coincida con el error
    weekly_sales NUMERIC(20,2),
    holiday_flag INT,
    temperature NUMERIC(20,4),
    fuel_price NUMERIC(20,4),
    cpi NUMERIC(20,8),
    unemployment NUMERIC(20,4)
);


SELECT
    ROUND(AVG(weekly_sales), 2) AS promedio_ventas,
    ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY weekly_sales) AS NUMERIC), 2) AS mediana_ventas,
    ROUND(AVG(weekly_sales) - CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY weekly_sales) AS NUMERIC), 2) AS diferencia
FROM walmart_sales;



SELECT ROUND(STDDEV(weekly_sales),2) AS desviacion_estandar,
       ROUND(VARIANCE(weekly_sales),2) as varianza_tecnica,
       ROUND((STDDEV(weekly_sales)/AVG(weekly_sales)) *100,2) as porcentaje_variacion_CV
FROM walmart_sales;


WITH estadisticas AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY weekly_sales) AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY weekly_sales) AS q3
    FROM walmart_sales
),
-- PASO 2: Calculamos el Rango Intercuartilico (IQR) y los Límites Críticos
limites AS (
    SELECT
        q1,
        q3,
        (q3 - q1) AS iqr,
        (q1 - 1.5 * (q3 - q1)) AS limite_inferior,
        (q3 + 1.5 * (q3 - q1)) AS limite_superior
    FROM estadisticas
)
-- PASO 3: Filtramos las ventas que estan FUERA de esos límites
SELECT * FROM walmart_sales, limites
WHERE weekly_sales > limite_superior
   OR weekly_sales < limite_inferior
ORDER BY weekly_sales desc
LIMIT 10;



WITH umbral AS (
    SELECT PERCENTILE_CONT(0.9) 
           WITHIN GROUP (ORDER BY weekly_sales) AS p90
    FROM walmart_sales
)
SELECT
    holiday_flag,
    COUNT(*) AS cuantas_semanas,
    ROUND(AVG(weekly_sales)::numeric, 2) AS promedio_ventas
FROM walmart_sales, umbral
WHERE weekly_sales >= p90
GROUP BY holiday_flag;











WITH calculoGlobal AS (
    SELECT 
        store,
        AVG(weekly_sales) AS promedio_global
    FROM walmart_sales
    GROUP BY store
)
SELECT
    w.store AS categoria,
    w."Date" AS fecha,
    cg.promedio_global,
    w.weekly_sales AS ventas_semanales,
    ROUND(w.weekly_sales - cg.promedio_global, 2) AS desempeño_vs_promedio
FROM walmart_sales w
INNER JOIN calculoGlobal cg
    ON w.store = cg.store
ORDER BY desempeño_vs_promedio DESC;



