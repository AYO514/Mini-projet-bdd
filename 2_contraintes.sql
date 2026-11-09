use mma;
-- 1. Validation du statut médical du combattant
ALTER TABLE combattant 
ADD CONSTRAINT chk_sstatut_medical 
CHECK (Statut_médical IN ('Apte', 'Inapte', 'Suspendu'));

-- 2. Validation des catégories de poids MMA courantes
ALTER TABLE combattant 
ADD CONSTRAINT chk_categorie_poids 
CHECK (Catégorie_de_poids IN ('Poids Mouche', 'Poids Coq', 'Poids Plume', 'Poids Léger', 'Poids Mi-Moyen', 'Poids Moyen', 'Poids Mi-Lourd', 'Poids Lourd'));

-- 3. Le prix d'un billet doit être strictement positif
ALTER TABLE billet 
ADD CONSTRAINT chk_prix_billet 
CHECK (Prix_billet > 0);

-- 4. Le montant d'un sponsoring doit être positif ou nul
ALTER TABLE sponsor 
ADD CONSTRAINT chk_montant_sponsor 
CHECK (Montant_sponsoring >= 0);

-- 5. Vérification de la cohérence des dates de sponsoring (Fin > Début)
ALTER TABLE sponsor 
ADD CONSTRAINT chk_dates_sponsor 
CHECK (Fin_contrat_sponsor >= Début_contrat_sponsor);

-- 6. Vérification de la cohérence des dates de licence (Expiration > Délivrance)
ALTER TABLE licence 
ADD CONSTRAINT chk_dates_licence 
CHECK (Date_expiration > Date_délivrance);

-- 7. Durée du combat positive
ALTER TABLE combat 
ADD CONSTRAINT chk_duree_combat 
CHECK (Durée_combat IS NULL OR Durée_combat > 0);

-- 8. Validations des nombres de victoires et défaites dans performance (non négatifs)
ALTER TABLE performance 
ADD CONSTRAINT chk_perf_victoires CHECK (Nombre_de_victoires >= 0),
ADD CONSTRAINT chk_perf_defaites CHECK (Nombre_de_défaites >= 0),
ADD CONSTRAINT chk_perf_nuls CHECK (Nombre_de_matchs_nuls >= 0),
ADD CONSTRAINT chk_perf_ko CHECK (Nombre_de_victoires_par_ko >= 0),
ADD CONSTRAINT chk_perf_sub CHECK (Nombre_de_victoires_par_soumission >= 0);

-- 9. Email spectateur valide (contient '@')
ALTER TABLE spectateur 
ADD CONSTRAINT chk_email_spectateur 
CHECK (Email_spectateur LIKE '%@%.%');
