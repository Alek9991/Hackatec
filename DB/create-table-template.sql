-- ================================================
-- DATABASE: Lerma (MySQL)
-- ================================================

-- USERS
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    rol VARCHAR(50) DEFAULT 'usuario',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- PUNTOS EN EL MAPA
CREATE TABLE puntos_mapa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(50) NOT NULL,
    lat DECIMAL(10,6) NOT NULL,
    lng DECIMAL(10,6) NOT NULL,
    usuario_id INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- PUBLICACIONES
CREATE TABLE publicaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    estado VARCHAR(60) NOT NULL,
    lat DECIMAL(10,6),
    lng DECIMAL(10,6),
    usuario_id INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- COMENTARIOS
CREATE TABLE comentarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contenido TEXT NOT NULL,
    post_id INT,
    usuario_id INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES publicaciones(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ALERTAS
CREATE TABLE alertas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    mensaje TEXT NOT NULL,
    nivel_riesgo VARCHAR(20),
    estado VARCHAR(60) NOT NULL,
    datos_clima JSON,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- REPORTE CLIMÁTICO
CREATE TABLE reporte_climatico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(60) NOT NULL,
    temperatura DECIMAL(5,2),
    lluvia DECIMAL(5,2),
    viento DECIMAL(5,2),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- CATEGORÍAS
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
) ENGINE=InnoDB;

-- RELACIÓN Publicación–Categoría
CREATE TABLE publicaciones_categorias (
    publicacion_id INT NOT NULL,
    categoria_id INT NOT NULL,
    PRIMARY KEY (publicacion_id, categoria_id),
    FOREIGN KEY (publicacion_id) REFERENCES publicaciones(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ================================================
-- ÍNDICES
CREATE INDEX idx_posts_estado ON publicaciones(estado);
CREATE INDEX idx_puntos_tipo ON puntos_mapa(tipo);
CREATE INDEX idx_alertas_estado ON alertas(estado);
CREATE INDEX idx_posts_geo ON publicaciones(lat, lng);
CREATE INDEX idx_puntos_geo ON puntos_mapa(lat, lng);

-- ================================================
-- DATA INSERT ------------------------------

INSERT INTO users (nombre, email, rol)
VALUES
('Ana Pérez', 'ana@example.com', 'admin'),
('Carlos Gómez', 'carlos@example.com', 'usuario'),
('Lucía Hernández', 'lucia@example.com', 'usuario');

INSERT INTO puntos_mapa (nombre, descripcion, tipo, lat, lng, usuario_id)
VALUES
('Descarga industrial', 'Posible descarga de residuos', 'contaminacion', 20.674, -103.387, 1),
('Proyecto de reforestación', 'Zona en recuperación', 'proyecto', 20.711, -103.350, 2);

INSERT INTO publicaciones (titulo, descripcion, estado, lat, lng, usuario_id)
VALUES
('Agua con mal olor', 'Reportan olor fuerte en río', 'Jalisco', 20.70, -103.40, 2),
('Voluntariado', 'Buscamos gente para limpiar la ribera', 'Guanajuato', NULL, NULL, 1);

INSERT INTO comentarios (contenido, post_id, usuario_id)
VALUES
('Lo vi también hoy en la mañana', 1, 3),
('Yo me apunto al voluntariado', 2, 2);

INSERT INTO alertas (tipo, mensaje, nivel_riesgo, estado, datos_clima)
VALUES
('clima', 'Posible tormenta fuerte', 'alto', 'Michoacán', '{"probabilidad_lluvia": 0.85}');

INSERT INTO reporte_climatico (estado, temperatura, lluvia, viento)
VALUES
('Guanajuato', 23.5, 0.0, 5.6),
('Jalisco', 19.1, 2.3, 7.2);

INSERT INTO categorias (nombre)
VALUES 
('contaminación'), 
('recursos hídricos'), 
('proyectos'), 
('voluntariado');

INSERT INTO publicaciones_categorias (publicacion_id, categoria_id)
VALUES (1, 1), (2, 4);
