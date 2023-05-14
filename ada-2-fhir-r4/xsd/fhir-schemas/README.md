# Directory `YATC-public/ada-2-fhir-r4/xsd/fhir-schemas/`

This directory contains the W3C XML Schemas used in validating the `ada-2-fhir-r4` results.

Their provenance is a download from [https://hl7.org/fhir/R4/fhir-all-xsd.zip](https://hl7.org/fhir/R4/fhir-all-xsd.zip) (a link to this and more is [here](https://hl7.org/fhir/R4/downloads.html)). 

**IMPORTANT REMARK (202305)**: For some unknown reason (yet), we have to *flatten* (resolve all includes) the `bundle.xsd` schema before it is useable in an XProc validation step. It's totally unclear why, because the same validation works fine in oXygen. XProc, however, complains about multiple occurrences of the global "Bundle" component.

Flattening is easy: oXygen has a tool called "Flatten Schema…"(in the tools menu). Store the result under the same name (`bundle.xsd`) in `YATC-public/ada-2-fhir-r4/xsd/fhir-schemas/FLATTENED`.