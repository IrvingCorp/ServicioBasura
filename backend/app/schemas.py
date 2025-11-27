from pydantic import BaseModel, EmailStr
from typing import Literal, List
from datetime import date

# ---------- PLANIFICACIÓN ----------
class PlanificacionCreate(BaseModel):
    fecha: date
    camion_id: int
    chofer_id: int
    colonias: List[int]

class PlanificacionUpdate(BaseModel):
    fecha: date
    camion_id: int
    chofer_id: int
    colonias: List[int]

# ---------- USER ----------
class UserBase(BaseModel):
    nombre: str
    email: EmailStr
    rol: Literal["admin", "chofer"]

class UserCreate(UserBase):
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserOut(UserBase):
    id: int
    class Config:
        orm_mode = True

# ---------- TOKEN ----------
class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
