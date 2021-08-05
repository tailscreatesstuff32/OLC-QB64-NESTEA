
'$include: 'mapper.bm'



SUB mapper_002 (prg_banks AS _UNSIGNED _BYTE, chr_banks AS _UNSIGNED _BYTE)
    Mapper prg_banks, chr_banks

END SUB

FUNCTION cpuMapRead (addr AS _UNSIGNED INTEGER, mapped_addr AS _UNSIGNED LONG, byte_data AS _UNSIGNED _BYTE)
    IF addr >= &H8000~% AND addr <= &HBFFF~% THEN

        mapped_addr = nPRGBankSelectLo * &H4000~% + (addr AND &H3FFF~%)
        cpuMapRead = 1
        EXIT FUNCTION
    END IF

    IF addr >= &HC000~% AND addr <= &HFFFF~% THEN

        mapped_addr = nPRGBankSelectHi * &H4000~% + (addr AND &H3FFF~%)

        cpuMapRead = 1
        EXIT FUNCTION
    END IF

    cpuMapRead = 0

END FUNCTION


FUNCTION cpuMapWrite (addr AS _UNSIGNED INTEGER, mapped_addr AS _UNSIGNED LONG, byte_data AS _UNSIGNED _BYTE)


    IF addr >= &H8000~% AND addr <= &HFFFF~% THEN

        nPRGBankSelectLo = byte_data AND &H0F

    END IF
    cpuMapWrite = 0



END FUNCTION


FUNCTION ppuMapRead (addr AS _UNSIGNED INTEGER, mapped_addr AS _UNSIGNED LONG)

    IF addr < &H2000~% THEN

        mapped_addr = addr

        ppuMapRead = 1
    ELSE
        ppuMapRead = 0
    END IF


END FUNCTION


FUNCTION ppuMapWrite (addr AS _UNSIGNED INTEGER, mapped_addr AS _UNSIGNED LONG)


    IF addr < &H2000~% THEN
        IF n_CHRbanks = 0 THEN

            ' Treat as RAM
            mapped_addr = addr
            ppuMapWrite = 1
            EXIT FUNCTION
        END IF


    END IF
    ppuMapWrite = 0



END FUNCTION

SUB Mapper_002_Reset ()

    nPRGBankSelectLo = 0
    nPRGBankSelectHi = n_PRGbanks - 1

END SUB
