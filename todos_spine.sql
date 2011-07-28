SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Datenbank: `todos_spine`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tasks`
--

CREATE TABLE `tasks` (
  `id` varchar(36) NOT NULL,
  `done` tinyint(1) unsigned zerofill default NULL,
  `name` varchar(50) default NULL,
  `order` int(11) default NULL,
  `created` datetime default NULL,
  `modified` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;