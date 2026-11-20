drop table if exists public.comment_likes cascade;
drop table if exists public.post_likes cascade;
drop table if exists public.comments cascade;
drop table if exists public.posts cascade;
drop table if exists public.users cascade;

create table public.users (
  id bigserial primary key,
  username text not null unique,
  avatar_url text not null default 'assets/images/post.jpg',
  bio text not null default '',
  created_at timestamptz not null default now()
);

create table public.posts (
  id bigserial primary key,
  user_id bigint not null references public.users(id) on delete cascade,
  image_url text not null default 'assets/images/post.jpg',
  caption text not null default '',
  created_at timestamptz not null default now()
);

create table public.comments (
  id bigserial primary key,
  post_id bigint not null references public.posts(id) on delete cascade,
  user_id bigint not null references public.users(id) on delete cascade,
  body text not null check (length(trim(body)) > 0),
  created_at timestamptz not null default now()
);

create table public.post_likes (
  post_id bigint not null references public.posts(id) on delete cascade,
  user_id bigint not null references public.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, user_id)
);

create table public.comment_likes (
  comment_id bigint not null references public.comments(id) on delete cascade,
  user_id bigint not null references public.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (comment_id, user_id)
);

create index posts_user_id_idx on public.posts (user_id);
create index comments_post_id_idx on public.comments (post_id);
create index comments_user_id_idx on public.comments (user_id);
create index post_likes_user_id_idx on public.post_likes (user_id);
create index comment_likes_user_id_idx on public.comment_likes (user_id);

alter table public.users disable row level security;
alter table public.posts disable row level security;
alter table public.comments disable row level security;
alter table public.post_likes disable row level security;
alter table public.comment_likes disable row level security;

grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on all tables in schema public to anon, authenticated;
grant usage, select on all sequences in schema public to anon, authenticated;

insert into public.users (id, username) values
  (1, 'aminloh'),
  (2, 'rizzlerr'),
  (3, 'goofy_ah'),
  (4, 'gugalugaa'),
  (5, 'mewing_mastr'),
  (6, 'grimace_shak'),
  (7, 'jojoo'),
  (8, 'brocoli_head'),
  (9, 'skibidi_kingg'),
  (10, 'sigma_lordd'),
  (11, 'no_cap_ninaa'),
  (12, 'bussin_broo'),
  (13, 'gyattzila'),
  (14, 'fanum_taxx'),
  (15, 'ohio_riz');

select setval('public.users_id_seq', 15);

insert into public.posts (id, user_id, caption) values
  (1, 1, 'morning coffee hits different fr'),
  (2, 4, 'this fit is lowkey bussin no cap'),
  (3, 7, 'bro the vibes today are immaculate'),
  (4, 9, 'no cap this spot is kinda fire'),
  (5, 10, 'grinding today so tomorrow we chill'),
  (6, 13, 'my camera roll is 90% random pics'),
  (7, 15, 'caught the sunset before it dipped'),
  (8, 14, 'living rent free in my head'),
  (9, 12, 'bro said one more minute and left me on read'),
  (10, 11, 'whole day was mid until this happened');

select setval('public.posts_id_seq', 10);

insert into public.comments (id, post_id, user_id, body) values
  (1, 1, 2, 'bro same every day'),
  (2, 1, 3, 'this cup is lowkey fire'),
  (3, 2, 5, 'fit goes crazy'),
  (4, 2, 6, 'where u got that'),
  (5, 3, 8, 'vibes are unmatched'),
  (6, 3, 9, 'we outside fr'),
  (7, 4, 1, 'drop the location'),
  (8, 4, 7, 'taking notes rn'),
  (9, 5, 11, 'respect the hustle'),
  (10, 5, 12, 'me after one coffee'),
  (11, 6, 4, 'realest thing i seen today'),
  (12, 6, 14, 'send the other 10%'),
  (13, 7, 13, 'this is so tuff'),
  (14, 7, 2, 'nature said lemme cook'),
  (15, 8, 10, 'who let bro cook'),
  (16, 8, 12, 'bro is down bad'),
  (17, 9, 15, 'that is foul'),
  (18, 9, 8, 'not the read receipt'),
  (19, 10, 14, 'the plot twist'),
  (20, 10, 9, 'main character energy');

select setval('public.comments_id_seq', 20);

insert into public.post_likes (post_id, user_id)
select p.id, u.id
from public.posts p
cross join public.users u
where u.id <> p.user_id
  and (p.id + u.id) % 3 <> 0;

insert into public.comment_likes (comment_id, user_id)
select c.id, u.id
from public.comments c
cross join public.users u
where u.id <> c.user_id
  and (c.id + u.id) % 5 = 0;

notify pgrst, 'reload schema';
