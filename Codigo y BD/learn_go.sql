-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-11-2023 a las 19:09:47
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `learn_go`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comentarios`
--

CREATE TABLE `comentarios` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `descripcion` varchar(700) NOT NULL,
  `postId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `comentarios`
--

INSERT INTO `comentarios` (`id`, `id_usuario`, `fecha`, `descripcion`, `postId`) VALUES
(1, 10, '2023-11-29 14:10:34', '¡Hola! Yo he pasado por Matemáticas Avanzadas y sé que puede ser desafiante. Te recomiendo revisar libros como \"Análisis Matemático\"para abordar conceptos clave. También, la práctica constante con problemas variados es fundamental. ¿En qué temas específicos necesitas ayuda? 📚🧮', 2),
(2, 1, '2023-11-29 14:04:16', '¡Hola! Yo también soy un apasionado del diseño gráfico. Para Adobe Illustrator, te recomiendo explorar las capas y practicar con las herramientas de pluma. ¿Hay algo específico en lo que necesitas ayuda? Estoy aquí para compartir trucos y técnicas. 👨‍🎨✨', 13),
(3, 10, '2023-11-29 14:04:57', '¡Claro! Trabajar con formas simples y combinarlas es clave. Además, dominar los atajos de teclado te ahorrará mucho tiempo. ¡Estaré encantado de guiarte a través de algunas funciones avanzadas! ¿Cuándo te viene bien hacer una sesión? 🖌️💡', 13),
(5, 1, '2023-11-29 14:23:52', '¡Hola! Soy un principiante y estoy lidiando con conceptos básicos de programación. ¿Tienes sugerencias para entender mejor los bucles? ¡Gracias por ofrecer asesorías, estoy emocionado por la oportunidad de aprender! 🌐🤓', 12);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materias`
--

CREATE TABLE `materias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `materias`
--

INSERT INTO `materias` (`id`, `nombre`) VALUES
(1, 'Ingles'),
(2, 'Matematicas Basicas'),
(3, 'Física'),
(4, 'Geografía'),
(5, 'Desarrollo Web'),
(6, 'Música'),
(7, 'Contabilidad'),
(8, 'Animación'),
(9, 'Economía'),
(10, 'Cálculo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `publicaciones`
--

CREATE TABLE `publicaciones` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `descripcion` varchar(700) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `publicaciones`
--

INSERT INTO `publicaciones` (`id`, `id_usuario`, `fecha`, `descripcion`) VALUES
(2, 1, '2023-11-29 02:19:00', '¡Hola comunidad académica! 👋 ¿Alguien tiene experiencia con Matemáticas Avanzadas? Estoy buscando algunos consejos para abordar temas específicos. ¡Cualquier recurso o consejo sería muy apreciado!'),
(3, 10, '2023-11-29 02:23:21', '¡Hola a todos! 👋 ¿Necesitas ayuda con Matemáticas? Ofrezco asesorías personalizadas para resolver dudas, preparar exámenes o simplemente mejorar tu comprensión. ¡Comentame si estás interesado en mejorar tus habilidades matemáticas!'),
(4, 11, '2023-11-29 02:21:18', 'Hola a todos amantes del arte 🎨💖 ¡Estoy buscando recomendaciones sobre libros o recursos para profundizar en la Historia del Arte! ¿Algún experto por aquí que pueda ofrecer orientación? '),
(12, 10, '2023-11-29 02:24:29', 'Hola programadores novatos y experimentados 🚀💻 ¿Te enfrentas a desafíos de programación? Estoy ofreciendo asesorías en diferentes lenguajes, desde principiantes hasta niveles avanzados. ¡Déjame saber tus preguntas y trabajemos juntos en soluciones!'),
(13, 11, '2023-11-29 02:45:21', 'Necesito asesoría en Diseño Gráfico, especialmente en el uso de herramientas como Adobe Illustrator. ¿Alguien dispuesto a compartir trucos y técnicas?');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas`
--

CREATE TABLE `reservas` (
  `id` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `id_materia` int(11) NOT NULL,
  `id_tutor` int(11) NOT NULL,
  `fecha` varchar(20) NOT NULL,
  `hora` varchar(20) NOT NULL,
  `tipo_reunion` varchar(50) NOT NULL,
  `precio` int(20) NOT NULL,
  `estado_reserva` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `reservas`
--

INSERT INTO `reservas` (`id`, `id_estudiante`, `id_materia`, `id_tutor`, `fecha`, `hora`, `tipo_reunion`, `precio`, `estado_reserva`) VALUES
(1, 11, 1, 10, '2023/12/01', '12:45 PM', 'Virtual', 20000, 'En Espera'),
(8, 11, 2, 13, '2023/12/01', '12:45 PM', 'Virtual', 100000, 'En Espera'),
(9, 1, 2, 10, '2023/12/01', '04:00 PM', 'Virtual', 50000, 'En Espera');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `descripcion`) VALUES
(1, 'Alumno'),
(2, 'Tutor');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `edad` int(5) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `id_materia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `apellido`, `edad`, `id_rol`, `email`, `password`, `id_materia`) VALUES
(1, 'Diana', 'Rosero', 22, 1, 'diana@gmail.com', '123', 2),
(10, 'Camila', 'Portilla', 21, 2, 'camila@gmail.com', '456', 5),
(11, 'Sofia', 'Peña', 21, 1, 'sofia@gmail.com', '789', 1),
(13, 'Mario', 'Zambrano', 21, 2, 'mario@gmail.com', '101', 8);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_usuario` (`id_usuario`),
  ADD KEY `fk_publicacion` (`postId`);

--
-- Indices de la tabla `materias`
--
ALTER TABLE `materias`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indices de la tabla `publicaciones`
--
ALTER TABLE `publicaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `flk_usuario` (`id_usuario`);

--
-- Indices de la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_estudiante` (`id_estudiante`),
  ADD KEY `fk_tutor` (`id_tutor`),
  ADD KEY `fk_materia` (`id_materia`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rol` (`id_rol`),
  ADD KEY `fkk_materiasssss` (`id_materia`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `materias`
--
ALTER TABLE `materias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `publicaciones`
--
ALTER TABLE `publicaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `reservas`
--
ALTER TABLE `reservas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD CONSTRAINT `fk_publicacion` FOREIGN KEY (`postId`) REFERENCES `publicaciones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `publicaciones`
--
ALTER TABLE `publicaciones`
  ADD CONSTRAINT `flk_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD CONSTRAINT `fk_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tutor` FOREIGN KEY (`id_tutor`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_rol` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fkk_materiasssss` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
