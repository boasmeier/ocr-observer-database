use ocr_observer;

select * from state;
select * from image;
select * from fields;
select * from history;
select * from history_has_state;
select * from task;
select * from dataset;

DELETE FROM dataset where iddataset=1;

# Get image with fields and state
select image.idimage, fields.idfields, image.name, image.mimetype, fields.signature, fields.author, fields.title, fields.comment, fields.category, state.name 
from image join fields join history_has_state join state 
where image.idfields = fields.idfields
and image.idhistory = history_has_state.idhistory
and history_has_state.idstate = state.idstate;

# Get image with state
SELECT * FROM (
	SELECT image.idimage, image.iddataset, image.name, image.mimetype, state.name as state, history_has_state.timestamp, row_number() over(partition by image.name order by history_has_state.timestamp desc) as rn
	FROM image JOIN history_has_state JOIN state 
	WHERE image.idhistory = history_has_state.idhistory
	AND history_has_state.idstate = state.idstate ) t
WHERE t.rn = 1;

# Get image histroy with state
SELECT history_has_state.idhistory, state.name as state, history_has_state.timestamp
FROM history_has_state JOIN state JOIN image
WHERE history_has_state.idstate = state.idstate
AND history_has_state.idhistory = image.idhistory
AND image.idimage = 10
ORDER BY timestamp desc;

# Get idfields, destination and name of images which are only uploaded
SELECT idfields, destination, name FROM (
	SELECT image.idimage, image.iddataset, image.idfields, image.name, image.destination, image.mimetype, state.name as state, history_has_state.timestamp, row_number() over(partition by image.name order by history_has_state.timestamp desc) as rn
	FROM image JOIN history_has_state JOIN state 
	WHERE image.idhistory = history_has_state.idhistory
	AND history_has_state.idstate = state.idstate ) t
WHERE t.rn = 1
AND state = 'Hochgeladen';

