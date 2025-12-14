import sql from "mssql"

import { getConnection } from "../database/conn.js"

export const getAllIndicios = async (req, res) => {
    const pool = await getConnection()
    var query = 'SELECT * FROM INDICIOS'

    const result = await pool.request().query(query)

    res.json(result.recordset)
}

export const getIndicio = async (req, res) => {
    const {id} = req.params

    try{
        const pool = await getConnection()
        const request = pool.request()
        const query = 'SELECT * FROM INDICIOS WHERE id_indicio = @idIndicio'

        request.input('idIndicio', sql.Int, id)

        const result = await request.query(query)

        if (result.recordset.length === 0) {
            return res.status(404).json({ 
                mensaje: "Indicio no encontrado" 
            });
        }

        res.json(result.recordset[0]);

    } catch (error) {
        console.error(error);
        res.status(500).json({
            mensaje: "Error interno en getIndicio"
        });
    }
}

export const createIndicio = async (req, res) => {
    const { id_expediente, descripcion, color, peso, ubicacion, usuario_creacion} = req.body

    try {
        const pool = await getConnection()
        const request = pool.request()

        request.input("id_expediente", sql.Int, id_expediente)
        request.input("descripcion", sql.VarChar(500), descripcion)
        request.input("color", sql.VarChar(30), color)
        request.input("peso", sql.Decimal(10,2), peso)
        request.input("ubicacion", sql.VarChar(200), ubicacion)
        request.input("usuario_creacion", sql.Int, usuario_creacion)
        request.output("mensaje", sql.VarChar(200))
        request.output("id_indicio", sql.Int)

        const result = await request.execute("SP_CREACION_INDICIOS")

        const returnCode = result.returnValue
        const mensaje = result.output.mensaje
        const idIndicio = result.output.id_indicio

        if (returnCode !== 0) {
            return res.status(400).json({
                codigo: returnCode,
                mensaje: mensaje
            })
        }

        res.status(201).json({
            mensaje: mensaje,
            id_indicio: idIndicio
        })

    } catch (error) {
        console.error(error)
        res.status(500).json({
            mensaje: "Error interno del servidor"
        })
    }
}

export const updateIndicio = async (req, res) => {
    const {descripcion, color, peso, ubicacion} = req.body
    const {id} = req.params

    try {
        const pool = await getConnection()
        const request = pool.request()

        request.input('id_indicio', sql.Int, id)
        request.input("descripcion", sql.VarChar(500), descripcion)
        request.input("color", sql.VarChar(30), color)
        request.input("peso", sql.Decimal(10,2), peso)
        request.input("ubicacion", sql.VarChar(200), ubicacion)
        request.output("mensaje", sql.VarChar(200))

        const result = await request.execute("SP_MODIFICA_INDICIO")

        const returnCode = result.returnValue
        const mensaje = result.output.mensaje

        if (returnCode !== 0) {
            return res.status(400).json({
                codigo: returnCode,
                mensaje: mensaje
            })
        }

        res.status(201).json({
            mensaje: mensaje
        })

    } catch (error) {
        console.error(error)
        res.status(500).json({
            mensaje: "Error interno en updateIndicio"
        })
    }
}

export const deleteIndicio = async (req, res) => {
    const {id} = req.params
    
    try{
        const pool = await getConnection()
        const request = pool.request()

        request.input('id_indicio', sql.Int, id)
        request.output("mensaje", sql.VarChar(200))

        const result = await request.execute("SP_ELIMINA_INDICIO")

        const returnCode = result.returnValue
        const mensaje = result.output.mensaje

        if (returnCode != 0) {
            return res.status(400).json({
                codigo: returnCode,
                mensaje: mensaje
            })
        }

        res.status(201).json({
            mensaje: mensaje
        })

    } catch (error) {
        console.error(error)
        res.status(500).json({
            mensaje: "Error interno del servidor"
        })
    }
}