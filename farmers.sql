-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 26, 2025 at 04:21 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `farmers`
--

-- --------------------------------------------------------

--
-- Table structure for table `addagroproducts`
--

CREATE TABLE `addagroproducts` (
  `username` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `pid` int(11) NOT NULL,
  `productname` varchar(100) NOT NULL,
  `productdesc` text NOT NULL,
  `price` int(100) NOT NULL,
  `farmingtype` varchar(50) NOT NULL,
  `stock` int(11) NOT NULL,
  `location` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `addagroproducts`
--

INSERT INTO `addagroproducts` (`username`, `email`, `pid`, `productname`, `productdesc`, `price`, `farmingtype`, `stock`, `location`) VALUES
('Santosh', 'farmer@gmail.com', 1, 'GIRIJA CAULIFLOWER', 'Tips for Growing Cauliflower. Well drained medium loam and or sandy loam soils are suitable.', 520, 'seed farming', 15, 'Uttar Pradesh'),
('Santosh', 'farmer@gmail.com', 2, 'COTTON', 'Cotton is a soft, fluffy staple fiber that grows in a boll,around the seeds of the cotton ', 563, 'fibre crop', 100, 'Tamil Nadu'),
('Santosh', 'farmer@gmail.com', 3, 'silk', 'silk is best business developed from coocon for saries preparation and so on', 582, 'silk', 65, 'Punjab'),
('Santosh', 'farmer@gmail.com', 4, 'Silk Fabric', 'Fabric made out of silk', 450, 'silk', 55, 'Karnataka');

-- --------------------------------------------------------

--
-- Table structure for table `farming`
--

CREATE TABLE `farming` (
  `fid` int(11) NOT NULL,
  `farmingtype` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `farming`
--

INSERT INTO `farming` (`fid`, `farmingtype`) VALUES
(1, 'Seed Farming'),
(2, 'coccon'),
(3, 'silk'),
(4, '');

-- --------------------------------------------------------

--
-- Table structure for table `register`
--

CREATE TABLE `register` (
  `rid` int(11) NOT NULL,
  `farmername` varchar(50) NOT NULL,
  `adharnumber` varchar(20) NOT NULL,
  `age` int(100) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `phonenumber` varchar(12) NOT NULL,
  `address` varchar(50) NOT NULL,
  `farming` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `register`
--

INSERT INTO `register` (`rid`, `farmername`, `adharnumber`, `age`, `gender`, `phonenumber`, `address`, `farming`, `email`) VALUES
(11, 'Santosh', '31938971329723', 29, 'male', '9102818192', 'A502, Near Chengalpattu Station, Chengalpattu, Tam', 'Seed Farming', 'farmer@gmail.com'),
(12, 'mani', '12234351355', 30, 'male', '98218918912', 'abdadhjjawe', 'coccon', 'mani@gmail.com');

--
-- Triggers `register`
--
DELIMITER $$
CREATE TRIGGER `deletion` BEFORE DELETE ON `register` FOR EACH ROW INSERT INTO trig VALUES(null,OLD.rid,'FARMER DELETED',NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertion` AFTER INSERT ON `register` FOR EACH ROW INSERT INTO trig VALUES(null,NEW.rid,'Farmer Inserted',NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updation` AFTER UPDATE ON `register` FOR EACH ROW INSERT INTO trig VALUES(null,NEW.rid,'FARMER UPDATED',NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `test`
--

CREATE TABLE `test` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trig`
--

CREATE TABLE `trig` (
  `id` int(11) NOT NULL,
  `fid` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trig`
--

INSERT INTO `trig` (`id`, `fid`, `action`, `timestamp`) VALUES
(3, '8', 'Farmer Inserted', '2025-02-19 23:16:52'),
(4, '8', 'FARMER UPDATED', '2025-02-19 23:17:17'),
(5, '8', 'FARMER DELETED', '2025-02-19 23:18:54'),
(6, '9', 'Farmer Inserted', '2025-03-20 21:33:31'),
(7, '9', 'FARMER DELETED', '2025-03-20 21:33:42'),
(8, '10', 'Farmer Inserted', '2025-03-20 21:49:14'),
(9, '10', 'FARMER DELETED', '2025-03-20 22:01:02'),
(10, '11', 'Farmer Inserted', '2025-03-20 22:02:12'),
(11, '11', 'FARMER UPDATED', '2025-03-20 22:16:13'),
(12, '11', 'FARMER UPDATED', '2025-03-20 22:20:46'),
(13, '11', 'FARMER UPDATED', '2025-03-20 22:24:31'),
(14, '11', 'FARMER UPDATED', '2025-03-21 08:21:09'),
(15, '12', 'Farmer Inserted', '2025-03-21 08:40:15');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(500) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'consumer'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `email`, `password`, `role`) VALUES
(6, 'Devansh', 'devansh.verma04@gmail.com', 'scrypt:32768:8:1$aL6i6Hl4HN8Asl6w$3348fb0e9a4f59da512b7b0ddfa43e2619a997d3c66bee01ba898fc961e3bbded85f7019c34973e5b525cd3ead7c4d08ce4610587f5e973f0e071564d9fb3d5a', 'admin'),
(7, 'famer1', 'farmer@gmail.com', 'scrypt:32768:8:1$s3PlZGWdIs5rvi4e$6c6f622e8d111a79ec623cba53acd254606daad1507729ec5874452601cc24d18b7d98b17d226ad0243a1c8bf7a56e44185fe49ea5737b03c307e47580c86613', 'farmer'),
(8, 'Consumer1', 'consumer@gmail.com', 'scrypt:32768:8:1$psR1wsOOTprIY5pA$391eeabcf123d5bba7fb2b6c4c3884204a54524cb77b388b0c3ad22891c2138f551f343afd421dbb22ce917168e3774f78f67b4d6a23870f3a21f6f64269456c', 'consumer'),
(9, 'Rudransh', 'rg6282@srmist.edu.in', 'scrypt:32768:8:1$fz2y0BkMNSGVhqwA$330660a2c7b1444649b530b7e2da6609cbce9c181cfb5544d30739fe102edb69b53adc5437ec055746876fbec1410fb5f856b5e1be36d5ba52c9ca12d91fbd13', 'admin'),
(10, 'Saksham', 'su2807@srmist.edu.in', 'scrypt:32768:8:1$tRRxMbEjyXjytmvx$9ae1e3c633ab96848f70f35c3f2f6e21c6d8bd1c756ce69fab133b1f5f95cdce3fe41bf819f5592cf04f08a4b759ca0e670dad7537349b94697ec6aac9322410', 'admin'),
(11, 'Mani', 'mani@gmail.com', 'scrypt:32768:8:1$Y4nL4QB4fav2ir63$11bd1e0dfd4b2e86eb546e297ca29693298089f28b130fcd95ee3ead8f051166a81ca7925ecc19f9923cdbf0fa65b22b4f88d5162d2d70ad67c86f5ee1248cb7', 'farmer');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addagroproducts`
--
ALTER TABLE `addagroproducts`
  ADD PRIMARY KEY (`pid`);

--
-- Indexes for table `farming`
--
ALTER TABLE `farming`
  ADD PRIMARY KEY (`fid`);

--
-- Indexes for table `register`
--
ALTER TABLE `register`
  ADD PRIMARY KEY (`rid`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `test`
--
ALTER TABLE `test`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trig`
--
ALTER TABLE `trig`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addagroproducts`
--
ALTER TABLE `addagroproducts`
  MODIFY `pid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `farming`
--
ALTER TABLE `farming`
  MODIFY `fid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `register`
--
ALTER TABLE `register`
  MODIFY `rid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `test`
--
ALTER TABLE `test`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `trig`
--
ALTER TABLE `trig`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
