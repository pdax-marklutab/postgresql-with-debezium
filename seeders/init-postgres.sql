-- Table transactions as T {
--   id uuid [pk]
--   reference_id uuid [not null]
--   type varchar [not null]
--   created_at timestamptz [not null, default: `now()`]// includes timezone
--   updated_at timestamptz [not null, default: `now()`]// includes timezone
-- }

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE transactions (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    reference_id uuid DEFAULT uuid_generate_v4(),
    created_at timestamptz  DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE fees (
    id SERIAL PRIMARY KEY,
    transaction_id uuid,
    amount NUMERIC (10, 2) DEFAULT 100,
    CONSTRAINT fk_transactions
    FOREIGN KEY(transaction_id) 
	REFERENCES transactions(id)
	ON DELETE CASCADE
);

CREATE INDEX transactions_created_at_idx
ON transactions (created_at);

ALTER TABLE public.transactions REPLICA IDENTITY FULL;
ALTER TABLE public.fees REPLICA IDENTITY FULL;

INSERT INTO transactions (created_at, updated_at) SELECT i::timestamptz, i::timestamptz from generate_series('2022-01-01','2022-01-02', INTERVAL '1 hour') AS t(i);
INSERT INTO fees (transaction_id) SELECT id FROM transactions;



