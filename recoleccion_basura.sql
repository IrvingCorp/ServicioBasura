-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3307
-- Tiempo de generación: 27-11-2025 a las 15:05:46
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `recoleccion_basura`
--



CREATE TABLE `avisos` (
  `id` int(11) NOT NULL,
  `ruta_id` int(11) NOT NULL,
  `mensaje` text NOT NULL,
  `enviado_en` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



CREATE TABLE `camiones` (
  `id` int(11) NOT NULL,
  `numero_unidad` varchar(30) NOT NULL,
  `estado` enum('operativo','reparacion') DEFAULT 'operativo',
  `tipo` enum('principal','respaldo') DEFAULT 'principal',
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `colonias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `prioridad` int(11) NOT NULL,
  `zona` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `incidencias` (
  `id` int(11) NOT NULL,
  `ruta_id` int(11) NOT NULL,
  `chofer_id` int(11) NOT NULL,
  `tipo` enum('falla','bloqueo','accidente','calle_inaccesible') NOT NULL,
  `descripcion` text DEFAULT NULL,
  `foto_url` varchar(255) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



CREATE TABLE `planeaciones_semanales` (
  `id` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `creado_por` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



CREATE TABLE `planeacion_detalle` (
  `id` int(11) NOT NULL,
  `planeacion_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `colonia_id` int(11) NOT NULL,
  `camion_id` int(11) NOT NULL,
  `chofer_id` int(11) NOT NULL,
  `tipo` enum('planeado','recalculado','reasignado_admin') DEFAULT 'planeado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



CREATE TABLE `rutas` (
  `id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `camion_id` int(11) NOT NULL,
  `chofer_id` int(11) NOT NULL,
  `estado` enum('en_progreso','completada','fallida') DEFAULT 'en_progreso',
  `origen` enum('planeado','recalculado','manual') DEFAULT 'planeado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



CREATE TABLE `ruta_colonia` (
  `id` int(11) NOT NULL,
  `ruta_id` int(11) NOT NULL,
  `colonia_id` int(11) NOT NULL,
  `atendida` tinyint(1) DEFAULT 0,
  `hora_atendida` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol` enum('admin','chofer') NOT NULL,
  `creado_en` datetime DEFAULT current_timestamp(),
  `actualizado_en` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



INSERT INTO `users` (`id`, `nombre`, `email`, `password_hash`, `rol`, `creado_en`, `actualizado_en`) VALUES
(1, 'Irving', 'user@example.com', '$2b$12$6JQTKSuq3bWtBBY56Q/o/OuckNSejwx..Cbh8PQP3LSH9tq4kg2f6', 'admin', '2025-11-27 03:49:22', '2025-11-27 03:50:55');


ALTER TABLE `avisos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ruta_id` (`ruta_id`);


ALTER TABLE `camiones`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `colonias`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `incidencias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ruta_id` (`ruta_id`),
  ADD KEY `chofer_id` (`chofer_id`);


ALTER TABLE `planeaciones_semanales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `creado_por` (`creado_por`);


ALTER TABLE `planeacion_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `planeacion_id` (`planeacion_id`),
  ADD KEY `colonia_id` (`colonia_id`),
  ADD KEY `camion_id` (`camion_id`),
  ADD KEY `chofer_id` (`chofer_id`);


ALTER TABLE `rutas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `camion_id` (`camion_id`),
  ADD KEY `chofer_id` (`chofer_id`);


ALTER TABLE `ruta_colonia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ruta_id` (`ruta_id`),
  ADD KEY `colonia_id` (`colonia_id`);


ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);




ALTER TABLE `avisos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `camiones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `colonias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `incidencias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `planeaciones_semanales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `planeacion_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `rutas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `ruta_colonia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;


ALTER TABLE `avisos`
  ADD CONSTRAINT `avisos_ibfk_1` FOREIGN KEY (`ruta_id`) REFERENCES `rutas` (`id`);


ALTER TABLE `incidencias`
  ADD CONSTRAINT `incidencias_ibfk_1` FOREIGN KEY (`ruta_id`) REFERENCES `rutas` (`id`),
  ADD CONSTRAINT `incidencias_ibfk_2` FOREIGN KEY (`chofer_id`) REFERENCES `users` (`id`);


ALTER TABLE `planeaciones_semanales`
  ADD CONSTRAINT `planeaciones_semanales_ibfk_1` FOREIGN KEY (`creado_por`) REFERENCES `users` (`id`);


ALTER TABLE `planeacion_detalle`
  ADD CONSTRAINT `planeacion_detalle_ibfk_1` FOREIGN KEY (`planeacion_id`) REFERENCES `planeaciones_semanales` (`id`),
  ADD CONSTRAINT `planeacion_detalle_ibfk_2` FOREIGN KEY (`colonia_id`) REFERENCES `colonias` (`id`),
  ADD CONSTRAINT `planeacion_detalle_ibfk_3` FOREIGN KEY (`camion_id`) REFERENCES `camiones` (`id`),
  ADD CONSTRAINT `planeacion_detalle_ibfk_4` FOREIGN KEY (`chofer_id`) REFERENCES `users` (`id`);


ALTER TABLE `rutas`
  ADD CONSTRAINT `rutas_ibfk_1` FOREIGN KEY (`camion_id`) REFERENCES `camiones` (`id`),
  ADD CONSTRAINT `rutas_ibfk_2` FOREIGN KEY (`chofer_id`) REFERENCES `users` (`id`);


ALTER TABLE `ruta_colonia`
  ADD CONSTRAINT `ruta_colonia_ibfk_1` FOREIGN KEY (`ruta_id`) REFERENCES `rutas` (`id`),
  ADD CONSTRAINT `ruta_colonia_ibfk_2` FOREIGN KEY (`colonia_id`) REFERENCES `colonias` (`id`);
COMMIT;
