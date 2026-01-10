-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CreateExtension  
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- CreateFunction
CREATE OR REPLACE FUNCTION uuid_v7()
RETURNS uuid AS $$
DECLARE
    unix_ts_ms BIGINT;
    ts        BYTEA;
    rand      BYTEA;
    bytes     BYTEA;
BEGIN
    -- timestamp tính theo mili giây
    unix_ts_ms := FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000);

    -- lấy 6 byte timestamp MSB
    ts := substring(int8send(unix_ts_ms)::bytea FROM 3 FOR 6);

    -- random 10 byte còn lại
    rand := gen_random_bytes(10);

    -- ghép 16 byte (6 timestamp + 10 random)
    bytes := ts || rand;

    -- gán version (4 MSB của byte 7 = 0111)
    bytes := set_byte(bytes, 6,
        (get_byte(bytes, 6) & 15) | (7 << 4)
    );

    -- gán variant (2 MSB của byte 9 = 10)
    bytes := set_byte(bytes, 8,
        (get_byte(bytes, 8) & 63) | 128
    );

    RETURN encode(bytes, 'hex')::uuid;
END;
$$ LANGUAGE plpgsql;