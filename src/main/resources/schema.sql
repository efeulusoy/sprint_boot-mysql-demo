DROP TABLE IF EXISTS users;

CREATE TABLE users(
    id      BIGINT(20) NOT NULL AUTO_INCREMENT,
    email   VARCHAR(300) NOT NULL,
    name    VARCHAR(300) NOT NULL,
    PRIMARY KEY(id)
);