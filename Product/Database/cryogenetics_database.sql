-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 25, 2023 at 03:03 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.0.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cryogenetics_database`
--

-- --------------------------------------------------------

--
-- Table structure for table `act`
--

CREATE TABLE `act` (
  `act_name` varchar(32) COLLATE utf8mb4_danish_ci NOT NULL,
  `description` varchar(64) COLLATE utf8mb4_danish_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dumping data for table `act`
--

INSERT INTO `act` (`act_name`, `description`, `is_active`) VALUES
('Discarded', 'The container has been discarded due to age or damage.', 1),
('Internal', 'The container has been transferred to another warehouse.', 1),
('Linked', 'When a client is linked to a tank.', 1),
('Maint compl', 'The container has completed maintenance.', 1),
('Maint need', 'The container has damages and requires maintenance.', 1),
('Refilled', 'The container has been filled.', 1),
('Returned', 'The container has returned from the customer', 1),
('Sent out', 'The container has been sent out to the customer.', 1),
('Sold', 'The container has been sold to an external client.', 1),
('Unlinked', 'When a client is unlinked from a tank.', 1);

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL,
  `email` varchar(64) COLLATE utf8mb4_danish_ci NOT NULL,
  `password_hash` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `email`, `password_hash`) VALUES
(1, 'test@testmail.test', 123),
(2, 'bingo@bongo.com', 432),
(203, 'jonasTest@outlook.com', 7337),
(204, 'admin123@test.com', 123);

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `client_id` int(11) NOT NULL,
  `client_name` varchar(64) COLLATE utf8mb4_danish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`client_id`, `client_name`) VALUES
(1, 'Greg\'s fish'),
(2, 'Lars\' lox'),
(3, 'Hugh\'s haul'),
(4, 'First rate fish'),
(5, 'Canada fish'),
(6, 'Salmon sages'),
(7, 'test');

-- --------------------------------------------------------

--
-- Table structure for table `container`
--

CREATE TABLE `container` (
  `container_sr_number` varchar(32) COLLATE utf8mb4_danish_ci NOT NULL,
  `container_model_name` varchar(32) COLLATE utf8mb4_danish_ci NOT NULL,
  `country_iso3` varchar(3) COLLATE utf8mb4_danish_ci NOT NULL,
  `last_filled` date DEFAULT NULL,
  `container_status_name` varchar(32) COLLATE utf8mb4_danish_ci NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `address` varchar(64) COLLATE utf8mb4_danish_ci DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `invoice` date DEFAULT NULL,
  `id` varchar(8) COLLATE utf8mb4_danish_ci DEFAULT NULL,
  `comment` varchar(512) COLLATE utf8mb4_danish_ci DEFAULT NULL,
  `maintenance_needed` tinyint(1) NOT NULL DEFAULT 0,
  `production_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dumping data for table `container`
--

INSERT INTO `container` (`container_sr_number`, `container_model_name`, `country_iso3`, `last_filled`, `container_status_name`, `client_id`, `address`, `location_id`, `invoice`, `id`, `comment`, `maintenance_needed`, `production_date`) VALUES
('1', 'verySmall60', 'USA', '2014-03-12', 'At client', 3, 'Test', NULL, '2023-03-09', '1', 'Leaking', 0, '2023-03-15'),
('111111111', 'verySmall60', 'USA', '2014-03-12', 'At client', 3, '47 Maple Street, Manchester, NH 03101', NULL, '2023-03-09', '13', NULL, 0, '2015-12-03'),
('123456789', 'large200', 'NOR', '2023-03-07', 'Available', NULL, NULL, 1, NULL, '12', NULL, 0, '2005-12-01'),
('2222222222', 'small100', 'CHL', '2023-03-23', 'In use', 6, 'Salmon Sages, Avenida Providencia 2309, Providencia, Santiago, C', NULL, '2023-03-18', '67', 'nulltull', 0, '1994-12-22'),
('432112', 'verySmall60', '', '2023-05-08', 'Available', 5, 'test', 2, NULL, '55', NULL, 0, '2021-05-11');

-- --------------------------------------------------------

--
-- Table structure for table `container_model`
--

CREATE TABLE `container_model` (
  `container_model_name` varchar(32) COLLATE utf8mb4_danish_ci NOT NULL,
  `refill_interval` float DEFAULT NULL,
  `liter_capacity` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dumping data for table `container_model`
--

INSERT INTO `container_model` (`container_model_name`, `refill_interval`, `liter_capacity`) VALUES
('large200', 4, 200),
('medium150', 5, 150),
('small100', 6, 100),
('verySmall60', 7, 60);

-- --------------------------------------------------------

--
-- Table structure for table `container_status`
--

CREATE TABLE `container_status` (
  `container_status_name` varchar(32) COLLATE utf8mb4_danish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dumping data for table `container_status`
--

INSERT INTO `container_status` (`container_status_name`) VALUES
('At client'),
('Available'),
('Disposed'),
('In use'),
('Quarantine'),
('Sold');

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `employee_id` int(11) NOT NULL,
  `employee_name` varchar(64) COLLATE utf8mb4_danish_ci NOT NULL,
  `employee_alias` varchar(16) COLLATE utf8mb4_danish_ci NOT NULL,
  `login_code` int(11) NOT NULL,
  `location_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`employee_id`, `employee_name`, `employee_alias`, `login_code`, `location_id`) VALUES
(1, 'Lars L. Ruud', 'LLR', 101, 1),
(2, 'Jonas Ødegaar', 'JØ', 102, 2),
(3, 'Per Pilk', 'PP', 111, 1),
(4, 'Jonathan Brando', 'JB', 810, 2),
(101, 'Jesse Ehrmantraut', 'JE', 444, 101),
(102, 'Walter Fring', 'WF', 555, 101),
(103, 'Huell McGill', 'HM', 666, 101),
(201, 'Everly B. Jackson', 'EBJ', 587, 201),
(301, 'Jhonny Chill', 'JC', 917, 301);

-- --------------------------------------------------------

--
-- Table structure for table `location`
--

CREATE TABLE `location` (
  `location_id` int(11) NOT NULL,
  `location_name` varchar(64) COLLATE utf8mb4_danish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dumping data for table `location`
--

INSERT INTO `location` (`location_id`, `location_name`) VALUES
(1, 'Norway: Hamar'),
(2, 'Norway: Trondheim'),
(101, 'USA: New Hampshire'),
(201, 'Canada: Black Creek'),
(301, 'Chile: Puerto Montt');

-- --------------------------------------------------------

--
-- Table structure for table `requested_keys`
--

CREATE TABLE `requested_keys` (
  `keyvalue` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `requested_keys`
--

INSERT INTO `requested_keys` (`keyvalue`) VALUES
('1324'),
('dfs'),
('dtfg fg'),
('gfdzg'),
('zghdfg');

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `transaction_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `address` varchar(64) COLLATE utf8mb4_danish_ci DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `container_sr_number` varchar(32) COLLATE utf8mb4_danish_ci DEFAULT NULL,
  `comment` varchar(512) COLLATE utf8mb4_danish_ci DEFAULT NULL,
  `date` datetime NOT NULL,
  `act` varchar(32) COLLATE utf8mb4_danish_ci NOT NULL,
  `container_status_name` varchar(60) COLLATE utf8mb4_danish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`transaction_id`, `employee_id`, `client_id`, `address`, `location_id`, `container_sr_number`, `comment`, `date`, `act`, `container_status_name`) VALUES
(101, 103, 3, '123 Warehouse Lane\r\nMerrimack, NH 03054', 101, '123456789', 'Sent container to customer', '2023-03-08 00:00:00', 'Sent out', 'At client'),
(102, 1, NULL, '456 Lagerveien\r\nHamar, 2316', 1, '111111111', 'Patched hole underneath container, used duct tape so might not last. ', '2023-03-16 00:00:00', 'Maint compl', 'At client'),
(103, 101, 5, '1010 Main Street West\r\nNorth Bay, ON P1B 2W1', 201, '2222222222', 'Recieved container from customer', '2023-03-08 00:00:00', 'Returned', 'At client'),
(104, 103, 6, 'Salmon Sages, Avenida Providencia 2309, Providencia, Santiagox.', 2, '2222222222', 'commentdas', '2023-05-03 00:00:00', 'Linked', 'At client'),
(105, 103, 6, 'Salmon Sages, Avenida Providencia 2309, Providencia, Santiagox.', 2, '2222222222', 'commentdas', '2023-05-03 00:00:00', 'Linked', 'At client'),
(106, 103, 6, 'Salmon Sages, Avenida Providencia 2309, Providencia, Santiagox.', 2, '2222222222', 'commentdas', '2023-05-03 00:00:00', 'Linked', 'At client'),
(107, 103, 1, 'nullgata', 1, '123456789', 'asdasd', '0000-00-00 00:00:00', 'Refilled', 'At client');

-- --------------------------------------------------------

--
-- Table structure for table `valid_keys`
--

CREATE TABLE `valid_keys` (
  `keyvalue` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `valid_keys`
--

INSERT INTO `valid_keys` (`keyvalue`) VALUES
('321123873128'),
('4334234'),
('4563654'),
('firstkey'),
('ghnb'),
('r4wt'),
('test'),
('WE');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `act`
--
ALTER TABLE `act`
  ADD PRIMARY KEY (`act_name`);

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`client_id`);

--
-- Indexes for table `container`
--
ALTER TABLE `container`
  ADD PRIMARY KEY (`container_sr_number`),
  ADD KEY `container_fk1` (`container_model_name`),
  ADD KEY `container_fk2` (`container_status_name`),
  ADD KEY `container_fk3` (`client_id`),
  ADD KEY `container_fk4` (`location_id`);

--
-- Indexes for table `container_model`
--
ALTER TABLE `container_model`
  ADD PRIMARY KEY (`container_model_name`);

--
-- Indexes for table `container_status`
--
ALTER TABLE `container_status`
  ADD PRIMARY KEY (`container_status_name`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`employee_id`),
  ADD KEY `employee_fk1` (`location_id`);

--
-- Indexes for table `location`
--
ALTER TABLE `location`
  ADD PRIMARY KEY (`location_id`);

--
-- Indexes for table `requested_keys`
--
ALTER TABLE `requested_keys`
  ADD PRIMARY KEY (`keyvalue`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `transaction_fk1` (`act`),
  ADD KEY `transaction_fk2` (`employee_id`),
  ADD KEY `transaction_fk3` (`client_id`),
  ADD KEY `transaction_fk4` (`container_sr_number`),
  ADD KEY `transaction_fk5` (`location_id`),
  ADD KEY `transaction_fk6` (`container_status_name`);

--
-- Indexes for table `valid_keys`
--
ALTER TABLE `valid_keys`
  ADD PRIMARY KEY (`keyvalue`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=205;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `employee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=302;

--
-- AUTO_INCREMENT for table `location`
--
ALTER TABLE `location`
  MODIFY `location_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=302;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `container`
--
ALTER TABLE `container`
  ADD CONSTRAINT `container_fk1` FOREIGN KEY (`container_model_name`) REFERENCES `container_model` (`container_model_name`) ON UPDATE CASCADE,
  ADD CONSTRAINT `container_fk2` FOREIGN KEY (`container_status_name`) REFERENCES `container_status` (`container_status_name`) ON UPDATE CASCADE,
  ADD CONSTRAINT `container_fk3` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `container_fk4` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `employee_fk1` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`) ON UPDATE CASCADE;

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_fk1` FOREIGN KEY (`act`) REFERENCES `act` (`act_name`) ON UPDATE CASCADE,
  ADD CONSTRAINT `transaction_fk2` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `transaction_fk3` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `transaction_fk4` FOREIGN KEY (`container_sr_number`) REFERENCES `container` (`container_sr_number`),
  ADD CONSTRAINT `transaction_fk5` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
