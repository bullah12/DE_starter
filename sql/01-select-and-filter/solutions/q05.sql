-- q05 — What payment methods are in use?
--
-- Eight values for four methods. bacs and BACS are different strings, and the
-- database has no opinion about which one is right.
--
-- Any report that groups by method will show these separately and nobody
-- will notice until the totals are challenged. Cleaning it is topic 09; for
-- now, knowing is the win.
SELECT DISTINCT method
FROM payments
ORDER BY method;
