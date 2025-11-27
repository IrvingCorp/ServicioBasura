-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3308
-- Tiempo de generación: 27-11-2025 a las 00:54:22
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `avisos`
--

CREATE TABLE `avisos` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `mensaje` text NOT NULL,
  `leido` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora_diaria`
--

CREATE TABLE `bitacora_diaria` (
  `id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `ruta_id` int(11) NOT NULL,
  `resumen` text DEFAULT NULL,
  `archivo_excel` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `camiones`
--

CREATE TABLE `camiones` (
  `id` int(11) NOT NULL,
  `numero_unidad` varchar(10) NOT NULL,
  `placas` varchar(20) NOT NULL,
  `estado` enum('operativo','en_reparacion','fuera_servicio') DEFAULT 'operativo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `camiones`
--

INSERT INTO `camiones` (`id`, `numero_unidad`, `placas`, `estado`) VALUES
(1, '01', 'PCH-12-34', 'operativo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `colonias`
--

CREATE TABLE `colonias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `tipo_zona` enum('comercial_avenida','escuela_hospital','otra') NOT NULL DEFAULT 'otra',
  `prioridad_nivel` tinyint(4) NOT NULL DEFAULT 4,
  `lat` decimal(10,6) DEFAULT NULL,
  `lng` decimal(10,6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `colonias`
--

INSERT INTO `colonias` (`id`, `nombre`, `tipo_zona`, `prioridad_nivel`, `lat`, `lng`) VALUES
(1, 'Mercado Central', 'comercial_avenida', 1, 16.167800, -95.199300),
(2, 'Hospital General', 'escuela_hospital', 2, 16.168500, -95.197000),
(3, 'Colonia Las Flores', 'otra', 3, 16.170000, -95.195000),
(4, 'Colonia Lejana', 'otra', 4, 16.180000, -95.210000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `incidencias`
--

CREATE TABLE `incidencias` (
  `id` int(11) NOT NULL,
  `ruta_id` int(11) NOT NULL,
  `colonia_id` int(11) DEFAULT NULL,
  `tipo` enum('falla_mecanica','bloqueo','accidente','calle_inaccesible','otro') NOT NULL,
  `descripcion` text DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planificacion_colonias`
--

CREATE TABLE `planificacion_colonias` (
  `id` int(11) NOT NULL,
  `colonia_id` int(11) NOT NULL,
  `dia_semana` enum('lunes','martes','miercoles','jueves','viernes','sabado','domingo') NOT NULL,
  `turno_preferido` enum('manana','noche','cualquiera') DEFAULT 'manana',
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rutas`
--

CREATE TABLE `rutas` (
  `id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `camion_id` int(11) NOT NULL,
  `chofer_id` int(11) NOT NULL,
  `turno` enum('manana','noche') NOT NULL DEFAULT 'manana',
  `estado` enum('pendiente','en_proceso','finalizada','cancelada') DEFAULT 'pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ruta_colonias`
--

CREATE TABLE `ruta_colonias` (
  `id` int(11) NOT NULL,
  `ruta_id` int(11) NOT NULL,
  `colonia_id` int(11) NOT NULL,
  `estado` enum('pendiente','atendida','no_atendida') DEFAULT 'pendiente',
  `hora_actualizacion` datetime DEFAULT NULL,
  `orden` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `telefono` varchar(10) DEFAULT NULL,
  `rol` enum('admin','chofer','ayudante') NOT NULL,
  `contra` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `telefono`, `rol`, `contra`) VALUES
(1, 'Administrador', '9710000001', 'admin', 'admin123'),
(2, 'Juan Pérez', '9710000002', 'chofer', 'chofer123'),
(3, 'Luis Ayudante', '9710000003', 'ayudante', 'ayudante123');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_rutas_completas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_rutas_completas` (
`id_ruta` int(11)
,`fecha` date
,`turno` enum('manana','noche')
,`estado_ruta` enum('pendiente','en_proceso','finalizada','cancelada')
,`id_usuario` int(11)
,`nombre_usuario` varchar(120)
,`telefono` varchar(10)
,`rol` enum('admin','chofer','ayudante')
,`id_camion` int(11)
,`numero_unidad` varchar(10)
,`placas` varchar(20)
,`estado_camion` enum('operativo','en_reparacion','fuera_servicio')
,`id_colonia` int(11)
,`nombre_colonia` varchar(120)
,`tipo_zona` enum('comercial_avenida','escuela_hospital','otra')
,`prioridad_nivel` tinyint(4)
,`estado_colonia` enum('pendiente','atendida','no_atendida')
,`orden_visita` int(11)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_rutas_completas`
--
DROP TABLE IF EXISTS `vista_rutas_completas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_rutas_completas`  AS SELECT `r`.`id` AS `id_ruta`, `r`.`fecha` AS `fecha`, `r`.`turno` AS `turno`, `r`.`estado` AS `estado_ruta`, `u`.`id` AS `id_usuario`, `u`.`nombre` AS `nombre_usuario`, `u`.`telefono` AS `telefono`, `u`.`rol` AS `rol`, `c`.`id` AS `id_camion`, `c`.`numero_unidad` AS `numero_unidad`, `c`.`placas` AS `placas`, `c`.`estado` AS `estado_camion`, `col`.`id` AS `id_colonia`, `col`.`nombre` AS `nombre_colonia`, `col`.`tipo_zona` AS `tipo_zona`, `col`.`prioridad_nivel` AS `prioridad_nivel`, `rc`.`estado` AS `estado_colonia`, `rc`.`orden` AS `orden_visita` FROM ((((`rutas` `r` join `usuarios` `u` on(`u`.`id` = `r`.`chofer_id`)) join `camiones` `c` on(`c`.`id` = `r`.`camion_id`)) left join `ruta_colonias` `rc` on(`rc`.`ruta_id` = `r`.`id`)) left join `colonias` `col` on(`col`.`id` = `rc`.`colonia_id`)) ORDER BY `r`.`fecha` DESC, `r`.`turno` ASC, `r`.`id` ASC, `rc`.`orden` ASC ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `avisos`
--
ALTER TABLE `avisos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_aviso_usuario` (`usuario_id`);

--
-- Indices de la tabla `bitacora_diaria`
--
ALTER TABLE `bitacora_diaria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_bitacora_ruta` (`ruta_id`);

--
-- Indices de la tabla `camiones`
--
ALTER TABLE `camiones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `colonias`
--
ALTER TABLE `colonias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `incidencias`
--
ALTER TABLE `incidencias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_incidencia_ruta` (`ruta_id`),
  ADD KEY `fk_incidencia_colonia` (`colonia_id`);

--
-- Indices de la tabla `planificacion_colonias`
--
ALTER TABLE `planificacion_colonias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_plan_colonia` (`colonia_id`);

--
-- Indices de la tabla `rutas`
--
ALTER TABLE `rutas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_ruta_camion` (`camion_id`),
  ADD KEY `fk_ruta_chofer` (`chofer_id`);

--
-- Indices de la tabla `ruta_colonias`
--
ALTER TABLE `ruta_colonias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rc_ruta` (`ruta_id`),
  ADD KEY `fk_rc_colonia` (`colonia_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `avisos`
--
ALTER TABLE `avisos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `bitacora_diaria`
--
ALTER TABLE `bitacora_diaria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `camiones`
--
ALTER TABLE `camiones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `colonias`
--
ALTER TABLE `colonias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `incidencias`
--
ALTER TABLE `incidencias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `planificacion_colonias`
--
ALTER TABLE `planificacion_colonias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rutas`
--
ALTER TABLE `rutas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ruta_colonias`
--
ALTER TABLE `ruta_colonias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `avisos`
--
ALTER TABLE `avisos`
  ADD CONSTRAINT `fk_aviso_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `bitacora_diaria`
--
ALTER TABLE `bitacora_diaria`
  ADD CONSTRAINT `fk_bitacora_ruta` FOREIGN KEY (`ruta_id`) REFERENCES `rutas` (`id`);

--
-- Filtros para la tabla `incidencias`
--
ALTER TABLE `incidencias`
  ADD CONSTRAINT `fk_incidencia_colonia` FOREIGN KEY (`colonia_id`) REFERENCES `colonias` (`id`),
  ADD CONSTRAINT `fk_incidencia_ruta` FOREIGN KEY (`ruta_id`) REFERENCES `rutas` (`id`);

--
-- Filtros para la tabla `planificacion_colonias`
--
ALTER TABLE `planificacion_colonias`
  ADD CONSTRAINT `fk_plan_colonia` FOREIGN KEY (`colonia_id`) REFERENCES `colonias` (`id`);

--
-- Filtros para la tabla `rutas`
--
ALTER TABLE `rutas`
  ADD CONSTRAINT `fk_ruta_camion` FOREIGN KEY (`camion_id`) REFERENCES `camiones` (`id`),
  ADD CONSTRAINT `fk_ruta_chofer` FOREIGN KEY (`chofer_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `ruta_colonias`
--
ALTER TABLE `ruta_colonias`
  ADD CONSTRAINT `fk_rc_colonia` FOREIGN KEY (`colonia_id`) REFERENCES `colonias` (`id`),
  ADD CONSTRAINT `fk_rc_ruta` FOREIGN KEY (`ruta_id`) REFERENCES `rutas` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
