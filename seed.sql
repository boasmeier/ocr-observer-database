use ocr_observer;

insert into state (name) values ("Hochgeladen");
insert into state (name) values ("Erkannt");
insert into state (name) values ("Bestaetigt");
insert into state (name) values ("Zurueckgewiesen");

insert into task (name, description) values ("test_task", "This is a test task");
insert into dataset (idtask, name, description) values (1, "test_dataset", "This is a test dataset");
