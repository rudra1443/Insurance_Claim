import pandas as pd 
import numpy as np
import matplotlib.pyplot as plt 

claims = pd.read_csv("Claims.csv")
customers = pd.read_csv("Customers.csv")
hospitals = pd.read_csv("Hospitals.csv")
payments = pd.read_csv("Payments.csv")
policies = pd.read_csv("Policies.csv")

print("Data loaded successfully.")
