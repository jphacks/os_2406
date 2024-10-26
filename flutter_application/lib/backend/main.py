from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pandas as pd

app = FastAPI()

class Data(BaseModel):
    energyDrink: str
    wakeUpTime: str
    currentTime: str
    sleepDuration: str
    focusedRating: int
    sleepyRating: int

@app.post("/submit")
async def submit_data(data: Data):
    # CSVに書き出すデータを辞書として準備
    record = {
        "EnergyDrink": data.energyDrink,
        'WakeUpTime': data.wakeUpTime,
        'CurrentTime': data.currentTime,
        'SleepDuration': data.sleepDuration,
        "FocusedRating": data.focusedRating,
        "SleepyRating": data.sleepyRating,
    }
    
    # CSVに書き出す（追記モードで）
    df = pd.DataFrame([record])
    df.to_csv("data/test.csv", mode='a', header=False, index=False)

    return {"message": "Data submitted successfully"}