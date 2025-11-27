from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .database import engine, Base

# Importar routers correctamente

from .routers.camiones import router as camiones_router
from .routers.colonias import router as colonias_router
from .routers.users import router as users_router
from .routers.planificacion import router as planificacion_router

# Crear tablas
Base.metadata.create_all(bind=engine)

app = FastAPI()

# CORS
origins = [
    "http://127.0.0.1:5500",
    "http://localhost:5500",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Registrar routers

app.include_router(camiones_router, prefix="/camiones")
app.include_router(colonias_router, prefix="/colonias")
app.include_router(users_router, prefix="/users")
app.include_router(planificacion_router, prefix="/planificacion")

@app.get("/")
def root():
    return {"message": "Backend funcionando correctamente"}
