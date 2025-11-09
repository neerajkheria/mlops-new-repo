
from flask import Flask, request, jsonify
import joblib
import numpy as np
import json

app = Flask(__name__)

# Load model and metadata
model = joblib.load('churn_model.joblib')
with open('model_metadata.json', 'r') as f:
    metadata = json.load(f)

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'model_version': metadata['model_version'],
        'model_name': metadata['model_name']
    })

@app.route('/predict', methods=['POST'])
def predict():
    """Prediction endpoint"""
    try:
        # Get input data
        data = request.get_json()
        
        # Validate features
        required_features = metadata['features']
        if not all(feature in data for feature in required_features):
            return jsonify({
                'error': 'Missing required features',
                'required': required_features
            }), 400
        
        # Prepare input
        input_data = np.array([[data[feature] for feature in required_features]])
        
        # Make prediction
        prediction = model.predict(input_data)[0]
        probability = model.predict_proba(input_data)[0]
        
        return jsonify({
            'prediction': int(prediction),
            'churn_probability': float(probability[1]),
            'no_churn_probability': float(probability[0]),
            'model_version': metadata['model_version']
        })
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/model-info', methods=['GET'])
def model_info():
    """Return model metadata"""
    return jsonify(metadata)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
