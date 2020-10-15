<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'user' );

/** MySQL database password */
define( 'DB_PASSWORD', 'password' );

/** MySQL hostname */
define( 'DB_HOST', 'mysql' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'Nmhx_+yqR:Ev8<FF>o-75dKKo<2u&(ol/&.B_GPq5nH*<O/AQs6/>K>Rn;k,JLl,' );
define( 'SECURE_AUTH_KEY',  'kHkNeU8Ovd_]s<oKvlY8~{1TTn&yg*? gtV,vy$`;&P.iTf?`-{xO#!M[S==d{Ov' );
define( 'LOGGED_IN_KEY',    'cpq_C,J.rA(W1ZG39x0D:3j3/}04^&;C!& l{/a2F;1(2XKImu%z2= qeFRt J]@' );
define( 'NONCE_KEY',        'S1Xt<XAi3cK|ni*W(9)}8Gq7*`#jOvpZ%7Iko^/S}=)6]lr1WgeWG}h-`-l@louo' );
define( 'AUTH_SALT',        'zeNGQ4`TqoBd&TN70j_o@*jX+ztzco#vyP/{$9%9[EQhH4G+P.U+^#l|inj|}!aH' );
define( 'SECURE_AUTH_SALT', '8n1+nhFh4G&H1&chbO=]CDy>^=q)xj`>=P7.A1A&]UahCOJ:>}T/;dlx:=cY6N30' );
define( 'LOGGED_IN_SALT',   'G~JCI{dj=m;!:m&~?$:[=v,d=KW`7BdrT$lQg$HT@(kg[W <g<YQm{&EvD[?W^o%' );
define( 'NONCE_SALT',       'jW~-V9d1^mt@H?, %6Y{O(a6;-.40]L!8bU[TJRM-voS[R6tpE;mhGuFg@s6imMi' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
