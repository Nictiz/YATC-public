# Nictiz distribution MP9-Medicatieproces-9.3.0 1.0.16

Distribution: MP9-Medicatieproces-9.3.0

Version: 1.0.16, gebaseerd op MP9 3.0.0-rc.2

Wijzigingen tov distributie 1.0.15
- MP-2192. Add support for translating MP 6.12 verstrekkingen to MP9 Medicatieverstrekking as well. Use parameter "outputMP9Bouwstenen" to influence the output.
- MP-1993. mp-InstructionsForUse.xsl kijkt of het dosering element bestaat, maar onterecht niet of deze ook gevuld is. Dit is hersteld.
- MP-2018. Medicatieverstrekking/verbruiksperiode werd niet goed geconverteerd. Dit is hersteld.
- MP-2027. De ada-2-hl7 voor adresgegevens is verbeterd bij zib2017 implementatie (MP 9.0.7 en MP 6.12). Met name voor de al dan niet gecodeerde versies van postcode, gemeente en woonplaats. Als bijvangst ook kleine verbeteringen bij huisnummer.
- MP-2045. Bij meerdere zo nodig criteria plaatste de XSLT's voor ada-2-fhir deze alle in asNeeded, maar in FHIR is dat helaas ingeperkt tot 0..1, daarom is er een extensie voor wanneer er meer dan 1 zijn. 
Dit is aangepast in ada-2-fhir-r4 (mp-InstructionsForUse.xsl) en ook in fhir-2-ada-r4.

Created: 2026-04-29 11:02:11

This distribution was created by the YATC distribute component.

