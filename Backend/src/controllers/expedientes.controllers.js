import sql from "mssql"

import { getConnection } from "../database/conn.js"

export const getAllExpedientes = async (req, res) => {
    const pool = await getConnection()
    var query = 'SELECT * FROM EXPEDIENTES'

    const result = await pool.request().query(query)

    res.json(result.recordset)
}

export const getExpediente = async (req, res) => {
    const {id} = req.params

    try{
        const pool = await getConnection()
        const request = pool.request()
        const query = 'SELECT * FROM EXPEDIENTES WHERE id_expediente = @idExpediente'

        request.input('idExpediente', sql.Int, id)

        const result = await request.query(query)

        if (result.recordset.length === 0) {
            return res.status(404).json({ 
                mensaje: "Expediente no encontrado" 
            });
        }

        res.json(result.recordset[0]);

    } catch (error) {
        console.error(error);
        res.status(500).json({
            mensaje: "Error interno en getExpediente"
        });
    }
}

export const createExpediente = async (req, res) => {
    const { descripcion, usuario_creacion } = req.body

    try {
        const pool = await getConnection()
        const request = pool.request()

        request.input("descripcion", sql.VarChar(500), descripcion)
        request.input("usuario_creacion", sql.Int, usuario_creacion)
        request.input("estado", sql.VarChar(20), "REGISTRADO")
        request.output("mensaje", sql.VarChar(200))
        request.output("id_expediente", sql.Int)

        const result = await request.execute("SP_CREA_EXPEDIENTE")

        const returnCode = result.returnValue
        const mensaje = result.output.mensaje
        const idExpediente = result.output.id_expediente

        if (returnCode !== 0) {
            return res.status(400).json({
                codigo: returnCode,
                mensaje: mensaje
            })
        }

        res.status(201).json({
            mensaje: mensaje,
            idExpediente: idExpediente
        })

    } catch (error) {
        console.error(error)
        res.status(500).json({
            mensaje: "Error interno del servidor"
        })
    }
}

export const updateExpediente = async (req, res) => {
    const { descripcion, estado } = req.body
    const {id} = req.params

    try {
        const pool = await getConnection()
        const request = pool.request()

        request.input('id_expediente', sql.Int, id)
        request.input("descripcion", sql.VarChar(500), descripcion)
        request.input("estado", sql.VarChar(20), estado)
        request.output("mensaje", sql.VarChar(200))

        const result = await request.execute("SP_MODIFICA_EXPEDIENTE")

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
            mensaje: "Error interno del servidor"
        })
    }
}

export const deleteExpediente = async (req, res) => {
    const {id} = req.params
    
    try{
        const pool = await getConnection()
        const request = pool.request()

        request.input('id_expediente', sql.Int, id)
        request.output("mensaje", sql.VarChar(200))

        const result = await request.execute("SP_ELIMINA_EXPEDIENTE")

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