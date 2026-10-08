% Observation info
obsInfo = rlNumericSpec([6 1],...
    LowerLimit= [-pi -inf -pi -inf -inf -inf]',...
    UpperLimit=[pi inf pi inf inf inf]');

% Name and description are optional and not used 
% by the software
obsInfo.Name = "observations";
obsInfo.Description = "integrated error, error," + ... 
    " and measured angle";

% Action info
actInfo = rlNumericSpec([1 1]);
actInfo.Name = "torque";

%create environment object
env = rlSimulinkEnv("gyro_3dof","gyro_3dof/RL Agent",...
    obsInfo,actInfo);

env.ResetFcn = @localResetFcnPPO;

Ts = 0.1;
Tf = 200;

obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);

criticNet = [
    featureInputLayer(prod(obsInfo.Dimension))
    fullyConnectedLayer(100)
    reluLayer
    fullyConnectedLayer(1)
    ];

criticNet = dlnetwork(criticNet);
criticNet = initialize(criticNet);
plot(criticNet)
summary(criticNet)

critic = rlValueFunction(criticNet,obsInfo);

getValue(critic,{rand(obsInfo.Dimension)})

% Define common input path layer
commonPath = [ 
    featureInputLayer(prod(obsInfo.Dimension),Name="comPathIn")
    fullyConnectedLayer(100)
    reluLayer
    fullyConnectedLayer(1,Name="comPathOut") 
    ];

% Define mean value path
meanPath = [
    fullyConnectedLayer(15,Name="meanPathIn")
    reluLayer
    fullyConnectedLayer(prod(actInfo.Dimension));
    tanhLayer;
    scalingLayer(Name="meanPathOut")
    ];

% Define standard deviation path
sdevPath = [
    fullyConnectedLayer(15,"Name","stdPathIn")
    reluLayer
    fullyConnectedLayer(prod(actInfo.Dimension));
    softplusLayer(Name="stdPathOut") 
    ];


actorNet = dlnetwork;
actorNet = addLayers(actorNet,commonPath);
actorNet = addLayers(actorNet,meanPath);
actorNet = addLayers(actorNet,sdevPath);

actorNet = connectLayers(actorNet,"comPathOut","meanPathIn/in");
actorNet = connectLayers(actorNet,"comPathOut","stdPathIn/in");

plot(actorNet)

actorNet = initialize(actorNet);
summary(actorNet)

actor = rlContinuousGaussianActor(actorNet, obsInfo, actInfo, ...
    "ActionMeanOutputNames","meanPathOut",...
    "ActionStandardDeviationOutputNames","stdPathOut",...
    ObservationInputNames="comPathIn");

getAction(actor,{rand(obsInfo.Dimension)})

agent = rlPPOAgent(actor,critic);

agent.AgentOptions.ExperienceHorizon = 1024;
agent.AgentOptions.DiscountFactor = 0.95;

agent.AgentOptions.CriticOptimizerOptions.LearnRate = 3e-4;
agent.AgentOptions.CriticOptimizerOptions.GradientThreshold = 1;
agent.AgentOptions.ActorOptimizerOptions.LearnRate = 5e-4;
agent.AgentOptions.ActorOptimizerOptions.GradientThreshold = 1;

criticOpts = rlOptimizerOptions( ...
    LearnRate=1e-4,GradientThreshold=1);

getAction(agent,{rand(obsInfo.Dimension)})
% load("PPO_update_2\Agent919.mat","saved_agent");

trainOpts = rlTrainingOptions(...
    'MaxEpisodes', 5000-1130-920-1200-5, ...
    'ScoreAveragingWindowLength', 100, ...
    'SaveAgentCriteria', 'EpisodeCount',...
    'SaveAgentValue', 1, ...
    'SaveAgentDirectory',"PPO_update_5",...
    'MaxStepsPerEpisode', ceil(Tf/Ts), ...
    'Plots', 'training-progress', ...
    'Verbose', true, ...
    'StopTrainingCriteria', 'EvaluationStatistic', ...
    'StopTrainingValue', 5000);

% agent evaluator
evl = rlEvaluator(EvaluationFrequency=10,NumEpisodes=5);
disp("Starting RL PPO Gyro Training....")

rng(0,"twister");

doTraining = true;
if doTraining
    % Train the agent.
    trainingStats = train(saved_agent,env,trainOpts,Evaluator=evl);
end
disp("Training Completed")
%%else
    % Load the pretrained agent for the example.
   % load("gyro.mat","agent")
%end%%%

rng(0,"twister");
simOpts = rlSimulationOptions( ...
    'MaxSteps',200, ...
    'StopOnError','on');
experiences = sim(env,agent,simOpts);