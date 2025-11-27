from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import date, timedelta
from ..database import get_db
from ..auth import get_current_user
from .. import models, schemas
import random

router = APIRouter(prefix="/planificacion", tags=["Planificación"])

# =======================================================
# 1) PLANIFICACIÓN AUTOMÁTICA
# =======================================================
@router.post("/nueva")
def generar_planificacion(db: Session = Depends(get_db),
                          user: models.User = Depends(get_current_user)):

    if user.rol != "admin":
        raise HTTPException(status_code=403, detail="Solo administradores pueden generar planificaciones")

    hoy = date.today()

    existente = db.query(models.RutaDiaria).filter(models.RutaDiaria.fecha == hoy).first()
    if existente:
        raise HTTPException(status_code=400, detail="Ya existe una planificación para hoy")

    camiones = db.query(models.Camion).filter(models.Camion.estado == "operativo").all()
    choferes = db.query(models.User).filter(models.User.rol == "chofer").all()
    colonias = db.query(models.Colonia).all()

    if not camiones or not choferes or not colonias:
        raise HTTPException(status_code=400, detail="Datos insuficientes para generar planificación")

    random.shuffle(colonias)

    rutas_generadas = []
    colonias_por_camion = len(colonias) // len(camiones)
    i = 0

    for camion in camiones:
        asignadas = colonias[i:i + colonias_por_camion]
        i += colonias_por_camion

        chofer = random.choice(choferes)

        ruta = models.RutaDiaria(
            fecha=hoy,
            camion_id=camion.id,
            chofer_id=chofer.id,
            estado="pendiente"
        )
        db.add(ruta)
        db.commit()
        db.refresh(ruta)

        for col in asignadas:
            nueva_rel = models.RutaColonia(
                ruta_id=ruta.id,
                colonia_id=col.id
            )
            db.add(nueva_rel)

        db.commit()

        rutas_generadas.append({
            "camion": camion.numero_unidad,
            "chofer": chofer.nombre,
            "colonias": [c.nombre_colonia for c in asignadas]
        })

    return {"fecha": hoy, "rutas_generadas": rutas_generadas}


# =======================================================
# 2) PLANIFICACIÓN MANUAL (formulario nueva ruta)
# =======================================================
@router.post("/crear")
def crear_planificacion(data: schemas.PlanificacionCreate,
                        db: Session = Depends(get_db),
                        user: models.User = Depends(get_current_user)):

    if user.rol != "admin":
        raise HTTPException(status_code=403, detail="Solo administradores pueden crear planificaciones")

    ruta = models.RutaDiaria(
        fecha=data.fecha,
        camion_id=data.camion_id,
        chofer_id=data.chofer_id,
        estado="pendiente"
    )

    db.add(ruta)
    db.commit()
    db.refresh(ruta)

    for col_id in data.colonias:
        asignacion = models.RutaColonia(
            ruta_id=ruta.id,
            colonia_id=col_id
        )
        db.add(asignacion)

    db.commit()

    return {"message": "Planificación creada correctamente", "ruta_id": ruta.id}


# =======================================================
# 3) RUTAS DEL DÍA
# =======================================================
@router.get("/hoy")
def rutas_de_hoy(db: Session = Depends(get_db)):
    hoy = date.today()
    rutas = db.query(models.RutaDiaria).filter(models.RutaDiaria.fecha == hoy).all()

    respuesta = []
    for r in rutas:
        respuesta.append({
            "id": r.id,
            "fecha": r.fecha,
            "camion": r.camion.numero_unidad,
            "chofer": r.chofer.nombre,
            "estado": r.estado,
            "colonias": [rel.colonia.nombre_colonia for rel in r.colonias]
        })
    return respuesta


# =======================================================
# 4) RUTAS DE LA SEMANA
# =======================================================
@router.get("/semana")
def rutas_semana(db: Session = Depends(get_db)):
    hoy = date.today()
    inicio = hoy - timedelta(days=hoy.weekday())
    fin = inicio + timedelta(days=6)

    rutas = db.query(models.RutaDiaria)\
              .filter(models.RutaDiaria.fecha >= inicio)\
              .filter(models.RutaDiaria.fecha <= fin)\
              .all()

    respuesta = []
    for r in rutas:
        respuesta.append({
            "id": r.id,
            "fecha": r.fecha,
            "dia": r.fecha.strftime("%A"),
            "camion": r.camion.numero_unidad,
            "chofer": r.chofer.nombre,
            "estado": r.estado,
            "colonias": [rel.colonia.nombre_colonia for rel in r.colonias]
        })

    return respuesta


# =======================================================
# 5) OBTENER UNA RUTA POR ID
# =======================================================
@router.get("/ruta/{ruta_id}")
def obtener_ruta(ruta_id: int,
                 db: Session = Depends(get_db),
                 user: models.User = Depends(get_current_user)):

    ruta = db.query(models.RutaDiaria).filter(models.RutaDiaria.id == ruta_id).first()
    if not ruta:
        raise HTTPException(status_code=404, detail="Ruta no encontrada")

    colonias_rel = db.query(models.RutaColonia).filter(models.RutaColonia.ruta_id == ruta.id).all()

    return {
        "id": ruta.id,
        "fecha": ruta.fecha,
        "camion_id": ruta.camion_id,
        "chofer_id": ruta.chofer_id,
        "estado": ruta.estado,
        "colonias_ids": [rel.colonia_id for rel in colonias_rel]
    }


# =======================================================
# 6) ACTUALIZAR RUTA
# =======================================================
@router.put("/ruta/{ruta_id}")
def actualizar_ruta(ruta_id: int,
                    data: schemas.PlanificacionUpdate,
                    db: Session = Depends(get_db),
                    user: models.User = Depends(get_current_user)):

    if user.rol != "admin":
        raise HTTPException(status_code=403, detail="Solo administradores pueden modificar rutas")

    ruta = db.query(models.RutaDiaria).filter(models.RutaDiaria.id == ruta_id).first()
    if not ruta:
        raise HTTPException(status_code=404, detail="Ruta no encontrada")

    ruta.fecha = data.fecha
    ruta.camion_id = data.camion_id
    ruta.chofer_id = data.chofer_id

    db.commit()

    db.query(models.RutaColonia).filter(models.RutaColonia.ruta_id == ruta.id).delete()

    for col_id in data.colonias:
        rel = models.RutaColonia(
            ruta_id=ruta.id,
            colonia_id=col_id
        )
        db.add(rel)

    db.commit()

    return {"message": "Ruta actualizada correctamente"}
