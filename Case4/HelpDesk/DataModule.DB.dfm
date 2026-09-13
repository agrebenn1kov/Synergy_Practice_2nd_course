object DBModule: TDBModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 240
  Width = 320
  object FDConnection: TFDConnection
    LoginPrompt = False
    Left = 72
    Top = 40
  end
  object FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink
    Left = 72
    Top = 104
  end
end