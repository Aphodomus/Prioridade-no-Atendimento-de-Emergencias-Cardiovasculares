# Imports
import numpy as np
import pandas as pd
from functions import *

# Carregando o conjunto de dados de treinamento
dataset_train = get_train()
print(dataset_train['Label'].value_counts())

# 

# Dividindo o conjunto de dados em conjuntos de treinamento e teste
#X_train, X_test, y_train, y_test = train_test_split(iris.data, iris.target, test_size=0.3, random_state=42)

# Criando um modelo KNN com k = 3
#knn = KNeighborsClassifier(n_neighbors=3)

# Treinando o modelo com o conjunto de treinamento
#knn.fit(X_train, y_train)

# Usando o modelo treinado para classificar o conjunto de teste
#y_pred = knn.predict(X_test)

# Calculando a precisão do modelo
#accuracy = accuracy_score(y_test, y_pred)
#print('A precisão do modelo é:', accuracy)

