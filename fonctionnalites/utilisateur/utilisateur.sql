CREATE FUNCTION create_user(email VARCHAR, mdp VARCHAR,telephone VARCHAR, Id_lieu Lieu.Id_lieu%TYPE,
 Id_personne Personne.Id_personne%TYPE, Id_compte Compte.Id_compte%TYPE) RETURNS text AS $$
DECLARE 

BEGIN
	INSERT INTO Utilisateur VALUES (
		Email,
		Mdp,
		Telephone,
		Id_lieu,
		Id_personne,
		Id_compte
	);
END
$$ LANGUAGE plpgsql;


CREATE TRIGGER new_user 
	BEFORE INSERT
	ON comptes
	FOR EACH ROW 
	WHEN( OLD.solde < 0)
	EXECUTE PROCEDURE alert_solde_negatif();




CREATE OR REPLACE FUNCTION create_user()
RETURNS trigger AS $$
DECLARE 
-- on recupere le type d'evenement effectué 
operation varchar(50) := TG_OP;
montant integer := 0;
BEGIN
	IF TG_OP = 'UPDATE' 
		THEN IF OLD.solde < NEW.solde -- alors on a DEPOSE de l'argent
			THEN operation := 'DEPOT';
				montant := NEW.solde - OLD.solde ;
			ELSE operation := 'RETRAIT';
				montant := OLD.solde - NEW.solde ;

		END IF;
	ELSIF TG_OP = 'INSERT'
		THEN operation := 'OUVERTURE';
	ELSE operation := 'FERMETURE';
	END IF;
	INSERT INTO audit VALUES (
		comptes.numcompte, 
		date(now()), -- date de l'operation
		operation,	-- type operation
		montant	-- montant --> positif
	);
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER fill_audit
	AFTER UPDATE OR DELETE OR INSERT ON Utilisateur
	FOR EACH ROW 
	EXECUTE PROCEDURE remplissage_audit();



