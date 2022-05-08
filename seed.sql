use ocr_observer;

insert into state (name) values ("Hochgeladen");
insert into state (name) values ("Erkannt");
insert into state (name) values ("Bestaetigt");
insert into state (name) values ("Zurueckgewiesen");

insert into task (name, description) values ("Zettelkatalog", "Zettel beinhalten Signatur, Autor, Titel, Bemerkung und ggf. Kategorie.");
insert into dataset (idtask, name, description) values (1, "Autor Datensatz A-Z", "Dieser Datensatz beinhaltet sämtliche Registerkarten des Autor Datensatz.");
