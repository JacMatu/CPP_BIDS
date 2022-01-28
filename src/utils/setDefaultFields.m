function structure = setDefaultFields(structure, fieldsToSet)
    %
    % Recursively loop through the fields of a structure and sets a default value if
    % they don't exist.
    %
    % USAGE::
    %
    %   structure = setDefaultFields(structure, fieldsToSet)
    %
    % :param structure: Structure to check.
    % :type structure: structure
    % :param fieldsToSet: Structure containing the defaults for the missing fields.
    % :type fieldsToSet: structure
    %
    % :returns: :structure: (structure)
    %
    % (C) Copyright 2020 CPP_BIDS developers

    fieldsToSet = orderfields(fieldsToSet);

    names = fieldnames(fieldsToSet);

    for i = 1:numel(names)

        thisField = fieldsToSet.(names{i});

        if isfield(structure, names{i}) && isstruct(structure.(names{i}))

            structure.(names{i}) = ...
                setDefaultFields(structure.(names{i}), fieldsToSet.(names{i}));

        else

            structure = setFieldToIfNotPresent( ...
                                               structure, ...
                                               names{i}, ...
                                               thisField);
        end

    end

    structure = orderfields(structure);

end

function structure = setFieldToIfNotPresent(structure, fieldName, value)
    if ~isfield(structure, fieldName)
        structure.(fieldName) = value;
    end
end
