# Nictiz distribution MP9-Medicatieproces-9.3.0 1.0.18

Distribution: MP9-Medicatieproces-9.3.0

Version: 1.0.18, gebaseerd op MP9 3.0.0-rc.2 en rc.3

Wijzigingen tov distributie 1.0.17
- MP-2124. hl7-2-ada 6.12. hl7-2-ada 6.12. Decision logic:
  - If @root starts with 1.3.6.1.4.1.58606.1.3., remove this prefix. For @extension, retain only the part before the !. This is based on a 6.12 prescription originating from an MP9 EVS, and TA/relatieMA must contain the actual MP9 MA ID.
  - Otherwise, use concat('1.3.6.1.4.1.58606.1.5.', @root) and retain @extension unchanged. This is based on a 6.12 prescription originating from a 6.12 EVS. TA/relatieMA must contain an MP9 MA ID that the EVS will create during migration.
- MP-2280
  - hl7-2-ada. MP 612. An error is logged when no patient in input instead of silently continuing.
  - ada-2-fhir-r4. MP9 3.0. A runtime error is avoided when there is no patient in input. An error is logged instead.
- MP-2288. When the G-standard unit is missing, the UCUM unit is now used as a fallback. The XSLT has been improved by giving preference to the original UCUM and it's translations where available.
- MP-2299. Fix in XSLT so that repeat period cyclic schedule is outputted also when the rest of the administration schedule is contained within an adaextension (the FHIRTiming). 
- MP-2308. Applied generic XSLT-templates fhir-2-ada-r4 for:
  - MGB/reden_wijzigen_of_stoppen_gebruik
  - MGB/gebruiksperiode/tijdsduur
  - MGB/volgens_afspraak_indicator
  - MVE/MBHid
  - MVE/verbruiksduur
  - MVE/verstrekte_hoeveelheid
  - MVE/aanschrijf_datum
  - MVE/medicatieverstrekkings_datum_tijd
  - MA/relatieMGB
  - MA/medicatieafspraak_stop_type

Created: 2026-08-27 17:36:23

This distribution was created by the YATC distribute component.

