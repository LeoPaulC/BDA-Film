DROP FUNCTION IF EXISTS create_compte;
DROP TRIGGER IF EXISTS manage_compte ON compte;
DROP FUNCTION IF EXISTS gestion_compte;


CREATE FUNCTION create_compte() RETURNS text AS $$
DECLARE 
decouvert_autorise INTEGER := -10;
total INTEGER;
res VARCHAR(80) := 'Nombre de compte au total :';
BEGIN
	INSERT INTO Compte(Solde,Decouvert_autorise) VALUES (
		0,
		decouvert_autorise
	);
	SELECT count(*) into total FROM Compte;
	RETURN CONCAT(res,total);
END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION gestion_compte()
RETURNS trigger AS $$
DECLARE 
-- on recupere le type d'evenement effectué 
operation varchar(50) := TG_OP;
BEGIN
	IF TG_OP = 'UPDATE' 
		THEN 	IF OLD.Solde > NEW.Solde -- alors on essaie RETIRER de l'argent
					THEN 	IF OLD.Solde <= OLD.Decouvert_autorise 
								THEN RAISE 'Montant du solde trop faible, veuillez alimenter votre compte : \n Solde = % \n Decouvert autorisé : % ',
					 				OLD.Solde ,OLD.Decouvert_autorise USING ERRCODE='20003';
							END IF;
				END IF;
	ELSE operation := 'FERMETURE';
	-- TODO: gérer la suppression de compte !
	END IF;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER manage_compte
	AFTER UPDATE OR DELETE ON Compte
	FOR EACH ROW 
	EXECUTE PROCEDURE gestion_compte();