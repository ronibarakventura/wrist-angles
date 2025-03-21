The datasets and codes herein, replicate the results reported in Barak Ventura et al. \<publication year\>, "A machine learning approach to predict wrist posture in telerehabilitation with haptic devices", \<journal name\>, \<issue\>(\<volume\>): \<pages\> (\<DOI\>). All analyses were made in Python.

# user_data.csv
This file summarizes information about the users, including the date of their age, gender, and dominant hand.

# training data
This folder contains data on eighteen users whose data were used to train a machine learning algorithm. The data files include:

- "imu.csv", which contains raw data from two inertial measurement units, one placed on users' hand (1) and another placed on users' forearm (2).

- "wrist-angles.csv", which contains the ground-truth measurements of users' wrist angles.

- "novint-falcon.csv", which contains raw data on the Novint Falcon's end-effector position.

- "IMG_2 (Instance).csv", which contains data pertaining the first image the users analyzed in the citizen science application and marks a timestamp where the users must have interacted with the Novint Falcon.

# out-of-sample data
This folder contains data on two users who serve for out-of-sample analysis.

# machine_learning.ipynb
This Jupyter Notebook contains the codes to train a machine learning algorithm.
