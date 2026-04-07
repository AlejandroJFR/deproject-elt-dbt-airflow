select
    unique_aer_id_number,
    drug_seq,
    ingredient_seq,
    ingredient_item->>'name' as ingredient_name,
    ingredient_item->'dose'->>'numerator' as dose_numerator,
    ingredient_item->'dose'->>'numerator_unit' as dose_numerator_unit,
    ingredient_item->'dose'->>'denominator' as dose_denominator,
    ingredient_item->'dose'->>'denominator_unit' as dose_denominator_unit
from raw.vet_ae_report
cross join lateral jsonb_array_elements(payload->'drug') with ordinality as d(drug_item, drug_seq)
cross join lateral jsonb_array_elements(drug_item->'active_ingredients') with ordinality as ai(ingredient_item, ingredient_seq)
