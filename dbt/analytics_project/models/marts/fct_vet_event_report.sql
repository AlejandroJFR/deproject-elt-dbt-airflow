select
    unique_aer_id_number,
    report_id,
    original_receive_date,
    ingested_at,
    type_of_information,
    serious_ae,
    treated_for_ae,
    number_of_animals_affected,
    number_of_animals_treated,
    primary_reporter,
    secondary_reporter,
    receiver_city,
    receiver_state,
    receiver_postal_code,
    receiver_country,
    onset_date
from {{ ref('stg_vet_ae_report') }}