-- ---------------------------------------------------------------------------------
-- DDL DE PROCEDIMIENTOS ALMACENADOS Y FUNCIONES
-- ---------------------------------------------------------------------------------

-- PROCEDURES PARA TABLA USUARIOS
CREATE PROCEDURE SP_CREA_USUARIO
    @user_name VARCHAR(50),
    @clave VARCHAR(20),
    @nombres VARCHAR(30),
    @apellidos VARCHAR(30),
    @id_tipo_usuario INT
AS
BEGIN

    INSERT INTO USUARIOS (user_name, clave, nombres, apellidos, id_tipo_usuario)
    VALUES (@user_name, @clave, @nombres, @apellidos, @id_tipo_usuario);

END;
GO

CREATE PROCEDURE SP_MODIFICA_USUARIO
    @id_usuario INT,
    @user_name VARCHAR(50),
    @nombres VARCHAR(30),
    @apellidos VARCHAR(30),
    @id_tipo_usuario INT,
    @estado BIT
AS
BEGIN

    UPDATE USUARIOS
    SET user_name = @user_name,
        nombres = @nombres,
        apellidos = @apellidos,
        id_tipo_usuario = @id_tipo_usuario,
        estado = @estado
    WHERE id_usuario = @id_usuario;

END;
GO

CREATE PROCEDURE SP_ELIMINA_USUARIO
    @id_usuario INT
AS
BEGIN

    UPDATE USUARIOS
    SET estado = 0
    WHERE id_usuario = @id_usuario;

END;
GO

-- PROCEDURES PARA TABLA EXPEDIENTES
CREATE PROCEDURE SP_CREA_EXPEDIENTE
    @descripcion VARCHAR(500),
    @usuario_creacion INT,
    @estado VARCHAR(20)
AS
BEGIN

    INSERT INTO EXPEDIENTES (descripcion, usuario_creacion, estado)
    VALUES (@descripcion, @usuario_creacion, @estado);

END;
GO

CREATE PROCEDURE SP_MODIFICA_EXPEDIENTE
    @id_expediente INT,
    @descripcion VARCHAR(500),
    @estado VARCHAR(20)
AS
BEGIN

    UPDATE EXPEDIENTES
    SET descripcion = @descripcion,
        estado = @estado
    WHERE id_expediente = @id_expediente;

END;
GO

CREATE PROCEDURE SP_ELIMINA_EXPEDIENTE
	@id_expediente INT
AS
BEGIN

	SET NOCOUNT ON;

	IF EXISTS(
		SELECT 1
		FROM EXPEDIENTES
		WHERE 
			id_expediente = @id_expediente AND
			estado = 'aprobado'
	)
	BEGIN
		RETURN;
	END

	DELETE FROM EXPEDIENTES
	WHERE id_expediente = @id_expediente;

END;
GO

-- PROCEDURES PARA TABLA INDICIOS
CREATE PROCEDURE SP_CREACION_INDICIOS
    @id_expediente INT,
    @descripcion VARCHAR(500),
    @color VARCHAR(30),
    @peso DECIMAL(10,2),
    @ubicacion VARCHAR(200),
    @usuario_creacion INT
AS
BEGIN

    INSERT INTO INDICIOS (id_expediente, descripcion, color, peso, ubicacion, usuario_creacion)
    VALUES (@id_expediente, @descripcion, @color, @peso, @ubicacion, @usuario_creacion);

END;
GO

CREATE PROCEDURE SP_MODIFICA_INDICIO
    @id_indicio INT,
    @descripcion VARCHAR(500),
    @color VARCHAR(30),
    @peso DECIMAL(10,2),
    @ubicacion VARCHAR(200)
AS
BEGIN

    UPDATE INDICIOS
    SET 
		descripcion = @descripcion,
        color = @color,
        peso = @peso,
        ubicacion = @ubicacion
    WHERE id_indicio = @id_indicio;

END;
GO

CREATE PROCEDURE SP_ELIMINA_INDICIO
    @id_indicio INT
AS
BEGIN
    DELETE FROM INDICIOS
    WHERE id_indicio = @id_indicio;
END;
GO

-- PROCEDURES PARA TABLA REVISIONES_EXPEDIENTES
CREATE PROCEDURE SP_CREA_REVISION_EXPEDIENTE
    @id_expediente INT,
    @id_coordinador INT,
    @estado VARCHAR(20),
    @justificacion VARCHAR(500)
AS
BEGIN

    INSERT INTO REVISIONES_EXPEDIENTE (id_expediente, id_coordinador, estado, justificacion)
    VALUES (@id_expediente, @id_coordinador, @estado, @justificacion);

END;
GO

CREATE PROCEDURE SP_MODIFICA_REVISION_EXPEDIENTE
    @id_revision INT,
    @estado VARCHAR(20),
    @justificacion VARCHAR(500)
AS
BEGIN

    UPDATE REVISIONES_EXPEDIENTE
    SET 
		estado = @estado,
        justificacion = @justificacion
	WHERE id_revision = @id_revision;

END;
GO

CREATE PROCEDURE SP_ELIMINA_REVISION_EXPEDIENTE
    @id_revision INT
AS
BEGIN
    DELETE FROM REVISIONES_EXPEDIENTE
    WHERE id_revision = @id_revision;
END;
GO

-- Funcion para validar clave del usuario
CREATE FUNCTION FN_LOGIN_USER(
	@user_name VARCHAR(50),
	@clave VARCHAR(20)
)
RETURNS BIT
AS
BEGIN
	RETURN(
		SELECT CASE WHEN EXISTS(
			SELECT 1
			FROM USUARIOS
			WHERE
				user_name = @user_name AND
				clave = @clave AND
				estado = 1
		) THEN 1 ELSE 0 END
	);
END;