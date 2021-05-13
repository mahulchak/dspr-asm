The master_table_d10_100bp.txt has the variants in a tab separated format with the following variant types:

```
	DEL = Clean deletion
	DEL:COM = Collection of overlapping small indels (i.e. Complex Deletion) and the reference has more nucleotides than the query
	DEL:rME = Deletion in the query that maps to a TE in the reference sequence.
	INS = Clean insertion
	INS:COM = Collection of overlapping indels (i.e. Complex Insertion) and the reference has fewer nucleotides than the query
	INS:CNV = Insertion in the query strain due to 1 copy number increase.
	INS:nCNV = Insertion in the query strain due to >1 copy number increase.
	INS:ME = Insertion in the query that maps to a mobile element (ME) or transposable element (TE) in the query strain.
	INV = Inverted sequence with respect to the reference.

```

The file has following 16 columns, with each row of the file containing information about an individual variant:

```
	Col1: Reference chromosome
	Col2: Reference chromosome start
	Col3: Reference chromosome end
	Col4: No. of individuals the variant is present in
	Col5-7: Same as Col1-3 but the precise range for the variant breakpoints for each strain for this particular variant
	Col8: Variant type (corresponds to the variant flavor tag or FL tag in the vcf file)
	Col9: Query chromosome with strain names
	Col10: Query start for all strains where the variant is present. The sequence matches the strain sequence in Col5-7 and Col9.
	Col11: Query end for all strains where the variant is present. The sequence matches the strain sequence in Col5-7 and Col9-10.
	Col12: variant id for each strain. The sequence matches the sequence in Col5-7 and Col9-11
	Col13: Lengths of the variant in strains where it is present. Sequence matches the sequence in Col9-11.
	Col14: Coverage of the reference interval (Col5-7) in the query genome. Sequence matches the sequence in Col9-11.
	Col15: Coverage of the query interval (Col9-11) in the reference genome. Sequence matches the sequence in Col9-11.
	Col16: Code for whether the variant overlaps with another variant within 5 kb. 1= it does. 0= it doesn't.

```
The vcf file SV.0328.vcf, derived from the master variant file, is hosted on the UCSC browser http://goo.gl/LLpoNH
