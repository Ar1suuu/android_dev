drop trigger if exists on_auth_user_created on auth.users;

drop table if exists public.comment_likes cascade;
drop table if exists public.post_likes cascade;
drop table if exists public.comments cascade;
drop table if exists public.posts cascade;
drop table if exists public.users cascade;

create table public.users (
  id bigserial primary key,
  auth_uid uuid unique references auth.users(id) on delete cascade,
  username text not null unique check (username ~ '^[a-z0-9_]{3,30}$'),
  display_name text not null default '',
  email text unique,
  avatar_url text not null default 'assets/images/post.jpg',
  bio text not null default '' check (char_length(bio) <= 150),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.posts (
  id bigserial primary key,
  user_id bigint not null references public.users(id) on delete cascade,
  image_url text not null default 'assets/images/post.jpg' check (length(trim(image_url)) > 0),
  caption text not null default '' check (char_length(caption) <= 2200),
  location text not null default '' check (char_length(location) <= 100),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
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

create index posts_created_at_idx on public.posts (created_at desc);
create index posts_user_id_idx on public.posts (user_id);
create index comments_post_id_idx on public.comments (post_id);
create index comments_user_id_idx on public.comments (user_id);
create index post_likes_user_id_idx on public.post_likes (user_id);
create index comment_likes_user_id_idx on public.comment_likes (user_id);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger users_set_updated_at
before update on public.users
for each row execute function public.set_updated_at();

create trigger posts_set_updated_at
before update on public.posts
for each row execute function public.set_updated_at();

create or replace function public.current_user_id()
returns bigint
language sql
stable
security definer
set search_path = public
as $$
  select id from public.users where auth_uid = auth.uid();
$$;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  base_username text;
  final_username text;
  counter int := 0;
begin
  base_username := lower(
    regexp_replace(
      coalesce(
        nullif(new.raw_user_meta_data->>'username', ''),
        split_part(coalesce(new.email, ''), '@', 1)
      ),
      '[^a-z0-9_]',
      '',
      'g'
    )
  );

  base_username := substr(base_username, 1, 30);

  if char_length(base_username) < 3 then
    base_username := 'user' || substr(replace(new.id::text, '-', ''), 1, 8);
  end if;

  final_username := base_username;

  while exists (
    select 1 from public.users where username = final_username
  ) loop
    counter := counter + 1;
    final_username := substr(
      base_username,
      1,
      30 - char_length(counter::text)
    ) || counter::text;
  end loop;

  insert into public.users (auth_uid, username, display_name, email)
  values (
    new.id,
    final_username,
    coalesce(
      nullif(new.raw_user_meta_data->>'display_name', ''),
      final_username
    ),
    new.email
  );

  return new;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

insert into public.users (id, username, display_name, bio) values
  (1, 'aminloh', 'Amin Loh', 'coffee and code'),
  (2, 'rizzlerr', 'Rizz Ler', 'always rizzing'),
  (3, 'goofy_ah', 'Goofy Ah', 'just goofy'),
  (4, 'gugalugaa', 'Guga Luga', 'guga energy'),
  (5, 'mewing_mastr', 'Mewing Master', 'mewing all day'),
  (6, 'grimace_shak', 'Grimace Shake', 'purple shake'),
  (7, 'jojoo', 'Jo Joo', 'jojo references'),
  (8, 'brocoli_head', 'Brocoli Head', 'eat your greens'),
  (9, 'skibidi_kingg', 'Skibidi King', 'skibidi bop'),
  (10, 'sigma_lordd', 'Sigma Lord', 'grindset'),
  (11, 'no_cap_ninaa', 'No Cap Nina', 'no cap ever'),
  (12, 'bussin_broo', 'Bussin Bro', 'this is bussin'),
  (13, 'gyattzila', 'Gyatt Zila', 'camera roll chaos'),
  (14, 'fanum_taxx', 'Fanum Tax', 'taxing your food'),
  (15, 'ohio_riz', 'Ohio Riz', 'only in ohio');

select setval('public.users_id_seq', 15);

insert into public.posts (id, user_id, caption, location) values
  (1, 1, 'morning coffee hits different fr', 'home'),
  (2, 4, 'this fit is lowkey bussin no cap', 'the crib'),
  (3, 7, 'bro the vibes today are immaculate', 'downtown'),
  (4, 9, 'no cap this spot is kinda fire', 'the spot'),
  (5, 10, 'grinding today so tomorrow we chill', 'campus'),
  (6, 13, 'my camera roll is 90% random pics', 'my room'),
  (7, 15, 'caught the sunset before it dipped', 'the roof'),
  (8, 14, 'living rent free in my head', 'outside'),
  (9, 12, 'bro said one more minute and left me on read', 'the chat'),
  (10, 11, 'whole day was mid until this happened', 'the plot');

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

do $$
declare
  auth_user record;
  base_username text;
  final_username text;
  counter int;
begin
  for auth_user in
    select *
    from auth.users au
    where not exists (
      select 1 from public.users u where u.auth_uid = au.id
    )
  loop
    base_username := lower(
      regexp_replace(
        coalesce(
          nullif(auth_user.raw_user_meta_data->>'username', ''),
          split_part(coalesce(auth_user.email, ''), '@', 1)
        ),
        '[^a-z0-9_]',
        '',
        'g'
      )
    );

    base_username := substr(base_username, 1, 30);

    if char_length(base_username) < 3 then
      base_username := 'user' || substr(replace(auth_user.id::text, '-', ''), 1, 8);
    end if;

    final_username := base_username;
    counter := 0;

    while exists (
      select 1 from public.users where username = final_username
    ) loop
      counter := counter + 1;
      final_username := substr(
        base_username,
        1,
        30 - char_length(counter::text)
      ) || counter::text;
    end loop;

    insert into public.users (auth_uid, username, display_name, email)
    values (
      auth_user.id,
      final_username,
      coalesce(
        nullif(auth_user.raw_user_meta_data->>'display_name', ''),
        final_username
      ),
      auth_user.email
    );
  end loop;
end;
$$;

alter table public.users enable row level security;
alter table public.posts enable row level security;
alter table public.comments enable row level security;
alter table public.post_likes enable row level security;
alter table public.comment_likes enable row level security;

create policy "users are readable"
  on public.users for select
  using (true);

create policy "users update own"
  on public.users for update
  to authenticated
  using (auth.uid() = auth_uid)
  with check (auth.uid() = auth_uid);

create policy "posts are readable"
  on public.posts for select
  using (true);

create policy "posts insert own"
  on public.posts for insert
  to authenticated
  with check (user_id = public.current_user_id());

create policy "posts update own"
  on public.posts for update
  to authenticated
  using (user_id = public.current_user_id())
  with check (user_id = public.current_user_id());

create policy "posts delete own"
  on public.posts for delete
  to authenticated
  using (user_id = public.current_user_id());

create policy "comments are readable"
  on public.comments for select
  using (true);

create policy "comments insert own"
  on public.comments for insert
  to authenticated
  with check (user_id = public.current_user_id());

create policy "comments update own"
  on public.comments for update
  to authenticated
  using (user_id = public.current_user_id())
  with check (user_id = public.current_user_id());

create policy "comments delete own"
  on public.comments for delete
  to authenticated
  using (user_id = public.current_user_id());

create policy "post likes are readable"
  on public.post_likes for select
  using (true);

create policy "post likes insert own"
  on public.post_likes for insert
  to authenticated
  with check (user_id = public.current_user_id());

create policy "post likes delete own"
  on public.post_likes for delete
  to authenticated
  using (user_id = public.current_user_id());

create policy "comment likes are readable"
  on public.comment_likes for select
  using (true);

create policy "comment likes insert own"
  on public.comment_likes for insert
  to authenticated
  with check (user_id = public.current_user_id());

create policy "comment likes delete own"
  on public.comment_likes for delete
  to authenticated
  using (user_id = public.current_user_id());

grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on all tables in schema public to anon, authenticated;
grant usage, select on all sequences in schema public to anon, authenticated;

notify pgrst, 'reload schema';
