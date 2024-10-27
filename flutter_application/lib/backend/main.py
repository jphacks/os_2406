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
        df = pd.read_csv('./data/input.csv', header=None)

        # Group by the first column and calculate the mean for the 4th and 5th columns
        averages = df.groupby(0).agg({4: 'mean', 5: 'mean'}).reset_index()
        print(averages)
        # Prepare the result dictionary
        result = {}
        for index, row in averages.iterrows():
            key = row[0]
            avg_5th = row[4]
            avg_6th = row[5]
            average_new = (avg_5th + avg_6th) / 2
            result[key] = [average_new]

        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/result_sleep")
async def get_averages():
    try:
        # Read the CSV file
        df = pd.read_csv('./data/input.csv', header=None)

        # Group by the first column and calculate the mean for the 4th and 5th columns
        averages = df.groupby(3).agg({4: 'mean'}).reset_index()
        print(averages)
        # Prepare the result dictionary
        result = {}
        for index, row in averages.iterrows():
            key = row[3]
            avg_5th = row[4]
            result[key] = [avg_5th]

        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    

@app.get("/result_count")
async def get_counts():
    try:
        # CSVファイルを読み込む
        df = pd.read_csv('./data/input.csv', header=None)
        
        # 1列目の値を数えて辞書形式に変換
        counts = df[0].value_counts().to_dict()

        # 辞書をJSON形式に合わせてフォーマット
        result = {key: [value] for key, value in counts.items()}

        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))