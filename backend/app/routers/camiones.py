
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..database import get_db
from .. import models

router = APIRouter(prefix="/camiones", tags=["Camiones"])

@router.get("/")
def get_camiones(db: Session = Depends(get_db)):
    return db.query(models.Camion).all()
