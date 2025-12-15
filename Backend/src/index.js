import 'dotenv/config'
import app from './app.js'
import { getConnection } from './database/conn.js'


const PORT = process.env.PORT || 3000

app.listen(PORT)
console.log('server iniciado' )