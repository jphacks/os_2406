from fastapi import FastAPI
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
    records = []
    
    records.append({
        "EnergyDrink": data.energyDrink,
        'WakeUpTime': data.wakeUpTime,
        'CurrentTime': data.currentTime,
        'SleepDuration': data.sleepDuration,
        "FocusedRating": data.focusedRating,
        "SleepyRating": data.sleepyRating,
    })
    
    # CSVに書き出す（追記モードで）
    df = pd.DataFrame(records)
    df.to_csv("data/input.csv", mode='a', header=False, index=False)

    return {"message": "Data submitted successfully"}


@app.get("/result")
async def get_averages():
    try:
        # Read the CSV file
        print("aiueo")
        df = pd.read_csv('./data/input.csv', header=None)

        # Group by the first column and calculate the mean for the 4th and 5th columns
        averages = df.groupby(0).agg({3: 'mean', 4: 'mean'}).reset_index()
        print(averages)
        # Prepare the result dictionary
        result = {}
        for index, row in averages.iterrows():
            key = row[0]
            avg_4th = row[3]
            avg_5th = row[4]
            average_new = (avg_4th + avg_5th) / 2
            result[key] = [average_new]

        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
