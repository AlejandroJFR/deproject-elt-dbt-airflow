select
  safetyreportid,
  safetyreportversion,
  receivedate,
  receiptdate,
  payload_hash,
  ingested_at,
  payload
from raw.human_ae_report