
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..database import get_db
from .. import models

router = APIRouter(prefix="/colonias", tags=["Colonias"])

@router.get("/")
def get_colonias(db: Session = Depends(get_db)):
    return db.query(models.Colonia).all()
