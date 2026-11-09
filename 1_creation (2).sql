-- create schema mma;
-- use mma;
DROP TABLE IF EXISTS participe;
DROP TABLE IF EXISTS est_obligatoire;
DROP TABLE IF EXISTS finance;
DROP TABLE IF EXISTS billet;
DROP TABLE IF EXISTS spectateur;
DROP TABLE IF EXISTS sponsor;
DROP TABLE IF EXISTS évènement;
DROP TABLE IF EXISTS media;
DROP TABLE IF EXISTS performance;
DROP TABLE IF EXISTS licence;
DROP TABLE IF EXISTS combat;
DROP TABLE IF EXISTS arbitre;
DROP TABLE IF EXISTS combattant;
DROP TABLE IF EXISTS organisation;

-- 1. Table Organisation
CREATE TABLE organisation (
    ID_organisation INT AUTO_INCREMENT PRIMARY KEY,
    Nom_organisation VARCHAR(100) NOT NULL,
    Email_organisation VARCHAR(100) UNIQUE
);

-- 2. Table Arbitre
CREATE TABLE arbitre (
    ID_arbitre INT AUTO_INCREMENT PRIMARY KEY,
    Nom_arbitre VARCHAR(50) NOT NULL,
    Prénom_arbitre VARCHAR(50) NOT NULL,
    Nationalité VARCHAR(50)
);

-- 3. Table Combattant
CREATE TABLE combattant (
    Combattant_ID INT AUTO_INCREMENT PRIMARY KEY,
    Prénom_combattant VARCHAR(50) NOT NULL,
    Nom_combattant VARCHAR(50) NOT NULL,
    Date_de_naissance DATE NOT NULL,
    Nationalité VARCHAR(50) NOT NULL,
    Catégorie_de_poids VARCHAR(30) NOT NULL,
    Statut_médical VARCHAR(30) NOT NULL DEFAULT 'Apte',
    Dernier_certificat_médical DATE NOT NULL
);

-- 4. Table Licence
CREATE TABLE licence (
    Numéro_Licence_Sportive VARCHAR(50) PRIMARY KEY,
    Date_délivrance DATE NOT NULL,
    Date_expiration DATE NOT NULL,
    ID_organisation INT NOT NULL,
    Combattant_ID INT NOT NULL UNIQUE,
    CONSTRAINT fk_licence_organisation FOREIGN KEY (ID_organisation) 
        REFERENCES organisation(ID_organisation) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_licence_combattant FOREIGN KEY (Combattant_ID) 
        REFERENCES combattant(Combattant_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 5. Table Performance
CREATE TABLE performance (
    ID_performance INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_de_victoires INT DEFAULT 0,
    Nombre_de_défaites INT DEFAULT 0,
    Nombre_de_matchs_nuls INT DEFAULT 0,
    Nombre_de_victoires_par_ko INT DEFAULT 0,
    Nombre_de_victoires_par_soumission INT DEFAULT 0,
    Combattant_ID INT NOT NULL UNIQUE,
    CONSTRAINT fk_perf_combattant FOREIGN KEY (Combattant_ID) 
        REFERENCES combattant(Combattant_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. Table Media
CREATE TABLE media (
    ID_media INT AUTO_INCREMENT PRIMARY KEY,
    Nom_media VARCHAR(100) NOT NULL,
    Type_media VARCHAR(50) NOT NULL
);

-- 7. Table Combat
CREATE TABLE combat (
    ID_combat INT AUTO_INCREMENT PRIMARY KEY,
    Résultat_combat VARCHAR(50),
    Durée_combat INT, -- en secondes
    Poids_autorisé DECIMAL(5,2) NOT NULL,
    ID_arbitre INT,
    CONSTRAINT fk_combat_arbitre FOREIGN KEY (ID_arbitre) 
        REFERENCES arbitre(ID_arbitre) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 8. Table Évènement
CREATE TABLE évènement (
    ID_évènement INT AUTO_INCREMENT PRIMARY KEY,
    Nom_évènement VARCHAR(100) NOT NULL,
    Date_évènement DATE NOT NULL,
    Lieu_évènement VARCHAR(100) NOT NULL,
    ID_media INT,
    ID_combat INT,
    ID_organisation INT NOT NULL,
    CONSTRAINT fk_event_media FOREIGN KEY (ID_media) 
        REFERENCES media(ID_media) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_event_combat FOREIGN KEY (ID_combat) 
        REFERENCES combat(ID_combat) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_event_org FOREIGN KEY (ID_organisation) 
        REFERENCES organisation(ID_organisation) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 9. Table Spectateur
CREATE TABLE spectateur (
    Téléphone_spectateur VARCHAR(20) PRIMARY KEY,
    Nom_spectateur VARCHAR(50) NOT NULL,
    Prénom_spectateur VARCHAR(50) NOT NULL,
    Email_spectateur VARCHAR(100) NOT NULL
);

-- 10. Table Billet
CREATE TABLE billet (
    ID_billet INT AUTO_INCREMENT PRIMARY KEY,
    Catégorie_billet VARCHAR(50) NOT NULL,
    Prix_billet DECIMAL(8,2) NOT NULL,
    ID_évènement INT NOT NULL,
    Téléphone_spectateur VARCHAR(20),
    ID_organisation INT NOT NULL,
    CONSTRAINT fk_billet_event FOREIGN KEY (ID_évènement) 
        REFERENCES évènement(ID_évènement) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_billet_spec FOREIGN KEY (Téléphone_spectateur) 
        REFERENCES spectateur(Téléphone_spectateur) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_billet_org FOREIGN KEY (ID_organisation) 
        REFERENCES organisation(ID_organisation) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 11. Table Sponsor
CREATE TABLE sponsor (
    ID_Sponsor INT AUTO_INCREMENT PRIMARY KEY,
    Nom_sponsor VARCHAR(100) NOT NULL,
    Type_de_sponsoring VARCHAR(50),
    Montant_sponsoring DECIMAL(10,2) NOT NULL,
    Début_contrat_sponsor DATE NOT NULL,
    Fin_contrat_sponsor DATE NOT NULL
);

-- 12. Tables d'Association (Relation N-N)
CREATE TABLE participe (
    Combattant_ID INT NOT NULL,
    ID_combat INT NOT NULL,
    PRIMARY KEY (Combattant_ID, ID_combat),
    CONSTRAINT fk_part_combattant FOREIGN KEY (Combattant_ID) 
        REFERENCES combattant(Combattant_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_part_combat FOREIGN KEY (ID_combat) 
        REFERENCES combat(ID_combat) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE est_obligatoire (
    Numéro_Licence_Sportive VARCHAR(50) NOT NULL,
    ID_combat INT NOT NULL,
    PRIMARY KEY (Numéro_Licence_Sportive, ID_combat),
    CONSTRAINT fk_obl_licence FOREIGN KEY (Numéro_Licence_Sportive) 
        REFERENCES licence(Numéro_Licence_Sportive) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_obl_combat FOREIGN KEY (ID_combat) 
        REFERENCES combat(ID_combat) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE finance (
    ID_évènement INT NOT NULL,
    ID_Sponsor INT NOT NULL,
    PRIMARY KEY (ID_évènement, ID_Sponsor),
    CONSTRAINT fk_fin_event FOREIGN KEY (ID_évènement) 
        REFERENCES évènement(ID_évènement) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_fin_sponsor FOREIGN KEY (ID_Sponsor) 
        REFERENCES sponsor(ID_Sponsor) ON DELETE CASCADE ON UPDATE CASCADE
);
