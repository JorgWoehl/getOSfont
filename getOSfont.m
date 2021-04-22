function [OSFont, OSFontSize] = getOSfont(OS, OSVersion)
%GETOSFONT System user interface font (default system font).
%   [OSFONT, OSFONTSIZE] = GETOSFONT(OS, OSVERSION) returns the name and
%   size (in points) of the user interface (UI) font of operating system OS
%   in version OSVERSION. If the system UI font is not available to MATLAB,
%   it is replaced by a similar font and a warning is issued. If the OS is
%   not supported, OSFONT and OSFONTSIZE are returned empty. If the font
%   selected by GETOSFONT is not available on the system, OSFONT is
%   returned empty.
%
%   OS is a character vector containing the name of the operating system in
%   lowercase letters. The following operating systems are supported:
%   'windows' (starting with Windows 3.1), 'macos' (all OS X and macOS
%   versions), 'ubuntu' (starting with Ubuntu 10.10), and 'centos'/'redhat'
%   (starting with version 6.8).
%
%   OSVERSION is a numeric vector representing the version number of the
%   operating system (such as [6, 1, 7601] for version 6.1.7601).
%
%   GETOSFONT is typically used in tandem with DETECTOS, available at
%   https://www.mathworks.com/matlabcentral/fileexchange/59695-detectos.
%
%Example:
%
%   % avoid error if OS cannot be determined
%   try
%      [OS, OSVersion] = detectOS;
%   catch
%      OS = '';
%      OSVersion = [];
%   end
%   [OSFont, OSFontSize] = getOSfont(OS, OSVersion);
%   % if returned empty, fall back on factory settings
%   if isempty(OSFont)
%      OSFont = get(groot, 'factoryUicontrolFontName');
%   end
%   if isempty(OSFontSize)
%      OSFontSize = get(groot, 'factoryUicontrolFontSize');
%   end
%
%See also DETECTOS.

% Created 2016-01-05 by Jorg C. Woehl
% 2016-12-05 (JCW): Converted to standalone function, comments added.
% 2016-12-08 (JCW): Input arguments added.
% 2016-12-19 (JCW): Font and font size treated separately.
% 2021-04-22 (JCW): Version information added (v1.1.3).

%% Input argument validation

% input 1: empty character array, or character vector
assert(ischar(OS) && (isrow(OS) || isempty(OS)), 'getOSfont:IncorrectInputType',...
    'Input 1 must be an empty character array or a character vector.');
% convert to all lowercase if necessary
OS = lower(OS);
if isempty(OS)
    % reduce to simplest empty type
    OS = '';
else
    % input 2: nonempty numeric vector containing finite real non-negative "integers"
    assert(isnumeric(OSVersion) && ~isempty(OSVersion) && isvector(OSVersion) && all(isfinite(OSVersion))...
        && isreal(OSVersion) && all(OSVersion == round(OSVersion)) && all(OSVersion >= 0),...
        'getOSfont:IncorrectInputType',...
        'Input 2 must be a nonempty vector containing finite real non-negative integer values (of any numeric type).');
end

%% Determine system UI font

font = '';
fontSize = [];

% supported operating systems
switch OS
    case 'macos'
        % make sure we know minor version number
        if (numel(OSVersion) < 2)
            warning('getOSfont:MinorVersionNeeded',...
                ['Minor version needed; assume OS version [' num2str(OSVersion(1)) ', 0].']);
            OSVersion(2) = 0;
        end
        if ((OSVersion(1) > 10) ||  ...
                ((OSVersion(1) == 10) && (OSVersion(2) >= 11)))
            % OS X El Capitan, macOS Sierra and higher
            % San Francisco is not available, use Helvetica Neue
            font = 'Helvetica Neue';
            fontSize = 13;
            warning('getOSfont:FontNotAvailable',...
                ['Font ''San Francisco Text'' not available; replaced by ''' font '''.']);
        elseif ((OSVersion(1) == 10) && (OSVersion(2) == 10))
            % OS X Yosemite
            font = 'Helvetica Neue';
            fontSize = 13;
        elseif (OSVersion(1) == 10)
            % Mac OS X Cheetah through OS X Mavericks
            font = 'Lucida Grande';
            fontSize = 13;
        end
    case 'windows'
        % make sure we know minor version number in case of Windows 3.x
        if ((OSVersion(1) == 3) && (numel(OSVersion) < 2))
            warning('getOSfont:MinorVersionNeeded',...
                ['Minor version needed; assume OS version [' num2str(OSVersion(1)) ', 0].']);
            OSVersion(2) = 0;
        end
        % https://msdn.microsoft.com/en-us/library/windows/desktop/dn742483(v=vs.85).aspx
        if (OSVersion(1) >= 6)
            % Windows Vista, 7, 8, and 10
            font = 'Segoe UI';
            fontSize = 9;
        elseif (OSVersion(1) == 5)
            % Windows 2000, XP, and Server 2003
            % https://en.wikipedia.org/wiki/Tahoma_(typeface)
            font = 'Tahoma';
            fontSize = 8;
        elseif ((OSVersion(1) == 4) || ...
                ((OSVersion(1) == 3) && (OSVersion(2) >= 10)))
            % Windows 3.1, 95, 98, ME, and NT 4.0
            % https://en.wikipedia.org/wiki/MS_Sans_Serif
            font = 'Microsoft Sans Serif';
            fontSize = 8;
        end
    case 'ubuntu'
        % make sure we know minor version number in case of Ubuntu 10.x
        if ((OSVersion(1) == 10) && (numel(OSVersion) < 2))
            warning('getOSfont:MinorVersionNeeded',...
                ['Minor version needed; assume OS version [' num2str(OSVersion(1)) ', 4].']);
            OSVersion(2) = 4;
        end
        if ((OSVersion(1) > 10) ||  ...
                ((OSVersion(1) == 10) && (OSVersion(2) >= 10)))
            % https://en.wikipedia.org/wiki/Ubuntu_(typeface)
            font = 'Ubuntu';
            fontSize = 11;
        end
    case {'centos', 'redhat'}
        % make sure we know minor version number in case of version 6.x
        if ((OSVersion(1) == 6) && (numel(OSVersion) < 2))
            warning('getOSfont:MinorVersionNeeded',...
                ['Minor version needed; assume OS version [' num2str(OSVersion(1)) ', 0].']);
            OSVersion(2) = 0;
        end
        if ((OSVersion(1) == 6) && (OSVersion(2) >= 8))
            % CentOS (Red Hat) 6.8 GNOME uses "Sans" (also called "Luxi Sans") 10pt,
            % which is not available to MATLAB (it lists "SansSerif" instead, which
            % looks nothing like it). The following is a better match:
            font = 'DejaVu Sans Condensed';
            warning('getOSfont:FontNotAvailable',...
                ['Font ''Sans'' not available; replaced by ''' font '''.']);
            fontSize = 10;
        elseif (OSVersion(1) > 6)
            % CentOS (Red Hat) 7 and higher (determined using Tweak Tool); see also
            % https://developer.gnome.org/hig/stable/typography.html.en
            font = 'Cantarell';
            fontSize = 11;
        end
end

OSFontSize = fontSize;
% check if the selected font exists
if fontexist(font)
    OSFont = font;
else
    OSFont = '';
end

end
