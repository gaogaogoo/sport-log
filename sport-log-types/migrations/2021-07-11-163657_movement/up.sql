create type movement_category as enum('strength', 'cardio');
create type movement_unit as enum('reps', 'cal', 'meter', 'km', 'yard', 'foot', 'mile');

create table movement (
    id bigint primary key,
    user_id integer references "user" on delete cascade,
    name varchar(80) not null,
    description text,
    category movement_category not null,
    last_change timestamptz not null default now(),
    deleted boolean not null default false,
    unique (user_id, name, category, deleted)
);

create trigger set_timestamp before update on movement
    for each row execute procedure trigger_set_timestamp();

insert into movement (id, user_id, name, description, category) values
    (1, null, 'Back Squat', null, 'strength'),
    (2, null, 'Front Squat', null, 'strength'),
    (3, null, 'Over Head Squat', null, 'strength'),
    (4, 1, 'Yoke Carry', null, 'strength'),
    (5, null, 'Running', 'road running without significant altitude change', 'cardio'),
    (6, null, 'Trailrunning', null, 'cardio'),
    (7, null, 'Swimming Freestyle', 'indoor freestyle swimming', 'cardio'),
    (8, 1, 'Rowing', null, 'cardio'),
    (9, null, 'Pull-Up', null, 'strength'),
    (10, null, 'Push-Up', null, 'strength'),
    (11, null, 'Air Squat', null, 'strength');

create table eorm (
    id bigserial primary key,
    reps integer not null check (reps >= 1),
    percentage real not null check (percentage > 0),
    unique (reps)
);

insert into eorm (reps, percentage) values
    (1, 1.0),
    (2, 0.97),
    (3, 0.94),
    (4, 0.92),
    (5, 0.89),
    (6, 0.86),
    (7, 0.83),
    (8, 0.81),
    (9, 0.78),
    (10, 0.75),
    (11, 0.73),
    (12, 0.71),
    (13, 0.70),
    (14, 0.68),
    (15, 0.67),
    (16, 0.65),
    (17, 0.64),
    (18, 0.63),
    (19, 0.61),
    (20, 0.60),
    (21, 0.59),
    (22, 0.58),
    (23, 0.57),
    (24, 0.56),
    (25, 0.55),
    (26, 0.54),
    (27, 0.53),
    (28, 0.52),
    (29, 0.51),
    (30, 0.50);