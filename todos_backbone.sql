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


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `groups`
--

CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Daten für Tabelle `groups`
--

INSERT INTO `groups` VALUES(1, 'Administrators');
INSERT INTO `groups` VALUES(2, 'Managers');
INSERT INTO `groups` VALUES(3, 'Users');
INSERT INTO `groups` VALUES(4, 'Guests');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created` datetime default NULL,
  `modified` datetime default NULL,
  `lastlogin` datetime default NULL,
  `enabled` tinyint(1) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Daten für Tabelle `users`
--

INSERT INTO `users` VALUES(1, 'admin', '8ca1564ac0cd14cf403c5cd2417a5a3e62ec3dbc', 'Administrator', '2011-01-04 11:10:55', '2011-02-01 05:39:32', '2011-02-01 05:39:32', 1, 1);
INSERT INTO `users` VALUES(2, 'guest', '701f9f95b384efe29f5949d10aa2e0e875fc32e7', 'SampleGuest', '2011-01-04 12:01:48', '2011-08-08 07:38:44', '2011-08-08 07:38:44', 1, 4);
