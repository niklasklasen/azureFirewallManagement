$folders = @(
  @{
    Path    = 'private'
    Export  = $true
    Recurse = $false
    Filter  = '*-*.ps1'
    Exclude = @(
      '*.Tests.ps1'
    )
  },
  @{
    Path    = 'custom'
    Export  = $true
    Recurse = $false
    Filter  = '*-*.ps1'
    Exclude = @(
      '*.Tests.ps1'
    )
  },
  @{
    Path    = 'public'
    Export  = $true
    Recurse = $false
    Filter  = '*-*.ps1'
    Exclude = @(
      '*.Tests.ps1'
    )
  }
);
foreach ($folder in $folders) {
  $thisDir = Join-Path -Path $PSScriptRoot -ChildPath "$($folder.Path)\*";
  $files = Get-ChildItem -Path $thisDir -Filter $folder.Filter -Exclude $folder.Exclude -Recurse:$folder.Recurse -ErrorAction Ignore;
  foreach ($file in $files) {
    try {
      . $file.FullName;
    }
    catch {
      throw;
    }
    if ($folder.Export) {
      Export-ModuleMember -Function $file.BaseName -Alias *;
    }
  }
}