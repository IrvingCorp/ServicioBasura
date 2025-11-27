
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL = "mysql+pymysql://root:@localhost:3307/recoleccion_basura"

# Crear el engine
engine = create_engine(
    DATABASE_URL,
    echo=True,            # ← Activa logs (útil por ahora)
    pool_pre_ping=True
)

# Crear fábrica de sesiones
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

# Base para los modelos
Base = declarative_base()

# Dependency: obtener DB
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
