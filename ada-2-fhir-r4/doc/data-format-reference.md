# Application ada-2-fhir-r4 format reference

This documents the XML format for the public YATC ada-2-fhir-r4 component's data file in `YATC-public/ada-2-fhir-r4/data/ada-2-fhir-r4-data.xml`, as used by the `ada-2-fhir-r4` command.

General remarks:

* There are two schemas for this document. For full validation both should be applied:
  * `YATC-public/ada-2-fhir-r4/xsd/ada-2-fhir-r4-data.xsd`
  * `YATC-public/ada-2-fhir-r4/sch/ada-2-fhir-r4-data.sch`

* All elements *must* be in the `https://nictiz.nl/ns/YATC-public` namespace.
* In some places XInclude processing is allowed, using `<xi:include>` elements. The resulting document (after all XIncludes are dereferenced) must be valid.
* References to YATC parameters, in text or attribute values (using either `${parname}` or `{$parname}`), will expand. A referenced parameter must exist.

-----

## Table of contents

* [Root ada-2-fhir-r4-data element](#section-anchor-1)
* [The application element](#section-anchor-2)
  * [The setup element](#section-anchor-2-1)
    * [The copy-data element](#section-anchor-2-1-1)
    * [The copy-project-schemas element](#section-anchor-2-1-2)
    * [The empty-directory element](#section-anchor-2-1-3)
    * [The copy-directory element](#section-anchor-2-1-4)
    * [The retrieve element](#section-anchor-2-1-5)

  * [The action element](#section-anchor-2-2)
    * [The build element](#section-anchor-2-2-1)
      * [The parameter element](#section-anchor-2-2-1-1)



* [Common definitions](#section-anchor-3)
  * [Common attributes](#section-anchor-3-1)
    * [Resolving the @directory attribute](#section-anchor-3-1-1)

  * [The include and exclude elements](#section-anchor-3-2)


-----

## <a name="section-anchor-1"/>Root `<ada-2-fhir-r4-data>` element

```
<ada-2-fhir-r4-data>
  ( <xi:include href="…"> |
    <application …> )*
</ada-2-fhir-r4-data>
```

| Child element | # | Description | 
| ----- | ----- | ----- | 
| `xi:include` | 1 | Reference to a file to include. | 
| `application` | 1 | Definition for a single application. | 

-----

## <a name="section-anchor-2"/>The `<application>` element

The `<application>` element defines the processing to be performed for a single application/version combination.

The copied and processed/created documents will be stored underneath `{$ada2wikiBaseStorageDirectory}/{@name}/{@version}` (parameter defined in `YATC-public/ada-2-fhir-r4/data/parameters.xml`).

```
<application name = xs:string
             version = xs:string
             source-project-name? = xs:string
             source-adarefs2ada? = xs:boolean >
  ( <message> |
    <setup …> |
    <action …> )*
</application>
```

| Attribute | # | Type | Description | 
| ----- | ----- | ----- | ----- | 
| `name` | 1 | `xs:string` | The name of the application. For instance: `lab`. | 
| `version` | 1 | `xs:string` | The version of the application. For instance: `4.0.0`. | 
| `source-project-name` | ? | `xs:string` | Default: `application/@name`<br/>The name of the project (directory) to be used. | 
| `source-adarefs2ada` | ? | `xs:boolean` | Default: `false`<br/>Whether the source documents for setup come from adarefs2ada computations or straight from the ART-DECOR data. See below. | 

| Child element | # | Description | 
| ----- | ----- | ----- | 
| `message` | 1 | Message which will be output on the console during processing for this application. | 
| `setup` | 1 | Any setup (data copying) to be done. | 
| `action` | 1 | Definition of the builds to be performed for a specific action | 

Some applications take their input source from data directly retrieved from ART-DECOR and some from adarefs2ada post-processing (all done by the `YATC-shared/get-production-ada-instances` component). The `@source-adarefs2ada` attribute takes care of this:

* `source-adarefs2ada="false"`: The source documents are supposed to come straight from ART-DECOR. They're taken from `{$productionAdaInstancesBaseStorageDirectory}/{@name}/{@version}/{$productionAdaInstancesDataSubdir}` (parameters defined in `YATC-shared/data/parameters.xml`).
* `source-adarefs2ada="true"`: The source documents are supposed to come from adarefs2ada post-processing. They're taken from the appropriate subdirectories of `{$adarefs2adaBaseStorageDirectory}/{@name}/{@version}/{@usecase}` (parameter defined in `YATC-shared/data/parameters.xml`).

### <a name="section-anchor-2-1"/><a name="setup-element"/>The `<setup>` element

The `<setup>` element defines the data-copying operations to be performed.

The string `$USECASE` will be substituted with the name of the usecase in the `@pattern` and `@glob` attributes of `<include>` and `<exclude>` elements.

```
<setup usecase = xs:string
       directory-id? = identifier
       source-project-name? = xs:string >
  ( <copy-data …> |
    <copy-project-schemas …> |
    <empty-directory …> |
    <copy-directory …> |
    <retrieve …> )*
</setup>
```

| Attribute | # | Type | Description | 
| ----- | ----- | ----- | ----- | 
| `usecase` | 1 | `xs:string` | Name of the usecase this setup is for. This becomes the name of the subdirectory where the usecase results are stored. | 
| `directory-id` | ? | `identifier` | Defines the identifier for the base usecase directories. See [common attributes](#common-attributes) for a usage example. | 
| `source-project-name` | ? | `xs:string` | Default: `application/@name`<br/>The name of the project (directory) to be used. Overrides a value for this defined on a parent element. | 

| Child element | # | Description | 
| ----- | ----- | ----- | 
| `copy-data` | 1 | Copies retrieved ADA documents to application/version specific sub-directories. | 
| `copy-project-schemas` | 1 | Copies project schemas to application/version specific sub-directories. | 
| `empty-directory` | 1 | Creates an empty directory (or empties an existing one). | 
| `copy-directory` | 1 | Copies a directory, optionally with subdirectories, to an application/version specific sub-directory. | 
| `retrieve` | 1 | Retrieves a single XML document from a REST URL and stores this in an application/version specific sub-directory. | 

Additional remarks:

* Although not strictly necessary (non-existent directories are created by the build steps as well), it is advised that the setup creates *all* directories, empty or not. This ensures that, during the setup process, these directories are emptied. It also allows referring to these directories using the directory identifier mechanism.
* Some components have commands that allow developers to compare the XML results created here against the XML results of the original (Ant based) system. By default, all directories that are created are compared. You can stop this comparison by adding a `compare="false"` attribute. This allows you to add (usually empty) directories for documents that are not created in the original code, like reports. Directories created with `<copy-directory>` are never compared (because this was meant for copying fixed resources).

#### <a name="section-anchor-2-1-1"/>The `<copy-data>` element

The `<copy-data>` element defines which files must be copied, and to where.

```
<copy-data target-subdir? = xs:string
           source-subdir? = xs:string
           directory-id? = identifier
           compare? = xs:boolean >
  ( <include> |
    <exclude> )*
</copy-data>
```

| Attribute | # | Type | Description | 
| ----- | ----- | ----- | ----- | 
| `target-subdir` | ? | `xs:string` | Default: `ada_instance`<br/>The name of the sub-directory to copy the data to. | 
| `source-subdir` | ? | `xs:string` | The name of the source sub-directory. Base directory and default depends on the component it is used in. Usually unspecified. | 
| `directory-id` | ? | `identifier` | Defines the identifier for the sub-directories. See [common attributes](#common-attributes) for a usage example. | 
| `compare` | ? | `xs:boolean` | Default: `true`<br/>Whether this directory should be included in a comparison (with results from the original code). | 

| Child element | # | Description | 
| ----- | ----- | ----- | 
| `include` | 1 | Definition of any files to include. See [include/exclude elements](#include-exclude) | 
| `exclude` | 1 | Definition of any files to exclude. See [include/exclude elements](#include-exclude) | 

#### <a name="section-anchor-2-1-2"/>The `<copy-project-schemas>` element

The `<copy-project-schemas>` element defines which schemas (from a project definition) must be copied, and to where. The location for source project files is defined using parameter `projectsBaseStorageDirectory`.

```
<copy-project-schemas target-subdir? = xs:string
                      copy-ada-meta? = xs:boolean
                      source-project-name? = xs:string
                      directory-id? = identifier
                      compare? = xs:boolean >
  ( <include> |
    <exclude> )*
</copy-project-schemas>
```

| Attribute | # | Type | Description | 
| ----- | ----- | ----- | ----- | 
| `target-subdir` | ? | `xs:string` | Default: `ada_schemas`<br/>The name of the sub-directory to copy the data to. | 
| `copy-ada-meta` | ? | `xs:boolean` | Default: `true`<br/>Whether to copy the default `ada_meta.xsd` schema also. | 
| `source-project-name` | ? | `xs:string` | Default: `application/@name`<br/>The name of the project (directory) to be used. Overrides a value for this defined on a parent element. | 
| `directory-id` | ? | `identifier` | Defines the identifier for the sub-directories. See [common attributes](#common-attributes) for a usage example. | 
| `compare` | ? | `xs:boolean` | Default: `true`<br/>Whether this directory should be included in a comparison (with results from the original code). | 

| Child element | # | Description | 
| ----- | ----- | ----- | 
| `include` | 1 | Definition of any files to include. See [include/exclude elements](#include-exclude) | 
| `exclude` | 1 | Definition of any files to exclude. See [include/exclude elements](#include-exclude) | 

#### <a name="section-anchor-2-1-3"/>The `<empty-directory>` element

The `<empty-directory>` element creates an empty directory (underneath the setup's main target directory). If such a directory already exists it will be emptied.

```
<empty-directory target-subdir = xs:string
                 directory-id? = identifier
                 compare? = xs:boolean />
```

| Attribute | # | Type | Description | 
| ----- | ----- | ----- | ----- | 
| `target-subdir` | 1 | `xs:string` | The name of the sub-directory to create. | 
| `directory-id` | ? | `identifier` | Defines the identifier for the sub-directories. See [common attributes](#common-attributes) for a usage example. | 
| `compare` | ? | `xs:boolean` | Default: `true`<br/>Whether this directory should be included in a comparison (with results from the original code). | 

#### <a name="section-anchor-2-1-4"/>The `<copy-directory>` element

The `<copy-directory>` element performs a straight copy from one directory to the other, including (optionally) subdirectories.

It was created for copying HTML assets to the result (but can of course also be used for other purposes). When you're copying from a directory in the code repository (which makes sense if it's a set of fixed asset files), use the `#…` notation for the `@directory` attribute. For instance `directory="#mp/9.0.7/beschikbaarstellen_medicatiegegevens/html_instance_kwal/assets"`: the directory name after the `#` is relative to the data file it is used in.

```
<copy-directory target-subdir = xs:string
                directory = xs:string
                recurse? = xs:boolean
                directory-id? = identifier >
  ( <include> |
    <exclude> )*
</copy-directory>
```

| Attribute | # | Type | Description | 
| ----- | ----- | ----- | ----- | 
| `target-subdir` | 1 | `xs:string` | The name of the sub-directory to copy the data to. | 
| `directory` | 1 | `xs:string` | The name of the source directory. See [common attributes](#common-attributes) for special handling. | 
| `recurse` | ? | `xs:boolean` | Default: `true`<br/>Whether to recurse into subdirectories and copy these as well. | 
| `directory-id` | ? | `identifier` | Defines the identifier for the sub-directories. See [common attributes](#common-attributes) for a usage example. | 

| Child element | # | Description | 
| ----- | ----- | ----- | 
| `include` | 1 | Definition of any files to include. See [include/exclude elements](#include-exclude) | 
| `exclude` | 1 | Definition of any files to exclude. See [include/exclude elements](#include-exclude) | 

#### <a name="section-anchor-2-1-5"/>The `<retrieve>` element

The `<retrieve>` element specifies a single XML document for download from a REST URL.

```
<retrieve target-subdir? = xs:string
          url = xs:anyURI
          name = xs:string
          directory-id? = identifier />
```

| Attribute | # | Type | Description | 
| ----- | ----- | ----- | ----- | 
| `target-subdir` | ? | `xs:string` | Default: `ada_instance`<br/>The name of the sub-directory to copy the data to. | 
| `url` | 1 | `xs:anyURI` | The REST URL to use for retrieving the XML document | 
| `name` | 1 | `xs:string` | The filename for the retrieved XML document. | 
| `directory-id` | ? | `identifier` | Defines the identifier for the target sub-directory. See [common attributes](#common-attributes) for a usage example. | 

### <a name="section-anchor-2-2"/><a name="action-element"/>The `<action>` element

The `<action>` element defines all the build steps to be performed for a single action, usually based upon the documents copied in the `<setup>` element(s).

```
<action name = identifier
        description? = xs:string
        default? = xs:boolean
        depends-on? = list of identifier >
  ( <message> |
    <build …> )*
</action>
```

| Attribute | # | Type | Description | 
| ----- | ----- | ----- | ----- | 
| `name` | 1 | `identifier` | The name of this action | 
| `description` | ? | `xs:string` | A`n optional short description for this action. Used in reporting/messaging. | 
| `default` | ? | `xs:boolean` | Default: `false`<br/>Whether this is the default action for this application/version. Only one action can be designated as default. | 
| `depends-on` | ? | `list of identifier` | An optional whitespace separated list of identifiers of the actions this action depends on. All actions listed here will be performed before this one. | 

| Child element | # | Description | 
| ----- | ----- | ----- | 
| `message` | 1 | Message which will be output on the console during processing for this application. | 
| `build` | 1 | Specification of a build step. | 

#### <a name="section-anchor-2-2-1"/>The `<build>` element

The `<build>` defines a single build step to be performed as part of an action. A build step is an XSLT transformation performed on one or more input documents.

```
<build name? = xs:string >
  <stylesheet href="…">
  ( <input-document directory="…" name="…"> |
    <input-documents directory="…" accept-empty="…"> |
    <no-input> )
  ( <output-document directory="…" name="…"> |
    <output-documents directory="…"> |
    <discard-output> )
  <parameter …>*
</build>
```

| Attribute | # | Type | Description | 
| ----- | ----- | ----- | ----- | 
| `name` | ? | `xs:string` | The name of this build (used for reporting). If nothing is specified, some unique name will be used. | 

| Child element | # | Description | 
| ----- | ----- | ----- | 
| `stylesheet` | 1 | Defines, with a `@href` attribute (see [common attributes](#common-attributes)) the XSLT stylesheet that will be run over the specified input document(s). | 
| `input-document` | 1 | Specifies a single input document for this build.<br/>Has a required `@directory` (see [common attributes](#common-attributes)) and `@name`attribute. | 
| `input-documents` | 1 | Specifies a set of input documents.<br/>Has a required `@directory` attribute (see [common attributes](#common-attributes)) and can have child `<include>` and/or `<exclude>` elements (see [include/exclude elements](#include-exclude)) to further narrow down the set of documents to process.<br/>Set `accept-empty="true"` if you want empty input sets handled without raising an error.<br/>You cannot specify a single output (`<output-document>` element) when specifying multiple input documents, use either `<output-documents>` or `<discard-output>`. | 
| `no-input` | 1 | Specifies that the stylesheet needs no input document (a small dummy document will be provided). | 
| `output-document` | 1 | Specifies where the direct output of the stylesheet must be written to. This will always be done using XML serialization.<br/>Has a required `@directory` (see [common attributes](#common-attributes)) and `@name`attribute. | 
| `output-documents` | 1 | Specifies that all direct outputs of the stylesheet must be written to this location, using the same filename as the input document. Usually used in conjunction with the `<input-documents>` element.<br/>Has a required `@directory` (see [common attributes](#common-attributes)). | 
| `discard-output` | 1 | Specifies that the direct output of the stylesheet must be discarded. | 
| `parameter` | * | Defines an additional parameter to be passed to the stylesheet. See [below](#parameter-element). | 

Besides direct output, a stylesheet can also produce secondary output(s) using the `<xsl:result-document>` instruction. These outputs will be written to disk, using the serialization options as specified on the `<xsl:result-document>` element.

##### <a name="section-anchor-2-2-1-1"/>The <a name="parameter-element"/>`<parameter>` element

The `<parameter>` element defines an additional parameter to be passed to a stylesheet.

```
<parameter name = xs:NCName
           value? = xs:string
           href? = URI
           directory? = URI />
```

| Attribute | # | Type | Description | 
| ----- | ----- | ----- | ----- | 
| `name` | 1 | `xs:NCName` | The name of the parameter. | 
| `value` | ? | `xs:string` | A (straight) value for the parameter. | 
| `href` | ? | `URI` | A URI as value for the parameter, see [common attributes](#common-attributes). | 
| `directory` | ? | `URI` | A directory as value for the parameter, see [common attributes](#common-attributes). | 

When multiple attributes are present, the processing is in this order:

* When *both*
                `@value` and `@directory` are present, a filename is constructed with `@directory` as the directory (after resolving of directory identifiers and relative path, see [common attributes](#common-attributes)) and `@value` as the filename.
* When `@value` is present, its value will be used for the value of the parameter. If this is `true` or `false`, it will be converted to a boolean parameter (instead of string).
* When `@directory` is present, its absolute value will be used for the value of the parameter (after resolving of directory identifiers and relative path, see [common attributes](#common-attributes)).
* When `@href` is present, its absolute value will be used for the value of the parameter (after resolving a relative path, see [common attributes](#common-attributes)).
* When no attributes are present, the parameter's value will be the empty string.

-----

## <a name="section-anchor-3"/>Common definitions

### <a name="section-anchor-3-1"/><a name="common-attributes"/>Common attributes

The following attributes appear on multiple elements:

| Attribute name | Description | 
| ----- | ----- | 
| `directory` | The URI of a directory.<br/>There's magic going on resolving these directory names. See below. | 
| `href` | Reference to a file, usually situated in the code repository itself (for instance a stylesheet). A relative name is resolved against the location of the data document it is in.<br/>An absolute name must start with `file://`. Using this for production code is strongly discouraged, because several people use the system, all with different disk layouts. | 

#### <a name="section-anchor-3-1-1"/><a name="resolving-directory-attribute"/>Resolving the `@directory` attribute

In resolving the value of the `@directory` attribute the following magic applies:

* An absolute path must start with `file://` (for instance `directory="file:///C:/some/dir/somefile.xml"`). Using this for production code is strongly discouraged, because several people use the system, all with different disk layouts.
* A (straight) relative path is resolved against the base directory for the application/version we're working on (`…/{application-name}/{version}`) (for instance `directory="beschikbaarstellen_medicatiegegevens/wiki_instance"`).
* When its value starts with `#`, it's value is resolved against the location of the data document it is in (for instance `directory="#mp/9.0.7/beschikbaarstellen_medicatiegegevens/html_kwal"`). This is (very rarely) used for referencing fixed/constant data files that reside in the code.
* When its value starts with either `@` or `^`, it is a reference to a *directory identifier* specified in one of the `<setup>` elements (or its children), for this application. This is done using the values of `@directory-id` attributes. The following rules apply (examples below):
  * When it starts with `@`, this is a reference to the *target* directory for the specified directory identifier.
  * When it starts with `^`, this is a reference to the *source* directory for the specified directory identifier. This is rarely used.


Some examples that reference target directory identifiers:

```
<setup usecase="testusecase" directory-id="tuc">
    …
</setup>            
            
<build name="…">
    …
    <output directory="@tuc/ada_instance"/>
</build>
```

```
<setup usecase="testusecase">
    <copy-data directory-id="tuc-instance">
        …
    </copy-data>
    …
</setup>            
            
<build name="…">
    …
    <output directory="@tuc-instance"/>
</build>
```

In both examples, the value of the `build/output/@directory` attribute will expand to `…/{application-name}/{version}/testusecase/ada_instance`



### <a name="section-anchor-3-2"/><a name="include-exclude"/>The `<include>` and `<exclude>` elements

The `<include>` and `<exclude>` elements define which files will be processed/copied:

* If there are no `<include>` elements, all files are included.
* A file is processed/copied when it's included and not excluded.

```
<include pattern? = xs:string
         glob? = xs:string >
  <!-- Use either @pattern or @glob, not both. -->
</include>
```

| Attribute | # | Type | Description | 
| ----- | ----- | ----- | ----- | 
| `pattern` | ? | `xs:string` | A regular expression, matched against filenames. For instance `\.xml$` for all XML files. | 
| `glob` | ? | `xs:string` | A (UNIX style) glob matched against filenames. For instance `*.xml` for all XML files. | 

* Matching on patterns or globs is on file*name* only (not on its path).
* Globs can *not* contain character class entries (`[…]`) and other more sophisticated constructs. Therefore, if your name matching gets complicated, you'll have to use patterns, not globs.

The definition of the `<exclude>` element is identical to that of the `<include>` element.

