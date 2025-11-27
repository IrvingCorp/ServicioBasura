
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..database import get_db
from .. import models

router = APIRouter(prefix="/users", tags=["Usuarios"])

@router.get("/choferes")
def get_choferes(db: Session = Depends(get_db)):
    return db.query(models.User).filter(models.User.rol == "chofer").all()
