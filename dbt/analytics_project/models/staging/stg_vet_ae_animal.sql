select
    unique_aer_id_number,
    payload->'animal'->>'species' as species,
    payload->'animal'->>'gender' as gender,
    payload->'animal'->>'reproductive_status' as reproductive_status,
    payload->'animal'->>'female_animal_physiological_status' as female_physiological_status,
    payload->'animal'->'age'->>'min' as age_min,
    payload->'animal'->'age'->>'unit' as age_unit,
    payload->'animal'->'weight'->>'min' as weight_min,
    payload->'animal'->'weight'->>'unit' as weight_unit
from raw.vet_ae_report