-- Run this in Supabase SQL Editor (https://supabase.com/dashboard/project/hqfszlxdkvwlvpwqqmbd/sql/new)

-- CX Standup Items table
CREATE TABLE IF NOT EXISTS cx_standup_items (
  id TEXT PRIMARY KEY,
  item TEXT NOT NULL,
  action TEXT NOT NULL,
  priority TEXT NOT NULL DEFAULT 'Medium',
  owner TEXT NOT NULL DEFAULT 'Don',
  status TEXT NOT NULL DEFAULT 'Open',
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- CX Standup Users table (simple login)
CREATE TABLE IF NOT EXISTS cx_standup_users (
  id SERIAL PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  display_name TEXT NOT NULL,
  color TEXT NOT NULL DEFAULT '#3b82f6'
);

-- Insert default users
INSERT INTO cx_standup_users (username, password, display_name, color) VALUES
  ('don', 'Don123!', 'Don', '#f97316'),
  ('mark', 'Mark123!', 'Mark', '#3b82f6'),
  ('kerushan', 'Kerushan123!', 'Kerushan', '#10b981'),
  ('daryl', 'Daryl123!', 'Daryl', '#8b5cf6'),
  ('tunya', 'Tunya123!', 'Tunya', '#ec4899'),
  ('tim', 'Tim123!', 'Tim', '#06b6d4'),
  ('john', 'John123!', 'John', '#f43f5e'),
  ('greg', 'Greg123!', 'Greg', '#84cc16'),
  ('verona', 'Verona123!', 'Verona', '#a855f7')
ON CONFLICT (username) DO NOTHING;

-- Enable RLS
ALTER TABLE cx_standup_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE cx_standup_users ENABLE ROW LEVEL SECURITY;

-- Allow all authenticated/anon users to read/write items (simple shared board)
CREATE POLICY "Allow all access to cx_standup_items" ON cx_standup_items FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow read access to cx_standup_users" ON cx_standup_users FOR SELECT USING (true);

-- Enable realtime
ALTER PUBLICATION supabase_realtime ADD TABLE cx_standup_items;
