function in = localResetFcnPPORandomTarget(in)

% Randomize reference signal
blk = sprintf("gyro_3dof/Reference angle");
% h=(rand*2 - 1)*pi/36;
% h = pi/60;
targets = [-10 -5 0 5 10];

target = targets(randi([1,5]))*pi/180;

in = setBlockParameter(in,blk,'Value',num2str(target));

% Randomize initial angle
% h = (rand*2 -1)*pi/36;
initial_conditions = [-5 -4 -3 -2 -1 0 1 2 3 4 5];
h= initial_conditions(randi([1,11]))*pi/180;
disp()
blk = "gyro_3dof/gyro_model/State Space";
initialStates = [0 h 0 0]';
in = setBlockParameter(in,blk,'X0',mat2str(initialStates));
disp(['Target Angle = ',num2str(target*180/pi),', Initial Angle = ',num2str(h*180/pi)])
end
