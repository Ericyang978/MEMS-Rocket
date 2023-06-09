%Note, all methodology originated from Open rocket's implementation, and
%based on their thesis/source code

%assumptions: subsonic flight, trapezoidal fins , wind is negligble,assume
%only 4 components, nosecone, cylinderical body, canards, and fins
%relatively small angles of attack (FOR open rocket, line 253 of
%BarrowmanCalculator.java, 17.5 is defined for threshold of warning, altho 10 is prob best)



%potential sources of error: 
%1) position x is defined relative to what (aerodynamic pitch/Cp section) I assume nose cone but not sure?
%2) Some values (like Renolds num) need magnitude of velocity, make sure
%that is correctly implemented
%3) assumed wetted area of rocket body is Diamter *L? not sure but idk wut
%else to do
%4) some equaition implementation is different from open rocket code and my
%code (even tho i follow the equations they listed in their document). an
%example is multiplying pitch damping by 3, and not including N when
%calculating fin damping. Also signs of dampning are different....

%notes
%1) sin(AOA)/AOA will be indeterminate at AOA = 0. Thus, follow wut open
%rocket does, and check the AOA variable ( make its value 1 if AOA < 0.001)
%2) when user defines fin, probably best to define it using 4 points? 
    %yeah this is best, and also can derive all pertinent fin values (Like
    %MAC length, Mac radial position, etc. from that) 


%--------------------------SIM INPUTS -----------------------


% Sim test 1: relatively low mach number, this doesn't test 
% 1) inindividual CP interpolation form .5-2, 
%2) the AOA = 0 case (testing the switch statements)
%3) straight drag to axial drag conversion
%) test different fin numbers (roll angle affects pitch in the less than 3
%case)
%) 

%atmopshere inputs
    airKinematicViscosity= 1.48*10^-5; 
    airDensity =1.2250 ; 
%Full rocket inputs
    rocketLength = 57/100;
    CGAxialPosition = 42.5/100;%center of gravity, relative to NOSECONE

%rocket body inputs
    bodyLength = 0.4; 
    bodyDiameter = 0.05; 
    bodyRoughness = 60*10^-5;%based on Table 3.2 Open Rocket

%fin geometry
    finLeadingEdgeNoseConeDistance = 45/100; 
    run('finParameters.m') %input 4 points which define trapezoidal fin

%fin (non geometry)
    finThickness = 0.3/100; 
    %Define a variable (finProfileType) which can be either 0 or 1. 
    % 0 implies the leading and trailing edge profiles are rounded, 
    % while 1 implies the leading and trailing edges are rectangular
    finProfileType = 1; 
    finCount = 4; 
    finCantAngle = 0; 

%nosecone
    noseConeHeight = .15; 
    noseConeVolume = (1/3)*noseConeHeight*(bodyDiameter/2)^2*pi; %assuming cone for now

    %defined a variable with numeric inputs.  
    % 1 -7 correspond with the shapes Figure 3.11 Open rocket doc)
    % 8 means there is a join angle, which is provided separately 
    % (assumed 0 if no joint angle). 
    noseConeType = 8; 
    noseConeJoinAngle = pi/2 - atan(noseConeHeight/(bodyDiameter/2));
    noseConeWettedArea =0.0139; 
    noseConePlanformArea = (1/2)*bodyDiameter* noseConeHeight; %assume for trangle for sim test 1
%Launch Lug
    launchLugLength = 3/100; 
    launchLugOuterDiameter = 1/100; 
    launchLugInnerDiameter = .8/100; 


%Variables of State
    %Compare at time t=1.417 (test values)
    rocketVelocityMag = 103.715; 
    machNum = .300;
    AOA = deg2rad(8); 
    pitchRate = -3.513;   %rate of change of AOA
    yawAngle =  -0.5282; 
    yawRate = -.487; 
    rollAngle = 0.0029; 
    rollRate = 0.012; 


% 
% flightSim = sim("FlightSim.slx");
% output1 = flightSim.yout{1}.Values.Data; %scuffed way to get the data, value in {} is port data
% disp(output1)




