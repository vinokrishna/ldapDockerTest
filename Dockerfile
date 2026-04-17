FROM osixia/openldap:1.5.0

COPY ldap/bootstrap.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom/
COPY ldap/acl-svc.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom/
