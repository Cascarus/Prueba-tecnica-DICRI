-- ---------------------------------------------------------------------------------
-- DDL DE PROCEDIMIENTOS ALMACENADOS Y FUNCIONES
-- ---------------------------------------------------------------------------------
USE mp_proyect;
GO
-- PROCEDURES PARA TABLA USUARIOS
CREATE OR ALTER PROCEDURE SP_CREA_USUARIO
    @user_name VARCHAR(50),
    @clave VARCHAR(20),
    @nombres VARCHAR(30),
    @apellidos VARCHAR(30),
    @id_tipo_usuario INT,
    @mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO USUARIOS (user_name, clave, nombres, apellidos, id_tipo_usuario)
        VALUES (@user_name, @clave, @nombres, @apellidos, @id_tipo_usuario);

        SET @mensaje = 'Usuario creado correctamente';
        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @mensaje = ERROR_MESSAGE();
        RETURN 1;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE SP_MODIFICA_USUARIO
    @id_usuario INT,
    @user_name VARCHAR(50),
    @nombres VARCHAR(30),
    @apellidos VARCHAR(30),
    @id_tipo_usuario INT,
    @estado BIT,
    @mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @id_usuario)
    BEGIN
        SET @mensaje = 'Usuario no existe';
        RETURN 2;
    END

    UPDATE USUARIOS
    SET user_name = @user_name,
        nombres = @nombres,
        apellidos = @apellidos,
        id_tipo_usuario = @id_tipo_usuario,
        estado = @estado
    WHERE id_usuario = @id_usuario;

    SET @mensaje = 'Usuario modificado correctamente';
    RETURN 0;
END;
GO

CREATE OR ALTER PROCEDURE SP_ELIMINA_USUARIO
    @id_usuario INT,
    @mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @id_usuario)
    BEGIN
        SET @mensaje = 'Usuario no existe';
        RETURN 2;
    END

    UPDATE USUARIOS
    SET estado = 0
    WHERE id_usuario = @id_usuario;

    SET @mensaje = 'Usuario desactivado correctamente';
    RETURN 0;
END;
GO

-- PROCEDURES PARA TABLA EXPEDIENTES
CREATE  OR ALTER PROCEDURE SP_CREA_EXPEDIENTE
    @descripcion VARCHAR(500),
    @usuario_creacion INT,
    @estado VARCHAR(20),
    @mensaje VARCHAR(200) OUTPUT,
    @id_expediente INT OUTPUT

AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO EXPEDIENTES (descripcion, usuario_creacion, estado)
        VALUES (@descripcion, @usuario_creacion, @estado);

        SET @mensaje = 'Expediente creado correctamente';
        SET @id_expediente = SCOPE_IDENTITY();

        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @mensaje = ERROR_MESSAGE();
        RETURN 1;
    END CATCH

END;
GO

CREATE OR ALTER PROCEDURE SP_MODIFICA_EXPEDIENTE
    @id_expediente INT,
    @descripcion VARCHAR(500),
    @estado VARCHAR(20),
    @mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM EXPEDIENTES WHERE id_expediente = @id_expediente)
    BEGIN
        SET @mensaje = 'Expediente no existe';
        RETURN 2;
    END

    UPDATE EXPEDIENTES
    SET descripcion = @descripcion,
        estado = @estado
    WHERE id_expediente = @id_expediente;

    SET @mensaje = 'Expediente modificado correctamente';
    RETURN 0;
END;
GO

CREATE  OR ALTER PROCEDURE SP_ELIMINA_EXPEDIENTE
    @id_expediente INT,
    @mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM EXPEDIENTES WHERE id_expediente = @id_expediente)
    BEGIN
        SET @mensaje = 'Expediente no existe';
        RETURN 2;
    END

    IF EXISTS (
        SELECT 1
        FROM EXPEDIENTES
        WHERE id_expediente = @id_expediente
          AND estado = 'aprobado'
    )
    BEGIN
        SET @mensaje = 'No se puede eliminar un expediente aprobado';
        RETURN 3;
    END

    DELETE FROM EXPEDIENTES
    WHERE id_expediente = @id_expediente;

    SET @mensaje = 'Expediente eliminado correctamente';
    RETURN 0;
END;
GO

-- PROCEDURES PARA TABLA INDICIOS
CREATE OR ALTER PROCEDURE SP_CREACION_INDICIOS
    @id_expediente INT,
    @descripcion VARCHAR(500),
    @color VARCHAR(30),
    @peso DECIMAL(10,2),
    @ubicacion VARCHAR(200),
    @usuario_creacion INT,
    @mensaje VARCHAR(200) OUTPUT,
    @id_indicio INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO INDICIOS (id_expediente, descripcion, color, peso, ubicacion, usuario_creacion)
        VALUES (@id_expediente, @descripcion, @color, @peso, @ubicacion, @usuario_creacion);

        SET @mensaje = 'Indicio creado correctamente';
        SET @id_indicio = SCOPE_IDENTITY();

        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @mensaje = ERROR_MESSAGE();
        RETURN 1;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE SP_MODIFICA_INDICIO
    @id_indicio INT,
    @descripcion VARCHAR(500),
    @color VARCHAR(30),
    @peso DECIMAL(10,2),
    @ubicacion VARCHAR(200),
    @mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM INDICIOS WHERE id_indicio = @id_indicio)
    BEGIN
        SET @mensaje = 'Indicio no existe';
        RETURN 2;
    END

    UPDATE INDICIOS
    SET descripcion = @descripcion,
        color = @color,
        peso = @peso,
        ubicacion = @ubicacion
    WHERE id_indicio = @id_indicio;

    SET @mensaje = 'Indicio modificado correctamente';
    RETURN 0;
END;
GO

CREATE OR ALTER PROCEDURE SP_ELIMINA_INDICIO
    @id_indicio INT,
    @mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM INDICIOS WHERE id_indicio = @id_indicio)
    BEGIN
        SET @mensaje = 'Indicio no existe';
        RETURN 2;
    END

    DELETE FROM INDICIOS
    WHERE id_indicio = @id_indicio;

    SET @mensaje = 'Indicio eliminado correctamente';
    RETURN 0;
END;
GO

-- PROCEDURES PARA TABLA REVISIONES_EXPEDIENTES
CREATE OR ALTER PROCEDURE SP_CREA_REVISION_EXPEDIENTE
    @id_expediente INT,
    @id_coordinador INT,
    @estado VARCHAR(20),
    @justificacion VARCHAR(500),
    @mensaje VARCHAR(200) OUTPUT,
    @id_revision INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM EXPEDIENTES WHERE id_expediente = @id_expediente)
        BEGIN
            SET @mensaje = 'Expediente no existe';
            ROLLBACK TRAN;
            RETURN 2;
        END

        INSERT INTO REVISIONES_EXPEDIENTE (id_expediente, id_coordinador, estado, justificacion)
        VALUES (@id_expediente, @id_coordinador, @estado, @justificacion);

        SET @id_revision = SCOPE_IDENTITY();

        UPDATE EXPEDIENTES
        SET estado = @estado
        WHERE id_expediente = @id_expediente;

        COMMIT TRAN;

        SET @mensaje = 'Revisión creada correctamente';
        
        RETURN 0;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        SET @mensaje = ERROR_MESSAGE();
        RETURN 1;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE SP_MODIFICA_REVISION_EXPEDIENTE
    @id_revision INT,
    @estado VARCHAR(20),
    @justificacion VARCHAR(500),
    @mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_expediente INT;

    BEGIN TRY
        BEGIN TRAN;

        SELECT @id_expediente = id_expediente
        FROM REVISIONES_EXPEDIENTE
        WHERE id_revision = @id_revision;

        IF @id_expediente IS NULL
        BEGIN
            SET @mensaje = 'Revisión no existe';
            ROLLBACK TRAN;
            RETURN 2;
        END

        UPDATE REVISIONES_EXPEDIENTE
        SET estado = @estado,
            justificacion = @justificacion
        WHERE id_revision = @id_revision;

        UPDATE EXPEDIENTES
        SET estado = @estado
        WHERE id_expediente = @id_expediente;

        COMMIT TRAN;

        SET @mensaje = 'Revisión actualizada correctamente';
        RETURN 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        SET @mensaje = ERROR_MESSAGE();
        RETURN 1;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE SP_ELIMINA_REVISION_EXPEDIENTE
    @id_revision INT,
    @mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM REVISIONES_EXPEDIENTE
    WHERE id_revision = @id_revision;

    SET @mensaje = 'Revisión eliminada correctamente';
    RETURN 0;
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