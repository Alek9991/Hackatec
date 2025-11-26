// db.js
import mysql from "mysql2/promise";

export const db = await mysql.createPool({
  host: "localhost",
  user: "root",
  password: "",           // tu contraseña
  database: "hackatec",      // tu base de datos
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Probar conexión:
try {
  const [rows] = await db.query("SELECT 1 + 1 AS resultado");
  console.log("Conexión MySQL OK →", rows[0].resultado);
} catch (err) {
  console.error("Error conectando a MySQL:", err);
}
