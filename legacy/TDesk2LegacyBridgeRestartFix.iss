#ifndef AppVersion
  #error AppVersion must be supplied.
#endif
#ifndef VelopackSetup
  #error VelopackSetup must be supplied.
#endif

[Setup]
AppId={{0C52C4FB-C08E-4E7F-B7D3-BA7020C675C0}
AppName=TDesk2 Update Bridge
AppVersion={#AppVersion}
AppVerName=TDesk2 Update Bridge {#AppVersion}
DefaultDirName={tmp}\TDesk2VelopackBridge
DisableDirPage=yes
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=..\build\bridge
OutputBaseFilename=TDesk2-{#AppVersion}-LegacyBridge-RestartFix
Compression=none
SolidCompression=no
WizardStyle=modern
CloseApplications=yes
RestartApplications=no
CreateUninstallRegKey=no
Uninstallable=no
SetupLogging=yes

[Files]
Source: "{#VelopackSetup}"; DestDir: "{tmp}\TDesk2VelopackBridge"; DestName: "TDesk2-Velopack-Setup.exe"; Flags: deleteafterinstall

[Code]
function LegacyRoot(): String;
begin
  Result := ExpandConstant('{localappdata}\Programs\TDesk2');
end;

procedure WriteLegacyVersionMarker(const RootDir: String);
var
  VersionJson: AnsiString;
begin
  VersionJson := '{"version":"{#AppVersion}"}';
  if not SaveStringToFile(RootDir + '\build_version.json', VersionJson, False) then
    RaiseException('Nije moguće zapisati TDesk2 build_version.json.');
end;

procedure WriteLegacyMigrationSkipMarker(const RootDir: String);
var
  MarkerText: AnsiString;
begin
  MarkerText := '{#AppVersion}';
  if not SaveStringToFile(
    RootDir + '\.legacy-update-skip-migrate.once',
    MarkerText,
    False
  ) then
    RaiseException('Nije moguće zapisati TDesk2 migration bridge marker.');
end;

procedure RemoveLegacyUninstallEntry();
begin
  RegDeleteKeyIncludingSubkeys(
    HKEY_CURRENT_USER,
    'Software\Microsoft\Windows\CurrentVersion\Uninstall\{C7A53FA0-90F4-4A7F-A3C9-FF2DE2F1E6B8}_is1'
  );
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  RootDir: String;
  SetupPath: String;
  ResultCode: Integer;
begin
  if CurStep <> ssPostInstall then
    exit;

  RootDir := LegacyRoot();
  SetupPath := ExpandConstant('{tmp}\TDesk2VelopackBridge\TDesk2-Velopack-Setup.exe');

  { Velopack Setup performs an atomic replacement of the existing legacy
    installation directory and rolls back automatically if installation fails.
    User settings/credentials are stored outside this directory in AppData. }
  if not Exec(
    SetupPath,
    '--silent --installto "' + RootDir + '"',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  ) then
    RaiseException('Velopack instalaciju nije moguće pokrenuti.');

  if ResultCode <> 0 then
    RaiseException(
      'Velopack instalacija nije uspjela (kod ' + IntToStr(ResultCode) + ').'
    );

  if not FileExists(RootDir + '\Update.exe') then
    RaiseException('Velopack Update.exe nije pronađen nakon instalacije.');
  if not FileExists(RootDir + '\TDesk2.exe') then
    RaiseException('TDesk2 launcher nije pronađen nakon instalacije.');
  if not FileExists(RootDir + '\current\TDesk2.exe') then
    RaiseException('Nova TDesk2 aplikacija nije pronađena nakon instalacije.');

  { The pre-Velopack updater verifies build_version.json and then invokes
    --maintenance-migrate. This one-shot marker makes only that automatic
    callback a no-op; normal administrator migrations keep working. }
  WriteLegacyVersionMarker(RootDir);
  WriteLegacyMigrationSkipMarker(RootDir);
  RemoveLegacyUninstallEntry();

  { The pre-Velopack updater restarts the old flat executable and then checks
    that exact process handle. Velopack's stable root launcher intentionally
    exits after handing control to current\TDesk2.exe, so the legacy updater
    can misclassify a successful hand-off as an early exit. Start the real
    current executable here. The legacy updater later detects TDesk2.exe
    already running and skips its duplicate restart. }
  if not Exec(
    RootDir + '\current\TDesk2.exe',
    '',
    RootDir + '\current',
    SW_SHOWNORMAL,
    ewNoWait,
    ResultCode
  ) then
    RaiseException('Nova TDesk2 aplikacija nije pokrenuta nakon migracije.');
end;
