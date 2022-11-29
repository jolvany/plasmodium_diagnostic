{
    "class": "Workflow",
    "cwlVersion": "v1.2",
    "id": "jolvany/topmed-a6k-unmapped-ghana/cram-to-bam/7",
    "label": "cram to bam",
    "$namespaces": {
        "sbg": "https://sevenbridges.com"
    },
    "inputs": [
        {
            "id": "input_bam_or_sam_file",
            "sbg:fileTypes": "BAM, SAM, CRAM",
            "type": "File",
            "label": "Input BAM/SAM/CRAM file",
            "doc": "Input BAM/SAM/CRAM file.",
            "sbg:x": -659.39990234375,
            "sbg:y": -279
        },
        {
            "id": "bowtie_index_archive",
            "sbg:fileTypes": "TAR",
            "type": "File",
            "label": "Bowtie index archive",
            "doc": "Archive file produced by Bowtie2 Indexer.",
            "sbg:x": -53.89990234375,
            "sbg:y": 36.5
        }
    ],
    "outputs": [
        {
            "id": "result_sam_file",
            "outputSource": [
                "bowtie2_aligner/result_sam_file"
            ],
            "sbg:fileTypes": "SAM",
            "type": "File?",
            "label": "Result SAM file",
            "doc": "SAM file containing the results of the alignment. It contains both aligned and unaligned reads.",
            "sbg:x": 368.35009765625,
            "sbg:y": -141
        },
        {
            "id": "aligned_reads_only",
            "outputSource": [
                "bowtie2_aligner/aligned_reads_only"
            ],
            "sbg:fileTypes": "FASTQ, FASTQ.GZ, FASTQ.BZ2",
            "type": "File[]?",
            "label": "Aligned reads only",
            "doc": "FASTQ file with reads that align at least once.",
            "sbg:x": 385.10009765625,
            "sbg:y": -31
        }
    ],
    "steps": [
        {
            "id": "samtools_view_1_6",
            "in": [
                {
                    "id": "include_header",
                    "default": true
                },
                {
                    "id": "input_bam_or_sam_file",
                    "source": "input_bam_or_sam_file"
                },
                {
                    "id": "output_format",
                    "default": "BAM"
                },
                {
                    "id": "output_filename",
                    "valueFrom": "${return inputs.in_alignments.nameroot+\".bam\"}"
                }
            ],
            "out": [
                {
                    "id": "output_bam_or_sam_or_cram_file"
                },
                {
                    "id": "reads_not_selected_by_filters"
                },
                {
                    "id": "alignement_count"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "jolvany/topmed-a6k-unmapped-ghana/samtools-view-1-6/0",
                "label": "SAMtools View",
                "description": "**SAMtools View** tool when used with no options or regions specified, prints all alignments in the specified input alignment file (in SAM, BAM, or CRAM format) to output file in SAM format (with no header). You may specify one or more space-separated region specifications to restrict output to only those alignments which overlap the specified region(s). Use of region specifications requires a coordinate-sorted and indexed input file (in BAM or CRAM format). [1]\n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the bottom of the page.*\n\n####Regions\n\nRegions can be specified as: RNAME[:STARTPOS[-ENDPOS]] and all position coordinates are 1-based. \n\n**Important note:** when multiple regions are given, some alignments may be output multiple times if they overlap more than one of the specified regions.\n\nExamples of region specifications:\n\n- **chr1**  - Output all alignments mapped to the reference sequence named `chr1' (i.e. @SQ SN:chr1).\n\n- **chr2:1000000** - The region on chr2 beginning at base position 1,000,000 and ending at the end of the chromosome.\n\n- **chr3:1000-2000** - The 1001bp region on chr3 beginning at base position 1,000 and ending at base position 2,000 (including both end positions).\n\n- **'\\*'** - Output the unmapped reads at the end of the file. (This does not include any unmapped reads placed on a reference sequence alongside their mapped mates.)\n\n- **.** - Output all alignments. (Mostly unnecessary as not specifying a region at all has the same effect.) [1]\n\n###Common Use Cases\n\nThis tool can be used for: \n\n- Filtering BAM/SAM/CRAM files - options set by following parameters and input files: **Include reads with all of these flags** (`-f`), **Exclude reads with any of these flags** (`-F`), **Exclude reads with all of these flags** (`-G`), **Read group** (`-r`), **Minimum mapping quality** (`-q`), **Only include alignments in library** (`-l`), **Minimum number of CIGAR bases consuming query sequence** (`-m`), **Subsample fraction** (`-s`), **Read group list** (`-R`), **BED region file** (`-L`)\n- Format conversion between SAM/BAM/CRAM formats - set by following parameters: **Output format** (`--output-fmt/-O`), **Fast bam compression** (`-1`), **Output uncompressed BAM** (`-u`)\n- Modification of the data which is contained in each alignment - set by following parameters: **Collapse the backward CIGAR operation** (`-B`), **Read tags to strip** (`-x`)\n- Counting number of alignments in SAM/BAM/CRAM file - set by parameter **Output only count of matching records** (`-c`)\n\n###Changes Introduced by Seven Bridges\n\n- Parameters **Output BAM** (`-b`) and **Output CRAM** (`-C`) were excluded from wrapper since they are redundant with parameter **Output format** (`--output-fmt/-O`).\n- Parameter **Input format** (`-S`) was excluded from wrapper since it is ignored by the tool (input format is auto-detected).\n- Input file **Index file** was added to the wrapper to enable operations that require index file for BAM/CRAM files.\n- Parameter **Number of threads** (`--threads/-@`) specifies total number of threads instead of additional threads. Command line argument (`--threads/-@`) will be reduced by 1 to set number of additional threads.\n\n###Common Issues and Important Notes\n\n- When multiple regions are given, some alignments may be output multiple times if they overlap more than one of the specified regions. [1]\n- Use of region specifications requires a coordinate-sorted and indexed input file (in BAM or CRAM format). [1]\n- Option **Output uncompressed BAM** (`-u`) saves time spent on compression/decompression and is thus preferred when the output is piped to another SAMtools command. [1]\n\n###Performance Benchmarking\n\nMultithreading can be enabled by setting parameter **Number of threads** (`--threads/-@`). In the following table you can find estimates of **SAMtools View** running time and cost. \n\n*Cost can be significantly reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*  \n\n| Input type | Input size | # of reads | Read length | Output format | # of threads | Duration | Cost | Instance (AWS)|\n|---------------|--------------|-----------------|---------------|------------------|-------------------|-----------------|-------------|--------|-------------|\n| BAM | 5.26 GB | 71.5M | 76 | BAM | 1 | 14min. | \\$0.09 | c4.2xlarge |\n| BAM | 11.86 GB | 161.2M | 101 | BAM | 1 | 35min. | \\$0.23 | c4.2xlarge |\n| BAM | 18.36 GB | 179M | 76 | BAM | 1 | 59min. | \\$0.39 | c4.2xlarge |\n| BAM | 58.61 GB | 845.6M | 150 | BAM | 1 | 3h 17min. | \\$1.31 | c4.2xlarge |\n| BAM | 5.26 GB | 71.5M | 76 | BAM | 8 | 7min. | \\$0.05 | c4.2xlarge |\n| BAM | 11.86 GB | 161.2M | 101 | BAM | 8 | 12min. | \\$0.08 | c4.2xlarge |\n| BAM | 18.36 GB | 179M | 76 | BAM | 8 | 18min. | \\$0.12 | c4.2xlarge |\n| BAM | 58.61 GB | 845.6M | 150 | BAM | 8 | 55min. | \\$0.36 | c4.2xlarge |\n| BAM | 5.26 GB | 71.5M | 76 | SAM | 8 | 12min. | \\$0.08 | c4.2xlarge |\n| BAM | 11.86 GB | 161.2M | 101 | SAM | 8 | 18min. | \\$0.12 | c4.2xlarge |\n| BAM | 18.36 GB | 179M | 76 | SAM | 8 | 26min. | \\$0.17 | c4.2xlarge |\n| BAM | 58.61 GB | 845.6M | 150 | SAM | 8 | 1h 44min. | \\$0.69 | c4.2xlarge |\n\n###References\n\n[1] [SAMtools documentation](http://www.htslib.org/doc/samtools-1.6.html)",
                "baseCommand": [
                    "/opt/samtools-1.6/samtools",
                    "view"
                ],
                "inputs": [
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 2,
                            "prefix": "-1",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Fast BAM compression",
                        "description": "Enable fast BAM compression (implies output in bam format).",
                        "id": "#fast_bam_compression"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 3,
                            "prefix": "-u",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Output uncompressed BAM",
                        "description": "Output uncompressed BAM (implies output BAM format). This option saves time spent on compression/decompression and is thus preferred when the output is piped to another SAMtools command.",
                        "id": "#uncompressed_bam"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 4,
                            "prefix": "-h",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Include the header in the output",
                        "description": "Include the header in the output.",
                        "id": "#include_header"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 5,
                            "prefix": "-H",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Output the header only",
                        "description": "Output the header only.",
                        "id": "#output_header_only"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 15,
                            "prefix": "-c",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Output only count of matching records",
                        "description": "Instead of outputing the alignments, only count them and output the total number. All filter options, such as -f, -F, and -q, are taken into account.",
                        "id": "#count_alignments"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "sbg:stageInput": "link",
                        "type": [
                            "null",
                            "File"
                        ],
                        "inputBinding": {
                            "position": 25,
                            "prefix": "-t",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "List of reference names and lengths",
                        "description": "A tab-delimited file. Each line must contain the reference name in the first column and the length of the reference in the second column, with one line for each distinct reference. Any additional fields beyond the second column are ignored. This file also defines the order of the reference sequences in sorting. If you run SAMtools Faidx on reference FASTA file (<ref.fa>), the resulting index file <ref.fa>.fai can be used as this file.",
                        "sbg:fileTypes": "FAI, TSV, TXT",
                        "id": "#reference_file_list"
                    },
                    {
                        "sbg:altPrefix": "-T",
                        "sbg:category": "File Inputs",
                        "sbg:stageInput": "link",
                        "type": [
                            "null",
                            "File"
                        ],
                        "inputBinding": {
                            "position": 24,
                            "prefix": "--reference",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Reference file",
                        "description": "A FASTA format reference file, optionally compressed by bgzip and ideally indexed by SAMtools Faidx. If an index is not present, one will be generated for you. This file is used for compression/decompression of CRAM files. Please provide reference file when using CRAM input/output file.",
                        "sbg:fileTypes": "FASTA, FA, FASTA.GZ, FA.GZ, GZ",
                        "id": "#reference_file"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "type": [
                            "null",
                            "File"
                        ],
                        "inputBinding": {
                            "position": 22,
                            "prefix": "-L",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "BED region file",
                        "description": "Only output alignments overlapping the input BED file.",
                        "sbg:fileTypes": "BED",
                        "id": "#bed_file"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 10,
                            "prefix": "-r",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Read group",
                        "description": "Only output reads in the specified read group.",
                        "id": "#read_group"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "type": [
                            "null",
                            "File"
                        ],
                        "inputBinding": {
                            "position": 23,
                            "prefix": "-R",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Read group list",
                        "description": "Output alignments in read groups listed in this file.",
                        "sbg:fileTypes": "TXT",
                        "id": "#read_group_list"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 11,
                            "prefix": "-q",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Minimum mapping quality",
                        "description": "Skip alignments with MAPQ smaller than this value.",
                        "id": "#filter_mapq"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 12,
                            "prefix": "-l",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Only include alignments in library",
                        "description": "Only output alignments in this library.",
                        "id": "#filter_library"
                    },
                    {
                        "sbg:toolDefaultValue": "0",
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 13,
                            "prefix": "-m",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Minimum number of CIGAR bases consuming query sequence",
                        "description": "Only output alignments with number of CIGAR bases consuming query sequence  ≥ INT.",
                        "id": "#min_cigar_operations"
                    },
                    {
                        "sbg:toolDefaultValue": "0",
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 7,
                            "prefix": "-f",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Include reads with all of these flags",
                        "description": "Only output alignments with all bits set in this integer present in the FLAG field.",
                        "id": "#filter_include"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "string"
                            }
                        ],
                        "inputBinding": {
                            "position": 14,
                            "prefix": "-x",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Read tags to strip",
                        "description": "Read tag to exclude from output (repeatable).",
                        "id": "#read_tag_to_strip"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 6,
                            "prefix": "-B",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Collapse the backward CIGAR operation",
                        "description": "Collapse the backward CIGAR operation.",
                        "id": "#collapse_cigar"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "float"
                        ],
                        "inputBinding": {
                            "position": 18,
                            "prefix": "-s",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Subsample fraction",
                        "description": "Output only a proportion of the input alignments. This subsampling acts in the same way on all of the alignment records in the same template or read pair, so it never keeps a read but not its mate. The integer and fractional parts of the INT.FRAC are used separately: the part after the decimal point sets the fraction of templates/pairs to be kept, while the integer part is used as a seed that influences which subset of reads is kept. When subsampling data that has previously been subsampled, be sure to use a different seed value from those used previously; otherwise more reads will be retained than expected.",
                        "id": "#subsample_fraction"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "type": [
                            "File"
                        ],
                        "inputBinding": {
                            "position": 99,
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Input BAM/SAM/CRAM file",
                        "description": "Input BAM/SAM/CRAM file.",
                        "sbg:fileTypes": "BAM, SAM, CRAM",
                        "id": "#input_bam_or_sam_file"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "string"
                            }
                        ],
                        "inputBinding": {
                            "position": 100,
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Regions array",
                        "description": "With no options or regions specified, prints all alignments in the specified input alignment file (in SAM, BAM, or CRAM format) to output file in specified format. Use of region specifications requires a coordinate-sorted and indexed input file (in BAM or CRAM format). Regions can be specified as: RNAME[:STARTPOS[-ENDPOS]] and all position coordinates are 1-based.  Important note: when multiple regions are given, some alignments may be output multiple times if they overlap more than one of the specified regions. Examples of region specifications:  chr1 - Output all alignments mapped to the reference sequence named `chr1' (i.e. @SQ SN:chr1);  chr2:1000000 - The region on chr2 beginning at base position 1,000,000 and ending at the end of the chromosome;  chr3:1000-2000 - The 1001bp region on chr3 beginning at base position 1,000 and ending at base position 2,000 (including both end positions);  '*' - Output the unmapped reads at the end of the file (this does not include any unmapped reads placed on a reference sequence alongside their mapped mates.);  . - Output all alignments (mostly unnecessary as not specifying a region at all has the same effect).",
                        "id": "#regions_array"
                    },
                    {
                        "sbg:category": "File Inputs",
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Index file",
                        "description": "This tool requires index file for some use cases.",
                        "sbg:fileTypes": "BAI, CRAI, CSI",
                        "id": "#index_file"
                    },
                    {
                        "sbg:toolDefaultValue": "1",
                        "sbg:altPrefix": "-@",
                        "sbg:category": "Execution",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 19,
                            "prefix": "--threads",
                            "separate": true,
                            "valueFrom": {
                                "script": "{\n  if($job.inputs.threads){\n    return $job.inputs.threads - 1\n  }\n  else{\n    return\n  }\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Number of threads",
                        "description": "Number of threads. SAMtools uses argument --threads/-@ to specify number of additional threads. This parameter sets total number of threads (and CPU cores). Command line argument will be reduced by 1 to set number of additional threads.",
                        "id": "#threads"
                    },
                    {
                        "sbg:altPrefix": "-O",
                        "sbg:category": "Config Inputs",
                        "sbg:stageInput": null,
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
                            "position": 1,
                            "prefix": "--output-fmt",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Output format",
                        "description": "Output format.",
                        "id": "#output_format"
                    },
                    {
                        "sbg:toolDefaultValue": "0",
                        "sbg:category": "Config Inputs",
                        "sbg:stageInput": null,
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 8,
                            "prefix": "-F",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Exclude reads with any of these flags",
                        "description": "Do not output alignments with any bits set in this integer present in the FLAG field.",
                        "id": "#filter_exclude_any"
                    },
                    {
                        "sbg:toolDefaultValue": "0",
                        "sbg:category": "Config Inputs",
                        "sbg:stageInput": null,
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 9,
                            "prefix": "-G",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Exclude reads with all of these flags",
                        "description": "Only exclude reads with all of the bits set in this integer present in the FLAG field.",
                        "id": "#filter_exclude_all"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 16,
                            "prefix": "--input-fmt-option",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Input file format option",
                        "description": "Specify a single input file format option in the form of OPTION or OPTION=VALUE.",
                        "id": "#input_fmt_option"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 17,
                            "prefix": "--output-fmt-option",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Output file format option",
                        "description": "Specify a single output file format option in the form of OPTION or OPTION=VALUE.",
                        "id": "#output_fmt_option"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 21,
                            "prefix": "-o",
                            "separate": true,
                            "valueFrom": {
                                "script": "{\n  if ($job.inputs.output_filename){\n    return $job.inputs.output_filename\n  }\n  input_filename = [].concat($job.inputs.input_bam_or_sam_file)[0].path.split('/').pop()\n  input_name_base = input_filename.split('.').slice(0,-1).join('.')\n  ext = 'sam'\n  if ($job.inputs.count_alignments){\n    return input_name_base + '.count.txt'\n  }\n  if ($job.inputs.uncompressed_bam || $job.inputs.fast_bam_compression){\n    ext = 'bam'\n  }\n  if ($job.inputs.output_format){\n    ext = $job.inputs.output_format.toLowerCase()\n  }\n  if ($job.inputs.output_header_only){\n    ext = 'header.' + ext\n  }\n  if ($job.inputs.subsample_fraction){\n    ext = 'subsample.' + ext\n  }\n  if ($job.inputs.bed_file || $job.inputs.read_group || $job.inputs.read_group_list ||\n      $job.inputs.filter_mapq || $job.inputs.filter_library || $job.inputs.min_cigar_operations ||\n      $job.inputs.filter_include || $job.inputs.filter_exclude_any || \n      $job.inputs.filter_exclude_all || $job.inputs.regions_array){\n    ext = 'filtered.' + ext\n  }\n    \n  return input_name_base + '.' + ext\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Output filename",
                        "description": "Define a filename of the output.",
                        "id": "#output_filename"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 20,
                            "prefix": "-U",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Filename for reads not selected by filters",
                        "description": "Write alignments that are not selected by the various filter options to this file. When this option is used, all alignments (or all alignments intersecting the regions specified) are written to either the output file or this file, but never both.",
                        "id": "#omitted_reads_filename"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Output BAM, SAM, or CRAM file",
                        "description": "The output file.",
                        "sbg:fileTypes": "BAM, SAM, CRAM",
                        "outputBinding": {
                            "glob": {
                                "script": "{\n  if ($job.inputs.output_filename){\n    return $job.inputs.output_filename\n  }\n  input_filename = [].concat($job.inputs.input_bam_or_sam_file)[0].path.split('/').pop()\n  input_name_base = input_filename.split('.').slice(0,-1). join('.')\n  ext = 'sam'\n  if ($job.inputs.count_alignments){\n    return \n  }\n  if ($job.inputs.uncompressed_bam || $job.inputs.fast_bam_compression){\n    ext = 'bam'\n  }\n  if ($job.inputs.output_format){\n    ext = $job.inputs.output_format.toLowerCase()\n  }\n  if ($job.inputs.output_header_only){\n    ext = 'header.' + ext\n  }\n  if ($job.inputs.subsample_fraction){\n    ext = 'subsample.' + ext\n  }\n  if ($job.inputs.bed_file || $job.inputs.read_group || $job.inputs.read_group_list ||\n      $job.inputs.filter_mapq || $job.inputs.filter_library || $job.inputs.min_cigar_operations ||\n      $job.inputs.filter_include || $job.inputs.filter_exclude_any || \n      $job.inputs.filter_exclude_all || $job.inputs.regions_array){\n    ext = 'filtered.' + ext\n  }\n    \n  return input_name_base + '.' + ext\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:inheritMetadataFrom": "#input_bam_or_sam_file"
                        },
                        "id": "#output_bam_or_sam_or_cram_file"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Reads not selected by filters",
                        "description": "File containing reads that are not selected by filters.",
                        "sbg:fileTypes": "BAM, SAM, CRAM",
                        "outputBinding": {
                            "glob": {
                                "script": "{\n  if ($job.inputs.omitted_reads_filename){\n    return $job.inputs.omitted_reads_filename\n  }\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:inheritMetadataFrom": "#input_bam_or_sam_file"
                        },
                        "id": "#reads_not_selected_by_filters"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Alignment count",
                        "description": "File containing number of alignments.",
                        "sbg:fileTypes": "TXT",
                        "outputBinding": {
                            "glob": {
                                "script": "{\n  input_filename = [].concat($job.inputs.input_bam_or_sam_file)[0].path.split('/').pop()\n  input_name_base = input_filename.split('.').slice(0,-1). join('.')\n  return input_name_base + '.count.txt'\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:inheritMetadataFrom": "#input_bam_or_sam_file"
                        },
                        "id": "#alignement_count"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "id": "#cwl-js-engine",
                        "requirements": [
                            {
                                "dockerPull": "rabix/js-engine",
                                "class": "DockerRequirement"
                            }
                        ]
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:CPURequirement",
                        "value": {
                            "script": "{\n  if($job.inputs.threads){\n    return $job.inputs.threads\n  }\n  else{\n    return 1\n  }\n}",
                            "engine": "#cwl-js-engine",
                            "class": "Expression"
                        }
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": {
                            "script": "{\n  mem_offset = 1000\n  if($job.inputs.reference_file){\n    mem_offset = mem_offset + 3000\n  }\n  if($job.inputs.threads){\n    threads = $job.inputs.threads\n  }\n  else{\n    threads = 1\n  }\n  return mem_offset + threads * 500\n}",
                            "engine": "#cwl-js-engine",
                            "class": "Expression"
                        }
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/milana_kaljevic/samtools:1.6"
                    }
                ],
                "sbg:image_url": null,
                "sbg:toolkit": "SAMtools",
                "sbg:projectName": "topmed-a6k-unmapped-ghana",
                "sbg:license": "MIT License",
                "sbg:toolAuthor": "Heng Li (Sanger Institute), Bob Handsaker (Broad Institute), Jue Ruan (Beijing Genome Institute), Colin Hercus, Petr Danecek",
                "sbg:toolkitVersion": "1.6",
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
                        "id": "https://sourceforge.net/projects/samtools/files/samtools/",
                        "label": "Download"
                    },
                    {
                        "id": "http://www.ncbi.nlm.nih.gov/pubmed/19505943",
                        "label": "Publication"
                    },
                    {
                        "id": "http://www.htslib.org/doc/samtools-1.6.html",
                        "label": "Documentation"
                    }
                ],
                "sbg:publisher": "sbg",
                "sbg:categories": [
                    "SAM/BAM-Processing",
                    "Converters"
                ],
                "sbg:cmdPreview": "/opt/samtools-1.6/samtools view  /path/to/input_bam_or_sam_file.bam",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "jolvany",
                        "sbg:modifiedOn": 1638306263,
                        "sbg:revisionNotes": "Copy of admin/sbg-public-data/samtools-view-1-6/4"
                    }
                ],
                "sbg:job": {
                    "inputs": {
                        "output_fmt_option": "",
                        "threads": 7,
                        "regions_array": null,
                        "min_cigar_operations": null,
                        "filter_library": "",
                        "output_format": "BAM",
                        "uncompressed_bam": false,
                        "read_group": "",
                        "read_tag_to_strip": null,
                        "filter_exclude_any": null,
                        "collapse_cigar": false,
                        "count_alignments": false,
                        "output_filename": "",
                        "include_header": false,
                        "input_bam_or_sam_file": {
                            "size": 0,
                            "path": "/path/to/input_bam_or_sam_file.bam",
                            "secondaryFiles": [],
                            "class": "File"
                        },
                        "input_fmt_option": "",
                        "omitted_reads_filename": "",
                        "output_header_only": false,
                        "filter_include": null,
                        "filter_exclude_all": null,
                        "filter_mapq": null,
                        "subsample_fraction": null,
                        "fast_bam_compression": false
                    },
                    "allocatedResources": {
                        "cpu": 7,
                        "mem": 4500
                    }
                },
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:id": "jolvany/topmed-a6k-unmapped-ghana/samtools-view-1-6/0",
                "sbg:revision": 0,
                "sbg:revisionNotes": "Copy of admin/sbg-public-data/samtools-view-1-6/4",
                "sbg:modifiedOn": 1638306263,
                "sbg:modifiedBy": "jolvany",
                "sbg:createdOn": 1638306263,
                "sbg:createdBy": "jolvany",
                "sbg:project": "jolvany/topmed-a6k-unmapped-ghana",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "jolvany"
                ],
                "sbg:latestRevision": 0,
                "sbg:content_hash": "a60b91662e47c43f5b1f32e08287bdd4f40d57d8a631ef23ac990b3f8e4134c97",
                "sbg:copyOf": "admin/sbg-public-data/samtools-view-1-6/4"
            },
            "label": "SAMtools View",
            "sbg:x": -438,
            "sbg:y": -168
        },
        {
            "id": "samtools_fasta_1_6",
            "in": [
                {
                    "id": "bam_file",
                    "source": "samtools_view_1_6/output_bam_or_sam_or_cram_file"
                },
                {
                    "id": "single_fasta_filename",
                    "valueFrom": "${return inputs.in_alignments.nameroot+\".fasta\"}"
                },
                {
                    "id": "single_fasta_file",
                    "default": true
                }
            ],
            "out": [
                {
                    "id": "paired_end_fasta"
                },
                {
                    "id": "unflagged_fasta"
                },
                {
                    "id": "singleton_fasta"
                },
                {
                    "id": "single_fasta"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "jolvany/topmed-a6k-unmapped-ghana/samtools-fasta-1-6/0",
                "label": "SAMtools FASTA",
                "description": "**SAMtools FASTA** tool converts a BAM or SAM into FASTA format. The FASTA files will be automatically compressed if the filenames have a .gz or .bgzf extention. [1]\n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the bottom of the page.*\n\n###Common Use Cases\n\n- Default use case provides two FASTA files as outputs (**Paired-end FASTA files**). If no parameter is set, this will be the case. The tool will output file with reads that are not properly flagged (**Unflagged reads FASTA file**) only in case this file is not empty. \n- If single FASTA file (with both paired end reads) is required, it should be specified by setting boolean parameter **Single FASTA file** to True. \n\n###Changes Introduced by Seven Bridges\n\n- Parameter **Single FASTA file** was added to parameter list to provide option for outputting single FASTA file with all the reads.\n- Parameter **Single FASTA filename** was added to parameter list to specify filename when **Single FASTA file** is set to True. This parameter is not mandatory. If **Single FASTA file** is set to True and **Single FASTA filename** is not specified, default value will be used (*input.fasta* for input **BAM/SAM file** named *input.bam*).\n- CRAM input was excluded from wrapper since it did not work in the cloud.\n- Input **Reference file** (`--reference`) was excluded from wrapper since it did not work with CRAM input in the cloud.\n- Parameter **Number of threads** (`--threads/-@`) specifies total number of threads instead of additional threads. Command line argument (`--threads/-@`) will be reduced by 1 to set number of additional threads.\n\n###Common Issues and Important Notes\n   \n- We had problem running **SAMtools FASTA** with CRAM input files in the cloud. If you need to use this tool with CRAM input files, please contact our support.   \n- When specifying output filenames, complete names should be used (including extensions). If the extension is .fasta.gz or .fasta.bgzf, output will be compressed. The tool does not validate extensions. If the extension is not valid, the task will not fail.\n\n###Performance Benchmarking\n\nIn the following table you can find estimates of **SAMtools FASTA** running time and cost. Parameter **Number of threads** (`--threads/-@`) can decrease running time (10% - 30% with 8 threads on c4.2xlarge instance (AWS)). \n\n*Cost can be significantly reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*  \n\n| Input type | Input size | Paired-end | # of reads | Read length |  # of threads | Duration | Cost | Instance (AWS)|\n|---------------|--------------|-----------------|---------------|------------------|-----------------|-------------|--------|-------------|\n| BAM | 5.26 GB | Yes | 71.5M | 76 | 1 | 8min. | \\$0.05 | c4.2xlarge |\n| BAM | 11.86 GB | Yes | 161.2M | 101 | 1 | 13min. | \\$0.09 | c4.2xlarge |\n| BAM | 18.36 GB | Yes | 179M | 76 | 1 | 16min. | \\$0.11 | c4.2xlarge |\n| BAM | 58.61 GB | Yes | 845.6M | 150 | 1 | 1h 5min. | \\$0.43 | c4.2xlarge |\n\n###References\n\n[1] [SAMtools documentation](http://www.htslib.org/doc/samtools-1.6.html)",
                "baseCommand": [
                    "/opt/samtools-1.6/samtools",
                    "fasta"
                ],
                "inputs": [
                    {
                        "sbg:category": "File Inputs",
                        "type": [
                            "File"
                        ],
                        "inputBinding": {
                            "position": 99,
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "BAM/SAM file",
                        "description": "Input BAM or SAM file.",
                        "sbg:fileTypes": "BAM, SAM",
                        "id": "#bam_file"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-0",
                            "separate": true,
                            "valueFrom": {
                                "script": "{\n  if ($job.inputs.single_fasta_file == true){\n  \treturn\n  }\n  else{\n    if ($job.inputs.read_0_filename){\n      return $job.inputs.read_0_filename\n    }\n    else{\n\t  bamname = [].concat($job.inputs.bam_file)[0].path.split('/')[[].concat($job.inputs.bam_file)[0].path.split('/').length - 1]\n\t  ext = bamname.split('.').pop().toLowerCase()\n      if ((ext == 'bam') || (ext == 'cram') || (ext == 'sam')){\n        return bamname.split('.').slice(0, bamname.split('.').length - 1).join('.') + '.pe_0.fasta'\n      }\n      else{\n        return bamname + '.pe_0.fasta'\n      }\n    }\n  }\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Unflagged reads filename",
                        "description": "Write reads with both or neither of the BAM_READ1 and BAM_READ2 flags set to this file.",
                        "id": "#read_0_filename"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-1",
                            "separate": true,
                            "valueFrom": {
                                "script": "{\n  if ($job.inputs.single_fasta_file == true){\n  \treturn\n  }\n  else{\n    if ($job.inputs.read_1_filename){\n      return $job.inputs.read_1_filename\n    }\n    else{\n\t  bamname = [].concat($job.inputs.bam_file)[0].path.split('/')[[].concat($job.inputs.bam_file)[0].path.split('/').length - 1]\n\t  ext = bamname.split('.').pop().toLowerCase()\n      if ((ext == 'bam') || (ext == 'cram') || (ext == 'sam')){\n        return bamname.split('.').slice(0, bamname.split('.').length - 1).join('.') + '.pe_1.fasta'\n      }\n      else{\n        return bamname + '.pe_1.fasta'\n      }\n    }\n  }\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Filename for BAM_READ1 flaged reads",
                        "description": "Write reads with the BAM_READ1 flag set to this file.",
                        "id": "#read_1_filename"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-2",
                            "separate": true,
                            "valueFrom": {
                                "script": "{\n  if ($job.inputs.single_fasta_file == true){\n  \treturn\n  }\n  else{\n    if ($job.inputs.read_2_filename){\n      return $job.inputs.read_2_filename\n    }\n    else{\n\t  bamname = [].concat($job.inputs.bam_file)[0].path.split('/')[[].concat($job.inputs.bam_file)[0].path.split('/').length - 1]\n\t  ext = bamname.split('.').pop().toLowerCase()\n      if ((ext == 'bam') || (ext == 'cram') || (ext == 'sam')){\n        return bamname.split('.').slice(0, bamname.split('.').length - 1).join('.') + '.pe_2.fasta'\n      }\n      else{\n        return bamname + '.pe_2.fasta'\n      }\n    }\n  }\n}  \n  \n",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Filename for BAM_READ2 flaged reads",
                        "description": "Write reads with the BAM_READ2 flag set to this file.",
                        "id": "#read_2_filename"
                    },
                    {
                        "sbg:toolDefaultValue": "0",
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-f",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Include reads with all of these flags",
                        "description": "Only output alignments with all bits set in this integer present in the FLAG field.",
                        "id": "#filter_include"
                    },
                    {
                        "sbg:toolDefaultValue": "0",
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-F",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Exclude reads with any of these flags",
                        "description": "Do not output alignments with any bits set in this integer present in the FLAG field.",
                        "id": "#filter_exclude_any"
                    },
                    {
                        "sbg:toolDefaultValue": "0",
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-G",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Exclude reads with all of these flags",
                        "description": "Only exclude reads with all of the bits set in this integer present in the FLAG field.",
                        "id": "#filter_exclude_all"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:stageInput": null,
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-n",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Don't append /1 and /2 to the read name",
                        "description": "By default, either '/1' or '/2' is added to the end of read names where the corresponding BAM_READ1 or BAM_READ2 flag is set. Setting this parameter causes read names to be left as they are.",
                        "id": "#do_not_append_read_number_to_name"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:stageInput": null,
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-N",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Always append /1 and /2 to the read name",
                        "description": "Always add either '/1' or '/2' to the end of read names even when put into different files.",
                        "id": "#always_append_read_number_to_name"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-s",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Singleton reads filename",
                        "description": "Write singleton reads in FASTA format to this file.",
                        "id": "#singleton_filename"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:stageInput": null,
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-t",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Copy RG, BC and QT tags to the FASTA header line",
                        "description": "Copy RG, BC and QT tags to the FASTA header line, if they exist.",
                        "id": "#copy_tags"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-T",
                            "separate": true,
                            "valueFrom": {
                                "script": "{\n  if($job.inputs.copy_taglist){\n    return $job.inputs.copy_taglist.replace(/ /g, '')\n  }\n  else{\n    return \n  }\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Taglist to copy to the FASTA header line",
                        "description": "Specify a comma-separated list of tags to copy to the FASTA header line, if they exist.",
                        "id": "#copy_taglist"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Single FASTA filename",
                        "description": "Filename of the output FASTA file if only one file is required.",
                        "id": "#single_fasta_filename"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "label": "Single FASTA file",
                        "description": "True if only one FASTA file is required as output.",
                        "id": "#single_fasta_file"
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--input-fmt-option",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Input file format option",
                        "description": "Specify a single input file format option in the form of OPTION or OPTION=VALUE.",
                        "id": "#input_fmt_option"
                    },
                    {
                        "sbg:toolDefaultValue": "0",
                        "sbg:altPrefix": "-@",
                        "sbg:category": "Execution",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--threads",
                            "separate": true,
                            "valueFrom": {
                                "script": "{\n  if($job.inputs.threads){\n    return $job.inputs.threads - 1\n  }\n  else{\n    return\n  }\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Number of threads",
                        "description": "Number of threads. SAMtools uses argument --threads/-@ to specify number of additional threads. This parameter sets total number of threads (and CPU cores). Command line argument will be reduced by 1 to set number of additional threads.",
                        "id": "#threads"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Paired-end FASTA files",
                        "description": "Output FASTA files.",
                        "sbg:fileTypes": "FASTA, FASTA.GZ, FASTA.BGZF, GZ, BGZF",
                        "outputBinding": {
                            "glob": {
                                "script": "{\n  if ($job.inputs.read_1_filename){\n    read1 = $job.inputs.read_1_filename\n  }\n  else{\n    read1 = '*pe_1.fasta*'\n  }\n  if ($job.inputs.read_2_filename){\n    read2 = $job.inputs.read_2_filename\n  }\n  else{\n    read2 = '*pe_2.fasta*'\n  }\n  return '{' + read1 + ',' + read2 + '}' \n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:inheritMetadataFrom": "#bam_file",
                            "outputEval": {
                                "script": "{\n  if($self){\n    for (i = 0; i<$self.length; i++){\n      if ($job.inputs.read_1_filename && \n          $self[i].path.split('/').slice(-1)[0] === $job.inputs.read_1_filename){\n        $self[i].metadata['paired_end'] = 1\n      }\n      else if($self[i].path.split('/').slice(-1)[0].split('.').slice(-2)[0] === 'pe_1'){\n        $self[i].metadata['paired_end'] = 1\n      }\n      if ($job.inputs.read_2_filename && \n          $self[i].path.split('/').slice(-1)[0] === $job.inputs.read_2_filename){\n        $self[i].metadata['paired_end'] = 2\n      }\n      else if($self[i].path.split('/').slice(-1)[0].split('.').slice(-2)[0] === 'pe_2'){\n        $self[i].metadata['paired_end'] = 2\n      }\n    }\n    return $self\n  }\n  return\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            }
                        },
                        "id": "#paired_end_fasta"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Unflagged reads FASTA file",
                        "description": "File consisting of  reads with both or neither of the BAM_READ1 and BAM_READ2 flags set.",
                        "sbg:fileTypes": "FASTA, FASTA.GZ, FASTA.BGZF, GZ, BGZF",
                        "outputBinding": {
                            "glob": {
                                "script": "{\n  if ($job.inputs.read_0_filename){\n    return $job.inputs.read_0_filename\n  }\n  else{\n    return '*pe_0.fasta*'\n  }\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:inheritMetadataFrom": "#bam_file",
                            "outputEval": {
                                "script": "{\n  if ($self[0]){\n    if ($self[0].size == 0){\n      return\n    }\n    else{\n      return $self\n    }\n  }\n  else{\n    return\n  }\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            }
                        },
                        "id": "#unflagged_fasta"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Singleton FASTA file",
                        "description": "FASTA file containing singleton reads.",
                        "sbg:fileTypes": "FASTA, FASTA.GZ, FASTA.BGZF, GZ, BGZF",
                        "outputBinding": {
                            "glob": {
                                "script": "{\n  if ($job.inputs.singleton_filename){\n    return $job.inputs.singleton_filename\n  }\n  else{ \n    return\n  }\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:inheritMetadataFrom": "#bam_file"
                        },
                        "id": "#singleton_fasta"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Single FASTA with all reads",
                        "description": "Single FASTA file with all reads (both paired ends).",
                        "sbg:fileTypes": "FASTA, FASTA.GZ, FASTA.BGZF, GZ, BGZF",
                        "outputBinding": {
                            "glob": {
                                "script": "{\n  if ($job.inputs.single_fasta_file){\n    if ($job.inputs.single_fasta_filename){\n      return $job.inputs.single_fasta_filename\n    }\n    else{\n      bamname = [].concat($job.inputs.bam_file)[0].path.split('/')[[].concat($job.inputs.bam_file)[0].path.split('/').length - 1]\n\t  ext = bamname.split('.').pop().toLowerCase()\n      if ((ext == 'bam') || (ext == 'cram') || (ext == 'sam')){\n        return bamname.split('.').slice(0, bamname.split('.').length - 1).join('.') + '.fasta'\n      }\n      else{\n        return bamname + '.fasta'\n      }\n    }\n  }\n  else{\n    return\n  }\n}",
                                "engine": "#cwl-js-engine",
                                "class": "Expression"
                            },
                            "sbg:inheritMetadataFrom": "#bam_file"
                        },
                        "id": "#single_fasta"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "id": "#cwl-js-engine",
                        "requirements": [
                            {
                                "dockerPull": "rabix/js-engine",
                                "class": "DockerRequirement"
                            }
                        ]
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:CPURequirement",
                        "value": {
                            "script": "{\n  if($job.inputs.threads){\n    return $job.inputs.threads\n  }\n  else{\n    return 1\n  }\n}",
                            "engine": "#cwl-js-engine",
                            "class": "Expression"
                        }
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": {
                            "script": "{\n  if($job.inputs.threads){\n    threads = $job.inputs.threads\n  }\n  else{\n    threads = 1\n  }\n  return 1000 + 500 * threads\n}",
                            "engine": "#cwl-js-engine",
                            "class": "Expression"
                        }
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/milana_kaljevic/samtools:1.6"
                    }
                ],
                "stdout": {
                    "script": "{\n  if ($job.inputs.single_fasta_file == true){\n    if ($job.inputs.single_fasta_filename){\n      return $job.inputs.single_fasta_filename\n    }\n  \telse{\n      bamname = [].concat($job.inputs.bam_file)[0].path.split('/')[[].concat($job.inputs.bam_file)[0].path.split('/').length - 1]\n\t  ext = bamname.split('.').pop().toLowerCase()\n      if ((ext == 'bam') || (ext == 'cram') || (ext == 'sam')){\n        return bamname.split('.').slice(0, bamname.split('.').length - 1).join('.') + '.fasta'\n      }\n      else{\n        return bamname + '.fasta'\n      }\n    }\n  }\n  else{\n    return\n  }\n}",
                    "engine": "#cwl-js-engine",
                    "class": "Expression"
                },
                "sbg:image_url": null,
                "sbg:toolkit": "SAMtools",
                "sbg:cmdPreview": "/opt/samtools-1.6/samtools fasta  /path/to/input.bam",
                "sbg:publisher": "sbg",
                "sbg:projectName": "topmed-a6k-unmapped-ghana",
                "sbg:license": "MIT License",
                "sbg:toolAuthor": "Heng Li (Sanger Institute), Bob Handsaker (Broad Institute), Jue Ruan (Beijing Genome Institute), Colin Hercus, Petr Danecek",
                "sbg:toolkitVersion": "1.6",
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
                        "id": "https://sourceforge.net/projects/samtools/files/samtools/",
                        "label": "Download"
                    },
                    {
                        "id": "http://www.ncbi.nlm.nih.gov/pubmed/19505943",
                        "label": "Publication"
                    },
                    {
                        "id": "http://www.htslib.org/doc/samtools-1.6.html",
                        "label": "Documentation"
                    }
                ],
                "sbg:categories": [
                    "SAM/BAM-Processing",
                    "FASTA-Processing",
                    "Converters"
                ],
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "jolvany",
                        "sbg:modifiedOn": 1638306158,
                        "sbg:revisionNotes": "Copy of admin/sbg-public-data/samtools-fasta-1-6/7"
                    }
                ],
                "sbg:job": {
                    "inputs": {
                        "bam_file": {
                            "size": 0,
                            "path": "/path/to/input.bam",
                            "secondaryFiles": [],
                            "class": "File"
                        },
                        "threads": null,
                        "always_append_read_number_to_name": false,
                        "read_0_filename": "",
                        "read_1_filename": "",
                        "copy_taglist": "",
                        "read_2_filename": "",
                        "input_fmt_option": "",
                        "single_fasta_file": false,
                        "do_not_append_read_number_to_name": false,
                        "filter_include": null,
                        "filter_exclude_all": null,
                        "filter_exclude_any": null,
                        "copy_tags": false,
                        "singleton_filename": "",
                        "single_fasta_filename": ""
                    },
                    "allocatedResources": {
                        "cpu": 1,
                        "mem": 1500
                    }
                },
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:id": "jolvany/topmed-a6k-unmapped-ghana/samtools-fasta-1-6/0",
                "sbg:revision": 0,
                "sbg:revisionNotes": "Copy of admin/sbg-public-data/samtools-fasta-1-6/7",
                "sbg:modifiedOn": 1638306158,
                "sbg:modifiedBy": "jolvany",
                "sbg:createdOn": 1638306158,
                "sbg:createdBy": "jolvany",
                "sbg:project": "jolvany/topmed-a6k-unmapped-ghana",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "jolvany"
                ],
                "sbg:latestRevision": 0,
                "sbg:content_hash": "a7daeb7172cbb9f2d4002bb50e9441f702550b2336fae2edf4f6e9fbfe4c6855e",
                "sbg:copyOf": "admin/sbg-public-data/samtools-fasta-1-6/7"
            },
            "label": "SAMtools FASTA",
            "sbg:x": -140.39990234375,
            "sbg:y": -162
        },
        {
            "id": "bowtie2_aligner",
            "in": [
                {
                    "id": "bowtie_index_archive",
                    "source": "bowtie_index_archive"
                },
                {
                    "id": "quality_scale",
                    "default": "Auto-detect"
                },
                {
                    "id": "preset_option",
                    "default": "Very sensitive"
                },
                {
                    "id": "ambiguous_character_penalty",
                    "default": 1
                },
                {
                    "id": "minimum_fragment_length",
                    "default": 75
                },
                {
                    "id": "read_sequence",
                    "source": [
                        "samtools_fasta_1_6/single_fasta"
                    ]
                },
                {
                    "id": "suppress_sam_records",
                    "default": true
                },
                {
                    "id": "input_fasta_files",
                    "default": true
                }
            ],
            "out": [
                {
                    "id": "result_sam_file"
                },
                {
                    "id": "aligned_reads_only"
                },
                {
                    "id": "unaligned_reads_only"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "jolvany/topmed-a6k-unmapped-ghana/bowtie2-aligner/0",
                "label": "Bowtie2 Aligner",
                "description": "Bowtie 2 is an ultrafast and memory-efficient tool for aligning sequencing reads to long reference sequences. It is particularly good at aligning reads of about 50 up to 100s or 1,000s of characters to relatively long (e.g. mammalian) genomes. Bowtie 2 indexes the genome with an [FM Index](http://portal.acm.org/citation.cfm?id=796543) (based on the [Burrows-Wheeler Transform](http://en.wikipedia.org/wiki/Burrows-Wheeler_transform) or [BWT](http://en.wikipedia.org/wiki/Burrows-Wheeler_transform)) to keep its memory footprint small: for the human genome, its memory footprint is typically around 3.2 gigabytes of RAM. In order to create needed index files, you should run [Bowtie2 Indexer](https://igor.sbgenomics.com/public/apps#tool/admin/sbg-public-data/bowtie2-indexer), which produces archived index files (containing 6 files with suffixes .1.bt2, .2.bt2, .3.bt2, .4.bt2, .rev.1.bt2, and .rev.2.bt2).\n\nBowtie 2 supports gapped, local, and paired-end alignment modes. Bowtie 2 outputs alignments in SAM format, enabling interoperation with a large number of other tools (e.g. [SAMtools](http://samtools.sourceforge.net/), [GATK](http://www.broadinstitute.org/gsa/wiki/index.php/The_Genome_Analysis_Toolkit)) that use SAM.\n\n###Common issues###\nNo issues have been reported.\n\n**Q&A:**\n\n***Q: What should I do if I already have Bowtie2 index files, not archived as tar bundle?***\n\n***A***: You can provide your *.bt2 files to [SBG Compressor](https://igor.sbgenomics.com/public/apps#admin/sbg-public-data/sbg-compressor-1-0/) app from our public apps and set \"TAR\" as your output format. After the task is finished, **you should assign common prefix of the index files to the `Reference genome` metadata field** and your TAR is ready for use.\n\n***Example:***\nIndexed files: chr20.1.bt2, chr20.2.bt2, chr20.3.bt2, chr20.4.bt2, chr20.rev.1.bt2, chr20.rev.2.bt2\n\nMetadata - `Reference genome`: **chr20**\n\n__Important note: In case of paired-end alignment it is crucial to set metadata 'paired-end' field to 1/2. Sequences specified as mate 1s must correspond file-for-file and read-for-read with those specified for mate 2s. Reads may be a mix of different lengths. In case of unpaired reads, the same metadata field should be set to '-'. Only one type of alignment can be performed at once, so all specified reads should be either paired or unpaired.__",
                "baseCommand": [
                    {
                        "class": "Expression",
                        "script": "{\n  var archive_name = $job.inputs.bowtie_index_archive.path.split(\"/\").pop()\n  return \"tar -xvf \".concat(archive_name, \" && rm -rf \", archive_name, \" && \")\n}",
                        "engine": "#cwl-js-engine"
                    },
                    "/opt/bowtie2-2.2.6/bowtie2"
                ],
                "inputs": [
                    {
                        "sbg:stageInput": "link",
                        "sbg:category": "Input files",
                        "type": [
                            "File"
                        ],
                        "label": "Bowtie index archive",
                        "description": "Archive file produced by Bowtie2 Indexer.",
                        "sbg:fileTypes": "TAR",
                        "id": "#bowtie_index_archive"
                    },
                    {
                        "sbg:category": "Alignment",
                        "sbg:toolDefaultValue": "End-to-end",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "End-to-end",
                                    "Local"
                                ],
                                "name": "alignment_mode"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "script": "{\n  if ($job.inputs.alignment_mode == \"Local\") {\n    return \"--local\"\n  }\n}",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Alignment mode",
                        "description": "Alignment mode. End-to-end: entire read must align; no clipping. Local: local alignment; ends might be soft clipped.",
                        "id": "#alignment_mode"
                    },
                    {
                        "sbg:altPrefix": "-s",
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "-",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--skip",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Skip reads",
                        "description": "Skip (i.e. do not align) the first given number of reads or pairs in the input.",
                        "id": "#skip_reads"
                    },
                    {
                        "sbg:altPrefix": "-u",
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "No limit",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--upto",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Align next n reads",
                        "description": "Align the first given number of reads or read pairs from the input (after the <int> reads or pairs have been skipped with \"Skip reads\"), then stop.",
                        "id": "#align_next_n_reads"
                    },
                    {
                        "sbg:altPrefix": "-5",
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "0",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--trim5",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Trim from 5'",
                        "description": "Trim given number of bases from 5' (left) end of each read before alignment.",
                        "id": "#trim_from_5"
                    },
                    {
                        "sbg:altPrefix": "-3",
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "0",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--trim3",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Trim from 3'",
                        "description": "Trim given number of bases from 3' (right) end of each read before alignment.",
                        "id": "#trim_from_3"
                    },
                    {
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "Phred+33",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "Auto-detect",
                                    "Phred+33",
                                    "Phred+64",
                                    "Solexa"
                                ],
                                "name": "quality_scale"
                            }
                        ],
                        "label": "Quality scale",
                        "description": "Set quality scale.",
                        "id": "#quality_scale"
                    },
                    {
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--int-quals",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Integer qualities",
                        "description": "Quality values are represented in the read input file as space-separated ASCII integers, e.g., 40 40 30 40..., rather than ASCII characters, e.g., II?I....",
                        "id": "#integer_qualities"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Alignment",
                        "sbg:toolDefaultValue": "0",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "0",
                                    "1"
                                ],
                                "name": "allowed_mismatch_number"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-N",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Allowed mismatch number",
                        "description": "Sets the number of mismatches to allowed in a seed alignment during multiseed alignment. Can be set to 0 or 1. Setting this higher makes alignment slower (often much slower) but increases sensitivity.",
                        "id": "#allowed_mismatch_number"
                    },
                    {
                        "sbg:category": "Alignment",
                        "sbg:toolDefaultValue": "22 or 20 (depending on preset type and alignment mode)",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-L",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Seed substring length",
                        "description": "Sets the length of the seed substrings to align during multiseed alignment. Smaller values make alignment slower but more senstive. Must be > 3 and < 32. The \"Sensitive\" preset is used by default, which sets this option to 22 in \"End-to-end\" mode and to 20 in \"Local\" mode.",
                        "id": "#seed_substring_length"
                    },
                    {
                        "sbg:category": "Alignment",
                        "sbg:toolDefaultValue": "15",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--dpad",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Dynamic padding",
                        "description": "\"Pads\" dynamic programming problems by the given number of columns on either side to allow gaps.",
                        "id": "#dynamic_padding"
                    },
                    {
                        "sbg:category": "Alignment",
                        "sbg:toolDefaultValue": "4",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--gbar",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Disallow gaps",
                        "description": "Disallow gaps within the given number of positions of the beginning or end of the read.",
                        "id": "#disallow_gaps"
                    },
                    {
                        "sbg:category": "Alignment",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--ignore-quals",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Ignore qualities",
                        "description": "When calculating a mismatch penalty, always consider the quality value at the mismatched position to be the highest possible, regardless of the actual value. I.e. treat all quality values as 30 on Phred scale. This is also the default behavior when the input doesn't specify quality values (e.g. when processing .fasta reads).",
                        "id": "#ignore_qualities"
                    },
                    {
                        "sbg:category": "Alignment",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--nofw",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Don't align forward",
                        "description": "If this option is specified, Bowtie2 will not attempt to align unpaired reads to the forward (Watson) reference strand. In paired-end mode, \"Don't align forward\" and \"Don't align reverse complement\" pertain to the fragments; i.e. specifying \"Don't align forward\" causes Bowtie2 to explore only those paired-end configurations corresponding to fragments from the reverse-complement (Crick) strand. Default: both strands enabled.",
                        "id": "#dont_align_forward"
                    },
                    {
                        "sbg:category": "Alignment",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--norc",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Don't align reverse complement",
                        "description": "If this option is specified, Bowtie2 will not attempt to align unpaired reads against the reverse-complement (Crick) reference strand. In paired-end mode, \"Don't align forward\" and \"Don't align reverse complement\" pertain to the fragments; i.e. specifying \"Don't align forward\" causes Bowtie2 to explore only those paired-end configurations corresponding to fragments from the reverse-complement (Crick) strand. Default: both strands enabled.",
                        "id": "#dont_align_reverse_complement"
                    },
                    {
                        "sbg:category": "Alignment",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--no-1mm-upfront",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Disable 1 mismatch alignments",
                        "description": "By default, Bowtie2 will attempt to find either an exact or a 1-mismatch end-to-end alignment for the read before trying the multiseed heuristic. Such alignments can be found very quickly, and many short read alignments have exact or near-exact end-to-end alignments. However, this can lead to unexpected alignments when the user also sets options governing the multiseed heuristic, like \"Seed substring length\" (-L) and \"Allowed mismatch number\" (-N). For instance, if the user specifies 0 for \"Allowed mismatch number\" and \"Seed substring length\" equal to the length of the read, the user will be surprised to find 1-mismatch alignments reported. This option prevents Bowtie2 from searching for 1-mismatch end-to-end alignments before using the multiseed heuristic, which leads to the expected behavior when combined with options such as \"Seed substring length\" and \"Allowed mismatch number\". This comes at the expense of speed.",
                        "id": "#disable_1_mismatch_alignments"
                    },
                    {
                        "sbg:category": "Presets",
                        "sbg:toolDefaultValue": "Sensitive",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "Very fast",
                                    "Fast",
                                    "Sensitive",
                                    "Very sensitive"
                                ],
                                "name": "preset_option"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "script": "{\n  var preset_option = $job.inputs.preset_option\n  var alignment_mode = $job.inputs.alignment_mode\n  \n  var presets = {\n    \"Very fast\": \"--very-fast\",\n    \"Fast\": \"--fast\",\n    \"Sensitive\": \"--sensitive\",\n    \"Very sensitive\": \"--very-sensitive\"\n  }\n  if (alignment_mode == \"Local\" && preset_option) {\n    return presets[preset_option].concat(\"-local\")\n  }\n  else if (preset_option){\n    return presets[preset_option]\n  }\n}",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Preset",
                        "description": "Preset options for \"Seed extension attempts\" (-D), \"Max number of re-seed\" (-R), \"Allowed mismatch number\" (-N), \"Seed substring length\" (-L) and \"Interval function\" (-i) parameters. Values for these options vary depending on whether the \"Local\" or \"End-to-end\" mode is selected under \"Alignment mode\".",
                        "id": "#preset_option"
                    },
                    {
                        "sbg:category": "Scoring",
                        "sbg:toolDefaultValue": "0 for \"End-to-end\" mode, 2 for \"Local\" mode",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--ma",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Set match bonus",
                        "description": "Sets the match bonus. The given number is added to the alignment score for each position where a read character aligns to a reference character and the characters match.",
                        "id": "#set_match_bonus"
                    },
                    {
                        "sbg:category": "Scoring",
                        "sbg:toolDefaultValue": "6",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--mp",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Maximum mismatch penalty",
                        "description": "Sets the maximum penalty for mismatch. Lower quality = lower penalty.",
                        "id": "#maximum_mismatch_penalty"
                    },
                    {
                        "sbg:category": "Scoring",
                        "sbg:toolDefaultValue": "1",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--np",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Ambiguous character penalty",
                        "description": "Sets penalty for positions where the read, reference, or both, contain an ambiguous character such as N.",
                        "id": "#ambiguous_character_penalty"
                    },
                    {
                        "sbg:category": "Scoring",
                        "sbg:toolDefaultValue": "5,3",
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "int"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--rdg",
                            "separate": true,
                            "itemSeparator": ",",
                            "sbg:cmdInclude": true
                        },
                        "label": "Read gap penalties",
                        "description": "Sets the read gap open (first value) and extend (second value) penalty, respectively. A read gap of length N gets a penalty of <gap-open-penalty> + N * <gap-extend-penalty>.",
                        "id": "#read_gap_penalties"
                    },
                    {
                        "sbg:category": "Scoring",
                        "sbg:toolDefaultValue": "5,3",
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "int"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--rfg",
                            "separate": true,
                            "itemSeparator": ",",
                            "sbg:cmdInclude": true
                        },
                        "label": "Reference gap penalties",
                        "description": "Sets the reference gap open (first value) and extend (second value) penalty, respectively. A reference gap of length N gets a penalty of <gap-open-penalty> + N * <gap-extend-penalty>.",
                        "id": "#reference_gap_penalties"
                    },
                    {
                        "sbg:category": "Reporting",
                        "sbg:toolDefaultValue": "-",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-k",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Report k alignments",
                        "description": "By default, Bowtie2 searches for distinct, valid alignments for each read. When it finds a valid alignment, it continues looking for alignments that are nearly as good or better. The best alignment found is reported (randomly selected from among best if tied). Information about the best alignments is used to estimate mapping quality and to set SAM optional fields, such as AS:i and XS:i. When \"Report k alignments\" is specified, however, Bowtie2 behaves differently. Instead, it searches for at most <given-number> distinct, valid alignments for each read. The search terminates when it can't find more distinct valid alignments, or when it finds <given-number>, whichever happens first. All alignments found are reported in descending order by alignment score. The alignment score for a paired-end alignment equals the sum of the alignment scores of the individual mates. Each reported read or pair alignment beyond the first has the SAM 'secondary' bit (which equals 256) set in its FLAGS field. For reads that have more than <given-number> distinct, valid alignments, Bowtie2 does not gaurantee that the <given-number> alignments reported are the best possible in terms of alignment score. \"Report k alignments\" is mutually exclusive with \"Report all alignments\". Note: Bowtie 2 is not designed with large values for \"Report k alignments\" in mind, and when aligning reads to long, repetitive genomes alignment can be very, very slow.",
                        "id": "#report_k_alignments"
                    },
                    {
                        "sbg:altPrefix": "-a",
                        "sbg:category": "Reporting",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--all",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Report all alignments",
                        "description": "Like \"Report k alignments\" but with no upper limit on number of alignments to search for. \"Report all alignments\" is mutually exclusive with \"Report k alignments\".",
                        "id": "#report_all_alignments"
                    },
                    {
                        "sbg:category": "Effort",
                        "sbg:toolDefaultValue": "15",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-D",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Seed extension attempts",
                        "description": "Maximum number of to consecutive seed extension attempts that can \"fail\" before Bowtie2 moves on, using the alignments found so far. A seed extension \"fails\" if it does not yield a new best or a new second-best alignment.",
                        "id": "#seed_extension_attempts"
                    },
                    {
                        "sbg:category": "Effort",
                        "sbg:toolDefaultValue": "2",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-R",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Max number of re-seed",
                        "description": "Given number is the maximum number of times Bowtie2 will 're-seed' reads with repetitive seeds. When 're-seeding', Bowtie2 simply chooses a new set of reads (same length, same number of mismatches allowed) at different offsets and searches for more alignments. A read is considered to have repetitive seeds if the total number of seed hits divided by the number of seeds that aligned at least once is greater than 300.",
                        "id": "#max_number_of_re_seed"
                    },
                    {
                        "sbg:altPrefix": "-I",
                        "sbg:category": "Paired-end",
                        "sbg:toolDefaultValue": "0",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--minins",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Minimum fragment length",
                        "description": "The minimum fragment length for valid paired-end alignments. E.g. if 60 is specified for \"Minimum fragment length\" (-I) and a paired-end alignment consists of two 20-bp alignments in the appropriate orientation with a 20-bp gap between them, that alignment is considered valid (as long as \"Maximum fragment length\" (-X) is also satisfied). A 19-bp gap would not be valid in that case. If trimming options -3 or -5 are also used, the \"Minimum fragment length\" constraint is applied with respect to the untrimmed mates. The larger the difference between \"Minimum fragment length\" and \"Maximum fragment length\", the slower Bowtie2 will run. This is because larger differences bewteen those two require that Bowtie2 scan a larger window to determine if a concordant alignment exists. For typical fragment length ranges (200 to 400 nucleotides), Bowtie2 is very efficient.",
                        "id": "#minimum_fragment_length"
                    },
                    {
                        "sbg:altPrefix": "-X",
                        "sbg:category": "Paired-end",
                        "sbg:toolDefaultValue": "500",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--maxins",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Maximum fragment length",
                        "description": "The maximum fragment length for valid paired-end alignments. E.g. if \"Maximum fragment length\" (-X) 100 is specified and a paired-end alignment consists of two 20-bp alignments in the proper orientation with a 60-bp gap between them, that alignment is considered valid (as long as \"Minimum fragment length\" (-I) is also satisfied). A 61-bp gap would not be valid in that case. If trimming options -3 or -5 are also used, the \"Maximum fragment length\" constraint is applied with respect to the untrimmed mates, not the trimmed mates. The larger the difference between \"Minimum fragment length\" and \"Maximum fragment length\", the slower Bowtie2 will run. This is because larger differences bewteen those two require that Bowtie2 scan a larger window to determine if a concordant alignment exists. For typical fragment length ranges (200 to 400 nucleotides), Bowtie2 is very efficient.",
                        "id": "#maximum_fragment_length"
                    },
                    {
                        "sbg:category": "Paired-end",
                        "sbg:toolDefaultValue": "--fr",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "--fr",
                                    "--rf",
                                    "--ff"
                                ],
                                "name": "mates_alignment_orientation"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Mates alignment orientation",
                        "description": "The upstream/downstream mate orientations for a valid paired-end alignment against the forward reference strand. E.g., if --fr is specified and there is a candidate paired-end alignment where mate 1 appears upstream of the reverse complement of mate 2 and the fragment length constraints (\"Minimum fragment length\" (-I) and \"Maximum fragment length\" (-X)) are met, that alignment is valid. Also, if mate 2 appears upstream of the reverse complement of mate 1 and all other constraints are met, that too is valid. --rf likewise requires that an upstream mate1 be reverse-complemented and a downstream mate2 be forward-oriented. --ff requires both an upstream mate 1 and a downstream mate 2 to be forward-oriented. Default orientation --fr is appropriate for Illumina's Paired-end Sequencing Assay.",
                        "id": "#mates_alignment_orientation"
                    },
                    {
                        "sbg:category": "Paired-end",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--no-mixed",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Disable unpaired alignments",
                        "description": "By default, when Bowtie2 cannot find a concordant or discordant alignment for a pair, it then tries to find alignments for the individual mates. This option disables that behavior.",
                        "id": "#disable_unpaired_alignments"
                    },
                    {
                        "sbg:category": "Paired-end",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--no-discordant",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Disable discordant alignments",
                        "description": "By default, Bowtie2 looks for discordant alignments if it cannot find any concordant alignments. A discordant alignment is an alignment where both mates align uniquely, but that does not satisfy the paired-end constraints (--fr/--rf/--ff, -I, -X). This option disables that behavior.",
                        "id": "#disable_discordant_alignments"
                    },
                    {
                        "sbg:category": "Paired-end",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--no-dovetail",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Disable dovetail alignments",
                        "description": "If the mates \"dovetail\", that is if one mate alignment extends past the beginning of the other such that the wrong mate begins upstream, consider that to be non-concordant.",
                        "id": "#disable_dovetail_alignments"
                    },
                    {
                        "sbg:category": "Paired-end",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--no-contain",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Disable containing alignments",
                        "description": "If one mate alignment contains the other, consider that to be non-concordant.",
                        "id": "#disable_containing_alignments"
                    },
                    {
                        "sbg:category": "Paired-end",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--no-overlap",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Disable overlapping alignments",
                        "description": "If one mate alignment overlaps the other at all, consider that to be non-concordant.",
                        "id": "#disable_overlapping_alignments"
                    },
                    {
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--no-head",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Suppress header lines",
                        "description": "Suppress SAM header lines (starting with @).",
                        "id": "#suppress_header_lines"
                    },
                    {
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--no-sq",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Suppress SQ header lines",
                        "description": "Suppress @SQ SAM header lines.",
                        "id": "#suppress_sq_header_lines"
                    },
                    {
                        "sbg:category": "Read group",
                        "sbg:toolDefaultValue": "id",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--rg-id",
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "script": "{\n  return ($job.inputs.read_group_id || \"id\") \n}",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Set the read group ID",
                        "description": "Set the read group ID text. This causes the SAM @RG header line to be printed, with the given text as the value associated with the ID: tag. It also causes the RG:Z: extra field to be attached to each SAM output record, with value set to this text.",
                        "id": "#read_group_id"
                    },
                    {
                        "sbg:category": "Read group",
                        "sbg:toolDefaultValue": "Infered from metadata",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "LS 454",
                                    "Helicos",
                                    "Illumina",
                                    "ABI SOLiD",
                                    "Ion Torrent PGM",
                                    "PacBio"
                                ],
                                "name": "platform"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "script": "{\n  if($job.inputs.platform)\n    return \"--rg PL:\" +$job.inputs.platform.replace(/ /g,\"_\")\n  else if([].concat($job.inputs.read_sequence)[0].metadata){\n    if ([].concat($job.inputs.read_sequence)[0].metadata.platform) {\n      return \"--rg PL:\" +[].concat($job.inputs.read_sequence)[0].metadata.platform.replace(/ /g,\"_\")\n    }\n  }\n  else {\n    return \"\"\n  }\n}",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Platform",
                        "description": "Specify the version of the technology that was used for sequencing or assaying. Default: inferred from metadata.",
                        "id": "#platform"
                    },
                    {
                        "sbg:category": "Read group",
                        "sbg:toolDefaultValue": "Infered from metadata",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "script": "{\n  if($job.inputs.sample_id)\n    return \"--rg SM:\" +$job.inputs.sample_id\n  else if([].concat($job.inputs.read_sequence)[0].metadata){\n      if([].concat($job.inputs.read_sequence)[0].metadata.sample_id)\n  \t\treturn \"--rg SM:\" +[].concat($job.inputs.read_sequence)[0].metadata.sample_id\n      else return \"\"\n    }\n  else\n    return \"\"\n}",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Sample",
                        "description": "Specify the sample ID for RG line.",
                        "id": "#sample_id"
                    },
                    {
                        "sbg:category": "Read group",
                        "sbg:toolDefaultValue": "Infered from metadata",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "script": "{\n  if($job.inputs.library_id)\n    return \"--rg LB:\" +$job.inputs.library_id\n  else if([].concat($job.inputs.read_sequence)[0].metadata){\n      if([].concat($job.inputs.read_sequence)[0].metadata.library_id)\n  \t\treturn \"--rg LB:\" +[].concat($job.inputs.read_sequence)[0].metadata.library_id\n      else return \"\"\n    }\n  else\n    return \"\"\n}",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Library",
                        "description": "Specify the library ID for RG line.",
                        "id": "#library_id"
                    },
                    {
                        "sbg:category": "Read group",
                        "sbg:toolDefaultValue": "Infered from metadata",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "script": "{\n  if($job.inputs.platform_unit_id)\n    return \"--rg PU:\" +$job.inputs.platform_unit_id\n  else if([].concat($job.inputs.read_sequence)[0].metadata){\n      if([].concat($job.inputs.read_sequence)[0].metadata.platform_unit_id)\n  \t\treturn \"--rg PU:\" +[].concat($job.inputs.read_sequence)[0].metadata.platform_unit_id\n      else return \"\"\n    }\n  else\n    return \"\"\n}",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Platform unit",
                        "description": "Specify the platform unit ID for RG line.",
                        "id": "#platform_unit_id"
                    },
                    {
                        "sbg:category": "Read group",
                        "sbg:toolDefaultValue": "Infered from metadata",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "script": "{\n  if($job.inputs.sequencing_center)\n    return \"--rg CN:\" +$job.inputs.sequencing_center\n    else if([].concat($job.inputs.read_sequence)[0].metadata){\n      if([].concat($job.inputs.read_sequence)[0].metadata.seq_center)\n  \t\treturn \"--rg CN:\" +[].concat($job.inputs.read_sequence)[0].metadata.seq_center\n    }\n  else\n    return \"\"\n}",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Sequencing center",
                        "description": "Specify the sequencing center for RG line.",
                        "id": "#sequencing_center"
                    },
                    {
                        "sbg:category": "Read group",
                        "sbg:toolDefaultValue": "Infered from metadata",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "script": "{\n  if($job.inputs.median_fragment_length)\n    return \"--rg PI:\" +$job.inputs.median_fragment_length\n  else if([].concat($job.inputs.read_sequence)[0].metadata){\n      if([].concat($job.inputs.read_sequence)[0].metadata.median_fragment_length)\n  \t\treturn \"--rg PI:\" +[].concat($job.inputs.read_sequence)[0].metadata.median_fragment_length\n      else return \"\"\n    }\n  else\n    return \"\"\n}",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Median fragment length",
                        "description": "Specify the median fragment length for RG line.",
                        "id": "#median_fragment_length"
                    },
                    {
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--omit-sec-seq",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Omit SEQ and QUAL",
                        "description": "When printing secondary alignments, Bowtie 2 by default will write out the SEQ and QUAL strings. Specifying this option causes Bowtie 2 to print an asterisk ('*') in those fields instead.",
                        "id": "#omit_seq_and_qual"
                    },
                    {
                        "sbg:category": "Performance",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--reorder",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Reorder output",
                        "description": "Guarantees that output SAM records are printed in an order corresponding to the order of the reads in the original input file. Specifying \"Reorder output\" causes Bowtie2 to run somewhat slower and use somewhat more memory.",
                        "id": "#reorder_output"
                    },
                    {
                        "sbg:category": "Other",
                        "sbg:toolDefaultValue": "0",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--seed",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Set seed",
                        "description": "Set the seed for pseudo-random number generator.",
                        "id": "#set_seed"
                    },
                    {
                        "sbg:category": "Other",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--non-deterministic",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Non deterministic",
                        "description": "Normally, Bowtie2 re-initializes its pseudo-random generator for each read. It seeds the generator with a number derived from (a) the read name, (b) the nucleotide sequence, (c) the quality sequence, (d) the value of the \"Set seed\" option. This means that if two reads are identical (same name, same nucleotides, same qualities) Bowtie2 will find and report the same alignment(s) for both, even if there was ambiguity. When \"Non deterministic\" is specified, Bowtie2 re-initializes its pseudo-random generator for each read using the current time. This means that Bowtie2 will not necessarily report the same alignment for two identical reads. This is counter-intuitive for some users, but might be more appropriate in situations where the input consists of many identical reads.",
                        "id": "#non_deterministic"
                    },
                    {
                        "sbg:category": "Interval function",
                        "sbg:toolDefaultValue": "Square-root",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "Constant",
                                    "Linear",
                                    "Square-root",
                                    "Natural log"
                                ],
                                "name": "function_i"
                            }
                        ],
                        "label": "Interval function",
                        "description": "Sets a function type F in function f governing the interval between seed substrings, to use during multiseed alignment. The interval function f is f(x) = A + B * F(x), where x is the read length. By default, function F is set to 'Square-root', Constant A to 1 and Coefficient B to 1.15 or 0.75 for \"End-to-end\" and \"Local\" mode respectively.",
                        "id": "#function_i"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Interval function",
                        "sbg:toolDefaultValue": "1",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Constant A [ interval function ]",
                        "description": "Sets a constant A in function governing the interval between seed substrings to use during multiseed alignment. The interval function f is f(x) = A + B * F(x), where x is the read length.",
                        "id": "#constant_i_a"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Interval function",
                        "sbg:toolDefaultValue": "1.15 or 0.75 (depending on \"Alignment mode\")",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Coefficient B [ interval function ]",
                        "description": "Sets a coefficient B in function governing the interval between seed substrings to use during multiseed alignment. The interval function f is f(x) = A + B * F(x), where x is the read length. Default: 1.15 in \"End-to-end\" mode and 0.75 in \"Local\" mode.",
                        "id": "#coefficient_i_b"
                    },
                    {
                        "sbg:category": "Ambiguous chars function",
                        "sbg:toolDefaultValue": "Linear",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "Constant",
                                    "Linear",
                                    "Square-root",
                                    "Natural log"
                                ],
                                "name": "function_n_ceil"
                            }
                        ],
                        "label": "Ambiguous chars function",
                        "description": "Sets a function type F in function governing the maximum number of ambiguous characters (usually Ns and/or .s) allowed in a read as a function of read length. The N-ceiling function f is f(x) = A + B * F(x), where x is the read length. Reads exceeding this ceiling are filtered out.",
                        "id": "#function_n_ceil"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Ambiguous chars function",
                        "sbg:toolDefaultValue": "0",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Constant A [ ambiguous chars function ]",
                        "description": "Sets a constant A in function governing the maximum number of ambiguous characters (usually Ns and/or .s) allowed in a read as a function of read length. The N-ceiling function f is f(x) = A + B * F(x), where x is the read length. Reads exceeding this ceiling are filtered out.",
                        "id": "#constant_nceil_a"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Ambiguous chars function",
                        "sbg:toolDefaultValue": "0.15",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Coefficient B [ ambiguous chars function ]",
                        "description": "Sets a coefficient B in function governing the maximum number of ambiguous characters (usually Ns and/or .s) allowed in a read as a function of read length. The N-ceiling function f is f(x) = A + B * F(x), where x is the read length. Reads exceeding this ceiling are filtered out.",
                        "id": "#coefficient_nceil_b"
                    },
                    {
                        "sbg:category": "Alignment score function",
                        "sbg:toolDefaultValue": "Natural log or Linear (depending on \"Alignment mode\")",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "Constant",
                                    "Linear",
                                    "Square-root",
                                    "Natural log"
                                ],
                                "name": "function_score_min"
                            }
                        ],
                        "label": "Alignment score function",
                        "description": "Sets a function type F in function governing the minimum alignment score needed for an alignment to be considered \"valid\" (i.e. good enough to report). This is a function of read length. The minimum-score function f is f(x) = A + B * F(x), where x is the read length. By default, function F is set to \"Natural log\" or \"Linear\", Constant A to 20 or -0.6 and Coefficient B to 8 or -0.6 depending on the \"Alignment mode\": \"End-to-end\" or \"Local\" respectively.",
                        "id": "#function_score_min"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Alignment score function",
                        "sbg:toolDefaultValue": "20 or -0.6 (depending on \"Alignment mode\")",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Constant A [ alignment score function ]",
                        "description": "Sets a constant A in function governing the minimum alignment score needed for an alignment to be considered 'valid' (i.e. good enough to report). This is a function of read length. The minimum-score function f is f(x) = A + B * F(x), where x is the read length. Default: 20 in \"End-to-end\" mode and -0.6 in \"Local\" mode.",
                        "id": "#constant_scoremin_a"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Alignment score function",
                        "sbg:toolDefaultValue": "8 or -0.6 (depending on \"Alignment mode\")",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Coefficient B [ alignment score function ]",
                        "description": "Sets a coefficient B in function governing the minimum alignment score needed for an alignment to be considered 'valid' (i.e. good enough to report). This is a function of read length. The minimum-score function f is f(x) = A + B * F(x), where x is the read length. Default: 8 in \"End-to-end\" mode and -0.6 in \"Local\" mode.",
                        "id": "#coefficient_scoremin_b"
                    },
                    {
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "None",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "raw",
                                    "gzip compressed",
                                    "bzip2 compressed",
                                    "None"
                                ],
                                "name": "unpaired_unaligned_reads"
                            }
                        ],
                        "label": "Unpaired unaligned reads",
                        "description": "Output unpaired reads that fail to align. These reads correspond to the SAM records with the FLAGS 0x4 bit set and neither the 0x40 nor 0x80 bits set. If \"gzip compressed\" is specified, output will be gzip compressed. If \"bzip2 compressed\" is specified, output will be bzip2 compressed. Reads written in this way will appear exactly as they did in the input file, without any modification (same sequence, same name, same quality string, same quality encoding). Reads will not necessarily appear in the same order as they did in the input.",
                        "id": "#unpaired_unaligned_reads"
                    },
                    {
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "None",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "raw",
                                    "gzip compressed",
                                    "bzip2 compressed",
                                    "None"
                                ],
                                "name": "unpaired_aligned_reads"
                            }
                        ],
                        "label": "Unpaired aligned reads",
                        "description": "Output unpaired reads that align at least once. These reads correspond to the SAM records with the FLAGS 0x4, 0x40, and 0x80 bits unset. If \"gzip compressed\" is specified, output will be gzip compressed. If \"bzip2 compressed\" is specified, output will be bzip2 compressed. Reads written in this way will appear exactly as they did in the input file, without any modification (same sequence, same name, same quality string, same quality encoding). Reads will not necessarily appear in the same order as they did in the input.",
                        "id": "#unpaired_aligned_reads"
                    },
                    {
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "None",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "raw",
                                    "gzip compressed",
                                    "bzip2 compressed",
                                    "None"
                                ],
                                "name": "paired_unaligned_reads"
                            }
                        ],
                        "label": "Paired unaligned reads",
                        "description": "Output paired-end reads that fail to align concordantly. These reads correspond to the SAM records with the FLAGS 0x4 bit set and either the 0x40 or 0x80 bit set (depending on whether it's mate #1 or #2). .1 and .2 strings are added to the filename to distinguish which file contains mate #1 and mate #2. If \"gzip compressed\" is specified, output will be gzip compressed. If \"bzip2 compressed\" is specified, output will be bzip2 compressed. Reads written in this way will appear exactly as they did in the input file, without any modification (same sequence, same name, same quality string, same quality encoding). Reads will not necessarily appear in the same order as they did in the input.",
                        "id": "#paired_unaligned_reads"
                    },
                    {
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "None",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "raw",
                                    "gzip compressed",
                                    "bzip2 compressed",
                                    "None"
                                ],
                                "name": "paired_aligned_reads"
                            }
                        ],
                        "label": "Paired aligned reads",
                        "description": "Output paired-end reads that align concordantly at least once. These reads correspond to the SAM records with the FLAGS 0x4 bit unset and either the 0x40 or 0x80 bit set (depending on whether it's mate #1 or #2). .1 and .2 strings are added to the filename to distinguish which file contains mate #1 and mate #2. If \"gzip compressed\" is specified, output will be gzip compressed. If \"bzip2 compressed\" is specified, output will be bzip2 compressed. Reads written in this way will appear exactly as they did in the input file, without any modification (same sequence, same name, same quality string, same quality encoding). Reads will not necessarily appear in the same order as they did in the input.",
                        "id": "#paired_aligned_reads"
                    },
                    {
                        "sbg:category": "Input files",
                        "type": [
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Read sequence",
                        "description": "Read sequence in FASTQ or FASTA format. COuld be also gzip'ed (extension .gz) or bzip2'ed (extension .bz2). In case of paired-end alignment it is crucial to set metadata 'paired-end' field to 1/2.",
                        "sbg:fileTypes": "FASTA, FASTA.GZ, FASTA.BZ2, FA.GZ, FA.BZ2, FASTQ, FA, FQ, FASTQ.GZ, FQ.GZ, FASTQ.BZ2, FQ.BZ2",
                        "id": "#read_sequence"
                    },
                    {
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--no-unal",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Suppress SAM records for unaligned reads",
                        "description": "Suppress SAM records for reads that failed to align.",
                        "id": "#suppress_sam_records"
                    },
                    {
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-f",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Input FASTA files",
                        "description": "Reads (specified with <m1>, <m2>, <s>) are FASTA files. FASTA files usually have extension .fa, .fasta, .mfa, .fna or similar. FASTA files do not have a way of specifying quality values, so when -f is set, the result is as if --ignore-quals is also set.",
                        "id": "#input_fasta_files"
                    },
                    {
                        "sbg:altPrefix": "-threads",
                        "sbg:category": "Performance",
                        "sbg:toolDefaultValue": "8",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "separate": true,
                            "valueFrom": {
                                "class": "Expression",
                                "script": "{\n\tif($job.inputs.threads)\n    {\n    \treturn \" -p \" + $job.inputs.threads\n    }\n  \telse\n    {\n    \treturn \" -p 8 \"\n    }\n}",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Number of threads",
                        "description": "Launch NTHREADS parallel search threads (default: 1). Threads will run on separate processors/cores and synchronize when parsing reads and outputting alignments. Searching for alignments is highly parallel, and speedup is close to linear. Increasing -p increases Bowtie 2's memory footprint. E.g. when aligning to a human genome index, increasing -p from 1 to 8 increases the memory footprint by a few hundred megabytes. This option is only available if bowtie is linked with the pthreads library (i.e. if BOWTIE_PTHREADS=0 is not specified at build time).",
                        "id": "#threads"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Result SAM file",
                        "description": "SAM file containing the results of the alignment. It contains both aligned and unaligned reads.",
                        "sbg:fileTypes": "SAM",
                        "outputBinding": {
                            "streamable": false,
                            "glob": "*.sam",
                            "sbg:metadata": {
                                "__inherit__": "fasta_reference"
                            },
                            "sbg:inheritMetadataFrom": "#read_sequence"
                        },
                        "id": "#result_sam_file"
                    },
                    {
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Aligned reads only",
                        "description": "FASTQ file with reads that align at least once.",
                        "sbg:fileTypes": "FASTQ, FASTQ.GZ, FASTQ.BZ2",
                        "outputBinding": {
                            "streamable": false,
                            "glob": "*_aligned*",
                            "sbg:metadata": {
                                "__inherit__": "fasta_reference"
                            },
                            "sbg:inheritMetadataFrom": "#read_sequence"
                        },
                        "id": "#aligned_reads_only"
                    },
                    {
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Unaligned reads only",
                        "description": "FASTQ file with reads that failed to align.",
                        "sbg:fileTypes": "FASTQ, FASTQ.GZ, FASTQ.BZ2",
                        "outputBinding": {
                            "streamable": false,
                            "glob": "*_unaligned*",
                            "sbg:metadata": {
                                "__inherit__": "fasta_reference"
                            },
                            "sbg:inheritMetadataFrom": "#read_sequence"
                        },
                        "id": "#unaligned_reads_only"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "engineCommand": "cwl-engine.js",
                        "id": "#cwl-js-engine",
                        "requirements": [
                            {
                                "class": "DockerRequirement",
                                "dockerPull": "rabix/js-engine"
                            }
                        ]
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:CPURequirement",
                        "value": 8
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": 6000
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerImageId": "029d3a264215",
                        "dockerPull": "images.sbgenomics.com/ana_d/bowtie2:2.2.6"
                    }
                ],
                "arguments": [
                    {
                        "position": 100,
                        "prefix": "",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "cmd = \"\"\nreads = [].concat($job.inputs.read_sequence)\nreads1 = [];\nreads2 = [];\nu_reads = [];\nfor (var i = 0; i < reads.length; i++){\n    if (reads[i].metadata.paired_end == 1){\n      reads1.push(reads[i].path);\n    }\n    else if (reads[i].metadata.paired_end == 2){\n      reads2.push(reads[i].path);\n    }\n  else {\n  \tu_reads.push(reads[i].path);\n   }\n  }\nif (reads1.length > 0 & reads1.length == reads2.length){\n\tcmd = \"-1 \" + reads1.join(\",\") + \" -2 \" + reads2.join(\",\");\n}\nif (u_reads.length > 0){\n\tcmd = \" -U \" + u_reads.join(\",\");\n}\ncmd\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 101,
                        "prefix": "-S",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  function sharedStart(array){\n  var A= array.concat().sort(), \n      a1= A[0], a2= A[A.length-1], L= a1.length, i= 0;\n  while(i<L && a1.charAt(i)=== a2.charAt(i)) i++;\n  return a1.substring(0, i);\n  }\n  path_list = []\n  reads = [].concat($job.inputs.read_sequence)\n  reads.forEach(function(f){return path_list.push(f.path.replace(/\\\\/g,'/').replace( /.*\\//, '' ))})\n  \n  common_prefix = sharedStart(path_list)\n  return \"./\".concat(common_prefix.replace( /\\-$|\\_$|\\.$/, '' ), \".\", \"sam\")\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "-x",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  var index_prefix = $job.inputs.bowtie_index_archive.metadata.reference_genome\n  return index_prefix\n}\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  function sharedStart(array){\n    var A= array.concat().sort(), \n        a1= A[0], a2= A[A.length-1], L= a1.length, i= 0;\n    while(i<L && a1.charAt(i)=== a2.charAt(i)) i++;\n    return a1.substring(0, i);\n  }\n  path_list = []\n  \n  reads = [].concat($job.inputs.read_sequence)\n  reads.forEach(function(f){return path_list.push(f.path.replace(/\\\\/g,'/').replace( /.*\\//, '' ))})\n  \n  common_prefix = sharedStart(path_list)\n  \n  if ($job.inputs.unpaired_unaligned_reads && $job.inputs.unpaired_unaligned_reads != \"None\") {\n    if ($job.inputs.unpaired_unaligned_reads == \"raw\") {\n      return \"--un \".concat(common_prefix, \".unpaired_unaligned.fastq\")\n    }\n    else if ($job.inputs.unpaired_unaligned_reads == \"gzip compressed\") {\n      return \"--un \".concat(common_prefix, \".unpaired_unaligned.fastq.gz\")\n    }\n    else if ($job.inputs.unpaired_unaligned_reads == \"bzip2 compressed\") {\n      return \"--un \".concat(common_prefix, \".unpaired_unaligned.fastq.bz2\")\n    }\n  }\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  function sharedStart(array){\n    var A= array.concat().sort(), \n        a1= A[0], a2= A[A.length-1], L= a1.length, i= 0;\n    while(i<L && a1.charAt(i)=== a2.charAt(i)) i++;\n    return a1.substring(0, i);\n  }\n  path_list = []\n  \n  reads = [].concat($job.inputs.read_sequence)\n  reads.forEach(function(f){return path_list.push(f.path.replace(/\\\\/g,'/').replace( /.*\\//, '' ))})\n  \n  common_prefix = sharedStart(path_list)\n  \n  if ($job.inputs.unpaired_aligned_reads && $job.inputs.unpaired_aligned_reads != \"None\") {\n    if ($job.inputs.unpaired_aligned_reads == \"raw\") {\n      return \"--al \".concat(common_prefix, \".unpaired_aligned.fastq\")\n    }\n    else if ($job.inputs.unpaired_aligned_reads == \"gzip compressed\") {\n      return \"--al \".concat(common_prefix, \".unpaired_aligned.fastq.gz\")\n    }\n    else if ($job.inputs.unpaired_aligned_reads == \"bzip2 compressed\") {\n      return \"--al \".concat(common_prefix, \".unpaired_aligned.fastq.bz2\")\n    }\n  }\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  function sharedStart(array){\n    var A= array.concat().sort(), \n        a1= A[0], a2= A[A.length-1], L= a1.length, i= 0;\n    while(i<L && a1.charAt(i)=== a2.charAt(i)) i++;\n    return a1.substring(0, i);\n  }\n  path_list = []\n  \n  reads = [].concat($job.inputs.read_sequence)\n  reads.forEach(function(f){return path_list.push(f.path.replace(/\\\\/g,'/').replace( /.*\\//, '' ))})\n  \n  common_prefix = sharedStart(path_list)\n  \n  if ($job.inputs.paired_unaligned_reads && $job.inputs.paired_unaligned_reads != \"None\") {\n    if ($job.inputs.paired_unaligned_reads == \"raw\") {\n      return \"--un-conc \".concat(common_prefix, \".paired_unaligned.fastq\")\n    }\n    else if ($job.inputs.paired_unaligned_reads == \"gzip compressed\") {\n      return \"--un-conc \".concat(common_prefix, \".paired_unaligned.fastq.gz\")\n    }\n    else if ($job.inputs.paired_unaligned_reads == \"bzip2 compressed\") {\n      return \"--un-conc \".concat(common_prefix, \".paired_unaligned.fastq.bz2\")\n    }\n  }\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  function sharedStart(array){\n    var A= array.concat().sort(), \n        a1= A[0], a2= A[A.length-1], L= a1.length, i= 0;\n    while(i<L && a1.charAt(i)=== a2.charAt(i)) i++;\n    return a1.substring(0, i);\n  }\n  path_list = []\n  reads = [].concat($job.inputs.read_sequence)\n  reads.forEach(function(f){return path_list.push(f.path.replace(/\\\\/g,'/').replace( /.*\\//, '' ))})\n  \n  common_prefix = sharedStart(path_list)\n  \n  if ($job.inputs.paired_aligned_reads && $job.inputs.paired_aligned_reads != \"None\") {\n    if ($job.inputs.paired_aligned_reads == \"raw\") {\n      return \"--al-conc \".concat(common_prefix, \".paired_aligned.fastq\")\n    }\n    else if ($job.inputs.paired_aligned_reads == \"gzip compressed\") {\n      return \"--al-conc \".concat(common_prefix, \".paired_aligned.fastq.gz\")\n    }\n    else if ($job.inputs.paired_aligned_reads == \"bzip2 compressed\") {\n      return \"--al-conc \".concat(common_prefix, \".paired_aligned.fastq.bz2\")\n    }\n  }\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  var functions = {\n    \"Constant\": \"C\",\n    \"Linear\": \"L\",\n    \"Square-root\": \"S\",\n    \"Natural log\": \"G\"\n  }\n  function_type = $job.inputs.function_i\n  value_list = [functions[function_type], $job.inputs.constant_i_a, $job.inputs.coefficient_i_b]\n  if (functions[function_type] && $job.inputs.constant_i_a && $job.inputs.coefficient_i_b) {\n    return \"-i \".concat(value_list.join(\",\"))\n  }\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  var functions = {\n    \"Constant\": \"C\",\n    \"Linear\": \"L\",\n    \"Square-root\": \"S\",\n    \"Natural log\": \"G\"\n  }\n  function_type = $job.inputs.function_n_ceil\n  value_list = [functions[function_type], $job.inputs.constant_nceil_a, $job.inputs.coefficient_nceil_b]\n  if (functions[function_type] && $job.inputs.constant_nceil_a && $job.inputs.coefficient_nceil_b) {\n    return \"--n-ceil \".concat(value_list.join(\",\"))\n  }\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  var functions = {\n    \"Constant\": \"C\",\n    \"Linear\": \"L\",\n    \"Square-root\": \"S\",\n    \"Natural log\": \"G\"\n  }\n  function_type = $job.inputs.function_score_min\n  \n  value_list = [functions[function_type], $job.inputs.constant_scoremin_a, $job.inputs.coefficient_scoremin_b]\n  if (functions[function_type] && $job.inputs.constant_scoremin_a && $job.inputs.coefficient_scoremin_b) {\n    return \"--score-min \".concat(value_list.join(\",\"))\n  }\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  meta_qual=\"\";\n  if ([].concat($job.inputs.read_sequence)[0].metadata){\n    if ([].concat($job.inputs.read_sequence)[0].metadata.quality_scale){\n      meta_qual = [].concat($job.inputs.read_sequence)[0].metadata.quality_scale\n    }\n  }\n  \n  if ($job.inputs.quality_scale == \"Phred+33\") {\n    return \"--phred33\"\n  }\n  else if ($job.inputs.quality_scale == \"Phred+64\") {\n    return \"--phred64\"\n  }\n  else if ($job.inputs.quality_scale == \"Solexa\") {\n    return \"--solexa-quals\"\n  }\n  else if ($job.inputs.quality_scale == \"Auto-detect\") {\n    if (meta_qual == \"solexa\") {\n      return \"--solexa-quals\"\n    }\n    else if (meta_qual == \"illumina13\" || meta_qual == \"illumina15\") {\n      return \"--phred64\"\n    }\n  }\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 102,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  function sharedStart(array){\n    var A= array.concat().sort(), \n        a1= A[0], a2= A[A.length-1], L= a1.length, i= 0;\n    while(i<L && a1.charAt(i)=== a2.charAt(i)) i++;\n    return a1.substring(0, i);\n  }\n  path_list = []\n  reads = [].concat($job.inputs.read_sequence)\n  reads.forEach(function(f){return path_list.push(f.path.replace(/\\\\/g,'/').replace( /.*\\//, '' ))})\n  common_prefix = sharedStart(path_list)\n  \n  gzip = \"gzip compressed\"\n  bzip = \"bzip2 compressed\"\n  paired_aligned = $job.inputs.paired_aligned_reads\n  paired_unaligned = $job.inputs.paired_unaligned_reads\n  aligned_first = common_prefix.concat(\".paired_aligned.fastq.1\")\n  aligned_second = common_prefix.concat(\".paired_aligned.fastq.2\")\n  aligned_first_mv = common_prefix.concat(\".paired_aligned.1.fastq\")\n  aligned_second_mv = common_prefix.concat(\".paired_aligned.2.fastq\")\n  \n  unaligned_first = common_prefix.concat(\".paired_unaligned.fastq.1\")\n  unaligned_second = common_prefix.concat(\".paired_unaligned.fastq.2\")\n  unaligned_first_mv = common_prefix.concat(\".paired_unaligned.1.fastq\")\n  unaligned_second_mv = common_prefix.concat(\".paired_unaligned.2.fastq\")\n  \n  aligned = \"\"\n  unaligned = \"\"\n  \n  if (paired_aligned && paired_aligned == gzip) {\n    aligned = \"&& mv \".concat(aligned_first, \".gz \", aligned_first_mv, \".gz && mv \", aligned_second, \".gz \", aligned_second_mv, \".gz \") \n  }\n  else if (paired_aligned && paired_aligned == bzip) {\n    aligned = \"&& mv \".concat(aligned_first, \".bz2 \", aligned_first_mv, \".bz2 && mv \", aligned_second, \".bz2 \", aligned_second_mv, \".bz2 \")\n  }\n  if (paired_unaligned && paired_unaligned == gzip) {\n    unaligned = \"&& mv \".concat(unaligned_first, \".gz \", unaligned_first_mv, \".gz && mv \", unaligned_second, \".gz \", unaligned_second_mv, \".gz\")\n  }\n  else if (paired_unaligned && paired_unaligned == bzip) {\n    unaligned = \"&& mv \".concat(unaligned_first, \".bz2 \", unaligned_first_mv, \".bz2 && mv \", unaligned_second, \".bz2 \", unaligned_second_mv, \".bz2\")\n  }\n  \n  return aligned.concat(unaligned)\n}",
                            "engine": "#cwl-js-engine"
                        }
                    }
                ],
                "sbg:links": [
                    {
                        "label": "Homepage",
                        "id": "http://bowtie-bio.sourceforge.net/bowtie2/index.shtml"
                    },
                    {
                        "label": "Download",
                        "id": "http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.6/"
                    },
                    {
                        "label": "Publication",
                        "id": "http://www.nature.com/nmeth/journal/v9/n4/full/nmeth.1923.html"
                    },
                    {
                        "label": "Manual",
                        "id": "http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml"
                    },
                    {
                        "label": "Source Code",
                        "id": "https://github.com/BenLangmead/bowtie2"
                    }
                ],
                "sbg:cmdPreview": "tar -xvf chr20_bowtie2-2.2.6.tar && rm -rf chr20_bowtie2-2.2.6.tar &&  /opt/bowtie2-2.2.6/bowtie2 -x chr20  --un mate.unpaired_unaligned.fastq.gz  --al mate.unpaired_aligned.fastq.gz  --un-conc mate.paired_unaligned.fastq  --al-conc mate.paired_aligned.fastq.gz  -i L,constant_i_a-string-value,coefficient_i_b-string-value  --n-ceil S,constant_nceil_a-string-value,coefficient_nceil_b-string-value  --score-min L,constant_scoremin_a-string-value,coefficient_scoremin_b-string-value  --phred33  -1 /demo/test-data/mate1.fastq -2 /demo/test-data/mate2.fastq -S ./mate.sam  && mv mate.paired_aligned.fastq.1.gz mate.paired_aligned.1.fastq.gz && mv mate.paired_aligned.fastq.2.gz mate.paired_aligned.2.fastq.gz",
                "sbg:toolkitVersion": "2.2.6",
                "sbg:toolAuthor": "Ben Langmead/John Hopkins University",
                "sbg:projectName": "topmed-a6k-unmapped-ghana",
                "sbg:toolkit": "Bowtie2",
                "sbg:image_url": null,
                "sbg:job": {
                    "inputs": {
                        "threads": null,
                        "sample_id": "nn",
                        "alignment_mode": "Local",
                        "paired_unaligned_reads": "raw",
                        "unpaired_aligned_reads": "gzip compressed",
                        "preset_option": "Very fast",
                        "input_fasta_files": true,
                        "constant_i_a": "constant_i_a-string-value",
                        "constant_scoremin_a": "constant_scoremin_a-string-value",
                        "read_gap_penalties": [
                            0
                        ],
                        "constant_nceil_a": "constant_nceil_a-string-value",
                        "coefficient_scoremin_b": "coefficient_scoremin_b-string-value",
                        "function_n_ceil": "Square-root",
                        "reference_gap_penalties": [
                            0
                        ],
                        "coefficient_i_b": "coefficient_i_b-string-value",
                        "unpaired_unaligned_reads": "gzip compressed",
                        "mates_alignment_orientation": "--rf",
                        "coefficient_nceil_b": "coefficient_nceil_b-string-value",
                        "disable_unpaired_alignments": false,
                        "suppress_sam_records": true,
                        "paired_aligned_reads": "gzip compressed",
                        "allowed_mismatch_number": "0",
                        "read_sequence": [
                            {
                                "metadata": {
                                    "file_format": "fastq",
                                    "quality_scale": "illumina15",
                                    "paired_end": "1"
                                },
                                "class": "File",
                                "secondaryFiles": [],
                                "path": "/demo/test-data/mate1.fastq",
                                "size": 0
                            },
                            {
                                "metadata": {
                                    "file_format": "fastq",
                                    "qual_scale": "illumina15",
                                    "paired_end": "2"
                                },
                                "secondaryFiles": [],
                                "path": "/demo/test-data/mate2.fastq"
                            }
                        ],
                        "quality_scale": "Phred+33",
                        "platform": "ABI SOLiD",
                        "bowtie_index_archive": {
                            "metadata": {
                                "reference_genome": "chr20"
                            },
                            "class": "File",
                            "secondaryFiles": [],
                            "path": "/demo/test-data/chr20_bowtie2-2.2.6.tar",
                            "size": 0
                        },
                        "function_score_min": "Linear",
                        "function_i": "Linear",
                        "disable_overlapping_alignments": false
                    },
                    "allocatedResources": {
                        "cpu": 8,
                        "mem": 6000
                    }
                },
                "sbg:license": "GNU General Public License v3.0 only",
                "sbg:revisionNotes": "Copy of admin/sbg-public-data/bowtie2-aligner/18",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "jolvany",
                        "sbg:modifiedOn": 1637329050,
                        "sbg:revisionNotes": "Copy of admin/sbg-public-data/bowtie2-aligner/18"
                    }
                ],
                "sbg:publisher": "sbg",
                "sbg:categories": [
                    "Alignment"
                ],
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:id": "jolvany/topmed-a6k-unmapped-ghana/bowtie2-aligner/0",
                "sbg:revision": 0,
                "sbg:modifiedOn": 1637329050,
                "sbg:modifiedBy": "jolvany",
                "sbg:createdOn": 1637329050,
                "sbg:createdBy": "jolvany",
                "sbg:project": "jolvany/topmed-a6k-unmapped-ghana",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "jolvany"
                ],
                "sbg:latestRevision": 0,
                "sbg:content_hash": "ab398f446f6d81a127712fa7572605ca3433e68a96849ab62d5452170d60deedf",
                "sbg:copyOf": "admin/sbg-public-data/bowtie2-aligner/18"
            },
            "label": "Bowtie2 Aligner",
            "sbg:x": 121.10009765625,
            "sbg:y": -116.5
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
    "sbg:projectName": "topmed-a6k-unmapped-ghana",
    "sbg:revisionsInfo": [
        {
            "sbg:revision": 0,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1638306343,
            "sbg:revisionNotes": null
        },
        {
            "sbg:revision": 1,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1638306566,
            "sbg:revisionNotes": "basic set up test"
        },
        {
            "sbg:revision": 2,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1638331396,
            "sbg:revisionNotes": "added the aligner"
        },
        {
            "sbg:revision": 3,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1638331708,
            "sbg:revisionNotes": "messed with bowtie2 settings but couldn't fine output name"
        },
        {
            "sbg:revision": 4,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1638388992,
            "sbg:revisionNotes": "fixed based on trial"
        },
        {
            "sbg:revision": 5,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1638389059,
            "sbg:revisionNotes": "for mapping output aligned"
        },
        {
            "sbg:revision": 6,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1644954377,
            "sbg:revisionNotes": "min length set"
        },
        {
            "sbg:revision": 7,
            "sbg:modifiedBy": "jolvany",
            "sbg:modifiedOn": 1645028803,
            "sbg:revisionNotes": ""
        }
    ],
    "sbg:image_url": "https://platform.sb.biodatacatalyst.nhlbi.nih.gov/ns/brood/images/jolvany/topmed-a6k-unmapped-ghana/cram-to-bam/7.png",
    "sbg:appVersion": [
        "v1.2",
        "sbg:draft-2"
    ],
    "sbg:id": "jolvany/topmed-a6k-unmapped-ghana/cram-to-bam/7",
    "sbg:revision": 7,
    "sbg:revisionNotes": "",
    "sbg:modifiedOn": 1645028803,
    "sbg:modifiedBy": "jolvany",
    "sbg:createdOn": 1638306343,
    "sbg:createdBy": "jolvany",
    "sbg:project": "jolvany/topmed-a6k-unmapped-ghana",
    "sbg:sbgMaintained": false,
    "sbg:validationErrors": [],
    "sbg:contributors": [
        "jolvany"
    ],
    "sbg:latestRevision": 7,
    "sbg:publisher": "sbg",
    "sbg:content_hash": "a69af6e5eae71fe76e369b5521252781a3a2fca93914761e50826fef5e52767a1",
    "sbg:workflowLanguage": "CWL"
}