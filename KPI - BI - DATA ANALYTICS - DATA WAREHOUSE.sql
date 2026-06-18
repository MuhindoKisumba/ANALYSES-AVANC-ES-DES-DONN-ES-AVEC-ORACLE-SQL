/***************************************************************************************************
* ANALYSES AVANCÉES DES DONNÉES AVEC ORACLE SQL
* KPI - BI - DATA ANALYTICS - DATA WAREHOUSE
* Compatible Oracle 11g / 12c / 18c / 19c / 21c / 23ai
***************************************************************************************************/

---------------------------------------------------------------------------------------------------
-- 1. TOP 5 DES PRODUITS LES PLUS RENTABLES
---------------------------------------------------------------------------------------------------

SELECT *
FROM
(
    SELECT
        PRODUIT,
        SUM(MONTANT_TOTAL) CA_TOTAL
    FROM VENTES
    GROUP BY PRODUIT
    ORDER BY CA_TOTAL DESC
)
WHERE ROWNUM <= 5;

---------------------------------------------------------------------------------------------------
-- 2. TOP 5 DES PROVINCES LES PLUS RENTABLES
---------------------------------------------------------------------------------------------------

SELECT *
FROM
(
    SELECT
        PROVINCE,
        SUM(MONTANT_TOTAL) CA_TOTAL
    FROM VENTES
    GROUP BY PROVINCE
    ORDER BY CA_TOTAL DESC
)
WHERE ROWNUM <= 5;

---------------------------------------------------------------------------------------------------
-- 3. PRODUITS AYANT LE PLUS GRAND VOLUME DE VENTE
---------------------------------------------------------------------------------------------------

SELECT
    PRODUIT,
    SUM(QUANTITE) QUANTITE_TOTALE
FROM VENTES
GROUP BY PRODUIT
ORDER BY QUANTITE_TOTALE DESC;

---------------------------------------------------------------------------------------------------
-- 4. POURCENTAGE DE CONTRIBUTION PAR PRODUIT
---------------------------------------------------------------------------------------------------

SELECT
    PRODUIT,
    SUM(MONTANT_TOTAL) CA,
    ROUND(
        SUM(MONTANT_TOTAL) * 100 /
        SUM(SUM(MONTANT_TOTAL)) OVER (),
        2
    ) POURCENTAGE
FROM VENTES
GROUP BY PRODUIT
ORDER BY CA DESC;

---------------------------------------------------------------------------------------------------
-- 5. EVOLUTION DES VENTES PAR MOIS
---------------------------------------------------------------------------------------------------

SELECT
    TO_CHAR(DATE_VENTE,'YYYY-MM') MOIS,
    SUM(MONTANT_TOTAL) CA
FROM VENTES
GROUP BY TO_CHAR(DATE_VENTE,'YYYY-MM')
ORDER BY MOIS;

---------------------------------------------------------------------------------------------------
-- 6. EVOLUTION DES VENTES PAR TRIMESTRE
---------------------------------------------------------------------------------------------------

SELECT
    TO_CHAR(DATE_VENTE,'YYYY') ANNEE,
    TO_CHAR(DATE_VENTE,'Q') TRIMESTRE,
    SUM(MONTANT_TOTAL) CA
FROM VENTES
GROUP BY
    TO_CHAR(DATE_VENTE,'YYYY'),
    TO_CHAR(DATE_VENTE,'Q')
ORDER BY
    ANNEE,
    TRIMESTRE;

---------------------------------------------------------------------------------------------------
-- 7. EVOLUTION DES VENTES PAR JOUR
---------------------------------------------------------------------------------------------------

SELECT
    TRUNC(DATE_VENTE) JOUR,
    SUM(MONTANT_TOTAL) TOTAL
FROM VENTES
GROUP BY TRUNC(DATE_VENTE)
ORDER BY JOUR;

---------------------------------------------------------------------------------------------------
-- 8. DETECTION DES BAISSES DE VENTE
---------------------------------------------------------------------------------------------------

WITH VENTES_MENSUELLES AS
(
    SELECT
        TO_CHAR(DATE_VENTE,'YYYY-MM') MOIS,
        SUM(MONTANT_TOTAL) CA
    FROM VENTES
    GROUP BY TO_CHAR(DATE_VENTE,'YYYY-MM')
)
SELECT
    MOIS,
    CA,
    LAG(CA) OVER(ORDER BY MOIS) CA_PRECEDENT,
    CA - LAG(CA) OVER(ORDER BY MOIS) VARIATION
FROM VENTES_MENSUELLES;

---------------------------------------------------------------------------------------------------
-- 9. ANALYSE DES PRODUITS LES MOINS PERFORMANTS
---------------------------------------------------------------------------------------------------

SELECT
    PRODUIT,
    SUM(MONTANT_TOTAL) CA
FROM VENTES
GROUP BY PRODUIT
ORDER BY CA ASC;

---------------------------------------------------------------------------------------------------
-- 10. ANALYSE PARETO 80/20
---------------------------------------------------------------------------------------------------

WITH PARETO AS
(
    SELECT
        PRODUIT,
        SUM(MONTANT_TOTAL) CA,
        SUM(SUM(MONTANT_TOTAL))
        OVER(ORDER BY SUM(MONTANT_TOTAL) DESC)
        CA_CUMULE,
        SUM(SUM(MONTANT_TOTAL))
        OVER()
        CA_TOTAL
    FROM VENTES
    GROUP BY PRODUIT
)
SELECT
    PRODUIT,
    CA,
    ROUND((CA_CUMULE / CA_TOTAL)*100,2) POURCENTAGE
FROM PARETO
ORDER BY CA DESC;

---------------------------------------------------------------------------------------------------
-- 11. CLASSEMENT DES PRODUITS AVEC DENSE_RANK
---------------------------------------------------------------------------------------------------

SELECT
    PRODUIT,
    SUM(MONTANT_TOTAL) CA,
    DENSE_RANK()
    OVER(
        ORDER BY SUM(MONTANT_TOTAL) DESC
    ) RANG
FROM VENTES
GROUP BY PRODUIT;

---------------------------------------------------------------------------------------------------
-- 12. ANALYSE DES VENTES PAR SEMAINE
---------------------------------------------------------------------------------------------------

SELECT
    TO_CHAR(DATE_VENTE,'IYYY-IW') SEMAINE,
    SUM(MONTANT_TOTAL) CA
FROM VENTES
GROUP BY TO_CHAR(DATE_VENTE,'IYYY-IW')
ORDER BY SEMAINE;

---------------------------------------------------------------------------------------------------
-- 13. ANALYSE DES PERFORMANCES REGIONALES
---------------------------------------------------------------------------------------------------

SELECT
    PROVINCE,
    COUNT(*) NB_VENTES,
    SUM(MONTANT_TOTAL) CA,
    AVG(MONTANT_TOTAL) PANIER_MOYEN
FROM VENTES
GROUP BY PROVINCE
ORDER BY CA DESC;

---------------------------------------------------------------------------------------------------
-- 14. DETECTION DES VALEURS ANORMALES
---------------------------------------------------------------------------------------------------

SELECT
    *
FROM VENTES
WHERE MONTANT_TOTAL >
(
    SELECT
        AVG(MONTANT_TOTAL)
        + 3 * STDDEV(MONTANT_TOTAL)
    FROM VENTES
);

---------------------------------------------------------------------------------------------------
-- 15. ANALYSE DE SAISONNALITE
---------------------------------------------------------------------------------------------------

SELECT
    TO_CHAR(DATE_VENTE,'MONTH') MOIS,
    SUM(MONTANT_TOTAL) CA
FROM VENTES
GROUP BY TO_CHAR(DATE_VENTE,'MONTH')
ORDER BY CA DESC;

---------------------------------------------------------------------------------------------------
-- 16. REPARTITION DES VENTES PAR JOUR DE LA SEMAINE
---------------------------------------------------------------------------------------------------

SELECT
    TO_CHAR(DATE_VENTE,'DAY') JOUR,
    COUNT(*) NOMBRE_VENTES,
    SUM(MONTANT_TOTAL) CA
FROM VENTES
GROUP BY TO_CHAR(DATE_VENTE,'DAY')
ORDER BY CA DESC;

---------------------------------------------------------------------------------------------------
-- 17. TAUX DE CROISSANCE MENSUEL
---------------------------------------------------------------------------------------------------

WITH CROISSANCE AS
(
    SELECT
        TO_CHAR(DATE_VENTE,'YYYY-MM') MOIS,
        SUM(MONTANT_TOTAL) CA
    FROM VENTES
    GROUP BY TO_CHAR(DATE_VENTE,'YYYY-MM')
)
SELECT
    MOIS,
    CA,
    ROUND(
        (
            (CA - LAG(CA) OVER(ORDER BY MOIS))
            /
            LAG(CA) OVER(ORDER BY MOIS)
        ) * 100,
        2
    ) TAUX_CROISSANCE
FROM CROISSANCE;

---------------------------------------------------------------------------------------------------
-- 18. PRODUITS LES PLUS STABLES
---------------------------------------------------------------------------------------------------

SELECT
    PRODUIT,
    STDDEV(MONTANT_TOTAL) ECART_TYPE
FROM VENTES
GROUP BY PRODUIT
ORDER BY ECART_TYPE;

---------------------------------------------------------------------------------------------------
-- 19. PREVISION SIMPLE DES VENTES
---------------------------------------------------------------------------------------------------

SELECT
    TO_CHAR(DATE_VENTE,'YYYY-MM') MOIS,
    SUM(MONTANT_TOTAL) CA,
    AVG(SUM(MONTANT_TOTAL))
    OVER(
        ORDER BY TO_CHAR(DATE_VENTE,'YYYY-MM')
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) PREVISION
FROM VENTES
GROUP BY TO_CHAR(DATE_VENTE,'YYYY-MM');

---------------------------------------------------------------------------------------------------
-- 20. KPI EXECUTIF GLOBAL
---------------------------------------------------------------------------------------------------

SELECT
    COUNT(*) TOTAL_VENTES,
    COUNT(DISTINCT PRODUIT) NB_PRODUITS,
    COUNT(DISTINCT PROVINCE) NB_PROVINCES,
    SUM(QUANTITE) QUANTITE_VENDUE,
    SUM(MONTANT_TOTAL) CHIFFRE_AFFAIRES,
    AVG(MONTANT_TOTAL) PANIER_MOYEN,
    MIN(MONTANT_TOTAL) PLUS_PETITE_VENTE,
    MAX(MONTANT_TOTAL) PLUS_GRANDE_VENTE
FROM VENTES;

---------------------------------------------------------------------------------------------------
-- 21. CREATION D'UNE VUE BI POUR POWER BI / GRAFANA
---------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW VW_BI_VENTES AS
SELECT
    DATE_VENTE,
    TO_CHAR(DATE_VENTE,'YYYY') ANNEE,
    TO_CHAR(DATE_VENTE,'MM') MOIS,
    TO_CHAR(DATE_VENTE,'Q') TRIMESTRE,
    PROVINCE,
    VILLE,
    PRODUIT,
    CATEGORIE,
    QUANTITE,
    PRIX_UNITAIRE,
    MONTANT_TOTAL
FROM VENTES;

---------------------------------------------------------------------------------------------------
-- 22. TABLEAU DE BORD DECISIONNEL
---------------------------------------------------------------------------------------------------

SELECT
    PROVINCE,
    COUNT(*) NB_VENTES,
    SUM(MONTANT_TOTAL) CA,
    ROUND(AVG(MONTANT_TOTAL),2) PANIER_MOYEN,
    ROUND(
        SUM(MONTANT_TOTAL) * 100
        /
        SUM(SUM(MONTANT_TOTAL)) OVER(),
        2
    ) PART_MARCHE
FROM VENTES
GROUP BY PROVINCE
ORDER BY CA DESC;

---------------------------------------------------------------------------------------------------
-- 23. ANALYSE DES 12 DERNIERS MOIS
---------------------------------------------------------------------------------------------------

SELECT
    TO_CHAR(DATE_VENTE,'YYYY-MM') MOIS,
    SUM(MONTANT_TOTAL) CA
FROM VENTES
WHERE DATE_VENTE >= ADD_MONTHS(SYSDATE,-12)
GROUP BY TO_CHAR(DATE_VENTE,'YYYY-MM')
ORDER BY MOIS;

---------------------------------------------------------------------------------------------------
-- 24. ANALYSE DE RENTABILITE
---------------------------------------------------------------------------------------------------

SELECT
    PRODUIT,
    SUM(MONTANT_TOTAL) CA,
    SUM(QUANTITE) QUANTITE,
    ROUND(SUM(MONTANT_TOTAL)/SUM(QUANTITE),2) REVENU_MOYEN
FROM VENTES
GROUP BY PRODUIT
ORDER BY CA DESC;

---------------------------------------------------------------------------------------------------
-- 25. SCORECARD EXECUTIVE
---------------------------------------------------------------------------------------------------

SELECT
    'CHIFFRE_AFFAIRES' KPI,
    SUM(MONTANT_TOTAL) VALEUR
FROM VENTES

UNION ALL

SELECT
    'NOMBRE_VENTES',
    COUNT(*)
FROM VENTES

UNION ALL

SELECT
    'PANIER_MOYEN',
    ROUND(AVG(MONTANT_TOTAL),2)
FROM VENTES

UNION ALL

SELECT
    'QUANTITE_VENDUE',
    SUM(QUANTITE)
FROM VENTES;

---------------------------------------------------------------------------------------------------
-- FIN
---------------------------------------------------------------------------------------------------