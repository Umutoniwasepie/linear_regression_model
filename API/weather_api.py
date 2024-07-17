from fastapi import FastAPI
from pydantic import BaseModel
import joblib

# Define the input data schema
class WeatherInput(BaseModel):
    temperature: float
    humidity: float
    wind_speed: float

# Initialization of the FastAPI app
app = FastAPI()

# Load the pre-trained model
model = joblib.load('weather_model.pkl')

# Define the prediction endpoint
@app.post('/predict')
def predict(input_data: WeatherInput):
    data = [[input_data.temperature, input_data.humidity, input_data.wind_speed]]
    prediction = model.predict(data)
    return {'prediction': prediction[0]}
