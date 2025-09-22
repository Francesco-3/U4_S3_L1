//TABLES
//TABELLA FATTURE
CREATE TABLE public.fatture (
     numero_fattura serial PRIMARY KEY,
	 tipologia varchar NOT NULL,
	 importo double precision NOT NULL,
	 iva int8 NOT NULL,
	 data_fattura date NOT NULL,
	 numero_cliente integer NOT NULL,
	 numero_fornitore integer NOT NULL,
	 CONSTRAINT cliente_fk FOREIGN KEY (numero_cliente)
	            REFERENCES public.cliente (numero_cliente),
	 CONSTRAINT fornitore_fk FOREIGN KEY (numero_fornitore)
	            REFERENCES public.fornitore (numero_fornitore)
);

//TABELLA CLIENTI
CREATE TABLE public.cliente (
     numero_cliente serial PRIMARY KEY,
     nome varchar NOT NULL,
     cognome varchar NOT NULL,
     anno_di_nascita date NOT NULL,
     regione_residenza varchar NOT NULL
);

//TABELLA PRODOTTI
CREATE TABLE public.prodotti (
     id_prodotto serial PRIMARY KEY,
     descrizione varchar NOT NULL,
     in_produzione boolean NOT NULL,
     in_commercio boolean NOT NULL,
     data_attivazione date NOT NULL,
     data_disattivazione date NOT NULL
);

//TABELLA FORNITORI
CREATE TABLE public.fornitori (
     numero_fornitore serial PRIMARY KEY,
     denominazione varchar NOT NULL,
     regione_residenza varchar NOT NULL
);






// Estrai tutti i clienti con nome Mario
SELECT * FROM clienti WHERE nome = 'Mario';

// Estrarre il nome e il cognome dei clienti nati nel 1982
SELECT nome, cognome FROM cliente WHERE anno_di_nascita = 1982;

// Estrarre i prodotti attivati nel 2017 e che sono in produzione oppure in commercio
SELECT * FROM prodotti
WHERE EXTRACT(YEAR FROM data_attivazione) = 2017
AND (in_produzione = true OR in_commercio = true)

// Estrarre le fatture con importo inferiore a 1000 e i dati dei clienti ad esse collegate
SELECT importo, nome, cognome, regione_residenza, anno_di_nascita 
FROM fatture INNER JOIN cliente ON importo < 1000

// Riportare l'elenco delle fatture (numero, importo, iva, e data) con in aggiunta il nome del fornitore
SELECT f.numero_fattura, f.importo, f.iva, f.data_fattura, fo.denominazione
FROM fatture f JOIN fornitori fo ON f.numero_fornitore = fo.numero_fornitore

// Considerando soltanto le fatture con iva al 20 per cento, estrarre il numero di fatture (conteggio fatture) per ogni anno
SELECT COUNT(fatture) AS fatture, EXTRACT(YEAR FROM data_fattura) AS anno
FROM fatture WHERE iva = 20
GROUP BY EXTRACT(YEAR FROM data_fattura)
ORDER BY anno

// Riportare il numero di fatture (conteggio fatture) e la somma dei relativi importi divisi per anno di fatturazione
SELECT COUNT(fatture) AS fatture, SUM(importo) AS importi, EXTRACT(YEAR FROM data_fattura) AS anno
FROM fatture
GROUP BY EXTRACT(YEAR FROM data_fattura)
ORDER BY anno

// [EXTRA] Estrarre gli anni in cui sono state registrate più di 2 fatture con tipologia 'A'
SELECT EXTRACT(YEAR FROM data_fattura) AS anno, COUNT(*) AS fatture_A
FROM fatture WHERE tipologia = 'A'
GROUP BY EXTRACT(YEAR FROM data_fattura)
HAVING COUNT(*) > 2
ORDER BY anno

// [EXTRA] Estrarre il totale degli importi delle fatture divisi per residenza dei clienti
SELECT SUM(importo) AS tot_importi, regione_residenza AS residenza
FROM fatture f JOIN cliente c
ON f.numero_cliente = c.numero_cliente
GROUP BY c.regione_residenza

// [EXTRA] Estrarre il numero dei clienti nati nel 1980 che hanno almeno una fattura superiore a 50 euro
SELECT COUNT(DISTINCT c.numero_cliente) AS tot_clienti
FROM public.cliente c
JOIN public.fatture f 
    ON c.numero_cliente = f.numero_cliente
WHERE anno_di_nascita = 1980
  AND f.importo > 50;