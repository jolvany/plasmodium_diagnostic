{
    "class": "Workflow",
    "cwlVersion": "v1.1",
    "id": "dave/variant-calling-pipeline-development-project/fully-unmapped/6",
    "label": "fully unmapped",
    "$namespaces": {
        "sbg": "https://sevenbridges.com"
    },
    "inputs": [
        {
            "id": "in_alignments",
            "sbg:fileTypes": "BAM, SAM, CRAM",
            "type": "File",
            "label": "Input BAM/SAM/CRAM file",
            "doc": "Input BAM/SAM/CRAM file.",
            "sbg:x": -355,
            "sbg:y": -82
        },
        {
            "id": "in_reference",
            "sbg:fileTypes": "FASTA, FA, FASTA.GZ, FA.GZ, GZ",
            "type": "File?",
            "label": "Reference file",
            "doc": "A FASTA format reference file, optionally compressed by bgzip and ideally indexed by SAMtools Faidx. If an index is not present, one will be generated for you. This file is used for compression/decompression of CRAM files. Please provide reference file when using CRAM input/output file.",
            "sbg:x": -364,
            "sbg:y": -220
        }
    ],
    "outputs": [
        {
            "id": "out_index",
            "outputSource": [
                "samtools_index_1_9_cwl1_0/out_index"
            ],
            "sbg:fileTypes": "BAI, CRAI, CSI",
            "type": "File?",
            "label": "Generated index file",
            "doc": "Generated index file (without the indexed data).",
            "sbg:x": 261,
            "sbg:y": -191.79998779296875
        },
        {
            "id": "indexed_data_file",
            "outputSource": [
                "samtools_index_1_9_cwl1_0/indexed_data_file"
            ],
            "sbg:fileTypes": "BAM, CRAM",
            "type": "File?",
            "label": "Indexed data file",
            "doc": "Output BAM/CRAM, along with its index as secondary file.",
            "sbg:x": 309,
            "sbg:y": -32.79998779296875
        },
        {
            "id": "out_alignments",
            "outputSource": [
                "samtools_view_1_9_cwl1_0/out_alignments"
            ],
            "sbg:fileTypes": "BAM, SAM, CRAM",
            "type": "File?",
            "label": "Output BAM, SAM, or CRAM file",
            "doc": "The output file.",
            "sbg:x": 98.2166748046875,
            "sbg:y": 88.72500610351562
        }
    ],
    "steps": [
        {
            "id": "samtools_view_1_9_cwl1_0",
            "in": [
                {
                    "id": "output_format",
                    "default": "CRAM"
                },
                {
                    "id": "include_header",
                    "default": true
                },
                {
                    "id": "filter_include",
                    "default": 12
                },
                {
                    "id": "filter_exclude_any",
                    "default": 256
                },
                {
                    "id": "output_filename",
                    "valueFrom": "${return inputs.in_alignments.nameroot+\".fully.unaligned.unmapped.cram\"}"
                },
                {
                    "id": "in_reference",
                    "source": "in_reference"
                },
                {
                    "id": "in_alignments",
                    "source": "in_alignments"
                }
            ],
            "out": [
                {
                    "id": "out_alignments"
                },
                {
                    "id": "reads_not_selected_by_filters"
                },
                {
                    "id": "alignement_count"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.0",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "dave/variant-calling-pipeline-development-project/samtools-view-1-9-cwl1-0/0",
                "baseCommand": [
                    "/opt/samtools-1.9/samtools",
                    "view"
                ],
                "inputs": [
                    {
                        "sbg:category": "File inputs",
                        "id": "in_index",
                        "type": "File?",
                        "label": "Index file",
                        "doc": "This tool requires index file for some use cases.",
                        "sbg:fileTypes": "BAI, CRAI, CSI"
                    },
                    {
                        "sbg:category": "Config inputs",
                        "sbg:toolDefaultValue": "SAM",
                        "sbg:altPrefix": "-O",
                        "id": "output_format",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "SAM",
                                    "BAM",
                                    "CRAM"
                                ],
                                "name": "output_format"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--output-fmt",
                            "shellQuote": false,
                            "position": 1
                        },
                        "label": "Output format",
                        "doc": "Output file format"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "False",
                        "id": "fast_bam_compression",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "-1",
                            "shellQuote": false,
                            "position": 2
                        },
                        "label": "Fast BAM compression",
                        "doc": "Enable fast BAM compression (implies output in bam format)."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "False",
                        "id": "uncompressed_bam",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "-u",
                            "shellQuote": false,
                            "position": 3
                        },
                        "label": "Output uncompressed BAM",
                        "doc": "Output uncompressed BAM (implies output BAM format). This option saves time spent on compression/decompression and is thus preferred when the output is piped to another SAMtools command."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "False",
                        "id": "include_header",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "-h",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Include the header in the output",
                        "doc": "Include the header in the output."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "False",
                        "id": "output_header_only",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "-H",
                            "shellQuote": false,
                            "position": 5
                        },
                        "label": "Output the header only",
                        "doc": "Output the header only."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "False",
                        "id": "collapse_cigar",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "-B",
                            "shellQuote": false,
                            "position": 6
                        },
                        "label": "Collapse the backward CIGAR operation",
                        "doc": "Collapse the backward CIGAR operation."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "0",
                        "id": "filter_include",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "-f",
                            "shellQuote": false,
                            "position": 7
                        },
                        "label": "Include reads with all of these flags",
                        "doc": "Only output alignments with all bits set in this integer present in the FLAG field."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "0",
                        "id": "filter_exclude_any",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "-F",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Exclude reads with any of these flags",
                        "doc": "Do not output alignments with any bits set in this integer present in the FLAG field."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "0",
                        "id": "filter_exclude_all",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "-G",
                            "shellQuote": false,
                            "position": 9
                        },
                        "label": "Exclude reads with all of these flags",
                        "doc": "Only exclude reads with all of the bits set in this integer present in the FLAG field."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "null",
                        "id": "read_group",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "-r",
                            "shellQuote": false,
                            "position": 10
                        },
                        "label": "Read group",
                        "doc": "Only output reads in the specified read group."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "0",
                        "id": "filter_mapq",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "-q",
                            "shellQuote": false,
                            "position": 11
                        },
                        "label": "Minimum mapping quality",
                        "doc": "Skip alignments with MAPQ smaller than this value."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "null",
                        "id": "filter_library",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "-l",
                            "shellQuote": false,
                            "position": 12
                        },
                        "label": "Only include alignments in library",
                        "doc": "Only output alignments in this library."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "0",
                        "id": "min_cigar_operations",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "-m",
                            "shellQuote": false,
                            "position": 13
                        },
                        "label": "Minimum number of CIGAR bases consuming query sequence",
                        "doc": "Only output alignments with number of CIGAR bases consuming query sequence  ≥ INT."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "id": "read_tag_to_strip",
                        "type": "string[]?",
                        "inputBinding": {
                            "prefix": "",
                            "itemSeparator": " ",
                            "shellQuote": false,
                            "position": 14,
                            "valueFrom": "${\n    if (self)\n    {\n        var cmd = [];\n        for (var i = 0; i < self.length; i++) \n        {\n            cmd.push('-x', self[i]);\n            \n        }\n        return cmd.join(' ');\n    }\n}"
                        },
                        "label": "Read tags to strip",
                        "doc": "Read tag to exclude from output (repeatable)."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "False",
                        "id": "count_alignments",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "-c",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Output only count of matching records",
                        "doc": "Instead of outputing the alignments, only count them and output the total number. All filter options, such as -f, -F, and -q, are taken into account."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "id": "input_fmt_option",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--input-fmt-option",
                            "shellQuote": false,
                            "position": 16
                        },
                        "label": "Input file format option",
                        "doc": "Specify a single input file format option in the form of OPTION or OPTION=VALUE."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "id": "output_fmt_option",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--output-fmt-option",
                            "shellQuote": false,
                            "position": 17
                        },
                        "label": "Output file format option",
                        "doc": "Specify a single output file format option in the form of OPTION or OPTION=VALUE."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "id": "subsample_fraction",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "-s",
                            "shellQuote": false,
                            "position": 18
                        },
                        "label": "Subsample fraction",
                        "doc": "Output only a proportion of the input alignments. This subsampling acts in the same way on all of the alignment records in the same template or read pair, so it never keeps a read but not its mate. The integer and fractional parts of the INT.FRAC are used separately: the part after the decimal point sets the fraction of templates/pairs to be kept, while the integer part is used as a seed that influences which subset of reads is kept. When subsampling data that has previously been subsampled, be sure to use a different seed value from those used previously; otherwise more reads will be retained than expected."
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:toolDefaultValue": "1",
                        "sbg:altPrefix": "-@",
                        "id": "threads",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--threads",
                            "shellQuote": false,
                            "position": 19,
                            "valueFrom": "${\n  if((inputs.threads)){\n    return (inputs.threads) - 1\n  }\n  else{\n    return\n  }\n}"
                        },
                        "label": "Number of threads",
                        "doc": "Number of threads. SAMtools uses argument --threads/-@ to specify number of additional threads. This parameter sets total number of threads (and CPU cores). Command line argument will be reduced by 1 to set number of additional threads."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "id": "omitted_reads_filename",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "-U",
                            "shellQuote": false,
                            "position": 20
                        },
                        "label": "Filename for reads not selected by filters",
                        "doc": "Write alignments that are not selected by the various filter options to this file. When this option is used, all alignments (or all alignments intersecting the regions specified) are written to either the output file or this file, but never both."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "stdout",
                        "id": "output_filename",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "-o",
                            "shellQuote": false,
                            "position": 21,
                            "valueFrom": "${\n  if (inputs.output_filename!=\"default_output_filename\"){\n    return (inputs.output_filename)\n  }\n  input_filename = [].concat(inputs.in_alignments)[0].path.split('/').pop()\n  input_name_base = input_filename.split('.').slice(0,-1).join('.')\n  ext = 'sam'\n  if (inputs.count_alignments){\n    return input_name_base + '.count.txt'\n  }\n  if ((inputs.uncompressed_bam) || (inputs.fast_bam_compression)){\n    ext = 'bam'\n  }\n  if (inputs.output_format){\n    ext = (inputs.output_format).toLowerCase()\n  }\n  if (inputs.output_header_only){\n    ext = 'header.' + ext\n  }\n  if (inputs.subsample_fraction){\n    ext = 'subsample.' + ext\n  }\n  if ((inputs.bed_file) || (inputs.read_group) || (inputs.read_group_list) ||\n      (inputs.filter_mapq) || (inputs.filter_library) || (inputs.min_cigar_operations) ||\n      (inputs.filter_include) || (inputs.filter_exclude_any) || \n      (inputs.filter_exclude_all) || (inputs.regions_array)){\n    ext = 'filtered.' + ext\n  }\n    \n  return input_name_base + '.' + ext\n}"
                        },
                        "label": "Output filename",
                        "doc": "Define a filename of the output.",
                        "default": "default_output_filename"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "id": "bed_file",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "-L",
                            "shellQuote": false,
                            "position": 22
                        },
                        "label": "BED region file",
                        "doc": "Only output alignments overlapping the input BED file.",
                        "sbg:fileTypes": "BED"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "id": "read_group_list",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "-R",
                            "shellQuote": false,
                            "position": 23
                        },
                        "label": "Read group list",
                        "doc": "Output alignments in read groups listed in this file.",
                        "sbg:fileTypes": "TXT"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "sbg:altPrefix": "-T",
                        "id": "in_reference",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--reference",
                            "shellQuote": false,
                            "position": 24
                        },
                        "label": "Reference file",
                        "doc": "A FASTA format reference file, optionally compressed by bgzip and ideally indexed by SAMtools Faidx. If an index is not present, one will be generated for you. This file is used for compression/decompression of CRAM files. Please provide reference file when using CRAM input/output file.",
                        "sbg:fileTypes": "FASTA, FA, FASTA.GZ, FA.GZ, GZ"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "id": "reference_file_list",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "-t",
                            "shellQuote": false,
                            "position": 25
                        },
                        "label": "List of reference names and lengths",
                        "doc": "A tab-delimited file. Each line must contain the reference name in the first column and the length of the reference in the second column, with one line for each distinct reference. Any additional fields beyond the second column are ignored. This file also defines the order of the reference sequences in sorting. If you run SAMtools Faidx on reference FASTA file (<ref.fa>), the resulting index file <ref.fa>.fai can be used as this file.",
                        "sbg:fileTypes": "FAI, TSV, TXT"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "id": "in_alignments",
                        "type": "File",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 99
                        },
                        "label": "Input BAM/SAM/CRAM file",
                        "doc": "Input BAM/SAM/CRAM file.",
                        "sbg:fileTypes": "BAM, SAM, CRAM"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "id": "regions_array",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 100
                        },
                        "label": "Regions array",
                        "doc": "With no options or regions specified, prints all alignments in the specified input alignment file (in SAM, BAM, or CRAM format) to output file in specified format. Use of region specifications requires a coordinate-sorted and indexed input file (in BAM or CRAM format). Regions can be specified as: RNAME[:STARTPOS[-ENDPOS]] and all position coordinates are 1-based.  Important note: when multiple regions are given, some alignments may be output multiple times if they overlap more than one of the specified regions. Examples of region specifications:  chr1 - Output all alignments mapped to the reference sequence named `chr1' (i.e. @SQ SN:chr1);  chr2:1000000 - The region on chr2 beginning at base position 1,000,000 and ending at the end of the chromosome;  chr3:1000-2000 - The 1001bp region on chr3 beginning at base position 1,000 and ending at base position 2,000 (including both end positions);  '*' - Output the unmapped reads at the end of the file (this does not include any unmapped reads placed on a reference sequence alongside their mapped mates.);  . - Output all alignments (mostly unnecessary as not specifying a region at all has the same effect)."
                    },
                    {
                        "sbg:category": "Config inputs",
                        "sbg:toolDefaultValue": "False",
                        "id": "multi_region_iterator",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "-M",
                            "shellQuote": false,
                            "position": 22
                        },
                        "label": "Use the multi-region iterator",
                        "doc": "Use the multi-region iterator on the union of the BED file and command-line region arguments."
                    },
                    {
                        "sbg:category": "Platform Options",
                        "sbg:toolDefaultValue": "1500",
                        "id": "mem_per_job",
                        "type": "int?",
                        "label": "Memory per job",
                        "doc": "Memory per job in MB."
                    },
                    {
                        "sbg:category": "Platform Options",
                        "sbg:toolDefaultValue": "1",
                        "id": "cpu_per_job",
                        "type": "int?",
                        "label": "CPU per job",
                        "doc": "Number of CPUs per job."
                    }
                ],
                "outputs": [
                    {
                        "id": "out_alignments",
                        "doc": "The output file.",
                        "label": "Output BAM, SAM, or CRAM file",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "${\n  if ((inputs.output_filename!=\"default_output_filename\")){\n    return (inputs.output_filename)\n  }\n  input_filename = [].concat((inputs.in_alignments))[0].path.split('/').pop()\n  input_name_base = input_filename.split('.').slice(0,-1). join('.')\n  ext = 'sam'\n  if ((inputs.count_alignments)){\n    return \n  }\n  if ((inputs.uncompressed_bam) || (inputs.fast_bam_compression)){\n    ext = 'bam'\n  }\n  if ((inputs.output_format)){\n    ext = (inputs.output_format).toLowerCase()\n  }\n  if ((inputs.output_header_only)){\n    ext = 'header.' + ext\n  }\n  if ((inputs.subsample_fraction)){\n    ext = 'subsample.' + ext\n  }\n  if ((inputs.bed_file) || (inputs.read_group) || (inputs.read_group_list) ||\n      (inputs.filter_mapq) || (inputs.filter_library) || (inputs.min_cigar_operations) ||\n      (inputs.filter_include) || (inputs.filter_exclude_any) || \n      (inputs.filter_exclude_all) || (inputs.regions_array)){\n    ext = 'filtered.' + ext\n  }\n    \n  return input_name_base + '.' + ext\n}",
                            "outputEval": "$(inheritMetadata(self, inputs.in_alignments))"
                        },
                        "sbg:fileTypes": "BAM, SAM, CRAM"
                    },
                    {
                        "id": "reads_not_selected_by_filters",
                        "doc": "File containing reads that are not selected by filters.",
                        "label": "Reads not selected by filters",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "${\n  if ((inputs.omitted_reads_filename)){\n    return (inputs.omitted_reads_filename)\n  }\n}",
                            "outputEval": "$(inheritMetadata(self, inputs.in_alignments))"
                        },
                        "sbg:fileTypes": "BAM, SAM, CRAM"
                    },
                    {
                        "id": "alignement_count",
                        "doc": "File containing number of alignments.",
                        "label": "Alignment count",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "${\n  input_filename = [].concat((inputs.in_alignments))[0].path.split('/').pop()\n  input_name_base = input_filename.split('.').slice(0,-1). join('.')\n  return input_name_base + '.count.txt'\n}",
                            "outputEval": "$(inheritMetadata(self, inputs.in_alignments))"
                        },
                        "sbg:fileTypes": "TXT"
                    }
                ],
                "doc": "**SAMtools View** tool prints all alignments from a SAM, BAM, or CRAM file to an output file in SAM format (headerless). You may specify one or more space-separated region specifications to restrict output to only those alignments which overlap the specified region(s). Use of region specifications requires a coordinate-sorted and indexed input file (in BAM or CRAM format) [1].\n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the bottom of the page.*\n\n####Regions\n\nRegions can be specified as: RNAME[:STARTPOS[-ENDPOS]] and all position coordinates are 1-based. \n\n**Important note:** when multiple regions are given, some alignments may be output multiple times if they overlap more than one of the specified regions.\n\nExamples of region specifications:\n\n- **chr1**  - Output all alignments mapped to the reference sequence named `chr1' (i.e. @SQ SN:chr1).\n\n- **chr2:1000000** - The region on chr2 beginning at base position 1,000,000 and ending at the end of the chromosome.\n\n- **chr3:1000-2000** - The 1001bp region on chr3 beginning at base position 1,000 and ending at base position 2,000 (including both end positions).\n\n- **'\\*'** - Output the unmapped reads at the end of the file. (This does not include any unmapped reads placed on a reference sequence alongside their mapped mates.)\n\n- **.** - Output all alignments. (Mostly unnecessary as not specifying a region at all has the same effect.) [1]\n\n###Common Use Cases\n\nThis tool can be used for: \n\n- Filtering BAM/SAM/CRAM files - options set by the following parameters and input files: **Include reads with all of these flags** (`-f`), **Exclude reads with any of these flags** (`-F`), **Exclude reads with all of these flags** (`-G`), **Read group** (`-r`), **Minimum mapping quality** (`-q`), **Only include alignments in library** (`-l`), **Minimum number of CIGAR bases consuming query sequence** (`-m`), **Subsample fraction** (`-s`), **Read group list** (`-R`), **BED region file** (`-L`)\n- Format conversion between SAM/BAM/CRAM formats - set by the following parameters: **Output format** (`--output-fmt/-O`), **Fast bam compression** (`-1`), **Output uncompressed BAM** (`-u`)\n- Modification of the data which is contained in each alignment - set by the following parameters: **Collapse the backward CIGAR operation** (`-B`), **Read tags to strip** (`-x`)\n- Counting number of alignments in SAM/BAM/CRAM file - set by parameter **Output only count of matching records** (`-c`)\n\n###Changes Introduced by Seven Bridges\n\n- Parameters **Output BAM** (`-b`) and **Output CRAM** (`-C`) were excluded from the wrapper since they are redundant with parameter **Output format** (`--output-fmt/-O`).\n- Parameter **Input format** (`-S`) was excluded from wrapper since it is ignored by the tool (input format is auto-detected).\n- Input file **Index file** was added to the wrapper to enable operations that require an index file for BAM/CRAM files.\n- Parameter **Number of threads** (`--threads/-@`) specifies the total number of threads instead of additional threads. Command line argument (`--threads/-@`) will be reduced by 1 to set the number of additional threads.\n\n###Common Issues and Important Notes\n\n- When multiple regions are given, some alignments may be output multiple times if they overlap more than one of the specified regions [1].\n- Use of region specifications requires a coordinate-sorted and indexed input file (in BAM or CRAM format) [1].\n- Option **Output uncompressed BAM** (`-u`) saves time spent on compression/decompression and is thus preferred when the output is piped to another SAMtools command [1].\n\n###Performance Benchmarking\n\nMultithreading can be enabled by setting parameter **Number of threads** (`--threads/-@`). In the following table you can find estimates of **SAMtools View** running time and cost. \n\n*Cost can be significantly reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*  \n\n| Input type | Input size | # of reads | Read length | Output format | # of threads | Duration | Cost | Instance (AWS)|\n|---------------|--------------|-----------------|---------------|------------------|-------------------|-----------------|-------------|--------|-------------|\n| BAM | 5.26 GB | 71.5M | 76 | BAM | 1 | 13min. | \\$0.12 | c4.2xlarge |\n| BAM | 11.86 GB | 161.2M | 101 | BAM | 1 | 33min. | \\$0.30 | c4.2xlarge |\n| BAM | 18.36 GB | 179M | 76 | BAM | 1 | 60min. | \\$0.54 | c4.2xlarge |\n| BAM | 58.61 GB | 845.6M | 150 | BAM | 1 | 3h 25min. | \\$1.84 | c4.2xlarge |\n| BAM | 5.26 GB | 71.5M | 76 | BAM | 8 | 5min. | \\$0.04 | c4.2xlarge |\n| BAM | 11.86 GB | 161.2M | 101 | BAM | 8 | 11min. | \\$0.10 | c4.2xlarge |\n| BAM | 18.36 GB | 179M | 76 | BAM | 8 | 19min. | \\$0.17 | c4.2xlarge |\n| BAM | 58.61 GB | 845.6M | 150 | BAM | 8 | 61min. | \\$0.55 | c4.2xlarge |\n| BAM | 5.26 GB | 71.5M | 76 | SAM | 8 | 14min. | \\$0.13 | c4.2xlarge |\n| BAM | 11.86 GB | 161.2M | 101 | SAM | 8 | 23min. | \\$0.21 | c4.2xlarge |\n| BAM | 18.36 GB | 179M | 76 | SAM | 8 | 35min. | \\$0.31 | c4.2xlarge |\n| BAM | 58.61 GB | 845.6M | 150 | SAM | 8 | 2h 29min. | \\$1.34 | c4.2xlarge |\n\n###References\n\n[1] [SAMtools documentation](http://www.htslib.org/doc/samtools-1.9.html)",
                "label": "Samtools View CWL1.0",
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "ResourceRequirement",
                        "ramMin": "${\n  if (inputs.mem_per_job) {\n      return inputs.mem_per_job\n  }    \n  else {\n  mem_offset = 1000\n  if((inputs.in_reference)){\n    mem_offset = mem_offset + 3000\n  }\n  if((inputs.threads)){\n    threads = (inputs.threads)\n  }\n  else{\n    threads = 1\n  }\n  return mem_offset + threads * 500\n  }\n}",
                        "coresMin": "${\n  if (inputs.cpu_per_job) {\n      return inputs.cpu_per_job\n  }\n  else {\n  if((inputs.threads)){\n    return (inputs.threads)\n  }\n  else{\n    return 1\n  }\n  }\n}"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/jrandjelovic/samtools-1-9:1"
                    },
                    {
                        "class": "InitialWorkDirRequirement",
                        "listing": [
                            "$(inputs.in_reference)",
                            "$(inputs.reference_file_list)",
                            "$(inputs.in_index)",
                            "$(inputs.in_alignments)"
                        ]
                    },
                    {
                        "class": "InlineJavascriptRequirement",
                        "expressionLib": [
                            "\nvar setMetadata = function(file, metadata) {\n    if (!('metadata' in file))\n        file['metadata'] = metadata;\n    else {\n        for (var key in metadata) {\n            file['metadata'][key] = metadata[key];\n        }\n    }\n    return file\n};\n\nvar inheritMetadata = function(o1, o2) {\n    var commonMetadata = {};\n    if (!Array.isArray(o2)) {\n        o2 = [o2]\n    }\n    for (var i = 0; i < o2.length; i++) {\n        var example = o2[i]['metadata'];\n        for (var key in example) {\n            if (i == 0)\n                commonMetadata[key] = example[key];\n            else {\n                if (!(commonMetadata[key] == example[key])) {\n                    delete commonMetadata[key]\n                }\n            }\n        }\n    }\n    if (!Array.isArray(o1)) {\n        o1 = setMetadata(o1, commonMetadata)\n    } else {\n        for (var i = 0; i < o1.length; i++) {\n            o1[i] = setMetadata(o1[i], commonMetadata)\n        }\n    }\n    return o1;\n};"
                        ]
                    }
                ],
                "sbg:links": [
                    {
                        "label": "Homepage",
                        "id": "http://www.htslib.org/"
                    },
                    {
                        "label": "Source Code",
                        "id": "https://github.com/samtools/samtools"
                    },
                    {
                        "label": "Wiki",
                        "id": "https://github.com/samtools/samtools/wiki"
                    },
                    {
                        "label": "Download",
                        "id": "https://sourceforge.net/projects/samtools/files/samtools/"
                    },
                    {
                        "label": "Publication",
                        "id": "http://www.ncbi.nlm.nih.gov/pubmed/19505943"
                    },
                    {
                        "label": "Documentation",
                        "id": "http://www.htslib.org/doc/samtools-1.9.html"
                    }
                ],
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "dave",
                        "sbg:modifiedOn": 1608238456,
                        "sbg:revisionNotes": "Copy of admin/sbg-public-data/samtools-view-1-9-cwl1-0/6"
                    }
                ],
                "sbg:categories": [
                    "Utilities",
                    "BAM Processing",
                    "CWL1.0"
                ],
                "sbg:toolkitVersion": "1.9",
                "sbg:projectName": "variant calling pipeline development project",
                "sbg:toolAuthor": "Heng Li (Sanger Institute), Bob Handsaker (Broad Institute), Jue Ruan (Beijing Genome Institute), Colin Hercus, Petr Danecek",
                "sbg:toolkit": "samtools",
                "sbg:image_url": null,
                "sbg:license": "MIT License",
                "sbg:appVersion": [
                    "v1.0"
                ],
                "sbg:id": "dave/variant-calling-pipeline-development-project/samtools-view-1-9-cwl1-0/0",
                "sbg:revision": 0,
                "sbg:revisionNotes": "Copy of admin/sbg-public-data/samtools-view-1-9-cwl1-0/6",
                "sbg:modifiedOn": 1608238456,
                "sbg:modifiedBy": "dave",
                "sbg:createdOn": 1608238456,
                "sbg:createdBy": "dave",
                "sbg:project": "dave/variant-calling-pipeline-development-project",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "dave"
                ],
                "sbg:latestRevision": 0,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "aa82916613444b2d378befd3fc8666677b6b22c3fb84f9dd8985aa73494c63afa",
                "sbg:copyOf": "admin/sbg-public-data/samtools-view-1-9-cwl1-0/6"
            },
            "label": "Samtools View CWL1.0",
            "sbg:x": -139,
            "sbg:y": -140.79998779296875
        },
        {
            "id": "samtools_index_1_9_cwl1_0",
            "in": [
                {
                    "id": "in_alignments",
                    "source": "samtools_view_1_9_cwl1_0/out_alignments"
                }
            ],
            "out": [
                {
                    "id": "indexed_data_file"
                },
                {
                    "id": "out_index"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.0",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "admin/sbg-public-data/samtools-index-1-9-cwl1-0/6",
                "baseCommand": [],
                "inputs": [
                    {
                        "sbg:category": "File Inputs",
                        "id": "in_alignments",
                        "type": "File",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 100,
                            "valueFrom": "${\n    if (inputs.in_index) {\n        var index_ext = [].concat(inputs.in_index)[0].path.substr([].concat(inputs.in_index)[0].path.lastIndexOf('.') + 1)\n        var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)\n        var index_format = 'BAI'\n        if (inputs.index_file_format) {\n            index_format = inputs.index_file_format\n        }\n        if (inputs.minimum_interval_size) {\n            index_format = ''\n        }\n\n        if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||\n            (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')) {\n            return\n        } else {\n            return inputs.in_alignments.path\n        }\n    } else {\n        return inputs.in_alignments.path\n    }\n}"
                        },
                        "label": "BAM/CRAM input file",
                        "doc": "BAM/CRAM input file.",
                        "sbg:fileTypes": "BAM, CRAM"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "False",
                        "id": "output_indexed_data",
                        "type": "boolean?",
                        "label": "Output indexed data file",
                        "doc": "Setting this parameter to True will provide BAM file (and BAI file as secondary file) at Indexed data file output port. The default value is False."
                    },
                    {
                        "sbg:category": "File Inputs",
                        "id": "in_index",
                        "type": "File?",
                        "label": "Input index file",
                        "doc": "Input index file (CSI, CRAI, or BAI). If an input BAM/CRAM file is already indexed, index file can be provided at this port. If it is provided, the tool will just pass it through. This option is useful for workflows when it is not know in advance if the input BAM/CRAM file has accompanying index file present in the project.",
                        "sbg:fileTypes": "BAI, CSI, CRAI"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "14",
                        "id": "minimum_interval_size",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "-m",
                            "shellQuote": false,
                            "position": 2,
                            "valueFrom": "${\n    var self\n    if (self == 0) {\n        self = null;\n        inputs.minimum_interval_size = null\n    };\n\n\n    if (inputs.minimum_interval_size) {\n        if (inputs.in_index) {\n            var index_ext = [].concat(inputs.in_index)[0].path.substr([].concat(inputs.in_index)[0].path.lastIndexOf('.') + 1)\n            var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)\n            var index_format = 'BAI'\n            if (inputs.index_file_format) {\n                index_format = inputs.index_file_format\n            }\n            if (inputs.minimum_interval_size) {\n                index_format = ''\n            }\n\n            if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||\n                (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')) {\n                return\n            } else {\n                return inputs.minimum_interval_size\n            }\n        } else {\n            return inputs.minimum_interval_size\n        }\n    } else {\n        return\n    }\n}"
                        },
                        "label": "Minimum interval size (2^INT)",
                        "doc": "Set minimum interval size for CSI indices to 2^INT. Default value is 14. Setting this value will force generating CSI index file (if the input file is BAM) regardless of the value of the parameter Format of index file (for BAM files).",
                        "default": 0
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "BAI",
                        "id": "index_file_format",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "BAI",
                                    "CSI"
                                ],
                                "name": "index_file_format"
                            }
                        ],
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 1,
                            "valueFrom": "${\n    var self\n    if (self == 0) {\n        self = null;\n        inputs.index_file_format = null\n    };\n\n\n    if (inputs.index_file_format) {\n        if (inputs.in_index) {\n            var index_ext = [].concat(inputs.in_index)[0].path.substr([].concat(inputs.in_index)[0].path.lastIndexOf('.') + 1)\n            var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)\n            var index_format = inputs.index_file_format\n            if (inputs.minimum_interval_size) {\n                index_format = ''\n            }\n\n            if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||\n                (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')) {\n                return\n            } else {\n                if (inputs.index_file_format === 'BAI') {\n                    return '-b'\n                } else if (inputs.index_file_format === 'CSI') {\n                    return '-c'\n                }\n            }\n        } else {\n            if (inputs.index_file_format === 'BAI') {\n                return '-b'\n            } else if (inputs.index_file_format === 'CSI') {\n                return '-c'\n            }\n        }\n    } else {\n        return\n    }\n}"
                        },
                        "label": "Format of index file (for BAM files)",
                        "doc": "Choose which file format will be generated for index file (BAI or CSI) if the input is BAM file. In case the input is CRAM file, this will be ignored and the tool will generate CRAI file.",
                        "default": 0
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:toolDefaultValue": "1",
                        "id": "threads",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "-@",
                            "shellQuote": false,
                            "position": 1,
                            "valueFrom": "${\n    var self\n    if (self == 0) {\n        self = null;\n        inputs.threads = null\n    };\n\n\n    if (inputs.threads) {\n        if (inputs.in_index) {\n            var index_ext = [].concat(inputs.in_index)[0].path.substr([].concat(inputs.in_index)[0].path.lastIndexOf('.') + 1)\n            var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)\n            var index_format = 'BAI'\n            if (inputs.index_file_format) {\n                index_format = inputs.index_file_format\n            }\n            if (inputs.minimum_interval_size) {\n                index_format = ''\n            }\n\n            if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||\n                (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')) {\n                return\n            } else {\n                return inputs.threads\n            }\n        } else {\n            return inputs.threads\n        }\n    } else {\n        return\n    }\n}"
                        },
                        "label": "Number of threads",
                        "doc": "Number of threads.",
                        "default": 0
                    },
                    {
                        "sbg:category": "File Inputs",
                        "sbg:altPrefix": "--reference",
                        "id": "in_reference",
                        "type": "File?",
                        "label": "Reference file",
                        "doc": "A FASTA format reference file, optionally compressed by bgzip and ideally indexed by SAMtools Faidx. If an index is not present, one will be generated for you. This file is used for compression/decompression of CRAM files. Please provide reference file when using CRAM input/output file.",
                        "sbg:fileTypes": "FASTA, FA, FASTA.GZ, FA.GZ, GZ"
                    },
                    {
                        "sbg:category": "Platform Options",
                        "sbg:toolDefaultValue": "1500",
                        "id": "mem_per_job",
                        "type": "int?",
                        "label": "Memory per job",
                        "doc": "Memory per job in MB."
                    },
                    {
                        "sbg:category": "Platform Options",
                        "sbg:toolDefaultValue": "1",
                        "id": "cpu_per_job",
                        "type": "int?",
                        "label": "CPU per job",
                        "doc": "Number of CPUs per job."
                    }
                ],
                "outputs": [
                    {
                        "id": "indexed_data_file",
                        "doc": "Output BAM/CRAM, along with its index as secondary file.",
                        "label": "Indexed data file",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "${\n    if (inputs.output_indexed_data === true) {\n        return [].concat(inputs.in_alignments)[0].path.split(\"/\").pop()\n    } else {\n        return ''\n    }\n}",
                            "outputEval": "${\n    for (var i = 0; i < self.length; i++){\n        self[i] = inheritMetadata(self[i], inputs.in_alignments);\n        if (self.hasOwnProperty('secondaryFiles')){\n            for (var j = 0; j < self[i].secondaryFiles.length; j++){\n                self[i].secondaryFiles[j] = inheritMetadata(self[i].secondaryFiles[j], inputs.in_alignments);\n            }\n        }\n    }\n    return self;\n}"
                        },
                        "secondaryFiles": [
                            ".bai",
                            ".crai",
                            "^.bai",
                            "^.crai",
                            ".csi",
                            "^.csi"
                        ],
                        "sbg:fileTypes": "BAM, CRAM"
                    },
                    {
                        "id": "out_index",
                        "doc": "Generated index file (without the indexed data).",
                        "label": "Generated index file",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "${\n    var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)\n    if (input_ext.toUpperCase() === 'CRAM') {\n        return '*.crai'\n    } else if (input_ext.toUpperCase() === 'BAM') {\n        var index_format = 'BAI'\n        if (inputs.index_file_format) {\n            index_format = inputs.index_file_format\n        }\n        if (inputs.minimum_interval_size) {\n            index_format = 'CSI'\n        }\n        return '*.' + index_format.toLowerCase()\n    }\n}",
                            "outputEval": "${\n    if (inputs.in_index) {\n        for (var i = 0; i < self.length; i++){\n                self[i] = inheritMetadata(self[i], inputs.in_index);\n    }\n    return self\n    }\n    else {\n    for (var i = 0; i < self.length; i++){\n                self[i] = inheritMetadata(self[i], inputs.in_alignments);\n    }\n    return self;\n    }\n}"
                        },
                        "sbg:fileTypes": "BAI, CRAI, CSI"
                    }
                ],
                "doc": "**SAMtools Index** tool is used to index a coordinate-sorted BAM or CRAM file for fast random access. Note that this does not work with SAM files even if they are bgzip compressed — to index such files, use tabix instead. This index is needed when region arguments are used to limit **SAMtools View** and similar commands to particular regions of interest. For a CRAM file aln.cram, index file aln.cram.crai will be created; for a BAM file aln.bam, either aln.bam.bai or aln.bam.csi will be created, depending on the index format selected [1].\n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the bottom of the page.*\n\n###Common Use Cases \n\n- When using this tool as a standalone tool, **Input index file** should not be provided. This input is given as an option that is convenient to use in workflows. \n- When using this tool in a workflow, **Input index file** can be provided. In case it is provided, tool execution will be skipped and it will just pass the inputs through. This is useful for workflows which use tools that require an index file when it is not known in advance if the input BAM/CRAM file will have accompanying index file present in the project. If the next tool in the workflow requires an index file as a secondary file, parameter **Output indexed data file** should be set to True. This will provide a BAM/CRAM file at the **Indexed data file** output port along with its index file (BAI/CSI/CRAI) as the secondary file.\n- If a CRAM file is provided at the **BAM/CRAM input file** port, the tool will generate a CRAI index file. If a BAM file is provided, the tool will generate a BAI or CSI index file depending on the parameter **Format of index file (for BAM files)** (`-b/-c`). If no value is set, the tool will generate a BAI index file. Setting the parameter **Minimum interval size (2^INT)** (`-m`) will force the CSI format regardless of the value of the parameter **Format of index file (for BAM files)**.\n\n###Changes Introduced by Seven Bridges\n\n- Parameter **Output filename** is omitted from the wrapper. For a CRAM file aln.cram, output filename will be aln.cram.crai; for a BAM file aln.bam, it will be either aln.bam.bai or aln.bam.csi, depending on the index format selected.\n- Parameter **Output indexed data file** and file input **Input index file** are added to provide additional options for integration with other tools within a workflow. \n\n###Common Issues and Important Notes\n\n- **BAM/CRAM input file** should be sorted by coordinates, not by name. Otherwise, the task will fail.\n- **When using this tool in a workflow, if the next tool in the workflow requires index file as a secondary file, parameter Output indexed data file should be set to True. This will provide BAM/CRAM file at Indexed data file output port along with its index file (BAI/CSI/CRAI) as secondary file.**\n\n###Performance Benchmarking\n\nMultithreading can be enabled by setting parameter **Number of threads** (`-@`). In the following table you can find estimates of **SAMtools Index** running time and cost.\n\n*Cost can be significantly reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*  \n\n| Input type | Input size | # of reads | Read length |  # of threads | Duration | Cost | Instance (AWS)|\n|---------------|--------------|---------------|------------------|---------------------|-------------|--------|-------------|\n|  BAM | 5.26 GB | 71.5M | 76 | 1 | 4min. | \\$0.04 | c4.2xlarge |\n|  BAM | 11.86 GB | 161.2M | 101| 1 | 10min. | \\$0.09 | c4.2xlarge |\n|  BAM | 18.36 GB | 179M | 76 | 1 | 12min. | \\$0.11 | c4.2xlarge |\n|  BAM | 58.61 GB | 845.6M | 150 | 1 | 36min. | \\$0.32 | c4.2xlarge |\n|  BAM | 5.26 GB | 71.5M | 76 | 8 | 3min. | \\$0.03 | c4.2xlarge |\n|  BAM | 11.86 GB | 161.2M | 101| 8 | 9min. | \\$0.08 | c4.2xlarge |\n|  BAM | 18.36 GB | 179M | 76 | 8 | 11min. | \\$0.10 | c4.2xlarge |\n|  BAM | 58.61 GB | 845.6M | 150 | 8 | 30min. | \\$0.27 | c4.2xlarge |\n\n###References\n\n[1] [SAMtools documentation](http://www.htslib.org/doc/samtools-1.9.html)",
                "label": "Samtools Index CWL1.0",
                "arguments": [
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "${\n    if (inputs.in_index) {\n        var index_ext = [].concat(inputs.in_index)[0].path.substr([].concat(inputs.in_index)[0].path.lastIndexOf('.') + 1)\n        var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)\n        var index_format = 'BAI'\n        if (inputs.index_file_format) {\n            index_format = inputs.index_file_format\n        }\n        if (inputs.minimum_interval_size) {\n            index_format = ''\n        }\n\n        if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||\n            (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')) {\n            return \"echo Skipping index step because an index file is provided on the input.\"\n        } else {\n            return \"/opt/samtools-1.9/samtools index\"\n        }\n    } else {\n        return \"/opt/samtools-1.9/samtools index\"\n    }\n}"
                    },
                    {
                        "shellQuote": false,
                        "position": 1001,
                        "valueFrom": "&& echo $REF_PATH"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "ResourceRequirement",
                        "ramMin": "${\n    if (inputs.mem_per_job) {\n        return inputs.mem_per_job\n    }\n    else {\n        return 1500\n    }\n}",
                        "coresMin": "${\n    if (inputs.cpu_per_job) {\n        return inputs.cpu_per_job\n    }\n    else {\n    var threads = 1\n    if (inputs.threads) {\n        threads = inputs.threads\n    }\n\n    if (inputs.in_index) {\n        var index_ext = [].concat(inputs.in_index)[0].path.substr([].concat(inputs.in_index)[0].path.lastIndexOf('.') + 1)\n        var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)\n        var index_format = 'BAI'\n        if (inputs.index_file_format) {\n            index_format = inputs.index_file_format\n        }\n        if (inputs.minimum_interval_size) {\n            index_format = ''\n        }\n\n        if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||\n            (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')) {\n            return 1\n        } else {\n            return threads\n        }\n    } else {\n        return threads\n    }\n    }\n}"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerImageId": "2fb927277493",
                        "dockerPull": "images.sbgenomics.com/jrandjelovic/samtools-1-9:1"
                    },
                    {
                        "class": "InitialWorkDirRequirement",
                        "listing": [
                            "$(inputs.in_alignments)",
                            "$(inputs.in_index)",
                            "$(inputs.in_reference)"
                        ]
                    },
                    {
                        "class": "InlineJavascriptRequirement",
                        "expressionLib": [
                            "var setMetadata = function(file, metadata) {\n    if (!('metadata' in file)) {\n        file['metadata'] = {}\n    }\n    for (var key in metadata) {\n        file['metadata'][key] = metadata[key];\n    }\n    return file\n};\n\nvar inheritMetadata = function(o1, o2) {\n    var commonMetadata = {};\n    if (!o2) {\n        return o1;\n    };\n    if (!Array.isArray(o2)) {\n        o2 = [o2]\n    }\n    for (var i = 0; i < o2.length; i++) {\n        var example = o2[i]['metadata'];\n        for (var key in example) {\n            if (i == 0)\n                commonMetadata[key] = example[key];\n            else {\n                if (!(commonMetadata[key] == example[key])) {\n                    delete commonMetadata[key]\n                }\n            }\n        }\n        for (var key in commonMetadata) {\n            if (!(key in example)) {\n                delete commonMetadata[key]\n            }\n        }\n    }\n    if (!Array.isArray(o1)) {\n        o1 = setMetadata(o1, commonMetadata)\n    } else {\n        for (var i = 0; i < o1.length; i++) {\n            o1[i] = setMetadata(o1[i], commonMetadata)\n        }\n    }\n    return o1;\n};\n"
                        ]
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:saveLogs",
                        "value": "path.log"
                    },
                    {
                        "class": "sbg:saveLogs",
                        "value": "job.tree.log"
                    }
                ],
                "stdout": "path.log",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1576244143,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1576244335,
                        "sbg:revisionNotes": "Final version"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1576244335,
                        "sbg:revisionNotes": "Description and tool default values edited."
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1576244335,
                        "sbg:revisionNotes": "English edited and CWL1.0 tag added."
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1576244335,
                        "sbg:revisionNotes": "Set default value for index_file_format"
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1576244336,
                        "sbg:revisionNotes": "Description edited - references put before full stop"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1576244336,
                        "sbg:revisionNotes": "Categories edited"
                    }
                ],
                "sbg:image_url": null,
                "sbg:cmdPreview": "/opt/samtools-1.9/samtools index /path/to/file.bam",
                "sbg:license": "MIT License",
                "sbg:links": [
                    {
                        "id": "http://www.htslib.org/",
                        "label": "Homepage"
                    },
                    {
                        "id": "https://github.com/samtools/samtools",
                        "label": "Source Code"
                    },
                    {
                        "id": "https://github.com/samtools/samtools/wiki",
                        "label": "Wiki"
                    },
                    {
                        "id": "https://sourceforge.net/projects/samtools/files/",
                        "label": "Download"
                    },
                    {
                        "id": "http://www.ncbi.nlm.nih.gov/pubmed/19505943",
                        "label": "Publication"
                    },
                    {
                        "id": "http://www.htslib.org/doc/samtools-1.9.html",
                        "label": "Documentation"
                    }
                ],
                "sbg:toolAuthor": "Heng Li (Sanger Institute), Bob Handsaker (Broad Institute), Jue Ruan (Beijing Genome Institute), Colin Hercus, Petr Danecek",
                "sbg:toolkit": "SAMtools",
                "sbg:toolkitVersion": "1.9",
                "sbg:projectName": "SBG Public Data",
                "sbg:categories": [
                    "Utilities",
                    "BAM Processing",
                    "CWL1.0"
                ],
                "sbg:appVersion": [
                    "v1.0"
                ],
                "sbg:id": "admin/sbg-public-data/samtools-index-1-9-cwl1-0/6",
                "sbg:revision": 6,
                "sbg:revisionNotes": "Categories edited",
                "sbg:modifiedOn": 1576244336,
                "sbg:modifiedBy": "admin",
                "sbg:createdOn": 1576244143,
                "sbg:createdBy": "admin",
                "sbg:project": "admin/sbg-public-data",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "admin"
                ],
                "sbg:latestRevision": 6,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a24d970ada7186ed353878e9c7ef2d2d22b210747468bef952668b223a1212fa2"
            },
            "label": "Samtools Index CWL1.0",
            "sbg:x": 86,
            "sbg:y": -118.79998779296875
        }
    ],
    "requirements": [
        {
            "class": "InlineJavascriptRequirement"
        },
        {
            "class": "StepInputExpressionRequirement"
        }
    ],
    "sbg:projectName": "variant calling pipeline development project",
    "sbg:revisionsInfo": [
        {
            "sbg:revision": 0,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1609785185,
            "sbg:revisionNotes": null
        },
        {
            "sbg:revision": 1,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1609785520,
            "sbg:revisionNotes": "set up"
        },
        {
            "sbg:revision": 2,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1609785576,
            "sbg:revisionNotes": "number changed don't scroll"
        },
        {
            "sbg:revision": 3,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1612798561,
            "sbg:revisionNotes": "one of the numbers changed"
        },
        {
            "sbg:revision": 4,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1612798591,
            "sbg:revisionNotes": "changed to bam to see where the files are disappearing"
        },
        {
            "sbg:revision": 5,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1612807790,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 6,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1612807801,
            "sbg:revisionNotes": ""
        }
    ],
    "sbg:image_url": "https://platform.sb.biodatacatalyst.nhlbi.nih.gov/ns/brood/images/dave/variant-calling-pipeline-development-project/fully-unmapped/6.png",
    "sbg:appVersion": [
        "v1.1",
        "v1.0"
    ],
    "sbg:id": "dave/variant-calling-pipeline-development-project/fully-unmapped/6",
    "sbg:revision": 6,
    "sbg:revisionNotes": "",
    "sbg:modifiedOn": 1612807801,
    "sbg:modifiedBy": "jolvany",
    "sbg:createdOn": 1609785185,
    "sbg:createdBy": "jolvany",
    "sbg:project": "dave/variant-calling-pipeline-development-project",
    "sbg:sbgMaintained": false,
    "sbg:validationErrors": [],
    "sbg:contributors": [
        "jolvany"
    ],
    "sbg:latestRevision": 6,
    "sbg:publisher": "sbg",
    "sbg:content_hash": "a4e79c7eadb41b0bab790af7dacde3c040c3496615ba8eb679d161c83ee39b8a0",
    "sbg:workflowLanguage": "CWL"
}