function cfg = checkCFG(cfg)
    % cfg = checkCFG(cfg)
    %
    % check that we have all the fields that we need in the experiment parameters
    % reuses a lot of code from the BIDS starter kit

    if nargin < 1 || isempty(cfg)
        cfg = struct();
    end

    checkCppBidsDependencies(cfg);

    %% list the defaults to set

    fieldsToSet.verbose = false;

    fieldsToSet.fileName.task = '';
    fieldsToSet.fileName.zeroPadding = 3;
    fieldsToSet.fileName.dateFormat = 'yyyymmddHHMM';

    fieldsToSet.dir.output = fullfile( ...
        fileparts(mfilename('fullpath')), ...
        '..', ...
        'output');

    fieldsToSet.subject.askGrpSess = [true true];
    fieldsToSet.subject.sessionNb = 1; % in case no session was provided
    fieldsToSet.subject.subjectGrp = ''; % in case no group was provided

    fieldsToSet.testingDevice = 'pc';

    fieldsToSet.eyeTracker = struct();

    fieldsToSet.eyeTracker.do = false;

    fieldsToSet = mriDefaults(fieldsToSet);

    %% BIDS

    fieldsToSet = datasetDescriptionDefaults(fieldsToSet);
    fieldsToSet = mriJsonDefaults(fieldsToSet);
    fieldsToSet = megJsonDefaults(fieldsToSet);

    fieldsToSet = transferInfoToBids(fieldsToSet, cfg);

    %% Set defaults
    cfg = setDefaultFields(cfg, fieldsToSet);

end

function fieldsToSet = mriDefaults(fieldsToSet)

    % for file naming and JSON
    fieldsToSet.mri.contrastEnhancement = [];
    fieldsToSet.mri.phaseEncodingDirection = [];
    fieldsToSet.mri.reconstruction = [];
    fieldsToSet.mri.echo = [];
    fieldsToSet.mri.acquisition = [];
    fieldsToSet.mri.repetitionTime = [];

    fieldsToSet.mri = orderfields(fieldsToSet.mri);

end

function fieldsToSet = datasetDescriptionDefaults(fieldsToSet)

    % REQUIRED name of the dataset
    fieldsToSet.bids.datasetDescription.Name = '';

    % REQUIRED The version of the BIDS standard that was used
    fieldsToSet.bids.datasetDescription.BIDSVersion = '';

    % RECOMMENDED
    % what license is this dataset distributed under? The
    % use of license name abbreviations is suggested for specifying a license.
    % A list of common licenses with suggested abbreviations can be found in appendix III.
    fieldsToSet.bids.datasetDescription.License = '';

    % RECOMMENDED List of individuals who contributed to the
    % creation/curation of the dataset
    fieldsToSet.bids.datasetDescription.Authors = {''};

    % RECOMMENDED who should be acknowledge in helping to collect the data
    fieldsToSet.bids.datasetDescription.Acknowledgements = '';

    % RECOMMENDED Instructions how researchers using this
    % dataset should acknowledge the original authors. This field can also be used
    % to define a publication that should be cited in publications that use the
    % dataset.
    fieldsToSet.bids.datasetDescription.HowToAcknowledge = '';

    % RECOMMENDED sources of funding (grant numbers)
    fieldsToSet.bids.datasetDescription.Funding = {''};

    % RECOMMENDED a list of references to
    % publication that contain information on the dataset, or links.
    fieldsToSet.bids.datasetDescription.ReferencesAndLinks = {''};

    % RECOMMENDED the Document Object Identifier of the dataset
    % (not the corresponding paper).
    fieldsToSet.bids.datasetDescription.DatasetDOI = '';

    % sort fields alphabetically
    fieldsToSet.bids.datasetDescription = orderfields(fieldsToSet.bids.datasetDescription);

end

function fieldsToSet = mriJsonDefaults(fieldsToSet)
    % for json for funcfional MRI data

    % REQUIRED The time in seconds between the beginning of an acquisition of
    % one volume and the beginning of acquisition of the volume following it
    % (TR). Please note that this definition includes time between scans
    % (when no data has been acquired) in case of sparse acquisition schemes.
    % This value needs to be consistent with the pixdim[4] field
    % (after accounting for units stored in xyzt_units field) in the NIfTI header
    fieldsToSet.bids.mri.RepetitionTime = [];

    % REQUIRED for sparse sequences that do not have the DelayTime field set.
    % This parameter is required for sparse sequences. In addition without this
    % parameter slice time correction will not be possible.
    %
    % In addition without this parameter slice time correction will not be possible.
    % The time at which each slice was acquired within each volume (frame) of  the acquisition.
    % The time at which each slice was acquired during the acquisition. Slice
    % timing is not slice order - it describes the time (sec) of each slice
    % acquisition in relation to the beginning of volume acquisition. It is
    % described using a list of times (in JSON format) referring to the acquisition
    % time for each slice. The list goes through slices along the slice axis in the
    % slice encoding dimension.
    fieldsToSet.bids.mri.SliceTiming = [];

    % REQUIRED Name of the task (for resting state use the "rest" prefix). No two tasks
    % should have the same name. Task label is derived from this field by
    % removing all non alphanumeric ([a-zA-Z0-9]) characters.
    fieldsToSet.bids.mri.TaskName = [];

    % RECOMMENDED Text of the instructions given to participants before the scan.
    % This is especially important in context of resting state fMRI and
    % distinguishing between eyes open and eyes closed paradigms.
    fieldsToSet.bids.mri.Instructions = '';

    % RECOMMENDED Longer description of the task.
    fieldsToSet.bids.mri.TaskDescription = '';

    % fieldsToSet.PhaseEncodingDirection = [];
    % fieldsToSet.EffectiveEchoSpacing = [];
    % fieldsToSet.EchoTime = [];

    fieldsToSet.bids.mri = orderfields(fieldsToSet.bids.mri);

end

function fieldsToSet = megJsonDefaults(fieldsToSet)
    % for json for MEG data

    % REQUIRED Name of the task (for resting state use the "rest" prefix). No two tasks
    % should have the same name. Task label is derived from this field by
    % removing all non alphanumeric ([a-zA-Z0-9]) characters.
    fieldsToSet.bids.meg.TaskName = [];

    % REQUIRED Sampling frequency
    fieldsToSet.bids.meg.SamplingFrequency = [];

    % REQUIRED Frequency (in Hz) of the power grid at the geographical location of
    % the MEG instrument (i.e. 50 or 60):
    fieldsToSet.bids.meg.PowerLineFrequency = [];

    % REQUIRED Position of the dewar during the MEG scan: "upright", "supine" or
    % "degrees" of angle from vertical: for example on CTF systems,
    % upright=15°, supine = 90°:
    fieldsToSet.bids.meg.DewarPosition = [];

    % REQUIRED List of temporal and/or spatial software filters applied, or ideally
    % key:value pairs of pre-applied software filters and their parameter
    % values: e.g., {"SSS": {"frame": "head", "badlimit": 7}},
    % {"SpatialCompensation": {"GradientOrder": Order of the gradient
    % compensation}}. Write "n/a" if no software filters applied.
    fieldsToSet.bids.meg.SoftwareFilters = [];

    % REQUIRED Boolean ("true" or "false") value indicating whether anatomical
    % landmark points (i.e. fiducials) are contained within this recording.
    fieldsToSet.bids.meg.DigitizedLandmarks = [];

    % REQUIRED Boolean ("true" or "false") value indicating whether head points
    % outlining the scalp/face surface are contained within this recording
    fieldsToSet.bids.meg.DigitizedHeadPoints = [];

    fieldsToSet.bids.meg = orderfields(fieldsToSet.bids.meg);

end