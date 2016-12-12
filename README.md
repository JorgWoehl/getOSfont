# getOSfont

**getOSfont** returns the name and size of the system user interface font (default system font).

## Purpose

Graphical user interfaces developed with MATLAB often lack the look and feel of native applications, which is in part due to the fact that they do not use the user interface font of the operating system on which they are running. **getOSfont** resolves this problem by returning the name and size of the system UI font for a variety of platforms and OS versions, including all platforms officially supported by R2014b and later.

## Usage

`[OSFont, OSFontSize] = getOSfont(OS, OSVersion)` returns the name and size (in points) of the system UI font of operating system `OS` in version `OSVersion`. If the system UI font is not available to MATLAB, it is replaced by a similar font and a warning is issued. If the OS is not supported, or if the selected font is not available, `OSFont` and `OSFontSize` are returned empty.

`OS` is a character vector containing the name of the operating system in lowercase letters. The following operating systems are supported:

* 'windows' (starting with Windows 3.1)
* 'macos' (all OS X and macOS versions)
* 'ubuntu' (starting with Ubuntu 10.10)
* 'centos' and 'redhat' (starting with version 6.8)

`OSVersion` is a numeric vector representing the version number of the operating system. For example, `OSVersion = [6, 1, 7601]` corresponds to version 6.1.7601.

**getOSfont** is typically used in tandem with **detectOS**, available at https://www.mathworks.com/matlabcentral/fileexchange/59695-detectos.

Example:

```matlab
% avoid error if OS cannot be determined
try
   [OS, OSVersion] = detectOS;
catch
   OS = '';
   OSVersion = [];
end
[OSFont, OSFontSize] = getOSfont(OS, OSVersion);
if isempty(OSFont)
   % default to factory settings
   OSFont     = get(groot, 'factoryUicontrolFontName');
   OSFontSize = get(groot, 'factoryUicontrolFontSize');
end
```

## Requirements

**detectOS** and **getOSfont** run on MATLAB R2013a or later.

## Feedback

Any help in improving and extending the code to other operating systems and/or versions is greatly appreciated!
