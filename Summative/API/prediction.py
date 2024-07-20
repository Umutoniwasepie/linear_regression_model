from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import joblib

# Define the input data schema
class WeatherInput(BaseModel):
    temperature: float = Field(..., gt=-50, lt=60)  # Assuming realistic temperature range
    humidity: float = Field(..., ge=0, le=100)  # Humidity percentage range
    wind_speed: float = Field(..., ge=0, le=150)  # Wind speed range

# Initialization of the FastAPI app
app = FastAPI()

# Configuring CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow requests from any origin
    allow_credentials=True,
    allow_methods=["*"],  # Allow all methods
    allow_headers=["*"],  # Allow all headers
)

# Load the pre-trained model
model = joblib.load('weather_model.pkl')

# Define the root route
@app.get("/", status_code=status.HTTP_200_OK)
def root():
    return {"message": "Welcome to the Weather Prediction API"}

# Define the prediction endpoint
@app.post('/predict', status_code=status.HTTP_200_OK)
def predict(input_data: WeatherInput):
    try:
        data = [[input_data.temperature, input_data.humidity, input_data.wind_speed]]
        prediction = model.predict(data)[0]
        return {
            'status': 'success',
            'prediction': prediction,
            'message': 'Prediction generated successfully'
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")
