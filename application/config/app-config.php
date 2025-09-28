<?php

defined("BASEPATH") or exit("No direct script access allowed");

define("APP_BASE_URL", getenv("APP_BASE_URL") ?: "https://saas-crm-obur.onrender.com/" );

define("APP_ENC_KEY", getenv("APP_ENC_KEY") ?: "86384491178583651062300823258772");

define("APP_DB_HOSTNAME", getenv("APP_DB_HOSTNAME") ?: "localhost");
define("APP_DB_USERNAME", getenv("APP_DB_USERNAME") ?: "root");
define("APP_DB_PASSWORD", getenv("APP_DB_PASSWORD") ?: "");
define("APP_DB_NAME", getenv("APP_DB_NAME") ?: "perfex_crm");
define("APP_DB_PORT", getenv("APP_DB_PORT") ?: "3306");

define("APP_DB_CHARSET", getenv("APP_DB_CHARSET") ?: "utf8mb4");
define("APP_DB_COLLATION", getenv("APP_DB_COLLATION") ?: "utf8mb4_unicode_ci");

define("SESS_DRIVER", getenv("SESS_DRIVER") ?: "database");
define("SESS_SAVE_PATH", getenv("SESS_SAVE_PATH") ?: "sessions");
define("APP_SESSION_COOKIE_SAME_SITE", getenv("APP_SESSION_COOKIE_SAME_SITE") ?: "Lax");

define("APP_CSRF_PROTECTION", getenv("APP_CSRF_PROTECTION") ?: true);
