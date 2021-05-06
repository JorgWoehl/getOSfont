[![View getOSfont on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/60710-getosfont)

# getOSfont

**getOSfont** returns the name and size of the system user interface font (default system font).

## Purpose

Graphical user interfaces developed with MATLAB often lack the look and feel of native applications, which is in part due to the fact that they do not use the user interface font of the operating system on which they are running. **getOSfont** resolves this issue by returning the name and size of the system UI font for a variety of platforms and OS versions, including all platforms officially supported by R2014b and above.

## Usage

`[OSFont, OSFontSize] = getOSfont(OS, OSVersion)` returns the name and size (in points) of the system UI font of the operating system `OS` in version `OSVersion`. If the system UI font is not available to MATLAB, it is replaced by a similar font and a warning is issued. If the OS is not supported, `OSFONT` and `OSFONTSIZE` are returned empty. If the font selected by **getOSfont** is not available on the system, `OSFONT` is returned empty.

`OS` is a character vector containing the name of the operating system in lowercase letters. The following operating systems are supported:

* 'windows' (starting with Windows 3.1)
* 'macos' (all OS X and macOS versions)
* 'ubuntu' (starting with Ubuntu 10.10)
* 'centos' and 'redhat' (starting with version 6.8)

`OSVersion` is a numeric vector representing the version number of the operating system. For example, `OSVersion = [6, 1, 7601]` corresponds to version 6.1.7601.

**getOSfont** is typically used in tandem with **[detectOS](https://www.mathworks.com/matlabcentral/fileexchange/59695-detectos)**.

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
% if returned empty, fall back on factory settings
if isempty(OSFont)
   OSFont = get(groot, 'factoryUicontrolFontName');
end
if isempty(OSFontSize)
   OSFontSize = get(groot, 'factoryUicontrolFontSize');
end
```

## Requirements

**getOSfont** is compatible with MATLAB R2013a and later releases.

## Feedback

Any feedback or help in extending the code to other operating systems/versions is welcome!
