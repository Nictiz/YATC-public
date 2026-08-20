# Nictiz distribution MP9-Medicatieproces-9.3.0 1.0.18

Distribution: MP9-Medicatieproces-9.3.0

Version: 1.0.18, gebaseerd op MP9 3.0.0-rc.2 en rc.3

Wijzigingen tov distributie 1.0.17
- MP-2124. hl7-2-ada 6.12. A prefix oid has been added in toedieningsafspraak/relatie_medicatieafspraak/identificatie
- MP-2280
  - hl7-2-ada. MP 612. An error is logged when no patient in input instead of silently continuing.
  - ada-2-fhir-r4. MP9 3.0. A runtime error is avoided when there is no patient in input. An error is logged instead.
- MP-2299. Fix in XSLT so that repeat period cyclic schedule is outputted also when the rest of the administration schedule is contained within an adaextension (the FHIRTiming). 
- MP-2308. Applied generic XSLT-templates fhir-2-ada-r4 for:
  - MGB/gebruiksperiode/tijdsduur
  - MGB/volgens_afspraak_indicator
  - MVE/MBHid
  - MVE/verbruiksduur
  - MVE/verstrekte_hoeveelheid
  - MVE/aanschrijf_datum
  - MVE/medicatieverstrekkings_datum_tijd
  - MA/relatieMGB
  - MA/medicatieafspraak_stop_type


Created: 2026-08-20 14:36:33

This distribution was created by the YATC distribute component.

