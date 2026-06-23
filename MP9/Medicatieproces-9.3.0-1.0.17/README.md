# Nictiz distribution MP9-Medicatieproces-9.3.0 1.0.17

Distribution: MP9-Medicatieproces-9.3.0

Version: 1.0.17, gebaseerd op MP9 3.0.0-rc.2

Wijzigingen tov distributie 1.0.16
- MP-2104. Update the intermediate ada results to new datasetstructure with MBHid in MP building blocks
- MP-2219. Fix for MTD/toediener/zorgaanbieder. This will now be a PractitionerRole in FHIR
- MP-2223. Update uuid generation to better randomize to avoid duplicates in large files
- MP-2255. Fix for when an empty input address results in invalid FHIR
- MP-2272. ada-2-fhir-r4 mp 9.3.0. Make the XSLT more robust for when there is bullocks UCUM input. It now no longer fails with hard error, but falls back on gargage in - garbage out.
- MP-2273. Fix for Static error in {(farmaceutisch_product} in pattern in xsl:template/@match on line 243 column 52 of mp-handle-bouwstenen.xsl: XTSE0340: Parentheses are not allowed in an XSLT 2.0 pattern
- MP-2274. ada-2-fhir-r4, fix for multiple itemCodeableConcept in ingredient, this is not allowed. Repeat is now in underlying coding.

Created: 2026-06-23 10:45:14

This distribution was created by the YATC distribute component.

