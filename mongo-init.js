db = db.getSiblingDB("admin");

db.createUser({
  user: "admin",
  pwd: "sekret",
  roles: [
    { role: "root", db: "admin" }
  ]
});

// db = db.getSiblingDB("$external");
//
// db.createUser({
//   user: "testuser",
//   roles: [
//     { role: "readWriteAnyDatabase", db: "admin" }
//   ]
// });


db = db.getSiblingDB("admin");

db.createRole({
  role: "cn=psmdb-readwrite,ou=Groups,dc=example,dc=com",
  privileges: [],
  roles: [
    { role: "readWriteAnyDatabase", db: "admin" }
  ]
});

