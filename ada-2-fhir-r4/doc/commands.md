# `YATC-public/ada-2-fhir-r4` available commands

This documents the available commands for the `YATC-public/ada-2-fhir-r4` component. These commands reside in the `YATC-public/ada-2-fhir-r4/bin` subdirectory.

It is recommended that the `YATC-shared/bin` subdirectory is on the system's path. This makes sure the base command `yatc` works.

All commands have a `-help` flag that provides a brief explanation of the command.

----------

## Command `ada-2-fhir-r4`

Performs the specified `ada-2-fhir-r4` processing for the application(s) and version(s) specified. For instance for application/version `lab`/`3.0.0`. 

Command line options:

* **`-list [application] [version]`**<br/>Lists the application/version combinations available. To get all versions/applications, use either `#all`  or leave the argument(s) empty.

* **`-actionlist [application] [version]`**<br/>Lists all actions available for the specified appliction/version. To get the actions for all versions/applications, use either `#all` or leave the argument(s) empty.


* **`[-nsetup] [-action:…] application version`**<br/>Perform `ada-2-fhir-r4` processing as specified.  To do this for all applications/versions, use `#all`.<br/>If no specific action is specified (no `-action:…` flag), the default action is performed (if any).
  * `-nosetup` Do *not* run the setup phase of the processing (setting up directories by copying data). Useful probably while developing the actions and you already know the setup is OK. 
  * `-action:…` performs the specified action(s). To specify multiple actions, separate them with a `+` sign (for instance `-action:ac1+ac2`). 

Examples:

* `yatc ada-2-fhir-r4 -list`<br/>Lists the available application/version combinations for the `ada-2-fhir-r4` command.
* `yatc ada-2-fhir-r4 -actionlist lab 3.0.0`<br/>Lists the actions available for application/version `lab`/`3.0.0`.
* `yatc ada-2-fhir-r4 -setup lab 3.0.0`<br/>First performs the setup for application/version `lab`/`3.0.0` and then processes its default action (if any).
* `yatc ada-2-fhir-r4 -action:validate lab 3.0.0`<br/>Processes the action called `validate` for application/version `lab`/`3.0.0`.

The `ada-2-fhir-r4` process is governed by the component's `data/ada-2-fhir-r4-data.xml` document. See [here](data-format-reference.md) for documentation.

### Parameter usage:

See [here](../../../YATC-shared/doc/parameters-system.md) for general information on parameters.

| Parameter | Base definition in | Data type | Usage | 
| ----- | ----- | ----- | ------ |
| `ada2fhirr4BaseStorageDirectory`  | `YATC-public/ada-2-fhir-r4/data/parameters.xml` | URI | The base location for storing the results of any `ada-2-fhir-r4` processing. |
| `ada2fhirr4DataDocument` | `YATC-public/ada-2-fhir-r4/data/parameters.xml` | URI | The document with the information what needs to be done for a certain application/version. Usually points to `YATC-public/ada-2-fhir-r4/data/ada-2-fhir-r4-data.xml`. | 

----------

## Command `compare-ada-2-fhir-r4`

Compares the outcome of the `ada-2-fhir-r4` command with he ones produced by the original [HL7-mappings](https://github.com/Nictiz/HL7-mappings) repository Ant scripts.

Command line options:
* **`application version [-nodirs]`**<br/>Compare the production documents for an application/version. To get all versions/applications, use either `#all` or leave the argument empty.<br/>If you specify the `-nodirs` option, full directory compares are disabled (only compares any specifiedt documents). This can save time during development in some cases.<br/>Examples:
    * `yatc compare-ada-2-fhir-r4 lab 3.0.0`<br/>Compares the results for the given application/version.

## How to use

* Get a copy/clone of the *original* [HL7-mappings](https://github.com/Nictiz/HL7-mappings) repository and use the *original* Ant scripts to get and build the data you want to compare. Don't forget to run the scripts in the Nictiz internal `production-ada-instances` and (if applicable) `adarefs2ada` for the application/version you want to compare *first*.
* Add the location of this repository on your disk to your local parameters override file in `{yatc-base-directory}/data/parameters.xml`. This looks like this:

```xml
        <parameters xmlns="https://nictiz.nl/ns/YATC-shared">
            <parameter name="HL7MappingsRepoForComparisonsBaseDirectory">
                <value>file:///C:/…/HL7-mappings</value>
            </parameter>
        </parameters>
```

* Get the data in again using the `yatc ada-2-fhir-r4` command. For instance:  `yatc ada-2-fhir-r4 lab 3.0.0`<br/>Of course, make sure the output of this command doesn’t go to the same location as the Ant one.
* Run the compare command. For instance: `yatc compare-ada-2-fhir-r4 lab 3.0.0`
* Examine the output for `differences="true"` attributes (probably wise to redirect the output to a file and use an editor).

**Important**: This command does a document-by-document comparison, but, for each document, stops on the first difference found. So if the command reports differences, it's probably a good idea to load the files in a *real*  XML diff application (there's one in oXygen) and examine what's going on in detail.


## Parameter usage

This command is built on top of the functionality of `ada-2-fhir-r4`. All settings and parameters for `ada-2-fhir-r4` also apply here.

| Parameter | Base definition in | Data type | Usage | 
| ----- | ----- | ----- | ------ |
| `HL7MappingsRepoForComparisonsBaseDirectory` | `YATC-shared/data/parameters.xml` (empty definition) | URI | Base location of the [HL7-mappings](https://github.com/Nictiz/HL7-mappings) repository (used for comparisons) on your machine.  See below.|

The `HL7MappingsRepoForComparisonsBaseDirectory` parameter is defined *as empty* in `YATC-shared/data/parameters.xml` (only to document that this parameter is there). The idea is to set its value in your local `{yatc-base-directory}/data/parameters.xml` document, and point it from there to the correct location.
