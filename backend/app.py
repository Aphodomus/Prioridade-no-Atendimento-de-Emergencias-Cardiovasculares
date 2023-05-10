# Imports
from flask import Flask, jsonify, request
from faker import Faker
import random
from keras.models import load_model
import base64
import os
from flask_pymongo import pymongo
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
import cv2
import tensorflow as tf
import pandas as pd
from tensorflow.keras.applications.resnet50 import preprocess_input
import numpy as np
from bson import ObjectId
import json

# URI global variable
with open('keys.json') as f:
    URI = json.load(f)['URI']

# Start flask
app = Flask(__name__)

# Transform image to base64
def image_to_base64(file_path):
    with open(file_path, "rb") as img_file:
        img_bytes = img_file.read()
        img_base64 = base64.b64encode(img_bytes).decode("utf-8")
    return img_base64

# Transform base64 to image
def base64_to_image(base64_string, file_path):
    with open(file_path, "wb") as img_file:
        # converter a string base64 de volta para bytes
        img_bytes = base64.b64decode(base64_string)
        # escrever os bytes da imagem no arquivo PNG
        img_file.write(img_bytes)
    return os.path.abspath(file_path)

# Transform to dict
def patients_to_dict(patients):
    result = []
    for patient in patients:
        patient_dict = {
            key: str(patient[key])
            if isinstance(patient[key], ObjectId)
            else patient[key]
            for key in patient
        }
        result.append(patient_dict)
    return result


# # Get all  data from mongodb atlas and return
@app.route('/telaHome', methods=['GET'])
def tela_home():
    try:
        uri = URI

        # Create a new client and connect to the server
        client = MongoClient(uri, server_api=ServerApi('1'))

        # Create a database
        database_name = "users_database"
        users_db = client[database_name]
        
        # Create collection
        collection_name="patients"
        collection = users_db[collection_name]
        
        # Find all documents in the collection
        patients = collection.find()
        
        # Convert cursor object to list of dictionaries
        patients_dict = patients_to_dict(patients)
        
        return jsonify(patients_dict)
    except Exception as e:
        print(e)

# teest Connect to database Mongo Atlas
def test_connect_database():
    uri = URI

    # Create a new client and connect to the server
    client = MongoClient(uri, server_api=ServerApi('1'))

    # Send a ping to confirm a successful connection
    try:
        client.admin.command('ping')
        print("Pinged your deployment. You successfully connected to MongoDB!")
    except Exception as e:
        print(e)
    
# Connect to database Mongo Atlas and insert patients
def insert_into_database(data):
    try:
        uri = URI

        # Create a new client and connect to the server
        client = MongoClient(uri, server_api=ServerApi('1'))

        # Create a database
        database_name = "users_database"
        users_db = client[database_name]
        
        # Create collection
        collection_name="patients"
        collection = users_db[collection_name]
        
        # Insert into database
        collection.insert_many(data)
    except Exception as e:
        print(e)

# Transform images
def preprocess_images(image_paths, size = 224):
    processed_images = []
    
    for path in image_paths:
        # Read image from path
        image = cv2.imread(path)

        # Resizes the image
        resized_image = cv2.resize(image, (size, size))
        
        # Expand dimensions
        transformedImage = np.expand_dims(resized_image, axis = 0)
        
        # Preprocess image resnet50
        transformedImage = preprocess_input(transformedImage)

        # Adds the preprocessed image to the list
        processed_images.append(transformedImage)

    return processed_images

# Function to predict image ecg based on ResNet50
def predict_ecg(data):
    # Load model to memory
    MODEL = load_model('model/best_model.h5')

    # Predict image ecg
    result = [np.argmax(MODEL.predict(i), axis=1) for i in data]
    result = [item[0] for item in result]

    # Get diagnosis
    dict_ecg = {
        0: 'Fusão dos Batimentos Ventriculares e Normais',
        1: 'Infarto do Miocárdio',
        2: 'Batimentos Normais',
        3: 'Batimento Inclassificável',
        4: 'Batimento Prematuro Supraventricular',
        5: 'Contração Ventricular Prematura'
    }
    
    for i in range(len(result)):
        result[i] = dict_ecg[result[i]]

    return result

# Load patients
@app.route('/insert', methods=['POST'])
def load_patients():
    # Payload from hospital
    body = request.get_json()
    
    # JSON to send to MongoDB
    result_insert = body
    
    # Get ecg images from payload
    list_ecg_images = [dicionario["ecg"] for dicionario in body]
    
    # Get foto images from payload
    list_foto_images = [dicionario["foto"] for dicionario in body]

    # Transform images ecg to base64
    image_ecg_base64_list = list(map(lambda x: image_to_base64(x), list_ecg_images))
    
    # Transform images foto to base64
    image_foto_base64_list = list(map(lambda x: image_to_base64(x), list_foto_images))

    # Preprocess images ecg to predict
    transformed_image = preprocess_images(list_ecg_images)
    
    # Predict images
    result = predict_ecg(transformed_image)
    
    # Create new payload to save base64
    for paciente, base64 in zip(result_insert, image_ecg_base64_list):
        paciente['ecg'] = base64
        
    # Create new payload to save base64
    for paciente, base64 in zip(result_insert, image_foto_base64_list):
        paciente['foto'] = base64
        
    # Create new payload to save predict
    for paciente, base64 in zip(result_insert, result):
        paciente['diagnostico'] = base64
    
    # Save data into MongoDB
    try:
        insert_into_database(result_insert)
        print("[SUCCESS]: Data saved on MongoDB")
        return "[SUCCESS]: Data saved on MongoDB"
    except Exception as e:
        print("[ERROR]:", e)
        return jsonify({'error': 'Internal Server Error', 'message': e}), 500

if __name__ == '__main__':
    app.run(debug=True)