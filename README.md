# 🚦 Smart Traffic Light Control with Machine Learning

This project implements an **AI-powered traffic light controller** that adapts in real time to traffic conditions.  
The goal is to reduce **average waiting time**, **queue lengths**, and **vehicle stops** compared to traditional fixed-time and rule-based controllers.  

---

## ✨ Features
- 🟢 **Traffic simulation** using [CityFlow](https://github.com/cityflow-project/CityFlow) or [SUMO](https://www.eclipse.org/sumo/).  
- 🤖 **Reinforcement Learning agents** (DQN, PPO) for adaptive signal control.  
- ⚖️ **Baseline controllers**:  
  - Fixed-time (static schedule)  
  - Actuated (queue-threshold rules)  
- 📊 **Performance metrics**: average delay, queue length, throughput, stop count, emissions proxy.  
- 🔒 **Safety constraints**: min/max green, amber, pedestrian phases.  
- 📹 (Optional) **Camera-based detection pipeline** with lightweight models (YOLO/OpenCV).  

---

## 🛠️ Tech Stack
- **Python 3.9+**  
- [PyTorch](https://pytorch.org/) – RL agent training  
- [Gymnasium](https://gymnasium.farama.org/) – environment API  
- [CityFlow](https://github.com/cityflow-project/CityFlow) or [SUMO](https://www.eclipse.org/sumo/) – traffic simulation  
- [Matplotlib](https://matplotlib.org/) – visualization  
- [Weights & Biases](https://wandb.ai/) (optional) – experiment tracking  

---

## 📂 Project Structure

```plaintext
traffic-light-ml/
├── README.md               # Project documentation
├── requirements.txt        # Dependencies list
├── configs/                # CityFlow/SUMO configs
│   └── single_intersection.json
├── envs/                   
│   └── traffic_env.py      # Custom Gym environment wrapper
├── controllers/            
│   ├── fixed_time.py       # Fixed-time baseline controller
│   ├── actuated.py         # Rule-based (actuated) controller
├── agents/                 
│   ├── dqn_agent.py        # Deep Q-Network (DQN) agent
│   └── ppo_agent.py        # Proximal Policy Optimization (PPO) agent
├── train.py                # Training script
├── evaluate.py             # Evaluation script
├── utils/                  
│   ├── logger.py           # Logging & plotting utilities
│   └── replay_buffer.py    # Replay buffer for DQN
└── data/                   
    └── results/            # Saved logs and experiment outputs
```

1) Define the smallest useful goal
	•	Scope: start with one 4-way intersection; scale to corridors later.
	•	Objective: minimize average vehicle delay and queue length; secondary: reduce stops and emissions.

2) Choose a simulator (so you can iterate safely)

Pick one:
	•	SUMO (mature, open-source; Python API via TraCI)
	•	CityFlow (fast, RL-friendly; simple JSON configs)
Either lets you spawn cars with routes, read queues/wait time, and switch signal phases from Python.

3) Baselines (so ML has something to beat)

Implement two non-ML controllers:
	1.	Fixed-time (e.g., NS/EW green 30s, then 10s yellow, etc.)
	2.	Actuated (simple rules using queue thresholds or detector hits)

Measure:
	•	Avg delay (s/veh)
	•	Avg queue length
	•	Throughput (veh/hour)
	•	% time green wasted (green with no cars)

4) Formulate the ML problem (Reinforcement Learning)

Environment
	•	State (each step, e.g., every 2–5s):
	•	Queue lengths per approach/lane
	•	Waiting time per lane
	•	Current phase + time in phase
	•	(optional) approaching vehicles within 100m
	•	Action:
	•	Either: choose next phase (from a valid set)
	•	Or: extend/terminate current green (binary), with min/max green constraints
	•	Reward (maximize):
	•	r = - (sum of delays + queue penalties + stop penalties)
	•	Add small penalty for phase change to discourage flicker
	•	Constraints (hard rules, always enforced):
	•	Minimum green, yellow, and all-red durations
	•	No conflicting greens (safety first)
