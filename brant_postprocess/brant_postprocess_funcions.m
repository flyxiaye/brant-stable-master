function prompt = brant_postprocess_funcions(functype)

switch(functype)
    case 'FC'
        prompt = {  'Draw ROIs';...
                    'Merge/Extract ROIs'
                    'ROI Signal Calculation';...
                    };
    case 'SPON'
        prompt = {  'AM';...
                    'ALFF/fALFF';...
                    ...'fGn';...
                    'ReHo';...
                    'FCD/FCS';...
                    };
    case 'STAT'
        prompt = {  'T-Tests';...
                    'IBMA';...
                    };
    case 'UTILITY'
        prompt = {  'DICOM Convert';...
                    'Head Motion Est';...
                    'Visual Check';...
                    'TSNR';...
                    'ROI Coordinates';...
                    'Extract Value';...
                    'Reslice';...
                    ...'Normalise';...
                    ...'Gzip/Gunzip Files';...
                    };
    case 'NET'
        prompt = {  'Threshold Estimation';...
                    'Network Calculation';...
                    'Network Statistics';...
                    };
    case 'VIEW'
        prompt = {  'Surface Mapping';...
                    'Slice Mapping'; ...
                    'ROI Mapping';...
                    'Network Visualization';...
                    ...'Circos';...
                    };
                
    case 'PREPROCESS'
        prompt = {  'Slice Timing';...
                    'Realign';...
                    'Coregister';...
                    'Normalise';...
                    'Denoise';...
                    'Smooth'};
    case 'THIRD PARTY'
        prompt = {  'DiffusionKit';...
                    'Circos'};
    otherwise
        warndlg('Unknown inputs!');
end