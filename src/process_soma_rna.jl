include("trim_sequence.jl")

include("check_sequence.jl")

include("count_transcript.jl")


function process_soma_rna(
    so1::String,
    so2::String,
    pa::String,
    fa::String,
    n_jo::Int,
)
    # fa is cdna_fasta.gz

    for fi in (so1, so2, fa)
        if !isfile(fi)

            error("$fi doesn't exist.")

        end

    end

    patr = joinpath(pa, "trim_sequence", "soma")

    trim_sequence(
        so1,
        so2,
        patr,
        n_jo,
    )

    so1tr = "$patr-trimmed-pair1.fastq.gz"

    so2tr = "$patr-trimmed-pair2.fastq.gz"

    check_sequence(
        (so1tr, so2tr),
        joinpath(pa, "check_sequence"),
        n_jo,
    )

    paco = joinpath(pa, "count_transcript")

    count_transcript(
        so1tr,
        so2tr,
        fa,
        paco,
        n_jo,
    )

end
