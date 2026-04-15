select
    d.unique_aer_id_number,
    r.original_receive_date,
    r.type_of_information,
    r.serious_ae,
    d.drug_seq,
    d.brand_name,
    d.route,
    d.dosage_form,
    d.administered_by,
    d.used_according_to_label,
    d.off_label_use,
    d.atc_vet_code,
    d.first_exposure_date,
    d.last_exposure_date
from {{ ref('stg_vet_ae_drug') }} as d
left join {{ ref('stg_vet_ae_report') }} as r 
    ON d.unique_aer_id_number = r.unique_aer_id_number