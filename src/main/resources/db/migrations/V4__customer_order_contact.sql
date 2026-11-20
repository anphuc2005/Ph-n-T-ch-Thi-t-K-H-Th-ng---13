-- Run once after V3 on an existing CineMan database. MySQL DDL auto-commits.
ALTER TABLE users
  ADD phone VARCHAR(20) NULL;

ALTER TABLE orders
  ADD contact_name VARCHAR(100) NULL,
  ADD contact_email VARCHAR(190) NULL,
  ADD contact_phone VARCHAR(20) NULL;

-- Preserve the customer's account name/email in existing online order history.
UPDATE orders o
JOIN users u ON u.id=COALESCE(o.customer_id,IF(o.channel='ONLINE',o.actor_id,NULL))
SET o.contact_name=u.name,
    o.contact_email=u.email,
    o.contact_phone=u.phone
WHERE o.contact_name IS NULL;

INSERT INTO schema_versions(version) VALUES(4);
