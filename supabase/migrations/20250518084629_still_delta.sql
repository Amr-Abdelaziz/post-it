/*
  # Initial Schema Setup

  1. New Tables
    - `aiOutput`
      - `id` (serial, primary key)
      - `formData` (varchar, not null)
      - `aiResponse` (text)
      - `templateSlug` (varchar, not null)
      - `createdBy` (varchar, not null)
      - `createdAt` (varchar)
    
    - `payments`
      - `id` (varchar, primary key)
      - `email` (varchar, not null)
      - `amount` (integer, not null)
      - `status` (varchar, not null)
      - `reference` (varchar, not null)
      - `created_at` (timestamp, default now)
    
    - `users`
      - `id` (varchar, primary key)
      - `email` (varchar, not null)
      - `totalUsage` (integer, default 10000)
      - `subscriptionStatus` (boolean, default false)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Create aiOutput table
CREATE TABLE IF NOT EXISTS "aiOutput" (
  id SERIAL PRIMARY KEY,
  "formData" VARCHAR NOT NULL,
  "aiResponse" TEXT,
  "templateSlug" VARCHAR NOT NULL,
  "createdBy" VARCHAR NOT NULL,
  "createdAt" VARCHAR
);

-- Create payments table
CREATE TABLE IF NOT EXISTS payments (
  id VARCHAR(255) PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  amount INTEGER NOT NULL,
  status VARCHAR(50) NOT NULL,
  reference VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id VARCHAR(255) PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  "totalUsage" INTEGER DEFAULT 10000,
  "subscriptionStatus" BOOLEAN DEFAULT FALSE
);

-- Enable Row Level Security
ALTER TABLE "aiOutput" ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create policies for aiOutput
CREATE POLICY "Users can read own aiOutput"
  ON "aiOutput"
  FOR SELECT
  TO authenticated
  USING ("createdBy" = auth.jwt()->>'email');

CREATE POLICY "Users can insert own aiOutput"
  ON "aiOutput"
  FOR INSERT
  TO authenticated
  WITH CHECK ("createdBy" = auth.jwt()->>'email');

-- Create policies for payments
CREATE POLICY "Users can read own payments"
  ON payments
  FOR SELECT
  TO authenticated
  USING (email = auth.jwt()->>'email');

CREATE POLICY "Users can insert own payments"
  ON payments
  FOR INSERT
  TO authenticated
  WITH CHECK (email = auth.jwt()->>'email');

-- Create policies for users
CREATE POLICY "Users can read own data"
  ON users
  FOR SELECT
  TO authenticated
  USING (email = auth.jwt()->>'email');

CREATE POLICY "Users can update own data"
  ON users
  FOR UPDATE
  TO authenticated
  USING (email = auth.jwt()->>'email');