INSERT INTO TIPO_USUARIO (tipo_usuario)
VALUES 
('TECNICO'),
('COORDINADOR');

INSERT INTO USUARIOS (user_name, clave, nombres, apellidos, id_tipo_usuario)
VALUES
('tecnico1', '1234', 'Juan', 'Pérez', 1),
('tecnico2', '1234', 'Ana', 'López', 1),
('coord1',   '1234', 'Carlos', 'Ramírez', 2);

INSERT INTO EXPEDIENTES (descripcion, usuario_creacion, estado)
VALUES
('Robo en zona 1', 1, 'REGISTRADO'),
('Allanamiento en zona 5', 2, 'REGISTRADO');

INSERT INTO INDICIOS
(id_expediente, descripcion, color, peso, ubicacion, usuario_creacion)
VALUES
(1, 'Arma blanca tipo cuchillo', 'Plateado', 1.25, 'Dormitorio principal', 1),
(1, 'Huella dactilar en ventana', 'N/A', NULL, 'Ventana trasera', 2),
(2, 'Teléfono celular marca X', 'Negro', 0.45, 'Sala', 1);

INSERT INTO REVISIONES_EXPEDIENTE
(id_expediente, id_coordinador, estado, justificacion)
VALUES
(1, 3, 'APROBADO', NULL),
(2, 3, 'RECHAZADO', 'Falta detallar peso y ubicación exacta de los indicios');

SELECT dbo.FN_LOGIN_USER('tecnico1', '1234') AS LoginTecnico;
SELECT dbo.FN_LOGIN_USER('coord1', '1234') AS LoginCoordinador;
SELECT dbo.FN_LOGIN_USER('coord1', 'xxxx') AS LoginInvalido;

SELECT * FROM EXPEDIENTES;
SELECT * FROM INDICIOS;
SELECT * FROM REVISIONES_EXPEDIENTE;

SELECT SCOPE_IDENTITY();