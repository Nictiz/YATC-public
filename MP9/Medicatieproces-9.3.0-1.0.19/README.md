# Nictiz distribution MP9-Medicatieproces-9.3.0 1.0.19

Distribution: MP9-Medicatieproces-9.3.0

Version: 1.0.19, gebaseerd op MP9 3.0.0-rc.2 en rc.3

Wijzigingen tov distributie 1.0.18
* MP-2304. If the dispense location reference cannot be found in the Bundle, an error is logged and, if available, the reference’s display text is used as a fallback.
* MP-2394. This concerns transforming 6.12 dispenses into an MP9 TA, specifically the prescriptionId into the TA/relatieMA. The XSLT was updated so that, for @extension, only everything before the last exclamation mark is retained.
* MP-2426. When encountering an OID with leading zeros, the XSLT transformation no longer terminates fatally. However, it still logs an error.

Created: 2026-10-14 11:00:59

This distribution was created by the YATC distribute component.

