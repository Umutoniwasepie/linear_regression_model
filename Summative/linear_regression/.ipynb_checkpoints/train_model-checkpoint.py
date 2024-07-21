import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
import joblib

# Load the dataset
df = pd.read_csv('weather.csv')

# Define features and target variable
X = df[['temperature', 'humidity', 'wind_speed']]  # Features
y = df['weather_condition']  # Target variable

# Split the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train the linear regression model
model = LinearRegression()
model.fit(X_train, y_train)

# Save the trained model
joblib.dump(model, 'weather_model.pkl')

print("Model trained and saved successfully!")
