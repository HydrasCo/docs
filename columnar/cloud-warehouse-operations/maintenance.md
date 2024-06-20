# Maintenance

## Production plans

Hydra performs rolling updates that do not impact the availability of production plans. However, queries may be cancelled as Hydra moves your production database between high availability nodes. Occassionally, Hydra may need to perform scheduled or emergency maintenance to your database.

### Scheduled maintenance

Hydra will schedule maintainance in order to perform upgrades on our underlying infrastructure in cases where we cannot maintain the uptime of you production cluster. Hydra will announce and communicate such maintenance windows at least 1 week in advance.

### Emergency maintenance

Hydra may need to perform emergency maintenance in order to ensure the overall availability of your database or other databases. An example would be a critical security update that cannot wait 1 week for scheduled maintenance.

## Staging plans

Staging plans are perfect for testing. However, they are single-node and do not have an availability guarantee or scheduled maintenance windows. You will experience small windows (<5 minutes) of downtime when updates are rolled out. Longer downtime may occur ocassionally for larger infrastructure updates. **We highly recommend using a Production plan if the availability of your data warehouse is business-critical.**
