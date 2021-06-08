include("trim_sequence.jl")

include("check_sequence.jl")

include("align_sequence.jl")

include("find_variant.jl")


function process_soma_dna(
    ge1::String,
    ge2::String,
    so1::String,
    so2::String,
    ta::Bool,
    paou::String,
    fa::String,
    chsi::String,
    chna::String,
    n_jo::Int,
    meto::Int,
    mejo::Int,
    snpeff::String,
)

    for file_path::String in (ge1, ge2, so1, so2, fa, chsi, chna)
        if !isfile(file_path)

            error("$file_path doesn't exist.")

        end

    end

    page::String = joinpath(paou, "trim_sequence", "germ")

    trim_sequence(ge1, ge2, paou, page, n_jo)

    ge1tr::String = "$page-trimmed-pair1.fastq.gz"

    ge2tr::String = "$page-trimmed-pair2.fastq.gz"

    paso::String = joinpath(paou, "trim_sequence", "soma")

    trim_sequence(so1, so2, paso, n_jo)

    so1tr::String = "$paso-trimmed-pair1.fastq.gz"

    so2tr::String = "$paso-trimmed-pair2.fastq.gz"

    check_sequence((ge1tr, ge2tr, so1tr, so2tr), joinpath(paou, "check_sequence"), n_jo)

    page::String = joinpath(paou, "align_sequence", "germ.bam")

    align_sequence(ge1tr, ge2tr, "Germ", fa, page, n_jo, mejo)

    paso::String = joinpath(paou, "align_sequence", "soma.bam")

    align_sequence(so1tr, so2tr, "Soma", fa, paso, n_jo, mejo)

    fagz::String = "$(splitext(fa)[1]).bgz"

    if !isfile(fagz)

        run_command(
            pipeline(
                `gzip --decompress $fa --stdout`,
                `bgzip --threads $n_jo --stdout`,
                fagz,
            ),
        )

    end

    pava::String = joinpath(paou, "find_variant")

    find_variant(page, paso, ta, fagz, chsi, chna, pava, n_jo, meto, snpeff)

end
