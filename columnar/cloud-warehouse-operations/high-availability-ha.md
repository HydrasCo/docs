# High Availability (HA)

High availability (HA) refers to the ability of a system or service to remain operational and accessible to users during unexpected or planned downtime events. This means ensuring that the database can continue to function and serve user requests even if a server fails or experiences a hardware or software issue.

To achieve HA on Hydra,  we use replication, where multiple servers are set up to host the same data, and one of the servers is designated as the primary server, which receives all incoming requests. If the primary server fails, another server can take its place and continue serving user requests without any downtime.

Additionally, it's important to regularly back up your database to protect against data loss in the event of a failure. This can be done using tools like pg\_dump or by using a cloud-based backup service.
