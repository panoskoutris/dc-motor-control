#  DC Motor Control

This repository contains a series of control system experiments focused on the modeling and control of a DC motor. Developed as part of the **Automated Control Systems II** course, the labs explore key techniques in classical and modern control theory, including:

-  System identification from experimental step response  
-  State feedback control for position regulation  
-  Integral action to eliminate steady-state error  
-  State observer design for output feedback control  

Each lab is implemented in real-time using MATLAB and Arduino-based hardware. The experiments are accompanied by theoretical derivations, control design, and performance evaluation documented in the report.

---

##  Lab Summaries

###  Lab 1 – System Identification  
Experimental estimation of the DC motor’s parameters based on step response measurements. Parameters include time constant, gain, torque constant, back-EMF, and friction coefficient.

 *See Section: "Εργαστήριο 1ο" in `report.pdf`*

---

###  Lab 2 – State Feedback Control  
Design and implementation of a full-state feedback controller to regulate motor position using measured states (position and speed). The controller is tested under different reference values and conditions.

-  `lab2_state_feedback.m`

---

###  Lab 3 – Integral State Feedback  
Extension of Lab 2 with dynamic state feedback that includes an integral term to reject constant disturbances (e.g., friction). The integrator improves steady-state tracking performance.

-  `lab3_integral_feedback.m`

---

###  Lab 4 – Observer Design & Output Feedback  
Two parts:
- **Observer Simulation**: Design and simulation of a Luenberger observer to estimate unmeasured states. Analysis of estimation accuracy.
  -  `lab4_observer_simulation.m`
- **Output Feedback Control**: Closed-loop control using estimated states instead of direct measurements. Comparison of system performance with different observer pole placements.
  -  `lab4_observer_feedback.m`

---

##  Documentation

-  `lab_specs.pdf` — Lab assignment description and motor system schematic  
-  `report.pdf` — Full technical report with theoretical analysis, simulation plots, controller design, and experimental evaluation

---

##  Repository Structure

```
dc-motor-control/
│
├── src/
│ ├── lab2_state_feedback.m
│ ├── lab3_integral_feedback.m
│ ├── lab4_observer_feedback.m
│ └── lab4_observer_simulation.m
│
├── lab_specs.pdf
├── report.pdf
└── README.md
```


---

##  Author

**Panagiotis Koutris**  
Undergraduate at AUTH – School of Electrical & Computer Engineering

---

##  License

Licensed under the [Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0.html).
