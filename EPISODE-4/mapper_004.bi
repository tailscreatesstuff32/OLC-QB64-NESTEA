REM '$include: 'mapper.bi'


DIM SHARED AS _UNSIGNED _BYTE nTargetRegister, bPRGBankMode, bCHRInversion, bIRQActive, bIRQEnable

DIM SHARED AS _UNSIGNED LONG pRegister(8), pCHRBank(8), pPRGBank(4), bIRQUpdate

DIM SHARED AS _UNSIGNED INTEGER nIRQCounter, nIRQReload

REDIM SHARED vRAMStatic(0) AS _UNSIGNED _BYTE









