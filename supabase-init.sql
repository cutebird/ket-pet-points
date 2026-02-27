-- 学生表
create table students (
  id text primary key,
  name text not null,
  avatar text default '🐾',
  level text default 'KET',
  available_points integer default 0,
  total_points integer default 0,
  redeemed_points integer default 0
);

-- 初始化两个学生
insert into students (id, name, avatar, level) values
  ('cancan', '灿灿', '🌟', 'KET'),
  ('dingding', '丁丁', '🎯', 'PET');

-- 积分事件表
create table point_events (
  id uuid primary key default gen_random_uuid(),
  student_id text references students(id),
  category text not null,
  points integer not null,
  note text default '',
  created_at timestamptz default now()
);

-- 奖励表
create table rewards (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text default '',
  icon text default '🎁',
  points integer not null,
  is_active boolean default true,
  sort_order integer default 0
);

-- 初始化几个奖励
insert into rewards (name, description, icon, points, sort_order) values
  ('自由阅读30分钟', '课堂自由阅读时间', '📚', 20, 1),
  ('选择课堂游戏', '选择一个你喜欢的游戏', '🎮', 30, 2),
  ('免一次作业', '免除一次课后作业', '📝', 50, 3),
  ('小礼品', '教师准备的小惊喜', '🎁', 80, 4);

-- 兑换记录表
create table redemptions (
  id uuid primary key default gen_random_uuid(),
  student_id text references students(id),
  reward_id uuid references rewards(id),
  reward_name text not null,
  points integer not null,
  created_at timestamptz default now()
);

-- 开放 RLS（允许前端直接读写，适合个人使用）
alter table students enable row level security;
alter table point_events enable row level security;
alter table rewards enable row level security;
alter table redemptions enable row level security;

create policy "allow all" on students for all using (true) with check (true);
create policy "allow all" on point_events for all using (true) with check (true);
create policy "allow all" on rewards for all using (true) with check (true);
create policy "allow all" on redemptions for all using (true) with check (true);
