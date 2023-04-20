# Component documentation `YATC-public/ada-2-fhir-r4`

The `YATC-public/ada-2-fhir-r4` performs the necessary processing for `ada-2-fhir-r4`, given an application and version. 

Remark: a `{$parametername}`  in the paths/descriptions below means that the value of the YATC parameter `parametername` is substituted here. See [here](../../../YATC-shared/doc/parameters-system.md) for more information about YATC parameters in general.

----

## Basics

* Main driver for the operation of this component is the datafile `data/ada-2-fhir-r4-data.xml`. This tells the component what to do to retrieve the right ADA documents. See  its [documentation](data-format-reference.md) for more information.
* This component is meant to be used stand-alone from the command line. See "Command-line usage summary" below or consult [command.md](commands.md).
* `ada-2-fhir-r4` processing has two parts:
  * **setup**: The setup part copies data to local directories. The source for this is what is produced by the (internal) `get-production-ada-instances` component. (either direct from ART-DECOR or created by the adarefs2ada processing).<br/>Since this data source is *internal* (available only for Nictiz employees), this part of the `ada-2-fhir-r4` processing is optional (`-setup` command flag).
  * **actions**: The `ada-2-fhir-r4` processing for an application/version can consist of separate parts. These parts are called *actions*. An action has a name you define yourself, for instance be `create-fhir-instances` or `validate-with-schema`. 
    * Actions themselves consist of XSLT transformations, performed on individual or sets of files. 
    * An action can depend on other actions to be performed first. This can be specified and the actions will be processed in the correct order.
* All results will usually be stored in `{$ada2fhirr4BaseStorageDirectory}/{application}/{version}/{usecase}/`.

### Command-line usage summary

If everything is installed correctly, the following commands should work:

* `yatc ada-2-fhir-r4 -help`<br/>Gives information on the command line options for `ada-2-fhir-r4`.
* `yatc ada-2-fhir-r4 -list`<br/>Lists all the applications and versions availaible for ada-2-fhir-r4.
* `yatc ada-2-fhir-r4 lab 3.0.0`<br/>Perform the default action for application `lab` version `3.0.0`. 

----

## Algorithm outline

The algorithm followed by the component is outlined below. The main code is in `../xpl/ada-2-fhir-r4.xpl`.

* The datafile is loaded from disk (by `xplmod/ada-2-fhir-r4.mod.xpl`):
  * Any XIncludes are resolved
  * The result is validated against the schema for the datafile in `xsd/ada-2-fhir-r4-data.xsd` and the Schematron schema in `sch/ada-2-fhir-r4-data.sch`. 
  * The resulting document is pruned so only the information for the requested application(s) and version(s) is left.  
  * The data file is post-processed (by `xplmod/xsl-ada-2-fhir-r4.mod/finalize-ada-2-fhir-r4-data.xsl`). This expands all directory and document names, performs the tricks on directory references by identifier, etc. 
* All application/version combinations left in the pruned datafile are processed:
  * If the `-setup` command line option is given, the `<setup>` elements are processed. Files produced by `get-production-ada-instances` are copied to the appropriate locations for ada-2-fhir-r4 processing.
  * The `<build>` elements inside the specified `<action>` elements are processed.
