# Traffic_Light_Controller
This project is a Verilog implementation of a traffic light controller for a two-street intersection. The design is modular, using a finite state machine (FSM) to manage the traffic light sequence and parameterized timers to handle the required timing for each light state.

💡 Design Philosophy
The main idea behind this project was to separate the core logic from the timing constraints. This modular approach makes the design flexible and reusable. The central traffic_light_controller FSM handles all state transitions based on traffic sensor inputs (Sa, Sb) and timing signals from external timer modules. The timer_parameter module is a generic, reusable timer that can be configured with a specific Final_value to create timers of any duration, decoupling the state logic from the physical clock frequency.

📝 Module Breakdown and Functionality

traffic_light_controller.v

This is the heart of the project. It's a finite state machine that controls the sequence of the traffic lights for streets A and B. It uses 12 different states to manage the flow of traffic. The state transitions are determined by the inputs from the vehicle sensors (Sa and Sb) and timer_done signals from the timing modules. The FSM outputs the signals for each of the six lights (Ra, Ya, Ga, Rb, Yb, Gb).




The state logic is designed to implement the specific rules of the intersection:


Street A is the main street and its light remains green for at least 60 seconds. The lights only change when a car approaches on street B.

Street B receives a green light after a car is detected and Street A's yellow light has passed. The green light on Street B lasts for at least 50 seconds and can be extended by 10 seconds if cars continue to arrive on street B with no cars on street A.

<img width="1323" height="613" alt="_traffic_light_state_diagram_" src="https://github.com/user-attachments/assets/fe22ea6f-a619-41cc-8a17-ffe779fd444b" />



timer_parameter.v

This is a generic timer module that counts clock cycles up to a specific Final_value. When the counter reaches this value, it asserts a 
done signal and resets. The timer can be reset externally and enabled by a dedicated input (en). By instantiating this module with different parameter values, we can create the 10, 50, and 60-second timers needed for the traffic light controller.


traffic_light.v

This is the top-level module that integrates the 
traffic_light_controller with three instances of the timer_parameter module. Each timer is configured with a different 
Final_value to represent the 10, 50, and 60-second time periods required by the controller. The controller outputs (
timer_reset_60, timer_reset_50, timer_reset_10) are used to reset the corresponding timers, creating the necessary timing for the intersection.

🧪 Test Bench and Verification

The traffic_light_tb.v test bench verifies the functionality of the traffic_light module by simulating various traffic scenarios and checking if the lights change correctly.

traffic_light_tb.v 

Explained The test bench instantiates the 
traffic_light module and generates a clock signal with a 10 ns period (localparam T = 10). This is used to drive the simulation. It also simplifies the output of the six individual light signals into two more readable values, 
light_A and light_B, representing the red, yellow, and green states.

The initial block sets up the test scenarios. It starts with a reset to ensure a known initial state. Then, it simulates four key scenarios to test the controller's logic:


No cars at either street: Sa = 0, Sb = 0. The system should remain in a stable state.


No cars at A, some at B: Sa = 0, Sb = 1. This tests the transition from Street A's green to Street B's green light.


Cars at both streets: Sa = 1, Sb = 1. This tests the controller's response to continuous demand.


Car appears at B, then no cars: Sa = 0, Sb = 1 followed by Sa = 0, Sb = 0. This tests the extension logic and the return to the idle state.

<img width="1919" height="361" alt="image" src="https://github.com/user-attachments/assets/247a49fc-c3db-49bf-914c-d4158b0bcf29" />
