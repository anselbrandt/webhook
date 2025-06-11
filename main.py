from fastapi import FastAPI
from fastapi.responses import JSONResponse
import subprocess

app = FastAPI()

@app.get("/")
async def run_connect_script():
    try:
        result = subprocess.run(["/bin/bash", "connect.sh"], capture_output=True, text=True, check=True)
        return JSONResponse(content={
            "status": "success",
            "output": str(result.stdout).replace("\n"," ")
        })
    except subprocess.CalledProcessError as e:
        return JSONResponse(status_code=500, content={
            "status": "error",
            "error": e.stderr
        })
