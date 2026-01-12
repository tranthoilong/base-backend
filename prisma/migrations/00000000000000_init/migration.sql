-- CreateExtensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
-- CREATE EXTENSION IF NOT EXISTS "postgis";



-- CreateFunction: uuid_v7
-- UUID v7 implementation with timestamp ordering (simplified version)
CREATE OR REPLACE FUNCTION uuid_v7() RETURNS uuid AS $$
DECLARE
  unix_ts_ms bigint;
  uuid_bytes bytea;
  random_bytes bytea;
BEGIN
  -- Get current timestamp in milliseconds
  unix_ts_ms := floor(extract(epoch from clock_timestamp()) * 1000)::bigint;
  
  -- Generate 10 random bytes for the remaining parts
  random_bytes := gen_random_bytes(10);
  
  -- Construct UUID v7: 
  -- 48 bits timestamp (6 bytes) + 4 bits version (0x7) + 12 bits random + 2 bits variant (0b10) + 62 bits random
  uuid_bytes := substring(int8send(unix_ts_ms) from 3 for 6) || -- 6 bytes timestamp
                set_byte('\x00'::bytea || random_bytes, 0, (get_byte(random_bytes, 0) & 15) | 112) || -- version 7 (0x7_)
                set_byte(substring(random_bytes from 2), 0, (get_byte(random_bytes, 1) & 63) | 128); -- variant 10
  
  RETURN encode(uuid_bytes, 'hex')::uuid;
END
$$ LANGUAGE plpgsql VOLATILE;
