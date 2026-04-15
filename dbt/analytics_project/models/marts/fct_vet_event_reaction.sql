SELECT
    rct.unique_aer_id_number,
    rct.reaction_seq,
    rct.reaction_term,
    rct.reaction_code,
    rct.reaction_version,
    r.original_receive_date,
    r.serious_ae, 
    r.type_of_information
FROM {{ ref('stg_vet_ae_reaction') }}  as rct
LEFT JOIN {{ ref('stg_vet_ae_report') }} as r
    ON rct.unique_aer_id_number = r.unique_aer_id_number