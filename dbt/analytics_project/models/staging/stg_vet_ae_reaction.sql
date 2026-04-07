
select
    unique_aer_id_number,
    reaction_seq,
    reaction_item->>'veddra_term_name' as reaction_term,
    reaction_item->>'veddra_term_code' as reaction_code,
    reaction_item->>'veddra_version' as reaction_version
from raw.vet_ae_report
cross join lateral jsonb_array_elements(payload->'reaction') with ordinality as r(reaction_item, reaction_seq)