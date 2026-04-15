select
    unique_aer_id_number,
    payload->>'report_id' as report_id,
    original_receive_date,
    ingested_at,
    payload->>'type_of_information' as type_of_information,
    payload->>'serious_ae' as serious_ae,
    payload->>'treated_for_ae' as treated_for_ae,
    payload->>'number_of_animals_affected' as number_of_animals_affected,
    payload->>'number_of_animals_treated' as number_of_animals_treated,
    payload->>'primary_reporter' as primary_reporter,
    payload->>'secondary_reporter' as secondary_reporter,
    payload->'receiver'->>'city' as receiver_city,
    payload->'receiver'->>'state' as receiver_state,
    payload->'receiver'->>'postal_code' as receiver_postal_code,
    payload->'receiver'->>'country' as receiver_country,
    payload->>'onset_date' as onset_date
from raw.vet_ae_report