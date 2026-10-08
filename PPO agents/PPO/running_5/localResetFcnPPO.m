function in = localResetFcnPPO(in)

% Randomize reference signal
blk = sprintf("gyro_3dof/Reference angle");
% h=(rand*2 - 1)*pi/36;
h = pi/60;
%disp(h)
in = setBlockParameter(in,blk,'Value',num2str(h));

% Randomize initial angle
h = (rand*2 -1)*pi/36;
% h = pi/60;

blk = "gyro_3dof/gyro_model/State Space";
initialStates = [0 h 0 0]';
in = setBlockParameter(in,blk,'X0',mat2str(initialStates));
disp(h)
end
