const mysql = require('mysql2/promise')

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'mysql01.cs.virginia.edu',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'wyb4kk',
  password: process.env.DB_PASSWORD || '1234',
  database: process.env.DB_NAME || 'wyb4kk_c',
  waitForConnections: true,
  connectionLimit: Number(process.env.DB_CONNECTION_LIMIT || 10),
  namedPlaceholders: true,
})

module.exports = pool
