function go(varargin)

% GO starts ASM project.
%
%       go (varargin)
%
%       Arguments:
%
%           parameter:  'simmode'
%
%           value:      'PC'  - for off-line simulation on PC under SIMULINK
%                       'HIL' - for real-time simulation on Real-Time HW
%                               with ECU connected
%                       'CPT' - for real-time simulation on Real-Time HW
%                               without ECU connected
%
%           The first argument defines the simulation mode in which
%           ASM should be used. Calling GO without 'simmode' initialzes
%           the default simulation mode.
%           The simmode influence the parameterization and controls the
%           asm_switch_online_offline function.
%           For VEOS it is always switched to offline independent from
%           simmode
%
%           ---------------------------------------------------------------
%
%           parameter:   <VARIANTLIST> - Name of variant definition list e.g. 'engine'
%
%           value: <VARIANTNAME> - Name of variant e.g. 'EngineVariant2'
%
%           The second argument defines the initialisation variant which
%           should be loaded to the MATLAB workspace. You can easily add
%           further variants by attaching other variant structures e.g.
%
%           godata.variants.engine =    { ...
%                                        'EngineVariant1',...  <== Default engine variant
%                                        'EngineVariant2',...
%                                       };
%
%           godata.variants.drivetrain = { ...
%                                        'DrivetrainVariant1',...  <== Default drivetrain variant
%                                        'DrivetrainVariant2',...,
%                                        'DrivetrainVariant3',...
%                                        };
%
%           ... append own variants in the same way.
%
%           Calling GO without variant arguments initialzes the default
%           variants. They are always on the first position of each
%           variant definition list.
%
%           ---------------------------------------------------------------
%
%           parameter: drivingcycle
%
%           value: <CYCLENAME>
%           The second argument defines the cycle variant which
%           should be loaded to the MATLAB workspace.
%
%           Calling GO without drivingcycles arguments initialzes the default
%           cycle. This are always on the first position of cycle definition list.
%
%           ---------------------------------------------------------------
%
%           parameter: platform
%
%           value: 'RTI'      - DS1005, DS1006, DS1007, DS1202
%                  'SCALEXIO' - Simulator Hardware
%                  'VEOS'     - Offline Simulation Platform
%
%           Platform controls the RTWSystemTargetFile and the
%           asm_switch_online_offline function.
%           For VEOS it is always switched to offline independent from
%           simmode
%           Calling GO without platform arguments initialzes the default
%           platform. This is always on the first position of platform definition list.
%
%           ---------------------------------------------------------------
%
%       Examples:
%
%         - Start of default variant 'Diesel4Cyl2p0l' with
%           default simulation mode 'PC'
%
%	        go
%
%         - Start of default variant 'Diesel4Cyl2p0l'
%           with simulation mode 'PC'
%
%           go PC
%           go ('simmode','PC')
%
%         - Start of user defined variant 'Diesel4Cyl2p0lAdvTurbo' with
%           simulation mode 'PC'
%
%           go ('simmode','PC','engine','Diesel4Cyl2p0lAdvTurbo')
%
%         - Start of user defined variant 'TruckDiesel6Cyl12p0l' with
%           simulation mode 'HIL'
%
%           go ('simmode','HIL','engine','TruckDiesel6Cyl12p0l')
%
% See also:
%
%

% REMARKS
%
%
% AUTHOR(S): dSPACE
%
%
% Copyright 2005 - 2015 by dSPACE GmbH, GERMANY

% =========================================================================
% =====                DEFINE SETTINGS AND DEFAULTS                   =====
% =========================================================================

DefSimMode  =  'PC';           % <== Default simulation mode

DefPlatform = {'SCALEXIO',...  % <== Default platform (always first)
               'RTI',...
               'VEOS'};

SimulationModel = 'ASM_EngineDiesel';

% =========================================================================
% =====                   INSERT YOUR VARIANTS HERE                   =====
% =========================================================================

godata.variants.engine = { ...
    'Diesel4Cyl2p0l',... % <== Default variant (always first variant)
    'Diesel4Cyl2p0lAdvTurbo',...          
    'TruckDiesel6Cyl12p0l',...
    'TruckDiesel6Cyl12p0lSAETurbo',...
    'TruckDiesel6cyl12p0lSCR',... 
    };

drivingcycles = {...
    'Ftp_75',...  % <== Default cycle (always first cycle)
    'AC',...
    'ESC',...
    'ETC',...
    'EUDC',...
    'EUDC_with_6gear',...
    'EUDC_with_gear',...
    'FTP_Transient',...
    'Ftp_75_short',...
    'HIGHWAY',...
    'JP_JE05',...
    'JP_JE05_with_Gear',...
    'Jap_10_15',...
    'SC03',...
    'US06',...
    'WHTC',...
    'ffe_city',...
    'JP_JC08',...
    'WLTC_Class1',...
    'WLTC_Class2',...
    'WLTC_Class3',...
    };
% Apply defaults
CurPlatform      = DefPlatform{1};
CycleName        = drivingcycles{1};
try
    % =========================================================================
    %% =====          CHECK OF DSPACE AND HILTOOL INSTALLATION            =====
    % =========================================================================
    home;
    % check  ASM Installation
    i_checkdspaceinstallation
    
    % Uncomment next lines if hiltools have been added to this project
    % i_checkhiltoolsinstallation
    % dspacehiltoolsrc;
    
    %% Handle vargin calling
    if(nargin==0)
        varargin{1} = 'simmode';
        varargin{2} = DefSimMode;
    elseif(nargin==1)
        varargin{2} = varargin{1};
        varargin{1} = 'simmode';
    elseif(any(strcmpi(varargin{1},{'hil','cpt','pc'})))
        for k=nargin:-1:1
            varargin{k+1} = varargin{k};
        end
        varargin{1} = 'simmode';
    else
        if ~strcmpi(varargin{1},'simmode')
            for k=nargin:-1:1
                varargin{k+2} = varargin{k};
            end
            varargin{1} = 'simmode';
            varargin{2} = DefSimMode;
        end
    end
    varargin{2} = upper(varargin{2});
    
    %% Check for and get driving cycle and remove from varargin
    indx = find(strcmpi(varargin(1:2:end),'drivingcycle'))*2;
    if ~isempty(indx)
        CycleName = varargin{indx};
    end
    
    %% Check for and get platform and remove from varargin
    indx = find(strcmpi(varargin(1:2:end),'platform'))*2;
    if ~isempty(indx)
        CurPlatform = varargin{indx};
    end
    
    godata.excludepath = {};
    % The following parameter are not an initialization variant and have to be ignored
    godata.excludeparameter = {'simmode','drivingcycle','platform'};
    % Add Simulation Model to godata
    godata.CurrentSystem = {SimulationModel};
    %% Start Initialization
    fprintf(['Simulation Mode: ', varargin{2}, '\n\n']);
    
    if ~SimulationInit(godata,varargin{:});
        error('asm:SimulationInit','Model initialization failed.\nRefer to messages above for details.')
    end
    
    %% Initialize driving or engine cycle
    asm_eng_drivingcycles('drivingcyclego','CycleList',drivingcycles,'CycleName', CycleName);
    
    try
        load_system(SimulationModel);
        open_system(SimulationModel);
    catch asm_error
        fprintf('\n### ERROR opening model: %s.\n',SimulationModel)
        rethrow(asm_error)
    end
    
    % Set the simulation platform
    i_setplatform(SimulationModel,CurPlatform);
    
    % ... switch of warning for ToWorkspace blocks in ForIterator subsystems
    warning('off', 'Simulink:logLoadBlocks:ToWksInIteratorSystem')
    
    fprintf('\n*** GO successfully executed.\n')
catch asm_error
    asm_migrate_common('showerror','Exception',asm_error)
    fprintf('\n*** GO failed.\n')
end
return
% =====================================================================================================================
function i_checkdspaceinstallation()
if ~exist('asmver','file')
    error('asm:asmnotinstalled','dSPACE Automotive Simulation Models (ASM) Software is not installed for this MATLAB version.\n')
end
return % end of i_checkdspaceinstallation


% =====================================================================================================================
function i_checkhiltoolsinstallation() %#ok<DEFNU>
if ~exist('dspacehiltoolsrc','file')
    error('asm:hiltoolsnotinstalled','dSPACE HILTools not installed for this MATLAB version.\n')
end
return % end of i_checkhiltoolsinstallation

% =====================================================================================================================
function check = i_setplatform(MdlName,platform)

% Check if model is open and make settings
if any(strcmp(find_system('type', 'block_diagram'),MdlName))
    switch lower(platform)
        case 'rti'
            set_param(MdlName,'SimulationMode','normal');
            Board='Offline';
            if exist('rtiver','file')
                % Get active RTI
                Board = rtiver('Type');
            else
                % Return if RTI is not installed
                check = 1;
                return
            end
            % Get active system target file
            SysTrgFile = get_param(MdlName,'RTWSystemTargetFile');
            % Set model configuration parameters
            % if system target file does not match to active RTI 
            if ~strncmpi(Board, SysTrgFile, 7)
               asm_set_rti(MdlName,'EngineDiesel');
               i_set_rti(MdlName);
            end
        case 'scalexio'
            % do nothing
            % settings are done by ConfigurationDesk
        case 'veos'
            asm_set_veos(MdlName);
        otherwise
            error('asm:go:invalidplatform','Platform %s is not supported. Valid platforms are ''RTI'', ''VEOS'' or ''SCALEXIO''.',platform)
    end
else
    error('asm:go:nomodel','Could not set platform ''%s'' for model ''%s''.\nThe model is not open',platform,MdlName)
end

check = 1;
return

% =====================================================================================================================
function i_set_rti(MdlName)

if any(strcmp(find_system('type','block_diagram'),MdlName))
    
    % set further compiler options for DS1005 if set_rti was successful
    SysTrgFile = get_param(MdlName,'RTWSystemTargetFile');
    if strcmp(SysTrgFile,'rti1005.tlc')
        rti_optionset(MdlName, ...
            'CCompilerOptimizationOptsPopup','User-defined',...
            'CCompilerOptimizationOpts','-O ');
    end
    
else
    fprintf(['### Warning: Could not set RTI settings for model ',upper(MdlName),'.\n'])
end
return
