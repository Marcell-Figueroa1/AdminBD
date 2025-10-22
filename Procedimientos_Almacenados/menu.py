# ==========================================
# sp_menu_comentado.py (versión funcional PyMySQL)
# ==========================================

import pymysql

# ---------- CONFIGURACIÓN ----------
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "1234",
    "database": "empresa",
    "port": 3306,
}

def conectar():
    """Conecta a la base de datos MySQL"""
    return pymysql.connect(**DB_CONFIG)

# ---------- PROCEDIMIENTOS ----------
def sp_insertar(nombre: str, cargo: str, sueldo: float) -> int:
    """Inserta un empleado y devuelve su nuevo ID"""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.execute("SET @nuevo_id = 0;")
        cur.callproc("sp_insertar_empleado", (nombre, cargo, sueldo, "@nuevo_id"))
        cur.execute("SELECT @nuevo_id;")
        nuevo_id = cur.fetchone()[0]
        cnx.commit()
        print(f"✅ Insertado correctamente. Nuevo ID: {nuevo_id}")
        return nuevo_id
    except pymysql.MySQLError as e:
        print("❌ Error en sp_insertar:", e)
        if cnx:
            cnx.rollback()
        return -1
    finally:
        if cur: cur.close()
        if cnx: cnx.close()

def sp_listar_activos():
    """Lista empleados activos (no eliminados)"""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_listar_empleados_activos")
        rows = cur.fetchall()
        print("=== EMPLEADOS ACTIVOS ===")
        for (id_, nombre, cargo, sueldo, created_at, updated_at) in rows:
            ua = updated_at if updated_at else "-"
            print(f"ID: {id_:<3} | Nombre: {nombre:<15} | Cargo: {cargo:<13} | "
                  f"Sueldo: ${sueldo:,.0f} | Creado: {created_at} | Actualizado: {ua}")
    except pymysql.MySQLError as e:
        print("❌ Error en sp_listar_activos:", e)
    finally:
        if cur: cur.close()
        if cnx: cnx.close()

def sp_listar_todos():
    """Lista todos los empleados (incluidos eliminados)"""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_listar_empleados_todos")
        rows = cur.fetchall()
        print("=== EMPLEADOS (TODOS) ===")
        for (id_, nombre, cargo, sueldo, eliminado, created_at, updated_at, deleted_at) in rows:
            estado = "ACTIVO" if eliminado == 0 else "ELIMINADO"
            ua = updated_at if updated_at else "-"
            da = deleted_at if deleted_at else "-"
            print(f"ID: {id_:<3} | Nombre: {nombre:<15} | Cargo: {cargo:<13} | "
                  f"Sueldo: ${sueldo:,.0f} | {estado:<9} | Creado: {created_at} | "
                  f"Actualizado: {ua} | Eliminado: {da}")
    except pymysql.MySQLError as e:
        print("❌ Error en sp_listar_todos:", e)
    finally:
        if cur: cur.close()
        if cnx: cnx.close()

def sp_borrado_logico(id_empleado: int):
    """Marca un empleado como eliminado"""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_borrado_logico_empleado", (id_empleado,))
        cnx.commit()
        print(f"✅ Borrado lógico aplicado al ID {id_empleado}.")
    except pymysql.MySQLError as e:
        print("❌ Error en sp_borrado_logico: ", e)
        if cnx:
            cnx.rollback()
    finally:
        if cur: cur.close()
        if cnx: cnx.close()

def sp_restaurar(id_empleado: int):
    """Restaura un empleado eliminado"""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_restaurar_empleado", (id_empleado,))
        cnx.commit()
        print(f"✅ Restaurado ID {id_empleado}.")
    except pymysql.MySQLError as e:
        print("❌ Error en sp_restaurar: ", e)
        if cnx:
            cnx.rollback()
    finally:
        if cur: cur.close()
        if cnx: cnx.close()

# ---------- MENÚ ----------
def menu():
    while True:
        print("\n===== MENÚ EMPLEADOS (MySQL + SP) =====")
        print("1) Insertar empleado")
        print("2) Listar empleados ACTIVOS")
        print("3) Listar empleados (TODOS)")
        print("4) Borrado lógico por ID")
        print("5) Restaurar por ID")
        print("0) Salir")

        opcion = input("Selecciona una opción: ").strip()
        if opcion == "1":
            nombre = input("Nombre: ").strip()
            cargo = input("Cargo: ").strip()
            try:
                sueldo = float(input("Sueldo: ").strip())
            except ValueError:
                print("❌ Sueldo inválido.")
                continue
            sp_insertar(nombre, cargo, sueldo)
        elif opcion == "2":
            sp_listar_activos()
        elif opcion == "3":
            sp_listar_todos()
        elif opcion == "4":
            try:
                id_emp = int(input("ID a eliminar: ").strip())
                sp_borrado_logico(id_emp)
            except ValueError:
                print("❌ ID inválido.")
        elif opcion == "5":
            try:
                id_emp = int(input("ID a restaurar: ").strip())
                sp_restaurar(id_emp)
            except ValueError:
                print("❌ ID inválido.")
        elif opcion == "0":
            print("👋 Saliendo...")
            break
        else:
            print("❌ Opción no válida.")

if __name__ == "__main__":
    menu()
