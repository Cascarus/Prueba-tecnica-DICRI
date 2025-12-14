import express from 'express'
import expedientesRoutes from './routes/expedientes.routes.js'
import indiciosRoutes from './routes/indicios.routes.js'
import revisionExpedientesRoutes from './routes/revisiones_expediente.routes.js'

const app = express()

app.use(express.json())
app.use(expedientesRoutes)
app.use(indiciosRoutes)
app.use(revisionExpedientesRoutes)

export default app