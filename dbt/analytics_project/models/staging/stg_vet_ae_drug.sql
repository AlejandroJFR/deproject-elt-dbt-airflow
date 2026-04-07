select
    unique_aer_id_number,
    drug_seq,
    drug_item->>'brand_name' as brand_name,
    drug_item->>'route' as route,
    drug_item->>'dosage_form' as dosage_form,
    drug_item->>'administered_by' as administered_by,
    drug_item->>'used_according_to_label' as used_according_to_label,
    drug_item->>'off_label_use' as off_label_use,
    drug_item->>'atc_vet_code' as atc_vet_code,
    drug_item->>'first_exposure_date' as first_exposure_date,
    drug_item->>'last_exposure_date' as last_exposure_date
from raw.vet_ae_report
cross join lateral jsonb_array_elements(payload->'drug') with ordinality as d(drug_item, drug_seq)
