# ==========================================
# sp_menu_comentado.py (versión funcional PyMySQL)
# ==========================================

import pymysql

# ---------- CONFIGURACIÓN ----------
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "1234",
    "database": "CRONODOSIS",
    "port": 3306,
}

def conectar():
    """Conecta a la base de datos MySQL"""
    return pymysql.connect(**DB_CONFIG)