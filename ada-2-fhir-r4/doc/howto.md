# How to configure YATC-internal/ada-2-fhir-r4

This document tries to explain how to configure the ada-2-fhir-r4 component setup. It starts the journey by adding a new application. If you're altering an existing application, just skip ahead to the right section.

The following documentation might also be of interest for this:

* [Component documentation](component-documentation.md): What does this component do and how does it work, more in general.
* [Command reference](commands.md): What commands are available.
* [Application data format reference](data-format-reference.md): Reference documentation for the base data file `YATC-public/ada-2-fhir-r4/data/ada-2-fhir-r4-data.xml`.
* [The parameters system](../../../YATC-shared/doc/parameters-system.md): Some things are defined using parameters which is documented here.

And of course it is useful and sensible to see how things were done for other applications. Better stolen well than badly made up.

-----

## Adding an application to the base data file

All the magic of ada-2-fhur-r4 is defined in its base data file `YATC-public/ada-2-fhir-r4/data/ada-2-fhir-r4-data.xml`.  Important remarks about this file:

* The name/location of this file is not a given. It is defined using parameter `ada2fhirr4DataDocument` in `YATC-public/ada-2-fhir-r4/data/parameters.xml`. This can be interesting when you want to replace the normal data file with one of your own in a test/development/debug situation. For this, redefine the parameter in your local parameters override file `{$yatcBaseDirectory}/data/parameters.xml`.
* The file can, if necessary/convenient, be segmented by storing `<application>` elements in separate XML documents and include these in the main file using `<xi:include href="…"/>` elements (the namespace prefix `xi` must be bound to the XInclude namespace `http://www.w3.org/2001/XInclude`).
* There are two schemas involved validating this file. See the [Application data format reference](data-format-reference.md) for more information. Editing this file (in oXygen for instance) works best when these schemas are referenced/used. This also applies to files included using `<xi:include/>`.

To add a new application to the data file, simply add an `/ada-2-fhir-r4-data/application` element. Add the name and version of the application in its (required) `@name` and `@version` attributes. All storage will now be done underneath `{$ada2fhirr4BaseStorageDirectory}/{@application}/{@version}`.

Originally the data file was set up keeping alphabetical order using the application's name and version. Whether you want to keep it that way is up to you.

There are two important attributes on `<application>`:

* `@source-project-name` defines the name of the project in the `projects` directory tree. The default is `@name` but this is rarely correct, so you'll probably have to set it explicitly. Projects are located using parameter `projectsBaseStorageDirectory` in `YATC-shared/data/parameters.xml`
* `@source-adarefs2ada` defines where the source files for `<setup>` elements come from (default: `false`):
  * `source-adarefs2ada="false"`: The source documents are supposed to come straight from ART-DECOR. They're taken from `{$productionAdaInstancesBaseStorageDirectory}/{@name}/{@version}/{$productionAdaInstancesDataSubdir}` (parameters defined in `YATC-shared/data/parameters.xml`).
  * `source-adarefs2ada="true"`: The source documents are supposed to come from adarefs2ada post-processing. They're taken from the appropriate subdirectories of `{$adarefs2adaBaseStorageDirectory}/{@name}/{@version}/{@usecase}` (parameter defined in `YATC-shared/data/parameters.xml`).
  
  
### Setting up the environment for a usecase

A `<setup>` element (it can occur multiple times as child of `<application>`) defines what files must copied to the ada-2-fhir-r4 result location  and where. The `@usecase` attribute defines the name of the usecase for the setup. This will become the name of the subdirectory underneath the `application/version` main directory. The details are [here](data-format-reference.md#setup-element). Some hints and clues:

* You can copy ADA documents using the `<copy-data>` child element. Add `<include>` and `<exclude>` elements to filter, the string `$USECASE` in `@glob` and `@pattern` attributes is replaced with the name of the usecase.
* You can copy schemas (from the `projects` directory tree) using the `<copy-project-schemas>` child element. Add `<include>` and `<exclude>` elements to filter, the string `$USECASE` in `@glob` and `@pattern` attributes is replaced with the name of the usecase.
* The setup can also create empty result directories using the `<empty-directory>` element. Usually these directories are filled during the build (see below).<br/>Creating these directories up-front is not strictly necessary, because any non-existing directories are automatically created by the build process. However it makes senses to define them here because the `compare-ada-2-fhir-r4` command now knows there's a result directory and takes it into account. 
* Exceptionally, it is necessary to copy fixed data files, usually CSS/JavaScript and the likes. This can be done using the `<copy-directory>` element.<br/>Very often, because they're fixed/constant, the source for these files is in the code directory tree (usually somewhere underneath `ada-2-fhir-r4/data`). To refer to such a directory without resorting to absolute path names, start the `@directory` attribute with a `#`. For instance: `directory="#mp/9.0.7/…/assets"`. Such a path is relative to the location of the file it is used in.
* Even more exceptional is retrieving data files from a REST URL (usually something in ART-DECOR) during setup. This can be done using the `<retrieve>` element.

Although not required, it makes sense to define *directory identifiers* for all directories using `@directory-id` attributes. See [here](data-format-reference.md#resolving-directory-attribute) for more information. this allows referring to these directories during the build without having to repeat there names.

### Actions

The ada-2-fhir-r4 component divides the things you can do for an application into "actions". Examples of actions are: build this; validate the results, etc.

* An action is defined by an `application/action` element. It has a required `@name` attribute that holds the name/identifier of the action.
* You can designate one action as the default action by adding a `default="true"` attribute.
* Actions can depend on other action: Add an `@depends-on` attribute with a whitespace separated list of actions that *must* be performed before this one.
* You can add a `@description` attribute with a short description of the action.
* Child elements of `<action>` describe what the action needs to do (build something, validate something, etc.).
* The `<action>` elements themselves can also be empty (no child elements). This can be useful for actions like `<action name="all" depends-on="…"/>`.

