# ANALYSES AVANCÉES DES DONNÉES AVEC ORACLE SQL

## Présentation

Ce projet fournit une collection de requêtes Oracle SQL avancées destinées à l'analyse décisionnelle, au reporting, à la Business Intelligence (BI) et à l'aide à la décision.

Les scripts exploitent les fonctions analytiques Oracle afin de produire des indicateurs de performance (KPI), des analyses de tendances, des classements, des prévisions simples et des tableaux de bord décisionnels exploitables dans Oracle SQL Developer, Oracle APEX, Power BI, Grafana ou tout autre outil de visualisation de données.

---

# Objectifs

Ce projet permet notamment de :

- Analyser les ventes et les revenus.
- Identifier les produits les plus performants.
- Mesurer les performances régionales.
- Détecter les anomalies et valeurs atypiques.
- Réaliser des analyses temporelles.
- Calculer les KPI stratégiques.
- Construire des tableaux de bord décisionnels.
- Alimenter des plateformes BI.
- Préparer les données pour un Data Warehouse.

---

# Technologies

- Oracle Database 11g
- Oracle Database 12c
- Oracle Database 18c
- Oracle Database 19c
- Oracle Database 21c
- Oracle Database 23ai

---

# Structure de la Table Utilisée

Le script suppose l'existence d'une table :

```sql
VENTES
```

Exemple de structure :

```sql
CREATE TABLE VENTES
(
    ID_VENTE NUMBER PRIMARY KEY,
    DATE_VENTE DATE,
    PROVINCE VARCHAR2(100),
    VILLE VARCHAR2(100),
    PRODUIT VARCHAR2(100),
    CATEGORIE VARCHAR2(100),
    QUANTITE NUMBER,
    PRIX_UNITAIRE NUMBER(12,2),
    MONTANT_TOTAL NUMBER(12,2)
);
```

---

# Fonctionnalités d'Analyse

## 1. Top Produits Rentables

Objectif :

Identifier les produits générant le plus de chiffre d'affaires.

Indicateurs :

- Produit
- Chiffre d'affaires total

Utilité :

- Gestion commerciale
- Optimisation du catalogue

---

## 2. Top Provinces Rentables

Objectif :

Identifier les provinces contribuant le plus aux revenus.

Indicateurs :

- Province
- Chiffre d'affaires total

Utilité :

- Expansion commerciale
- Analyse territoriale

---

## 3. Produits les Plus Vendus

Objectif :

Mesurer le volume des ventes.

Indicateurs :

- Quantité vendue
- Classement des produits

Utilité :

- Gestion des stocks
- Prévision des approvisionnements

---

## 4. Contribution de Chaque Produit

Objectif :

Mesurer le poids économique de chaque produit.

Indicateurs :

- Pourcentage de contribution
- Part de marché interne

Utilité :

- Analyse de portefeuille
- Priorisation commerciale

---

## 5. Évolution Mensuelle des Ventes

Objectif :

Observer les tendances de vente.

Indicateurs :

- Chiffre d'affaires mensuel

Utilité :

- Pilotage stratégique
- Prévisions budgétaires

---

## 6. Évolution Trimestrielle

Objectif :

Mesurer la croissance sur des périodes plus longues.

Indicateurs :

- Revenus trimestriels

Utilité :

- Reporting financier
- Tableaux de bord exécutifs

---

## 7. Évolution Quotidienne

Objectif :

Suivre l'activité opérationnelle.

Indicateurs :

- Ventes journalières

Utilité :

- Monitoring temps réel
- Détection rapide des variations

---

## 8. Détection des Baisses de Ventes

Objectif :

Identifier les périodes de régression.

Fonctions utilisées :

- LAG()

Utilité :

- Gestion proactive
- Détection précoce des problèmes

---

## 9. Produits les Moins Performants

Objectif :

Détecter les produits à faible rendement.

Utilité :

- Rationalisation du catalogue
- Optimisation des coûts

---

## 10. Analyse Pareto 80/20

Objectif :

Identifier les produits générant la majorité des revenus.

Principe :

- 20 % des produits produisent souvent 80 % du chiffre d'affaires.

Utilité :

- Priorisation stratégique
- Optimisation commerciale

---

## 11. Classement Dynamique des Produits

Fonction Oracle utilisée :

```sql
DENSE_RANK()
```

Objectif :

Classer automatiquement les produits selon leurs performances.

---

## 12. Analyse Hebdomadaire

Objectif :

Étudier les ventes semaine par semaine.

Utilité :

- Analyse opérationnelle
- Détection des cycles courts

---

## 13. Analyse Régionale

Objectif :

Comparer les performances entre provinces.

Indicateurs :

- Nombre de ventes
- Chiffre d'affaires
- Panier moyen

---

## 14. Détection d'Anomalies

Fonctions statistiques :

```sql
AVG()
STDDEV()
```

Objectif :

Identifier les ventes exceptionnellement élevées.

Utilité :

- Contrôle qualité
- Audit
- Détection de fraude

---

## 15. Analyse de Saisonnalité

Objectif :

Identifier les mois les plus rentables.

Utilité :

- Prévisions commerciales
- Planification budgétaire

---

## 16. Répartition par Jour de la Semaine

Objectif :

Identifier les jours les plus actifs.

Utilité :

- Planification du personnel
- Gestion des ressources

---

## 17. Taux de Croissance

Objectif :

Mesurer l'évolution du chiffre d'affaires.

Formule :

```text
((CA actuel - CA précédent) / CA précédent) × 100
```

Utilité :

- Suivi de performance
- Analyse stratégique

---

## 18. Produits les Plus Stables

Mesure :

```sql
STDDEV()
```

Objectif :

Identifier les produits les plus réguliers.

Utilité :

- Réduction des risques commerciaux

---

## 19. Prévision Simple

Méthode :

Moyenne mobile sur 3 périodes.

Fonctions :

```sql
AVG()
OVER()
```

Utilité :

- Prévisions rapides
- Reporting exécutif

---

## 20. KPI Exécutifs

Le script calcule automatiquement :

- Nombre total de ventes
- Nombre de produits
- Nombre de provinces
- Quantité vendue
- Chiffre d'affaires total
- Panier moyen
- Vente minimale
- Vente maximale

---

## 21. Vue BI

Vue créée :

```sql
VW_BI_VENTES
```

Objectif :

Servir directement les outils :

- Power BI
- Grafana
- Oracle Analytics
- Tableau
- Apache Superset

---

## 22. Tableau de Bord Décisionnel

Indicateurs :

- Nombre de ventes
- Chiffre d'affaires
- Panier moyen
- Part de marché

Utilité :

- Comité de direction
- Reporting stratégique

---

## 23. Analyse des 12 Derniers Mois

Objectif :

Mesurer les performances récentes.

Fonction Oracle :

```sql
ADD_MONTHS()
```

Utilité :

- Suivi annuel glissant

---

## 24. Analyse de Rentabilité

Indicateurs :

- Chiffre d'affaires
- Quantité vendue
- Revenu moyen par unité

Utilité :

- Optimisation des marges

---

## 25. Scorecard Exécutive

KPI affichés :

- Chiffre d'affaires
- Nombre de ventes
- Panier moyen
- Quantité vendue

Utilité :

- Dashboard Direction Générale
- Reporting Exécutif

---

# Cas d'Utilisation

Ce projet peut être utilisé pour :

- Commerce
- Distribution
- Santé publique
- ONG
- Télécommunications
- Banques
- Assurances
- Industrie
- Administration publique
- Universités
- Recherche

---

# Intégration BI

Compatible avec :

- Oracle SQL Developer
- Oracle APEX
- Power BI
- Grafana
- Tableau
- Apache Superset
- Metabase
- Pentaho
- Talend
- Airflow

---

# Niveau du Projet

Niveau : Intermédiaire à Expert

Domaines couverts :

- Data Analytics
- Data Warehouse
- Business Intelligence
- Reporting
- KPI
- Statistiques
- Prévision
- Analyse Décisionnelle
- Oracle SQL Analytique

---

# Auteur
MUHINDO KISUMBA

Projet Oracle SQL Analytics

Version : 1.0

Compatible :
Oracle Database 11g, 12c, 18c, 19c, 21c et 23ai.

---
FIN DU README
