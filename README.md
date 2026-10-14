# Deep RL Stabilization of Gyroscope

## Overview

This project involves the development of Deep RL PPO control system for stabilization and trajectory tracking of a 3-DOF Gyroscope. The project workflow consists of initialising the target response in the Simulink Model and running the local reset function before training the model using PPO algorithm code. Once training is completed, we have to validate the agent.


Kindly refer to the Project manuscript [Implementation of RL Based Gyroscope Control System (PDF)](./Implementation%20of%20RL%20based%20Gyroscope%20control%20system%20(1)%20(2).pdf) for elaborate explanations for Controller design, Algorithm explanation, training and validation.

## Tech-stack

Ensure the following software is installed before running the project:

* MATLAB
* Simulink
* MATLAB Reinforcement Learning Toolbox

## Project Files

| File                     | Description                                                                    |
| ------------------------ | ------------------------------------------------------------------------------ |
| `gyro_3dof.slx`          | Simulink model used to simulate the controller with an RL agent that will be trained. Generate output graphs for control response.      |
| `ppo_code.m`     | Trains the RL agent to reduce error between initial state and reference input.                   |
| `localResetFcnPPO.m`     | Initializes reference inputs and randomizes them for training. Resets the system to train again after every episode. Used by PPO training code. |
| `validationcode.m`       | Validates the trained agent after loading. |

## How to Run

Follow the steps below in the given order.

### 1. Open the simulink model

Open the Simulink Model. 

```matlab
gyro_3dof.slx
```

### 2. Initialize reference inputs

Run the local reset function code to initialize randomized reference inputs. 

```matlab
localResetFcnPPO.m
```

### 3. Training the agent

Run the PPO algorithm training code to train the agent. 

```matlab
ppo_code.m
```
The PPO code trains the agent while the resetting process after every training episode. The training progress is displayed in MATLAB RL Toolbox training monitor. 

### 4. Load the agent 

Check which agent has the highest evaluation statistic (pink star) and load that agent. Update the agent file name accordingly. 

```matlab
saved_agent = load('trainedAgent.mat')
```

### 5. Validation

Run the validation code to generate the output graphs in Simulink for the best agent. 

```matlab
validationcode.m
```

### Output response plot

![Output Plot](<Plots/0-50 Agent 4850 ppo.png>)

### Reward plot
![Reward Plot](<Plots/Screenshot 2025-06-16 112425.png>)

### Hardware Testing graphs

![Output Plot - Step input](<Plots/Hardware testing/Gryo response step.png>)
![Output Plot - Sine input](<Plots/Hardware testing/gyro response sine.png>)

## Execution Flow

Simulation
```
gyro_3dof.slx
          ↓
localResetFcnPPO.m
          ↓
ppo_code.m
          ↓
MATLAB RL Training monitor
          ↓
saved_agent
          ↓
validationcode.m
          ↓
Output response plots
```

## Notes
* Delete early training agents saved before achieving before high rewards to avoid memory filling up.

## Acknowledgement 
This project was developed as part of Second Year Summer Internship at Flight Dynamics and Controls Lab at Aerospace Department at IIT Madras from May 2025 - July 2025. 
