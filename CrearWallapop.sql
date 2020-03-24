use master
go

drop database if exists Wallapop
go

CREATE DATABASE Wallapop
ON PRIMARY 
(NAME = Wallapop_main, 
FILENAME = 'C:\Data\Wallapopmain.mdf',
SIZE = 2MB,
MAXSIZE = 50MB,
FILEGROWTH = 1MB), 

FILEGROUP Wallapop2 
(NAME = Wallapop2, 
 FILENAME = 'C:\Data\Wallapopsecond.ndf',
 SIZE = 2MB,
MAXSIZE = 50MB,
FILEGROWTH = 1MB)
LOG ON 
(NAME = Wallalog, 
 FILENAME = 'C:\Data\Wallalog.ldf',
 SIZE = 2MB,
MAXSIZE = 50MB,
FILEGROWTH = 1MB)

/*
SELECT groupName AS FileGroupName FROM sysfilegroups
GO
*/

ALTER DATABASE Wallapop
MODIFY FILEGROUP Wallapop2 DEFAULT
GO

use Wallapop
go

CREATE TABLE codigo_postal (
    cp                           INTEGER NOT NULL,
    provincia_codigo_provincia   INTEGER NOT NULL,
    zona_postal_codigo_zona      INTEGER NOT NULL
)
go

ALTER TABLE codigo_postal ADD constraint codigo_postal_pk PRIMARY KEY CLUSTERED (cp)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 
go

CREATE TABLE cuenta 
    ( email nvarchar (80) NOT NULL , 
     password NVARCHAR (255) NOT NULL , 
     metodo_pago_numero_tarjeta INTEGER NOT null ) 
go

ALTER TABLE cuenta ADD constraint cuenta_pk PRIMARY KEY CLUSTERED (email)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 
go

CREATE TABLE direccion 
    (
    numero       INTEGER,
    puerta       INTEGER,
    via_nombre   nvarchar (30) NOT NULL , 
     codigo_postal_cp INTEGER NOT NULL , 
     id_direccion NVARCHAR (15) NOT NULL , 
     nombre_calle NVARCHAR (80) NOT NULL , 
     ciudad NVARCHAR (80) NOT null ) 
go

ALTER TABLE direccion ADD constraint direccion_pk PRIMARY KEY CLUSTERED (id_direccion)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 
go

CREATE TABLE factura (
    id                           VARCHAR(24) NOT NULL,
    metodo_pago_numero_tarjeta   INTEGER NOT NULL,
    producto_id_producto         VARCHAR(9) NOT NULL,
    venta_id                     varchar NOT NULL
)
go

ALTER TABLE factura ADD constraint factura_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 
go

CREATE TABLE metodo_pago (
    numero_tarjeta   INTEGER NOT NULL,
    mes              INTEGER NOT NULL,
    año              INTEGER NOT NULL,
    cvc              INTEGER NOT NULL
)
go

ALTER TABLE metodo_pago ADD constraint metodo_pago_pk PRIMARY KEY CLUSTERED (numero_tarjeta)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 
go

CREATE TABLE producto 
    (
    id_producto   VARCHAR(9) NOT NULL,
    moneda        nvarchar (1) NOT NULL , 
     precio FLOAT (14) NOT NULL , 
     descripcion NVARCHAR (50) NOT NULL , 
     foto image NOT null ) 
go

ALTER TABLE producto ADD constraint producto_pk PRIMARY KEY CLUSTERED (id_producto)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 
go

CREATE TABLE provincia 
    ( nombre nvarchar (80) NOT NULL , 
     codigo_provincia INTEGER NOT null ) 
go

ALTER TABLE provincia ADD constraint provincia_pk PRIMARY KEY CLUSTERED (codigo_provincia)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 
go

CREATE TABLE usuario 
    (
    nif                      CHAR(9) NOT NULL,
    direccion_id_direccion   nvarchar (15) NOT NULL , 
     nombre NVARCHAR (80) NOT NULL , 
     apellido1 NVARCHAR (80) NOT NULL , 
     apellido2 NVARCHAR (80) NOT NULL , 
     telefono INTEGER , 
     foto_perfil IMAGE , 
     descripcion NVARCHAR (200) , 
     horario_apertura NVARCHAR (250) , 
     web NVARCHAR (50) , 
     fecha_nacimiento DATE NOT NULL , 
     sexo BIT NOT NULL , 
     cuenta_email NVARCHAR (80) NOT null ) 
go

ALTER TABLE usuario ADD constraint usuario_pk PRIMARY KEY CLUSTERED (nif)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 
go

CREATE TABLE venta (
    fecha          datetime,
    usuario_nif    CHAR(9) NOT NULL,
    usuario_nif1   CHAR(9) NOT NULL,
    id             varchar NOT NULL
)
go

ALTER TABLE venta ADD constraint venta_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 
go

CREATE TABLE via 
    ( nombre nvarchar (30) NOT NULL , 
     descripcion NVARCHAR (100) NOT null ) 
go

ALTER TABLE via ADD constraint via_pk PRIMARY KEY CLUSTERED (nombre)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 
go

CREATE TABLE zona_postal (
    nombre        nvarchar NOT NULL,
    codigo_zona   INTEGER NOT NULL
)
go

ALTER TABLE zona_postal ADD constraint zona_postal_pk PRIMARY KEY CLUSTERED (codigo_zona)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 
go

ALTER TABLE codigo_postal
    ADD CONSTRAINT codigo_postal_provincia_fk FOREIGN KEY ( provincia_codigo_provincia )
        REFERENCES provincia ( codigo_provincia )
ON DELETE NO ACTION 
    ON UPDATE no action 
go

ALTER TABLE codigo_postal
    ADD CONSTRAINT codigo_postal_zona_postal_fk FOREIGN KEY ( zona_postal_codigo_zona )
        REFERENCES zona_postal ( codigo_zona )
ON DELETE NO ACTION 
    ON UPDATE no action 
go

ALTER TABLE cuenta
    ADD CONSTRAINT cuenta_metodo_pago_fk FOREIGN KEY ( metodo_pago_numero_tarjeta )
        REFERENCES metodo_pago ( numero_tarjeta )
ON DELETE NO ACTION 
    ON UPDATE no action 
go

ALTER TABLE direccion
    ADD CONSTRAINT direccion_codigo_postal_fk FOREIGN KEY ( codigo_postal_cp )
        REFERENCES codigo_postal ( cp )
ON DELETE NO ACTION 
    ON UPDATE no action 
go

ALTER TABLE direccion
    ADD CONSTRAINT direccion_via_fk FOREIGN KEY ( via_nombre )
        REFERENCES via ( nombre )
ON DELETE NO ACTION 
    ON UPDATE no action 
go

ALTER TABLE factura
    ADD CONSTRAINT factura_metodo_pago_fk FOREIGN KEY ( metodo_pago_numero_tarjeta )
        REFERENCES metodo_pago ( numero_tarjeta )
ON DELETE NO ACTION 
    ON UPDATE no action 
go

ALTER TABLE factura
    ADD CONSTRAINT factura_producto_fk FOREIGN KEY ( producto_id_producto )
        REFERENCES producto ( id_producto )
ON DELETE NO ACTION 
    ON UPDATE no action 
go

ALTER TABLE factura
    ADD CONSTRAINT factura_venta_fk FOREIGN KEY ( venta_id )
        REFERENCES venta ( id )
ON DELETE NO ACTION 
    ON UPDATE no action 
go

ALTER TABLE usuario
    ADD CONSTRAINT usuario_cuenta_fk FOREIGN KEY ( cuenta_email )
        REFERENCES cuenta ( email )
ON DELETE NO ACTION 
    ON UPDATE no action 
go

ALTER TABLE usuario
    ADD CONSTRAINT usuario_direccion_fk FOREIGN KEY ( direccion_id_direccion )
        REFERENCES direccion ( id_direccion )
ON DELETE NO ACTION 
    ON UPDATE no action 
go

ALTER TABLE venta
    ADD CONSTRAINT venta_usuario_fk FOREIGN KEY ( usuario_nif )
        REFERENCES usuario ( nif )
ON DELETE NO ACTION 
    ON UPDATE no action 
go

ALTER TABLE venta
    ADD CONSTRAINT venta_usuario_fkv2 FOREIGN KEY ( usuario_nif1 )
        REFERENCES usuario ( nif )
ON DELETE NO ACTION 
    ON UPDATE no action 
go
