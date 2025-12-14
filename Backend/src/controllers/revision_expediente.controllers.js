import sql from "mssql"

import { getConnection } from "../database/conn.js"

export const getAllRevExpedientes = async (req, res) => {
    const pool = await getConnection()
    var query = 'SELECT * FROM REVISIONES_EXPEDIENTE'

    const result = await pool.request().query(query)

    res.json(result.recordset)
}

export const getRevExpediente = async (req, res) => {
    const {id} = req.params

    try{
        const pool = await getConnection()
        const request = pool.request()
        const query = 'SELECT * FROM REVISIONES_EXPEDIENTE WHERE id_revision = @idRevExpediente'

        request.input('idRevExpediente', sql.Int, id)

        const result = await request.query(query)

        if (result.recordset.length === 0) {
            return res.status(404).json({ 
                mensaje: "RevExpediente no encontrado" 
            });
        }

        res.json(result.recordset[0]);

    } catch (error) {
        console.error(error);
        res.status(500).json({
            mensaje: "Error interno en getRevExpediente"
        });
    }
}

export const createRevExpediente = async (req, res) => {
    const { id_expediente, id_coordinador, estado, justificacion } = req.body

    try {
        const pool = await getConnection()
        const request = pool.request()

        request.input("id_expediente", sql.Int, id_expediente)
        request.input("id_coordinador", sql.Int, id_coordinador)
        request.input("estado", sql.VarChar(20), estado)
        request.input("justificacion", sql.VarChar(500), justificacion)
        request.output("mensaje", sql.VarChar(200))
        request.output("id_revision", sql.Int)
        

        const result = await request.execute("SP_CREA_REVISION_EXPEDIENTE")

        const returnCode = result.returnValue
        const mensaje = result.output.mensaje
        const idRevExpediente = result.output.id_revision

        if (returnCode !== 0) {
            return res.status(400).json({
                codigo: returnCode,
                mensaje: mensaje
            })
        }

        res.status(201).json({
            mensaje: mensaje,
            id_revision: idRevExpediente
        })

    } catch (error) {
        console.error(error)
        res.status(500).json({
            mensaje: "Error interno del servidor"
        })
    }
}

export const updateRevExpediente = async (req, res) => {
    const { estado, justificacion } = req.body
    const {id} = req.params

    try {
        const pool = await getConnection()
        const request = pool.request()

        request.input('id_revision', sql.Int, id)
        request.input("estado", sql.VarChar(20), estado)
        request.input("justificacion", sql.VarChar(500), justificacion)
        request.output("mensaje", sql.VarChar(200))

        const result = await request.execute("SP_MODIFICA_REVISION_EXPEDIENTE")

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

export const deleteRevExpediente = async (req, res) => {
    const {id} = req.params
    
    try{
        const pool = await getConnection()
        const request = pool.request()

        request.input('id_revision', sql.Int, id)
        request.output("mensaje", sql.VarChar(200))

        const result = await request.execute("SP_ELIMINA_REVISION_EXPEDIENTE")

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