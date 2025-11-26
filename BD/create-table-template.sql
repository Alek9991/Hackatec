-- ================================================
-- DATABASE: Lerma (PostgreSQL)
-- ================================================

-- USERS
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    rol VARCHAR(50) DEFAULT 'usuario',
    fecha_creacion TIMESTAMP DEFAULT NOW()
);

-- PUNTOS EN EL MAPA
CREATE TABLE puntos_mapa (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(50) NOT NULL, -- "contaminación", "proyecto", "monitoreo"
    lat DECIMAL(10, 6) NOT NULL,
    lng DECIMAL(10, 6) NOT NULL,
    usuario_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    fecha TIMESTAMP DEFAULT NOW()
);

-- PUBLICACIONES (tipo red social)
CREATE TABLE publicaciones (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    estado VARCHAR(60) NOT NULL, -- "Guanajuato", "Jalisco", "Estado de México"...
    lat DECIMAL(10, 6),
    lng DECIMAL(10, 6),
    usuario_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    fecha TIMESTAMP DEFAULT NOW()
);

-- COMENTARIOS EN PUBLICACIONES
CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    post_id INTEGER REFERENCES publicaciones(id) ON DELETE CASCADE,
    usuario_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    fecha TIMESTAMP DEFAULT NOW()
);

-- ALERTAS GENERADAS AUTOMÁTICAMENTE O POR IA
CREATE TABLE alertas (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,     -- "clima", "agua", "riesgo"
    mensaje TEXT NOT NULL,
    nivel_riesgo VARCHAR(20),      -- "bajo", "medio", "alto"
    estado VARCHAR(60) NOT NULL,
    datos_clima JSONB,             -- contiene info de API clima
    fecha TIMESTAMP DEFAULT NOW()
);

-- REPORTE CLIMÁTICO AUTOMÁTICO
CREATE TABLE reporte_climatico (
    id SERIAL PRIMARY KEY,
    estado VARCHAR(60) NOT NULL,
    temperatura NUMERIC(5,2),
    lluvia NUMERIC(5,2),
    viento NUMERIC(5,2),
    fecha TIMESTAMP DEFAULT NOW()
);

-- CATEGORÍAS (opcional IA)
CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

-- RELACIÓN opcional Publicación–Categoría
CREATE TABLE publicaciones_categorias (
    publicacion_id INTEGER REFERENCES publicaciones(id) ON DELETE CASCADE,
    categoria_id INTEGER REFERENCES categorias(id) ON DELETE CASCADE,
    PRIMARY KEY (publicacion_id, categoria_id)
);



-- Indices de las tablas
CREATE INDEX idx_posts_estado ON publicaciones(estado);
CREATE INDEX idx_puntos_tipo ON puntos_mapa(tipo);
CREATE INDEX idx_alertas_estado ON alertas(estado);
CREATE INDEX idx_posts_geo ON publicaciones(lat, lng);
CREATE INDEX idx_puntos_geo ON puntos_mapa(lat, lng);

-- ================================================
-- Users
INSERT INTO users (nombre, email, rol)
VALUES
('Ana Pérez', 'ana@example.com', 'admin'),
('Carlos Gómez', 'carlos@example.com', 'usuario'),
('Lucía Hernández', 'lucia@example.com', 'usuario');

-- PuntosMapa
INSERT INTO puntos_mapa (nombre, descripcion, tipo, lat, lng, usuario_id)
VALUES
('Descarga industrial', 'Posible descarga de residuos', 'contaminacion', 20.674, -103.387, 1),
('Proyecto de reforestación', 'Zona en recuperación', 'proyecto', 20.711, -103.350, 2);

-- Publicaciones
INSERT INTO publicaciones (titulo, descripcion, estado, lat, lng, usuario_id)
VALUES
('Agua con mal olor', 'Reportan olor fuerte en río', 'Jalisco', 20.70, -103.40, 2),
('Voluntariado', 'Buscamos gente para limpiar la ribera', 'Guanajuato', NULL, NULL, 1);

-- Comentarios
INSERT INTO comentarios (contenido, post_id, usuario_id)
VALUES
('Lo vi también hoy en la mañana', 1, 3),
('Yo me apunto al voluntariado', 2, 2);

-- Alertas
INSERT INTO alertas (tipo, mensaje, nivel_riesgo, estado, datos_clima)
VALUES
('clima', 'Posible tormenta fuerte', 'alto', 'Michoacán', '{"probabilidad_lluvia": 0.85}');

-- Reporte climático
INSERT INTO reporte_climatico (estado, temperatura, lluvia, viento)
VALUES
('Guanajuato', 23.5, 0.0, 5.6),
('Jalisco', 19.1, 2.3, 7.2);

-- Categorías
INSERT INTO categorias (nombre)
VALUES ('contaminación'), ('recursos hídricos'), ('proyectos'), ('voluntariado');

-- Publicación–Categoría ejemplo
INSERT INTO publicaciones_categorias (publicacion_id, categoria_id)
VALUES (1, 1), (2, 4);
