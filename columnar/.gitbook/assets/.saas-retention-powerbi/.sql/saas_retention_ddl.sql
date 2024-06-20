---
--- drop table
---

DROP TABLE IF EXISTS user_activity;

--
-- Name: user_activity; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--


CREATE TABLE user_activity (
    record_date date,
    beginning_users integer,
    new_users integer,
    lost_users integer,
    end_users integer,
    logins integer,
    active_users integer,
    monthly_retention real,
    monthly_churn real
);