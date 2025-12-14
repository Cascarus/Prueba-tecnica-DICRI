import app from './app.js'
import { getConnection } from './database/conn.js'

getConnection()

app.listen(3000)
console.log('server iniciado')