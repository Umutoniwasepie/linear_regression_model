# linear_regression_model

This repository contains a series of tasks that demonstrate the creation and deployment of machine learning models, including linear regression, decision trees, and random forests. It also includes an API built with FastAPI and a Flutter app for making predictions.

## Project Description

This project includes three main tasks:

1. **Task 1: Linear Regression**
    - Creating and optimizing a linear regression model using gradient descent.
    - Comparing linear regression with decision trees and random forests using RMSE.
    - Ranking the models based on performance.

2. **Task 2: Create an API**
    - Creating an API endpoint using FastAPI to make predictions with a linear regression model.
    - Using a different dataset with multiple variables.

3. **Task 3: Flutter App**
    - Building a Flutter app to interact with the API.
    - The app allows users to input values and receive predictions.

## Installation

### Prerequisites

- Python 3.x
- pip (Python package installer)
- FastAPI
- Uvicorn
- Flutter (for the frontend)

### Steps

1. Clone the repository:
    ```sh
    git clone [https://github.com/Umutoniwasepie/linear_regression_model.git]
    cd linear_regression_model
    ```

2. Install the required Python packages:
    ```sh
    pip install -r summative/API/requirements.txt
    ```

3. Install Flutter (if not already installed). Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).

## Usage

### Task 1: Linear Regression

1. The `univariate.ipynb` and `multivariate.ipynb` files are found here.
2. For the notebook, the univariate linear regression model to predict sales given marketing budget task: [Univariate Linear Regression Notebook](Summative/linear_regression/univariate.ipynb)
3. For the notebook, the multivariate linear regression model task: [Multivariate Linear Regression Notebook](Summative/linear_regression/multivariate.ipynb)
 - The model predicts weather conditions given the following parameters:
  - Temperature
  - Humidity
  - Wind Speed

 - The model was trained on the dataset available in the repository.

### Task 2: Running the API

1. Navigate to the `summative/API/` directory.
2. Start the FastAPI server:
    ```sh
    uvicorn prediction:app --reload
    ```
3. Public API Endpoint
The API is hosted on Render and is publicly accessible when you click [HERE](https://fastapi-mi8f.onrender.com).

## API Endpoint
Example:
```json
{
    "temperature": 22.5,
    "humidity": 65,
    "wind_speed": 12.5
}
 ```

 - Response:
    ```json
    {
    "status": "success",
    "prediction": 1.0,
    "message": "Prediction generated successfully"
    }
   
    ```

### Task 3: Flutter App

1. Open the `weather_prediction_app` directory in your preferred Flutter development environment.
2. Update the API endpoint in the Flutter app to match your deployed API.
3. Run the Flutter app on an emulator or physical device.
