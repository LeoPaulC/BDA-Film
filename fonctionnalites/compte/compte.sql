DROP TRIGGER IF EXISTS manage_compte ON compte;
DROP FUNCTION IF EXISTS gestion_compte;
DROP FUNCTION IF EXISTS test;
DROP FUNCTION IF EXISTS create_compte;


CREATE OR REPLACE FUNCTION create_compte() RETURNS INTEGER AS $$
DECLARE 
id INTEGER;
BEGIN
	INSERT INTO Compte(Solde) VALUES (
		0
	) RETURNING Id_compte INTO id;
	RETURN id;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION test() RETURNS INTEGER AS $$
DECLARE
chiffre INTEGER;
BEGIN 
	chiffre := create_compte();
	chiffre := chiffre +1000;
	RETURN chiffre;
END
$$ LANGUAGE plpgsql;




-- gestion de contrainte : TRIGGER + FONCTION ASSOCIEE


CREATE OR REPLACE FUNCTION gestion_compte() RETURNS trigger AS $$
DECLARE 
-- on recupere le type d'evenement effectué 
operation varchar(50) := TG_OP;
num INTEGER ;
BEGIN
	IF TG_OP = 'UPDATE' 
		THEN 	IF OLD.Solde > NEW.Solde -- alors on essaie RETIRER de l'argent
					THEN 	IF OLD.Solde <= OLD.Decouvert_autorise OR New.Solde<OLD.Decouvert_autorise
								THEN RAISE 'Montant du solde trop faible, veuillez alimenter votre compte : \n Solde = % \n Decouvert autorisé : % ',
					 				OLD.Solde ,OLD.Decouvert_autorise USING ERRCODE='20003';
							END IF;
				END IF;
	ELSE 
		IF OLD.Solde <> 0 THEN	RAISE EXCEPTION '

Le compte % n a pas été vidé
', OLD.Id_compte;
		END If;
		--PERFORM suppression_compte(OLD.Id_compte);
	END IF;
END
$$ LANGUAGE plpgsql;

-- manage_compte est un trigger s'occupe des update et des delete sur la table compte
CREATE TRIGGER manage_compte
	BEFORE UPDATE OR DELETE ON Compte
	FOR EACH ROW 
	EXECUTE PROCEDURE gestion_compte();