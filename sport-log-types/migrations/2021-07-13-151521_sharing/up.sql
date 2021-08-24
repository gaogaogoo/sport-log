create table "group" (
    id bigint primary key,
    name varchar(80) not null,
    last_change timestamptz not null default now(),
    deleted boolean not null default false
);

create unique index group_idx on "group" (name) where deleted = false;

create trigger set_timestamp before update on "group"
    for each row execute procedure trigger_set_timestamp();

create table group_user (
    id bigint primary key,
    group_id bigint not null references "group" on delete cascade,
    user_id bigint not null references "user" on delete cascade,
    last_change timestamptz not null default now(),
    deleted boolean not null default false
);

create unique index group_user_idx on group_user (group_id, user_id) where deleted = false;

create trigger set_timestamp before update on group_user
    for each row execute procedure trigger_set_timestamp();

create table shared_metcon_session (
    id bigint primary key,
    group_id bigint not null references "group" on delete cascade,
    metcon_session_id bigint not null references metcon_session on delete cascade,
    last_change timestamptz not null default now(),
    deleted boolean not null default false
);

create unique index shared_metcon_session_idx on shared_metcon_session (group_id, metcon_session_id) 
    where deleted = false;

create trigger set_timestamp before update on shared_metcon_session
    for each row execute procedure trigger_set_timestamp();

create table shared_strength_session (
    id bigint primary key,
    group_id bigint not null references "group" on delete cascade,
    strength_session_id bigint not null references strength_session on delete cascade,
    last_change timestamptz not null default now(),
    deleted boolean not null default false
);

create unique index shared_strength_session_idx on shared_strength_session (group_id, strength_session_id) 
    where deleted = false;

create trigger set_timestamp before update on shared_strength_session
    for each row execute procedure trigger_set_timestamp();

create table shared_cardio_session (
    id bigint primary key,
    group_id bigint not null references "group" on delete cascade,
    cardio_session_id bigint not null references cardio_session on delete cascade,
    last_change timestamptz not null default now(),
    deleted boolean not null default false
);

create unique index shared_cardio_session_idx on shared_cardio_session (group_id, cardio_session_id) 
    where deleted = false;

create trigger set_timestamp before update on shared_cardio_session
    for each row execute procedure trigger_set_timestamp();

create table shared_diary (
    id bigint primary key,
    group_id bigint not null references "group" on delete cascade,
    diary_id bigint not null references diary on delete cascade,
    last_change timestamptz not null default now(),
    deleted boolean not null default false
);

create unique index shared_diary_idx on shared_diary (group_id, diary_id) 
    where deleted = false;

create trigger set_timestamp before update on shared_diary
    for each row execute procedure trigger_set_timestamp();
