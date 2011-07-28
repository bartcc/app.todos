SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Datenbank: `todos_backbone`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `todos`
--

CREATE TABLE `todos` (
  `id` int(11) NOT NULL auto_increment,
  `done` tinyint(1) unsigned zerofill NOT NULL,
  `content` varchar(50) NOT NULL,
  `order` int(11) NOT NULL,
  `created` datetime default NULL,
  `modified` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
