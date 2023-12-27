CREATE GROUP proprietaires_abeilles;

CREATE GROUP moniteurs_abeilles;

CREATE GROUP garcons_de_plage_abeilles;

CREATE USER ynarbey WITH PASSWORD 'yn12345';
CREATE USER abrun WITH PASSWORD 'ab12345';

GRANT proprietaires_abeilles TO ynarbey;
GRANT proprietaires_abeilles TO abrun;

CREATE USER lfrottier WITH PASSWORD 'lf67890';
CREATE USER jbond WITH PASSWORD 'jb67890';
CREATE USER ffleuriot WITH PASSWORD 'ff67890';

GRANT moniteurs_abeilles TO lfrottier;
GRANT moniteurs_abeilles TO jbond;
GRANT moniteurs_abeilles TO ffleuriot;

CREATE USER vcordonnier WITH PASSWORD 'vc13579';
CREATE USER gbattier WITH PASSWORD 'gb13579';

GRANT garcons_de_plage_abeilles TO vcordonnier;
GRANT garcons_de_plage_abeilles TO gbattier;
