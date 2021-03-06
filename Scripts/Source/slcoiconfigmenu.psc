scriptname SLCoiConfigMenu extends SKI_ConfigBase hidden

; TODO: add collapsable menus

SLCoiSystem property System auto

; CONSTS
int TOP_LEFT = 0
int TOP_RIGHT = 1
int BOTTOM_LEFT = 63

string COLOR_RED = "#AA5555"
string COLOR_GREEN = "#55AA55"

; OIDs
int oidStatusActive = -1

int oidSettingsNPCInfections = -1

int oidSettingsInfectionTypeLycanthropySelection = -1
int oidSettingsInfectionTypeVampirismSelection = -1
int oidSettingsInfectionTypeSuccubusCurseSelection = -1

int oidSettingsInfectionTypeLycanthropyEnabled = -1
int oidSettingsInfectionTypeVampirismEnabled = -1
int oidSettingsInfectionTypeSuccubusCurseEnabled = -1

int oidSettingsInfectionCauseVaginal = -1
int oidSettingsInfectionCauseAnal = -1
int oidSettingsInfectionCauseOral = -1

int oidSettingsInfectionLycanthropyProbabilityPC = -1
int oidSettingsInfectionLycanthropyProbabilityNPC = -1
int oidSettingsInfectionVampirismProbabilityPC = -1
int oidSettingsInfectionVampirismProbabilityNPC = -1
int oidSettingsInfectionSuccubusCurseProbabilityPC = -1
int oidSettingsInfectionSuccubusCurseProbabilityNPC = -1

int oidSettingsPSQNPCInfectionProbability = -1

int oidSettingsInfectionTypeLiceEnabled = -1
int oidSettingsInfectionLiceProbabilityPC = -1
int oidSettingsInfectionLiceProbabilityNPC = -1
int oidSettingsInfectionLiceSeverityIncrease = -1
int oidSettingsInfectionLiceUnnervingThreshold = -1
int oidSettingsInfectionLiceSevereThreshold = -1
int oidSettingsInfectionLiceMildDebuff = -1
int oidSettingsInfectionLiceUnnervingDebuff = -1
int oidSettingsInfectionLiceSevereDebuff = -1
int oidSettingsInfectionLiceFakeNPCProbability = -1

int oidMiscDebug = -1

int oidMiscCure = -1

int oidMiscImport = -1
int oidMiscExport = -1

; Version
int function GetVersion()
  return 2
endFunction

; SkyUI MCM Events
event OnConfigInit()
endEvent

event OnConfigRegister()
endEvent

event OnVersionUpdate(int version)
  if(version > CurrentVersion)
    System.DebugMessage("New version")
  endIf
endEvent

event OnPageReset(string a_page) ; if mod not active, show message instead of page
  if((a_page != "$PageStatus" || a_page != "") && !System.OptActive)
    ShowMessage("$ModIsNotActivated")

    SetupPageStatus()
    return
  endIf

  if(a_page == "$PageStatus" || a_page == "")
    SetupPageStatus()
  endIf

  If(a_page == "$PageSettings")
    SetupPageSettings()

  elseIf(a_page == "$PageMisc")
    SetupPageMisc()

  endIf
endEvent

event OnOptionHighlight(int option)
  if(option == oidSettingsInfectionTypeSuccubusCurseEnabled)
    SetInfoText("$SettingsInfectionTypeSuccubusCurseHint")

  elseIf(option == oidSettingsPSQNPCInfectionProbability                      \
  ||    option == oidSettingsInfectionLiceFakeNPCProbability)
    SetInfoText("$SettingsFakeNPCInfectionProbabilityHint")

  elseIf(option == oidSettingsNPCInfections)
    SetInfoText("$SettingsNPCInfectionsHint")

  elseIf(option == oidSettingsInfectionLiceMildDebuff                         \
  ||    option == oidSettingsInfectionLiceUnnervingDebuff                     \
  ||    option == oidSettingsInfectionLiceSevereDebuff)
    SetInfoText("$SettingsSTDLiceDebuffHint")

  elseIf(option == oidSettingsInfectionLiceSeverityIncrease)
    SetInfoText("$SettingsSTDLiceSeverityIncreasePerHourHint")

  endIf
endEvent

event OnOptionSelect(int option)
  if(option == oidStatusActive)
    System.OptActive = !System.OptActive

  elseIf(option == oidSettingsNPCInfections)
    System.OptNPCInfections = !System.OptNPCInfections

  ; Infection Activation
  elseIf(option == oidSettingsInfectionTypeLycanthropyEnabled)
    System.Infections.Lycanthropy.Enabled = !System.Infections.Lycanthropy.Enabled

  elseIf(option == oidSettingsInfectionTypeVampirismEnabled)
    System.Infections.Vampirism.Enabled = !System.Infections.Vampirism.Enabled

  elseIf(option == oidSettingsInfectionTypeSuccubusCurseEnabled)
    System.Infections.SuccubusCurse.Enabled = !System.Infections.SuccubusCurse.Enabled

  elseIf(option == oidSettingsInfectionTypeLiceEnabled)
    System.Infections.Lice.Enabled = !System.Infections.Lice.Enabled

  ; Infeciton Causes
  elseIf(option == oidSettingsInfectionCauseVaginal)
    System.OptInfectionCause =                                                \
      Math.LogicalOr(System.OptInfectionCause, System.InfectionCauseVaginal)

  elseIf(option == oidSettingsInfectionCauseAnal)
    System.OptInfectionCause =                                                \
      Math.LogicalOr(System.OptInfectionCause, System.InfectionCauseAnal)

  elseIf(option == oidSettingsInfectionCauseOral)
    System.OptInfectionCause =                                                \
      Math.LogicalOr(System.OptInfectionCause, System.InfectionCauseOral)

  ; DebugMessage
  elseIf(option == oidMiscDebug)
    System.OptDebug = !System.OptDebug

  ; Cure
  elseIf(option == oidMiscCure)
    if(System.Infections.Player)
      ShowMessage("$MiscCureMessage")

      System.CureInfection(System.PlayerRef)
    endIf

  ; Import / Export
  elseIf(option == oidMiscImport)
    System.SettingsImport()
    ShowMessage("$MessageDone")

  elseIf(option == oidMiscExport)
    System.SettingsExport()
    ShowMessage("$MessageDone")

  else
    return

  endIf

  ForcePageReset()
endEvent

event OnOptionSliderOpen(int option)
  ; PSQ
  if(option == oidSettingsPSQNPCInfectionProbability)
    ; simply use the same values as above, no need for further consts
    SetSliderDialogStartValue(System.Infections.PSQ_SuccubusCurse.NonPlayerFakeInfectionProbability)
    SetSliderDialogDefaultValue(System.Infections.PSQ_SuccubusCurse.DefaultNonPlayerFakeInfectionProbability)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  ; Lycanthropy
  elseIf(option == oidSettingsInfectionLycanthropyProbabilityPC)
    SetSliderDialogStartValue(System.Infections.Lycanthropy.PlayerProbability)
    SetSliderDialogDefaultValue(System.Infections.Lycanthropy.PlayerProbabilityDefault)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  elseIf(option == oidSettingsInfectionLycanthropyProbabilityNPC)
    SetSliderDialogStartValue(System.Infections.Lycanthropy.NonPlayerProbability)
    SetSliderDialogDefaultValue(System.Infections.Lycanthropy.NonPlayerProbabilityDefault)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  ; Vampirism
  elseIf(option == oidSettingsInfectionVampirismProbabilityPC)
    SetSliderDialogStartValue(System.Infections.Vampirism.PlayerProbability)
    SetSliderDialogDefaultValue(System.Infections.Vampirism.PlayerProbabilityDefault)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  elseIf(option == oidSettingsInfectionVampirismProbabilityNPC)
    SetSliderDialogStartValue(System.Infections.Vampirism.NonPlayerProbability)
    SetSliderDialogDefaultValue(System.Infections.Vampirism.NonPlayerProbabilityDefault)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  ; Succubus Curse
  elseIf(option == oidSettingsInfectionSuccubusCurseProbabilityPC)
    SetSliderDialogStartValue(System.Infections.SuccubusCurse.PlayerProbability)
    SetSliderDialogDefaultValue(System.Infections.SuccubusCurse.PlayerProbabilityDefault)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  elseIf(option == oidSettingsInfectionSuccubusCurseProbabilityNPC)
    SetSliderDialogStartValue(System.Infections.SuccubusCurse.NonPlayerProbability)
    SetSliderDialogDefaultValue(System.Infections.SuccubusCurse.NonPlayerProbabilityDefault)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  ; Lice
  elseIf(option == oidSettingsInfectionLiceProbabilityPC)
    SetSliderDialogStartValue(System.Infections.Lice.PlayerProbability)
    SetSliderDialogDefaultValue(System.Infections.Lice.PlayerProbabilityDefault)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  elseIf(option == oidSettingsInfectionLiceProbabilityNPC)
    SetSliderDialogStartValue(System.Infections.Lice.NonPlayerProbability)
    SetSliderDialogDefaultValue(System.Infections.Lice.NonPlayerProbabilityDefault)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  elseIf(option == oidSettingsInfectionLiceSeverityIncrease)
    SetSliderDialogStartValue(System.Infections.Lice.SeverityIncreasePerHour)
    SetSliderDialogDefaultValue(System.Infections.Lice.DefaultSeverityIncreasePerHour)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  elseIf(option == oidSettingsInfectionLiceUnnervingThreshold)
    SetSliderDialogStartValue(System.Infections.Lice.UnnervingThreshold)
    SetSliderDialogDefaultValue(System.Infections.Lice.DefaultUnnervingThreshold)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.1, 1.0)

  elseIf(option == oidSettingsInfectionLiceSevereThreshold)
    SetSliderDialogStartValue(System.Infections.Lice.SevereThreshold)
    SetSliderDialogDefaultValue(System.Infections.Lice.DefaultSevereThreshold)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.2, 1.0)

  elseIf(option == oidSettingsInfectionLiceMildDebuff)
    SetSliderDialogStartValue(System.Infections.Lice.MildRegenDebuff)
    SetSliderDialogDefaultValue(System.Infections.Lice.DefaultMildRegenDebuff)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  elseIf(option == oidSettingsInfectionLiceUnnervingDebuff)
    SetSliderDialogStartValue(System.Infections.Lice.UnnervingRegenDebuff)
    SetSliderDialogDefaultValue(System.Infections.Lice.DefaultUnnervingRegenDebuff)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  elseIf(option == oidSettingsInfectionLiceSevereDebuff)
    SetSliderDialogStartValue(System.Infections.Lice.SevereRegenDebuff)
    SetSliderDialogDefaultValue(System.Infections.Lice.DefaultSevereRegenDebuff)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  elseIf(option == oidSettingsInfectionLiceFakeNPCProbability)
    SetSliderDialogStartValue(System.Infections.Lice.NonPlayerFakeInfectionProbability)
    SetSliderDialogDefaultValue(System.Infections.Lice.DefaultNonPlayerFakeInfectionProbability)
    SetSliderDialogInterval(0.01)
    SetSliderDialogRange(0.0, 1.0)

  endIf
endEvent

event OnOptionSliderAccept(int option, float value)
  if(option == oidSettingsPSQNPCInfectionProbability)
    System.Infections.PSQ_SuccubusCurse.NonPlayerFakeInfectionProbability = value

  elseIf(option == oidSettingsInfectionLycanthropyProbabilityPC)
    System.Infections.Lycanthropy.PlayerProbability = value

  elseIf(option == oidSettingsInfectionLycanthropyProbabilityNPC)
    System.Infections.Lycanthropy.NonPlayerProbability = value

  elseIf(option == oidSettingsInfectionVampirismProbabilityPC)
    System.Infections.Vampirism.PlayerProbability = value

  elseIf(option == oidSettingsInfectionVampirismProbabilityNPC)
    System.Infections.Vampirism.NonPlayerProbability = value

  elseIf(option == oidSettingsInfectionSuccubusCurseProbabilityPC)
    System.Infections.SuccubusCurse.PlayerProbability = value

  elseIf(option == oidSettingsInfectionSuccubusCurseProbabilityNPC)
    System.Infections.SuccubusCurse.NonPlayerProbability = value

  elseIf(option == oidSettingsInfectionLiceProbabilityPC)
    System.Infections.Lice.PlayerProbability = value

  elseIf(option == oidSettingsInfectionLiceProbabilityNPC)
    System.Infections.Lice.NonPlayerProbability = value

  elseIf(option == oidSettingsInfectionLiceSeverityIncrease)
    System.Infections.Lice.SeverityIncreasePerHour = value

  elseIf(option == oidSettingsInfectionLiceUnnervingThreshold)
    System.Infections.Lice.UnnervingThreshold = value

  elseIf(option == oidSettingsInfectionLiceSevereThreshold)
    System.Infections.Lice.SevereThreshold = value

  elseIf(option == oidSettingsInfectionLiceMildDebuff)
    System.Infections.Lice.MildRegenDebuff = value

  elseIf(option == oidSettingsInfectionLiceUnnervingDebuff)
    System.Infections.Lice.UnnervingRegenDebuff = value

  elseIf(option == oidSettingsInfectionLiceSevereDebuff)
    System.Infections.Lice.SevereRegenDebuff = value

  elseIf(option == oidSettingsInfectionLiceFakeNPCProbability)
    System.Infections.Lice.NonPlayerFakeInfectionProbability = value

  endIf

  ForcePageReset()
endEvent

event OnOptionMenuOpen(int option)
  if(option == oidSettingsInfectionTypeLycanthropySelection)
    string[] itemsLycanthropy = new string[2]
    int startIndexLycanthropy = 0

    itemsLycanthropy[0] = System.Infections.DefaultLycanthropy.GetName()
    itemsLycanthropy[1] = System.Infections.MT_Lycanthropy.GetName()

    if(itemsLycanthropy[1] == System.Infections.Lycanthropy.GetName())
      startIndexLycanthropy = 1
    endIf

    SetMenuDialogDefaultIndex(0)
    SetMenuDialogStartIndex(startIndexLycanthropy)
    SetMenuDialogOptions(itemsLycanthropy)

  elseIf(option == oidSettingsInfectionTypeVampirismSelection)
    string[] itemsVampirism = new string[1]
    int startIndex = 0

    itemsVampirism[0] = System.Infections.DefaultVampirism.GetName()

    SetMenuDialogDefaultIndex(0)
    SetMenuDialogStartIndex(0)
    SetMenuDialogOptions(itemsVampirism)

  elseIf(option == oidSettingsInfectionTypeSuccubusCurseSelection)
    string[] itemsSuccubusCurse = new string[2]
    int startIndexSuccubusCurse = 0

    itemsSuccubusCurse[0] = System.Infections.DefaultSuccubusCurse.GetName()
    itemsSuccubusCurse[1] = System.Infections.PSQ_SuccubusCurse.GetName()

    if(itemsSuccubusCurse[1] == System.Infections.SuccubusCurse.GetName())
      startIndexSuccubusCurse = 1
    endIf

    SetMenuDialogDefaultIndex(0)
    SetMenuDialogStartIndex(startIndexSuccubusCurse)
    SetMenuDialogOptions(itemsSuccubusCurse)
  endIf
endEvent

event OnOptionMenuAccept(int option, int index)
  if(option == oidSettingsInfectionTypeLycanthropySelection)
    if(index == 0)
      System.Infections.SetLycanthropy(System.Infections.DefaultLycanthropy)
    elseIf(index == 1)
      System.Infections.SetLycanthropy(System.Infections.MT_Lycanthropy)
    endIf

  elseIf(option == oidSettingsInfectionTypeVampirismSelection)
    ; Nothing To Do

  elseIf(option == oidSettingsInfectionTypeSuccubusCurseSelection)
    if(index == 0)
      System.Infections.SetSuccubusCurse(System.Infections.DefaultSuccubusCurse)
    elseIf(index == 1)
      System.Infections.SetSuccubusCurse(System.Infections.PSQ_SuccubusCurse)
    endIf

  endIf

  ForcePageReset()
endEvent

; Pages
function SetupPageStatus()
  SetCursorFillMode(TOP_TO_BOTTOM)
  SetCursorPosition(TOP_LEFT)

  oidStatusActive =                                                           \
    AddTextOption(                                                            \
      "$StatusMod",                                                           \
      SexLabUtil.StringIfElse(System.OptActive,                               \
          ColoredText("$StatusActive", COLOR_GREEN),                          \
          ColoredText("$StatusInactive", COLOR_RED)                           \
      )                                                                       \
    )

endFunction

function SetupPageSettings()
  SetCursorFillMode(TOP_TO_BOTTOM)
  SetCursorPosition(TOP_LEFT)

  ; General
  oidSettingsNPCInfections =                                                  \
    AddToggleOption(                                                          \
      "$SettingsNPCInfections",                                               \
      System.OptNPCInfections,                                                \
      OPTION_FLAG_DISABLED                                                    \
    )

  ; Infection: Lycanthropy
  AddEmptyOption()
  AddHeaderOption("$SettingsInfectionTypeLycanthropy")

  oidSettingsInfectionTypeLycanthropyEnabled =                                \
    AddTextOption(                                                            \
      "$SettingsInfectionEnabled",                                            \
      System.Infections.Lycanthropy.Enabled)

  oidSettingsInfectionTypeLycanthropySelection =                              \
    AddMenuOption(                                                            \
      "$SettingsInfectionSelection",                                          \
      System.Infections.Lycanthropy.GetName())

  oidSettingsInfectionLycanthropyProbabilityPC =                              \
    AddSliderOption(                                                          \
      "$SettingsInfectionProbabilityPC",                                      \
      System.Infections.Lycanthropy.PlayerProbability,                        \
      "$SettingsInfectionProbabilityFormat")

  oidSettingsInfectionLycanthropyProbabilityNPC =                             \
    AddSliderOption(                                                          \
      "$SettingsInfectionProbabilityNPC",                                     \
      System.Infections.Lycanthropy.NonPlayerProbability,                     \
      "$SettingsInfectionProbabilityFormat")

  ; Infection: Vampirism
  AddEmptyOption()
  AddHeaderOption("$SettingsInfectionTypeVampirism")

  oidSettingsInfectionTypeVampirismEnabled =                                  \
    AddTextOption(                                                            \
      "$SettingsInfectionEnabled",                                            \
      System.Infections.Vampirism.Enabled)

  oidSettingsInfectionTypeVampirismSelection =                                \
    AddMenuOption(                                                            \
      "$SettingsInfectionSelection",                                          \
      System.Infections.Vampirism.GetName())

  oidSettingsInfectionVampirismProbabilityPC =                                \
    AddSliderOption(                                                          \
      "$SettingsInfectionProbabilityPC",                                      \
      System.Infections.Vampirism.PlayerProbability,                          \
      "$SettingsInfectionProbabilityFormat")

  oidSettingsInfectionVampirismProbabilityNPC =                               \
    AddSliderOption(                                                          \
      "$SettingsInfectionProbabilityNPC",                                     \
      System.Infections.Vampirism.NonPlayerProbability,                       \
      "$SettingsInfectionProbabilityFormat")

  ; Infection: Succubus Curse
  AddEmptyOption()
  AddHeaderOption("$SettingsInfectionTypeSuccubusCurse")

  oidSettingsInfectionTypeSuccubusCurseEnabled =                              \
    AddTextOption(                                                            \
      "$SettingsInfectionEnabled",                                            \
      System.Infections.SuccubusCurse.Enabled)

  oidSettingsInfectionTypeSuccubusCurseSelection =                            \
    AddMenuOption(                                                            \
      "$SettingsInfectionSelection",                                          \
      System.Infections.SuccubusCurse.GetName())

  oidSettingsInfectionSuccubusCurseProbabilityPC =                            \
    AddSliderOption(                                                          \
      "$SettingsInfectionProbabilityPC",                                      \
      System.Infections.SuccubusCurse.PlayerProbability,                      \
      "$SettingsInfectionProbabilityFormat")

  oidSettingsInfectionSuccubusCurseProbabilityNPC =                           \
    AddSliderOption(                                                          \
      "$SettingsInfectionProbabilityNPC",                                     \
      System.Infections.SuccubusCurse.NonPlayerProbability,                   \
      "$SettingsInfectionProbabilityFormat")

  ; Infection: Lice (STD)
  AddEmptyOption()
  AddHeaderOption("$SLCoiSTDLice")

  oidSettingsInfectionTypeLiceEnabled =                                       \
    AddTextOption(                                                            \
      "$SettingsInfectionEnabled",                                            \
      System.Infections.Lice.Enabled)

  oidSettingsInfectionLiceProbabilityPC =                                     \
    AddSliderOption(                                                          \
      "$SettingsInfectionProbabilityPC",                                      \
      System.Infections.Lice.PlayerProbability,                               \
      "$SettingsInfectionProbabilityFormat")

  oidSettingsInfectionLiceProbabilityNPC =                                    \
    AddSliderOption(                                                          \
      "$SettingsInfectionProbabilityNPC",                                     \
      System.Infections.Lice.NonPlayerProbability,                            \
      "$SettingsInfectionProbabilityFormat")

  oidSettingsInfectionLiceSeverityIncrease =                                  \
    AddSliderOption(                                                          \
      "$SettingsSTDLiceSeverityIncreasePerHour",                              \
      System.Infections.Lice.SeverityIncreasePerHour,                         \
      "$SettingsSTDLiceSeverityIncreasePerHourFormat"                         \
    )

  oidSettingsInfectionLiceUnnervingThreshold =                                \
    AddSliderOption(                                                          \
      "$SettingsSTDLiceUnnervingThreshold",                                   \
      System.Infections.Lice.UnnervingThreshold,                              \
      "$SettingsSTDLiceThresholdFormat"                                       \
    )

  oidSettingsInfectionLiceSevereThreshold =                                   \
    AddSliderOption(                                                          \
      "$SettingsSTDLiceSevereThreshold",                                      \
      System.Infections.Lice.SevereThreshold,                                 \
      "$SettingsSTDLiceThresholdFormat"                                       \
    )

  oidSettingsInfectionLiceMildDebuff =                                        \
    AddSliderOption(                                                          \
      "$SettingsSTDLiceMildRegenDebuff",                                      \
      System.Infections.Lice.MildRegenDebuff,                                 \
      "$SettingsSTDLiceRegenDebuffFormat"                                     \
    )

  oidSettingsInfectionLiceUnnervingDebuff =                                   \
    AddSliderOption(                                                          \
      "$SettingsSTDLiceUnnervingRegenDebuff",                                 \
      System.Infections.Lice.UnnervingRegenDebuff,                            \
      "$SettingsSTDLiceRegenDebuffFormat"                                     \
    )

  oidSettingsInfectionLiceSevereDebuff =                                      \
    AddSliderOption(                                                          \
      "$SettingsSTDLiceSevereRegenDebuff",                                    \
      System.Infections.Lice.SevereRegenDebuff,                               \
      "$SettingsSTDLiceRegenDebuffFormat"                                     \
    )

  oidSettingsInfectionLiceFakeNPCProbability =                                \
    AddSliderOption(                                                          \
      "$SettingsFakeNPCInfectionProbability",                                 \
      System.Infections.Lice.NonPlayerFakeInfectionProbability,               \
      "$SettingsFakeNPCInfectionProbabilityFormat"                            \
    )

  AddEmptyOption()
  AddHeaderOption("$SettingsInfectionCauses")

  oidSettingsInfectionCauseVaginal =                                          \
    AddToggleOption(                                                          \
      "$SettingsInfectionCauseVaginal",                                       \
      Math.LogicalAnd(System.OptInfectionCause, System.InfectionCauseVaginal))

  oidSettingsInfectionCauseAnal =                                             \
    AddToggleOption(                                                          \
      "$SettingsInfectionCauseAnal",                                          \
      Math.LogicalAnd(System.OptInfectionCause, System.InfectionCauseAnal))

  oidSettingsInfectionCauseOral =                                             \
    AddToggleOption(                                                          \
      "$SettingsInfectionCauseOral",                                          \
      Math.LogicalAnd(System.OptInfectionCause, System.InfectionCauseOral))

  SetCursorPosition(TOP_RIGHT)

  if(System.Infections.PSQ_SuccubusCurse.Supported)
    AddHeaderOption("$SettingsPSQ")

    oidSettingsPSQNPCInfectionProbability = AddSliderOption(                  \
      "$SettingsFakeNPCInfectionProbability",                                 \
      System.Infections.PSQ_SuccubusCurse.NonPlayerFakeInfectionProbability,  \
      "$SettingsFakeNPCInfectionProbabilityFormat")

    AddEmptyOption()
  endIf
endFunction

function SetupPageMisc()
  SetCursorFillMode(TOP_TO_BOTTOM)
  SetCursorPosition(TOP_LEFT)

  oidMiscCure = AddTextOption("$MiscCureMe", "")

  AddEmptyOption()
  AddHeaderOption("$MiscSettings")
  oidMiscImport = AddTextOption("$MiscSettingsImport", "")
  oidMiscExport = AddTextOption("$MiscSettingsExport", "")

  SetCursorPosition(TOP_RIGHT)

  AddHeaderOption("$MiscSupport")

  AddTextOption(                                                              \
    SexLabUtil.StringIfElse(System.Infections.MT_Lycanthropy.Supported,       \
      ColoredText("$MISCSUPPORTMT", COLOR_GREEN),                             \
      ColoredText("$MISCSUPPORTMT", COLOR_RED)                                \
    ),                                                                        \
    "")

  AddTextOption(                                                              \
    SexLabUtil.StringIfElse(System.Infections.PSQ_SuccubusCurse.Supported,    \
      ColoredText("$MISCSUPPORTPSQ", COLOR_GREEN),                            \
      ColoredText("$MISCSUPPORTPSQ", COLOR_RED)                               \
    ),                                                                        \
    "")

  AddEmptyOption()
  AddEmptyOption()
  AddEmptyOption()
  AddEmptyOption()
  AddEmptyOption()
  AddEmptyOption()

  oidMiscDebug = AddToggleOption("$MiscDebug", System.OptDebug)
endFunction

; Utility
string function ColoredText(string text, string color)
  return "<font color='" + color + "'>" + text + "</font>"
endFunction
